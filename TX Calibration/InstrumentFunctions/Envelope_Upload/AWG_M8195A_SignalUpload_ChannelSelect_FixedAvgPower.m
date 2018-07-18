function AWG_M8195A_SignalUpload_ChannelSelect_FixedAvgPower(SignalsCell, CarrierFreqCell, SampleFreqCell, SampleFreqAWG, CorrectionEnabled, DisplaySignal,channel,Expansion_Margin, PAPR_input, PAPR_original)
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


% Check if the connection driver is open, otherwise open it.
[~,result] = system('tasklist /FI "imagename eq AgM8195SFP.exe" /fo table /nh');

if strcmp(result(2:15),'AgM8195SFP.exe')==0
    winopen('C:\Program Files (x86)\Keysight\M8195\bin\AgM8195SFP.exe');
    pause(60);
end

    UpsamplingMethod = 'Interpolation' ; % either 'Interpolation' or 'FFT' could be used
%     channelMapping = [1 0; 0 1] ; %Set I to channel 1 and Q to channel 2 
    if channel == 2
        channelMapping = [0 0; 1 0] ; %Set I to channel 2
    elseif channel == 1
        channelMapping = [1 0; 0 1; 0 1; 0 1] ; %Set I to channel 1 
    elseif channel == 0
        channelMapping = [1 0; 0 1; 0 1; 0 1] ; %Set RF to both channels 
    else
        channelMapping = [1 0; 0 1; 0 1; 0 1] ; %Set I to channel 1 and Q to channel 2 
    end
   
%     if SampleFreqAWG > 8e9
%         msgbox('Please check the highest sampling rate', 'Error');
%         return
%     end

    for j = 1 : length(SignalsCell)
        iqdata = [];
        fs = 0;
        marker = [];
        % read data
            iqdata = SignalsCell{j} ;
            iqdata = reshape(iqdata, length(iqdata), 1) ;
           
            fs = SampleFreqCell{j} ;
            factor = SampleFreqAWG/fs ;
        % resample if necessary
            if fs < SampleFreqAWG
                method = UpsamplingMethod;                
                switch (method)
                    case 'Interpolation'; ipfct = @(data,r) interp(double(data), r);
                    case 'FFT'; ipfct = @(data,r) interpft(data, r * length(data));
                    otherwise error('unknown method');
                end
                try
                    iqdata = ipfct(iqdata, factor);
                    fs = fs * factor;
                catch ex
                    errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
                end
            end
        % Upconversion
            fc = CarrierFreqCell{j} ;
            n = length(iqdata);
            iqdata = iqdata .* exp(1i*2*pi*(n*fc/fs)/n*(1:n)') ;
        % Combine Signal
            if j == 1
                iqtotaldata = iqdata ;
            else
                iqtotaldata = iqtotaldata+iqdata ;
            end
    end
    iqtotaldata = real(iqtotaldata);
    iqtotaldata = iqtotaldata./max(iqtotaldata);
    norm_fact = 10^(-Expansion_Margin/20)*10^((PAPR_input - PAPR_original)/20) ;   
    if (CorrectionEnabled)
        iqtotaldata = iqcorrection(iqtotaldata, fs);
    end
    
    if norm_fact < 1
        iqtotaldata = iqtotaldata*norm_fact;
    else
        iqtotaldata = iqtotaldata;
    end        

    marker = zeros(1,length(iqtotaldata));
    marker(1:floor(length(iqtotaldata)/2)) = ones(1, floor(length(iqtotaldata)/2));
%     marker = [ones(floor(factor*50),1); zeros(length(iqtotaldata)-floor(factor*50),1)] ;
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
        arbConfig = loadArbConfig();
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

        % Add in marker to Q
        iqdata = complex(iqdata, marker);
% Modified iqdownload code
        iqdownload(iqdata, fs, 'channelMapping', channelMapping, ...
            'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1));
%         iqdownload(repmat(iqdata, rept, 1), fs, 'channelMapping', channelMapping, ...
%             'segmentNumber', segmentNum, 'marker', repmat(marker, rept, 1));
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
    clear iqdata iqtotaldata


