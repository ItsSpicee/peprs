function AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower(SignalsCell, ...
    CarrierFreqCell, SampleFreqCell, SampleFreqAWG, CorrectionEnabled, ...
    DisplaySignal,channel,Expansion_Margin, PAPR_input, PAPR_original, I_offset, Q_offset,run,syncModuleFlag,directConvFlag)
% Upload one or several signals to the configured AWG
% - SignalsCell - cell of complex signals that needs to be sent
% - CarrierFreqCell - cell of carrier frequency values to which signals will be
% upconverted
% - SampleFreqCell - cell of sampling frequency values of each signal 
% - SampleFreqAWG - Sample Frequency of the M8190A. Value should be between
% 125e6 and 8e9 for Version 14Bits and 125e6 and 12e9 for Version 12Bits
% - CorrectionEnabled - logical value for enabling the amplitude correction
% saved in the ampCorr.mat
% - DisplaySignal - Logical Value to display signal created

if nargin < 12
   I_offset = 0; Q_offset = 0;
end
if nargin < 13
   run = 1;
end
if nargin < 14
   syncModuleFlag = 0;
end
if nargin < 15
    directConvFlag = 1;
end


% Check if the connection driver is open, otherwise open it.
[~,result] = system('tasklist /FI "imagename eq AgM8190Firmware.exe" /fo table /nh');

if strcmp(result(2:20),'AgM8190Firmware.exe')==0
    winopen('C:\Program Files (x86)\Agilent\M8190\bin\AgM8190Firmware.exe');
    pause(60);
end

    UpsamplingMethod = 'Interpolation' ; % either 'Interpolation' or 'FFT' could be used
%     channelMapping = [1 0; 0 1] ; %Set I to channel 1 and Q to channel 2 
    if channel == 2
        channelMapping = [0 0; 1 0] ; %Set I to channel 2
    elseif channel == 1
        channelMapping = [1 0; 0 1] ; %Set I to channel 1 
    elseif channel == 0
        channelMapping = [1 1; 1 1] ; %Set RF to both channels 
    else
        channelMapping = [1 0; 0 1] ; %Set I to channel 1 and Q to channel 2 
    end
   
%     if SampleFreqAWG > 8e9
%         msgbox('Please check the highest sampling rate', 'Error');
%         return
%     end
%     CheckPower(SignalsCell{1}, 1)

    for j = 1 : length(SignalsCell)
        iqdata = [];
        fs = 0;
        marker = [];
        % read data
            iqdata = SignalsCell{j} ;
            iqdata = reshape(iqdata, length(iqdata), 1) ;
           
            fs = SampleFreqCell{j} ;
%             factor = SampleFreqAWG/fs ;
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
%                     iqdata2 = ipfct(iqdata, factor);
%                     iqdata = resample(iqdata, factor, 1, 100);
                    iqdata = resample(iqdata, factor_n, factor_d, 1000);
                    fs = fs * factor_n / factor_d;%factor;
                catch ex
                    errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
                end
            end
%         % Upconversion
            fc = CarrierFreqCell{j} ;
            n = length(iqdata);
            iqdata= digital_lpf(iqdata, SampleFreqAWG, fs);
%             load('temp.mat');
%             if (iter > 1);
%                 [I_corr, Q_corr ] = ApplyInverseIQImbalanceFilters(real(iqdata), imag(iqdata),  SampleFreqAWG, ...
%                 G{iter-1}.G11, G{iter-1}.G12, G{iter-1}.G21, G{iter-1}.G22, tonesFreq, tonesFreq); 
%                 I_corr   = real(I_corr);
%                 Q_corr   = real(Q_corr);
%                 iqdata = complex(I_corr,Q_corr);
%                 iqdata = SetMeanPower(iqdata, 0);
%             end

            % Extra filtering
