function AWG_M8190A_IQSignalUpload(SignalsCell, ...
    CarrierFreqCell, SampleFreqCell, SampleFreqAWG, varargin)
%--------------------------------------------------------------------------
% Description: Upload one or several signals to the configured AWG
%--------------------------------------------------------------------------
% Required arguments
%--------------------------------------------------------------------------
% - SignalsCell - cell of complex signals that needs to be sent
% - CarrierFreqCell - cell of carrier frequency values to which signals will be
% upconverted
% - SampleFreqCell - cell of sampling frequency values of each signal 
% - SampleFreqAWG - Sample Frequency of the M8190A. Value should be between
% 125e6 and 8e9 for Version 14Bits and 125e6 and 12e9 for Version 12Bits
%--------------------------------------------------------------------------
% Optional arguments - accepted in name/value pairs
%--------------------------------------------------------------------------
% - SignalBandwidthCell - bandwidth of the signal for filtering
% - IQOutputEnable - Upload I and Q 
% - CorrectionEnabled - logical value for enabling the amplitude correction
% saved in the ampCorr.mat
% - DisplaySignal - Logical Value to display signal created
% - ExpansionMarginSettings - structure containing the fields
%       - ExpansionMarginEnable - whether to enable expansion margin or
%       backoff the AWG by the ExpansionMargin field value
%       - ExpansionMargin - amount of room to leave for the signal to
%       expand
%       - PAPR_input - PAPR of the input signal
%       - PAPR_original - PAPR of the original signal before DPD and
%       calibration
% - IQOffsets - structure containing the IQ DC offset fields
%       - I_Offset - amount to offset the channel I output
%       - Q_Offset - amount to offset the channel Q output
% - RunSettings - structure containing AWG run settings
%       - RunFlag - whether to run the AWG after uploading or to wait until
%       configure
%       - MultichannelFlag - whether or not the AWGs are configured in a
%       multichannel configuration
%--------------------------------------------------------------------------
    % Parse optional arguments
    OptionalArguments = varargin;
    [SignalBandwidthCell, IQOutputEnable, CorrectionEnabled, DisplaySignal, ChannelSelectSettings, ...
        ExpansionMarginSettings, IQOffsets, RunSettings] = parseInputArguments(SampleFreqCell, OptionalArguments);

    % Check if the connection driver is open, otherwise open it.
    [~,result] = system('tasklist /FI "imagename eq AgM8190Firmware.exe" /fo table /nh');

    if strcmp(result(2:20),'AgM8190Firmware.exe')==0
        winopen('C:\Program Files (x86)\Agilent\M8190\bin\AgM8190Firmware.exe');
        pause(60);
    end

    UpsamplingMethod = 'Interpolation' ; % either 'Interpolation' or 'FFT' could be used
    if ChannelSelectSettings == 2
        channelMapping = [0 0; 1 0] ; %Set I to channel 2
    elseif ChannelSelectSettings == 1
        channelMapping = [1 0; 0 1] ; %Set I to channel 1 
    elseif ChannelSelectSettings == 0
        channelMapping = [1 1; 1 1] ; %Set RF to both channels 
    else
        channelMapping = [1 0; 0 1] ; %Set I to channel 1 and Q to channel 2 
    end

    for j = 1 : length(SignalsCell)
        iqdata = [];
        fs = 0;
        marker = [];
        % read data
            iqdata = SignalsCell{j} ;
            iqdata = reshape(iqdata, length(iqdata), 1) ;
           
            fs = SampleFreqCell{j} ;
            [factor_n, factor_d] = rat(SampleFreqAWG/fs) ;
            % resample if necessary
            if fs < SampleFreqAWG
                method = UpsamplingMethod;                
                switch (method)
                    case 'Interpolation'; ipfct = @(data,r) interp(double(data), r);
                    case 'FFT'; ipfct = @(data,r) interpft(data, r * length(data));
                    otherwise error('unknown method');
                end
                try
                    %iqdata = ipfct(iqdata, factor);
                    iqdata = resample(iqdata, factor_n, factor_d, 1000);
                    fs = fs * factor_n / factor_d;
                catch ex
                    errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
                end
            end
            % Upconversion
            fc = CarrierFreqCell{j} ;
            n = length(iqdata);
            iqdata= ApplyFrequencyWindow(iqdata, SampleFreqAWG, SignalBandwidthCell{j} / 2);
            %%
            iqdata = iqdata .* exp(1i*2*pi*(n*fc/fs)/n*(1:n)') ;
            % If we are only outputting the real part then take the I
            if ~IQOutputEnable
                iqdata = real(iqdata);
            end
            % Combine Signal
            if j == 1
                iqtotaldata = iqdata ;
            else
                iqtotaldata = iqtotaldata+iqdata ;
            end
    end
    
    % Normalize the max power of the iq data to 0 dBm
    %     iqtotaldata = iqtotaldata ./ max(max(real(iqtotaldata)),max(imag(iqtotaldata)));
    %     iqtotaldata = SetMeanPower(iqtotaldata, 0);
    if (CorrectionEnabled)
        iqtotaldata = iqcorrection(iqtotaldata, fs);
    end
    if ExpansionMarginSettings.ExpansionMarginEnable
        norm_fact = 10^(-ExpansionMarginSettings.ExpansionMargin/20)*...
            10^((ExpansionMarginSettings.PAPR_input - ExpansionMarginSettings.PAPR_original)/20) ;   
    else
        % just backoff the awg by the expansion margin
        norm_fact = 10^(-ExpansionMarginSettings.ExpansionMargin/20);
    end

    if (norm_fact < 1)
        iqtotaldata = iqtotaldata*norm_fact;
    else
        iqtotaldata = iqtotaldata;
    end
    
    marker = zeros(1,length(iqtotaldata));
    % Set marker period to 1/2 and set to 1 to enable sample marker ONLY and 
    % 3 to enable sample marker AND sync marker 
    marker(1:floor(length(iqtotaldata)/2)) = 3 *ones(1, floor(length(iqtotaldata)/2));

    % Plot Combined signal for verification
    assignin('base', 'iqtotaldata', iqtotaldata) ;
    assignin('base', 'fs', fs) ;
    
    if (~isempty(iqtotaldata) && DisplaySignal)
         iqplot(iqtotaldata, fs, 'marker', marker) ;
    end

    % Upload the signal to the AWG
    disp('Uploading Waveform...')
    
    if (~isempty(iqtotaldata))
        len = numel(iqtotaldata);
        iqtotaldata = reshape(iqtotaldata, len, 1);
        marker = reshape(marker, numel(marker), 1);
        load('arbConfig.mat')
        arbConfig = loadArbConfig(arbConfig);
        rept = lcm(len, arbConfig.segmentGranularity) / len;
        if (rept * len < arbConfig.minimumSegmentSize)
            rept = rept+1;
        end
        segmentNum = 1;
        
        % Modified code 
        Seg_size = arbConfig.minimumSegmentSize;
        Num_seg  = floor(length(iqtotaldata)/Seg_size);
        if (length(iqtotaldata)/Seg_size - Num_seg) ~= 0
            Additional_poits = Seg_size - ( length(iqtotaldata) - Num_seg * Seg_size);
            iqtotaldata = [iqtotaldata; iqtotaldata(1:Additional_poits)];
            marker = [marker; zeros(Additional_poits, 1)];
        end
        rept = 1; % Saves memory
               
        % Modified iqdownload code
        iqtotaldata  = iqtotaldata + complex(IQOffsets.I_Offset, IQOffsets.Q_Offset);
        if ~RunSettings.SyncModuleFlag
            iqdownload(repmat(iqtotaldata, rept, 1), fs, 'channelMapping', channelMapping, ...
                'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1), 'run', RunSettings.RunFlag);
        else
            AWG_iqdownload_MultiChannel(repmat(iqtotaldata, rept, 1), fs, ...
                'channelMapping', channelMapping, ...
                'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1), 'run', RunSettings.RunFlag);
        end
        % assignin('base', 'iqdata', repmat(iqtotaldata, rept, 1));
    end
    disp('Upload Complete') ;
end

function [SignalBandwidthCell, IQOutputEnable, CorrectionEnabled, DisplaySignal, ChannelSelectSettings, ...
    ExpansionMarginSettings, IQOffsets, RunSettings] = parseInputArguments(SampleFreqCell, OptionalArguments)
    %----------------------------------------------------------------------
    % Description: Parsing the input arguments
    %----------------------------------------------------------------------
    % Initial values
    SignalBandwidthCell = SampleFreqCell;
    IQOutputEnable = 1;
    CorrectionEnabled = 0;
    DisplaySignal = 0;
    % Channel mapping settings
    ChannelSelectSettings = [];
    % AWG Backoff settings
    ExpansionMarginSettings.ExpansionMarginEnable = 0;
    ExpansionMarginSettings.ExpansionMargin = 0;
    ExpansionMarginSettings.PAPR_input = 0;
    ExpansionMarginSettings.PAPR_original = 0;
    % IQ DC Offset settings
    IQOffsets.I_Offset = 0; 
    IQOffsets.Q_Offset = 0;
    % AWG Upload run settings
    RunSettings.RunFlag = 1;
    RunSettings.SyncModuleFlag = 0;
    
    % Parse values
    for i = 1:2:length(OptionalArguments)
        if (ischar(OptionalArguments{i}))
            switch OptionalArguments{i}
                case 'SignalBandwidthCell'; SignalBandwidthCell = OptionalArguments{i+1};
                case 'IQOutputEnable'; IQOutputEnable = OptionalArguments{i+1};
                case 'CorrectionEnabled';  CorrectionEnabled = OptionalArguments{i+1};
                case 'DisplaySignal'; DisplaySignal = OptionalArguments{i+1};
                case 'ChannelSelectSettings'; ChannelSelectSettings = OptionalArguments{i+1};
                case 'ExpansionMarginSettings'; 
                    ExpansionMarginSettings = OptionalArguments{i+1};
                    if(~isfield(ExpansionMarginSettings, 'ExpansionMarginEnable'))
                        warning('ExpansionMarginEnable field not found. Turning off expansion margin.');
                        ExpansionMarginSettings.ExpansionMarginEnable = 0;
                    end
                    if(~isfield(ExpansionMarginSettings, 'ExpansionMargin'))
                        warning('ExpansionMargin field not found. Turning off expansion margin.');
                        ExpansionMarginSettings.ExpansionMarginEnable = 0;
                    end
                    if(~isfield(ExpansionMarginSettings, 'PAPR_input') && (ExpansionMarginSettings.ExpansionMarginEnable == 1))
                        warning('PAPR_input field not found. Turning off expansion margin.');
                        ExpansionMarginSettings.PAPR_input = 0;
                    end
                    if(~isfield(ExpansionMarginSettings, 'PAPR_original') && (ExpansionMarginSettings.ExpansionMarginEnable == 1))
                        warning('PAPR_input field not found. Turning off expansion margin.');
                        ExpansionMarginSettings.PAPR_original = 0;
                    end
                case 'IQOffsets'; 
                    IQOffsets = OptionalArguments{i+1};
                    if(~isfield(IQOffsets,'I_Offset'))
                        IQOffsets.I_Offset = 0;
                    end
                    if(~isfield(IQOffsets,'Q_Offset'))
                        IQOffsets.Q_Offset = 0;
                    end            
                case 'RunSettings'; 
                    RunSettings = OptionalArguments{i+1};
                    if(~isfield(RunSettings,'RunFlag'))
                        RunSettings.RunFlag = 1;
                    end 
                    if(~isfield(RunSettings,'SyncModuleFlag'))
                        RunSettings.SyncModuleFlag = 0;
                    end   
                otherwise; error(['unexpected argument: ' OptionalArguments{i}]);
            end
        end
    end
end