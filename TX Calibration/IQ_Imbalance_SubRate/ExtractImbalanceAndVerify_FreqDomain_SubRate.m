function [ CalResults ] = ExtractImbalanceAndVerify_FreqDomain_SubRate(TX, RX, Cal)
    %% Extract imbalance modelling parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     % Check the input power of the input training signal
    In_train              = SetMeanPower(Cal.Signal.TrainingSignal, 0);
    [~, ~, PAPR_original]    = CheckPower(In_train, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
%     FsampleAnalysis = TX.Fsample / 8;
    FsampleAnalysis = TX.Fsample;
    
    % Apply AWG Correction
    if (Cal.AWG.Calflag)
        [ In_train_cal ] = ApplyAWGCorrection( In_train, TX.Fsample, TX.AWG_Correction_I, TX.AWG_Correction_Q);
    else
        In_train_cal = Cal.Signal.TrainingSignal;
    end
    [~, ~, PAPR_input]    = CheckPower(In_train_cal, 1);
    
    I_offset    = TX.I_Offset;
    Q_offset    = TX.Q_Offset;    
    AWG_In_signal = In_train_cal - mean(In_train_cal);
    Fsample_signal = TX.Fsample;
%     Fsample_signal = TX.Fsample / 8;
    PointsPerRecord = RX.PointsPerRecord;
    save('Scope_in.mat', 'PointsPerRecord');
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'TX', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
    if Cal.Processing32BitFlag
%         iter =1;
%         save('temp.mat','iter');
        AWG_Upload_32bit;
    else
        waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));
    end
    if strcmp(RX.Type, 'UXA')
        % Get received I and Q signals 
        [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier, ...
            RX.UXA.AnalysisBandwidth, 10 * RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
        Received_train = complex(Received_I, Received_Q);
        Received_train = Received_train(1:80e3);
        if (Cal.RX.Calflag)
            Received_train = ApplyLUTCalibration(Received_train, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
        end
        [DownSampleUXA, UpSampleUXA] = rat(TX.Fsample / RX.UXA.AnalysisBandwidth);
%         if (TX.Fsample / 8 > RX.UXA.AnalysisBandwidth)
%         if (TX.Fsample > RX.UXA.AnalysisBandwidth)
%             FsampleAnalysis = RX.UXA.AnalysisBandwidth;
%             Cal.Signal.Fsample = RX.UXA.AnalysisBandwidth;
%             In_train = resample(In_train, UpSampleUXA, DownSampleUXA, 100);
%         else
            Received_train = resample(Received_train, DownSampleUXA, UpSampleUXA, 100);
%         end
    elseif (strcmp(RX.Type, 'Scope') || strcmp(RX.Type, 'Digitizer'))
        if Cal.Processing32BitFlag
            CaptureScope_32bit;
        end
        load('Scope_out.mat');
        Received_train = waveform;
        % Downconvert the signal
        [Received_train] = DigitalDownconvert( Received_train, RX.Fsample, RX.Fcarrier, RX.Filter, RX.LOLowerInjectionFlag);
        % Do RX calibration
        if (Cal.RX.Calflag)
            Received_train = ApplyLUTCalibration(Received_train, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
        end
        % Resample
        [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Fsample);
        Received_train = resample(Received_train, DownSampleScope, UpSampleScope);
    end
    % Remove DC offset from LO feedthrough
    Received_train = Received_train - mean(Received_train);
    % Received_train = Received_train(end-100000+1:end);
%     Received_train = Received_train(Cal.Signal.TrainingLength+1:end);  
    
    % Decimate and reconstruct signal
    [TonesEstimate_s2, TonesEstimate_s4, TonesEstimate_s8] = ReconstructFullRateTones(Received_train, Cal.Signal.ToneFrequencies, TX.Fsample);
%     [FullRateEstimate_s2, FullRateEstimate_s4, FullRateEstimate_s8] = ReconstructFullRateSignal(Received_train, TonesEstimate_s2, TonesEstimate_s4, TonesEstimate_s8, TX, Cal);
    [~, ~, FullRateEstimate_s8] = ReconstructFullRateSignal(Received_train, TonesEstimate_s2, TonesEstimate_s4, TonesEstimate_s8, TX, Cal);
    alignFreqDomainFlag = 1;
    [ In_D, Out_D, EVM_Perc] = AlignAndAnalyzeSignals(In_train, Received_train, FsampleAnalysis, alignFreqDomainFlag);
    display([ 'EVM Before         = ' num2str(EVM_Perc)      ' % ' ]);
    
%     [ In_D_s2, Out_D_s2, EVM_Perc_s2] = AlignAndAnalyzeSignals(In_train, FullRateEstimate_s2, FsampleAnalysis, alignFreqDomainFlag);
%     display([ 'EVM Before_s2         = ' num2str(EVM_Perc_s2)      ' % ' ]);

%     [ In_D_s4, Out_D_s4, EVM_Perc_s4] = AlignAndAnalyzeSignals(In_train, FullRateEstimate_s4, FsampleAnalysis, alignFreqDomainFlag);
%     display([ 'EVM Before_s4         = ' num2str(EVM_Perc_s4)      ' % ' ]);
% 
    [ In_D_s8, Out_D_s8, EVM_Perc_s8] = AlignAndAnalyzeSignals(In_train, FullRateEstimate_s8, FsampleAnalysis, alignFreqDomainFlag);
    display([ 'EVM Before_s8         = ' num2str(EVM_Perc_s8)      ' % ' ]);
    
  
    %% Extraction of Filters
    G = cell(Cal.NumberOfIterations,1);
    iter = 1;
%     [tonesFreq, G{iter} ] = ImbalanceFilterExtraction_FreqDomain(In_D, Out_D, Cal);
%     [tonesFreq, G{iter} ] = ImbalanceFilterExtraction_FreqDomain(In_D_s2, Out_D_s2, Cal);
%     [tonesFreq, G{iter} ] = ImbalanceFilterExtraction_FreqDomain(In_D_s4, Out_D_s4, Cal);
    [tonesFreq, G{iter} ] = ImbalanceFilterExtraction_FreqDomain(In_D_s8, Out_D_s8, Cal);
    for iter = 2:Cal.NumberOfIterations
        In_test = Cal.Signal.VerificationSignal;
        [~, ~, PAPR_original]    = CheckPower(In_test, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
        if (Cal.AWG.Calflag)
            [ In_test_awgcal ]  = ApplyAWGCorrection( In_test, TX.Fsample, TX.AWG_Correction_I, TX.AWG_Correction_Q);   
        else 
            In_test_awgcal = In_test;
        end
        
%         save('temp.mat', 'G', 'iter', 'tonesFreq');
        [I_corr, Q_corr ] = ApplyInverseIQImbalanceFilters(real(In_test_awgcal), imag(In_test_awgcal),  TX.Fsample, ...
            G{iter-1}.G11, G{iter-1}.G12, G{iter-1}.G21, G{iter-1}.G22, tonesFreq, tonesFreq); 
        I_corr   = real(I_corr);
        Q_corr   = real(Q_corr);
        
%         Upload
        In_test_cal = complex(I_corr,Q_corr);
        In_test_cal = SetMeanPower(In_test_cal, 0);
        [~, ~, PAPR_input] = CheckPower(In_test_cal,1);
%         In_test_cal = In_test_awgcal;

        AWG_In_signal = In_test_cal - mean(In_test_cal);
        save('IQ_AWG_in.mat', 'AWG_In_signal', 'TX', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
        if Cal.Processing32BitFlag
            AWG_Upload_32bit;
        else
            waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));
        end           
        if strcmp(RX.Type, 'UXA')
            % Get received I and Q signals 
            [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier, ...
                RX.UXA.AnalysisBandwidth, 20 * RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
            Received_test = complex(Received_I, Received_Q);
            Received_test = Received_test(1:80e3);
            if (Cal.RX.Calflag)
                Received_test = ApplyLUTCalibration(Received_test, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
            end
            [DownSampleUXA, UpSampleUXA] = rat(TX.Fsample / RX.UXA.AnalysisBandwidth);
%             if (TX.Fsample > RX.UXA.AnalysisBandwidth)
%                 In_test = resample(In_test, UpSampleUXA, DownSampleUXA, 100);
%             else
                Received_test = resample(Received_test, DownSampleUXA, UpSampleUXA);
%             end
        elseif (strcmp(RX.Type, 'Scope') || strcmp(RX.Type, 'Digitizer'))
            if Cal.Processing32BitFlag
                CaptureScope_32bit;
            end
            load('Scope_out.mat');
            Received_test = waveform;
            % Downconvert the signal
            [Received_test] = DigitalDownconvert(Received_test, RX.Fsample, RX.Fcarrier, RX.Filter, RX.LOLowerInjectionFlag);
            % Do RX calibration
            if (Cal.RX.Calflag)
                Received_test = ApplyLUTCalibration(Received_test, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
            end
            % Resample
            [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Fsample);
            Received_test = resample(Received_test, DownSampleScope, UpSampleScope);
        end
        % Remove DC offset from LO feedthrough
        Received_test = Received_test - mean(Received_test);

        % Received_train = Received_train(end-100000+1:end);
%         Received_test = Received_test(Cal.Signal.TrainingLength+1:end);  

        % Decimate and reconstruct signal
        [TonesEstimate_s2, TonesEstimate_s4, TonesEstimate_s8] = ReconstructFullRateTones(Received_test, Cal.Signal.ToneFrequencies, TX.Fsample);
        [~, ~, FullRateEstimate_s8] = ReconstructFullRateSignal(Received_test, TonesEstimate_s2, TonesEstimate_s4, TonesEstimate_s8, TX, Cal);

        [ In_D, Out_D, EVM_Perc] = AlignAndAnalyzeSignals(In_test, Received_test, FsampleAnalysis, alignFreqDomainFlag);          
        [freq, spectrum]   = CalculatedSpectrum(Out_D, FsampleAnalysis);
        [ACLR_L, ACLR_U]   = CalculateACLR(freq, spectrum, 0, Cal.Signal.BW, TX.FGuard);
        [ACPR_L, ACPR_U]   = CalculateACPR(freq, spectrum, 0, Cal.Signal.BW, TX.FGuard);

        display([ 'EVM          = ' num2str(EVM_Perc)      ' % ' ]);
        display([ 'ACLR (L/U)   = ' num2str(ACLR_L) ' / '  num2str(ACLR_U) ' dB ' ]);    
        display([ 'ACPR (L/U)   = ' num2str(ACPR_L) ' / '  num2str(ACPR_U) ' dB ' ]); 

%         [ In_D, Out_D_s2, EVM_Perc_s2] = AlignAndAnalyzeSignals(In_test, FullRateEstimate_s2, FsampleAnalysis, alignFreqDomainFlag);
%         display([ 'EVM Before_s2         = ' num2str(EVM_Perc_s2)      ' % ' ]);

%         [ In_D_s4, Out_D_s4, EVM_Perc_s4] = AlignAndAnalyzeSignals(In_test, FullRateEstimate_s4, FsampleAnalysis, alignFreqDomainFlag);
%         display([ 'EVM Before_s4         = ' num2str(EVM_Perc_s4)      ' % ' ]);
% 
        [ In_D_s8, Out_D_s8, EVM_Perc_s8] = AlignAndAnalyzeSignals(In_test, FullRateEstimate_s8, FsampleAnalysis, alignFreqDomainFlag);
        display([ 'EVM Before_s8         = ' num2str(EVM_Perc_s8)      ' % ' ]);

        % Calculate the current iteration's imbalance filters
%         [ tonesFreq, G{iter} ] = ImbalanceFilterExtraction_FreqDomain( In_D, Out_D, Cal);
        [ tonesFreq, G{iter} ] = ImbalanceFilterExtraction_FreqDomain( In_D, Out_D_s8, Cal);
        [ G{iter} ]           = CascadeImbalanceFilters_FreqDomain( G{iter-1}, G{iter} );
    end
    
    CalResults =        struct( 'Type',         Cal.Type, ...
                                'tones',        tonesFreq, ...
                                'G',            G,...
                                'In_D',         In_D, ...
                                'Out_D',        Out_D);
end