%             load FIR_LPF_fs8e9_fpass_0r8e9_Order430
%             iqdata = filter(Num, [1 0], iqdata);
            %%
            iqdata = iqdata .* exp(1i*2*pi*(n*fc/fs)/n*(1:n)') ;
            if (~directConvFlag)
                iqdata = real(iqdata);
            end
            
        % Combine Signal
            if j == 1
                iqtotaldata = iqdata ;
            else
                iqtotaldata = iqtotaldata+iqdata ;
            end
    end
    
    
    
    % Normalize the iq data
    [mean_power, max_power, papr_power] = CheckPower(iqtotaldata, 0);
%     i_data = real(iqtotaldata);
%     q_data = imag(iqtotaldata);
%     max_i_data = max(abs(i_data));
%     max_q_data = max(abs(q_data));
%     max_data = max(max_i_data, max_q_data);
%     i_data = i_data./max_data;
%     q_data = q_data./max_data;
%     iqtotaldata = complex(i_data, q_data);
%     
    iqtotaldata = SetMeanPower(iqtotaldata, 10-papr_power);

%     CheckPower(iqtotaldata, 1)
    norm_fact = 10^(-Expansion_Margin/20)*10^((PAPR_input - PAPR_original)/20) ;   
    if (CorrectionEnabled)
        iqtotaldata = iqcorrection(iqtotaldata, fs);
    end
    
    if (norm_fact < 1)
        iqtotaldata = iqtotaldata*norm_fact;
    else
        iqtotaldata = iqtotaldata;
    end        

    %marker = [ones(floor(factor*50*2),1); zeros(length(iqtotaldata)-floor(factor*50*2),1)] ;
    %marker = [ones(floor(factor*50*2),1); zeros(length(iqtotaldata)-floor(factor*50*2),1)] ;
    marker = zeros(1,length(iqtotaldata));
    % Set marker period to 1/2 and set to 1 to enable sample marker ONLY and 
    % 3 to enable sample marker AND sync marker 
    marker(1:floor(length(iqtotaldata)/2)) = 3 *ones(1, floor(length(iqtotaldata)/2));
    %    marker=[];
%     for j=1:factor
%         marker = [marker;1; zeros(length(SignalsCell{1})-1,1)] ;
%     end

% Plot Combined signal for verification
    assignin('base', 'iqtotaldata', iqtotaldata) ;
    assignin('base', 'fs', fs) ;
    
    if (~isempty(iqtotaldata) && DisplaySignal)
         iqplot(iqtotaldata, fs, 'marker', marker) ;
    end

% Upload the signal to the AWG
    disp('Uploading Waveform...')
    iqdata = iqtotaldata ;
    
    if (~isempty(iqdata))
        len = numel(iqdata);
        iqdata = reshape(iqdata, len, 1);
        marker = reshape(marker, numel(marker), 1);
        load('arbConfig.mat')
        arbConfig = loadArbConfig(arbConfig);
        rept = lcm(len, arbConfig.segmentGranularity) / len;
        if (rept * len < arbConfig.minimumSegmentSize)
            rept = rept+1;
        end
        segmentNum = 1;
        
        % Modified code 
% force rept = 1 to save memory. This is modified code.
        Seg_size = arbConfig.minimumSegmentSize;
        Num_seg  = floor(length(iqdata)/Seg_size);
        if (length(iqdata)/Seg_size - Num_seg) ~= 0
            Additional_poits = Seg_size - ( length(iqdata) - Num_seg * Seg_size);
            iqdata = [iqdata; iqdata(1:Additional_poits)];
            marker = [marker; zeros(Additional_poits, 1)];
        end
        rept = 1;
               
% Modified iqdownload code
        iqdata  = iqdata + complex(I_offset, Q_offset);
%         CheckPower(iqdata, 1)
        if ~syncModuleFlag
            iqdownload(repmat(iqdata, rept, 1), fs, 'channelMapping', channelMapping, ...
                'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1), 'run', run);
        else
            AWG_iqdownload_MultiChannel(repmat(iqdata, rept, 1), fs, ...
                'channelMapping', channelMapping, ...
                'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1), 'run', run);
        end
        assignin('base', 'iqdata', repmat(iqdata, rept, 1));
% Default code        
%         iqdownload(repmat(iqdata, rept, 1), fs, 'channelMapping', channelMapping, ...
%             'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1));
%         assignin('base', 'iqdata', repmat(iqdata, rept, 1));


%         
%         iqdownload(repmat(iqdata, rept, 1), fs, 'channelMapping', channelMapping, ...
%             'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1));
%         assignin('base', 'iqdata', repmat(iqdata, rept, 1));
    end
    disp('Upload Complete') ;
end