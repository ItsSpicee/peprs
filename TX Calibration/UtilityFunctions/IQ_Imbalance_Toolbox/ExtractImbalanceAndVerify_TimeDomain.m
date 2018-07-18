function [ CalResults ] = ExtractImbalanceAndVerify_TimeDomain(TX, RX, Cal)

    %% Extract imbalance modelling parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Check the input power of the input training signal
    In_train              = SetMeanPower(Cal.Signal.TrainingSignal, 0);
    [~, ~, PAPR_original]    = CheckPower(In_train, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
    FsampleAnalysis  = TX.Fsample;
    
    
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
    PointsPerRecord = RX.PointsPerRecord;
    save('Scope_in.mat', 'PointsPerRecord', 'RX');
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'TX', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
    AWG_Upload_32bit;
    waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));
    
    if (strcmp(RX.Type, 'UXA'))
        % Get received I and Q signals 
        [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier, ...
            RX.UXA.AnalysisBandwidth, RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
        Received_train = complex(Received_I, Received_Q);         
        
        [DownSampleUXA, UpSampleUXA] = rat(TX.Fsample / RX.UXA.AnalysisBandwidth);
%         if (TX.Fsample / 8 > RX.UXA.AnalysisBandwidth)
        if (TX.Fsample > RX.UXA.AnalysisBandwidth)
            FsampleAnalysis = RX.UXA.AnalysisBandwidth;
            Cal.Signal.Fsample = RX.UXA.AnalysisBandwidth;
            In_train = resample(In_train, UpSampleUXA, DownSampleUXA, 100);
        else
            Received_train = resample(Received_train, DownSampleUXA, UpSampleUXA);
        end
        
    elseif (strcmp(RX.Type, 'Scope') || strcmp(RX.Type, 'Digitizer'))
        CaptureScope_32bit;
        load('Scope_out.mat');
        Received_train = waveform;
        % Downconvert the signal
        [Received_train] = DigitalDownconvert( Received_train, RX.Fsample, RX.Fcarrier, RX.Filter, RX.LOLowerInjectionFlag);
        % Do RX calibration
        if (Cal.RX.Calflag)
            Received_train = ApplyLUTCalibration(Received_train, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
        end
        [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Fsample);
        Received_train = resample(Received_train, DownSampleScope, UpSampleScope);
    end
    % Remove DC offset from LO feedthrough
    Received_train = Received_train - mean(Received_train);
    
    Received_train = Received_train(Cal.Signal.TrainingLength+1:end);
    alignFrequencyDomainFlag = 0;
    [ In_D, Out_D, EVM_Perc] = AlignAndAnalyzeSignals(In_train, Received_train, FsampleAnalysis, alignFrequencyDomainFlag);
    display([ 'EVM Before         = ' num2str(EVM_Perc)      ' % ' ]);
    
    % The noise floor has. The model should not be modelling this, so we 
    % add white noise to ensure that the modelling is done with a flat noise floor. 
    noise_density = sqrt(2 / 10^6);
    noise = noise_density * (randn(length(Out_D),1) + 1i * randn(length(Out_D),1));
    
    % Calculate H (modelling) matrix using pseudo-inverse least-squares fitting
    [H_coeff, modeling_NMSE] = ImbalanceFilterExtraction(Out_D + noise, In_D, Cal.FIR_Order);
    display([ 'NMSE          = ' num2str(modeling_NMSE)      ' dB ' ]);
    CalResults =        struct( 'Type',         Cal.Type,        ...
                                'H_coeff',      H_coeff,         ... 
                                'I_offset',     TX.I_Offset,   ...
                                'Q_offset',     TX.Q_Offset,   ...
                                'FsampleCal',   FsampleAnalysis);
                            
    
    %% Apply imbalance model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    In_test = Cal.Signal.VerificationSignal;
    [~, ~, PAPR_input]    = CheckPower(In_test, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
    
    % Apply AWG Correction
    if (Cal.AWG.Calflag)
        [ In_test_awgcal ] = ApplyAWGCorrection( In_test, TX.Fsample, TX.AWG_Correction_I, TX.AWG_Correction_Q);
    else
        In_test_awgcal = Cal.Signal.VerificationSignal;
    end
    [In_test_awgcal, In_test_cal] = ApplyIQImbalanceCal(In_test_awgcal, CalResults, TX.Fsample);
    In_test_cal           = SetMeanPower(In_test_cal, 0);
    [~, ~, PAPR_input]    = CheckPower(In_test_cal, 1);
    
    AWG_In_signal = In_test_cal - mean(In_test_cal);
%     AWG_In_signal = AWG_In_signal(length(AWG_In_signal)-240e03+1:end);
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'TX', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
    waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));
    AWG_Upload_32bit;
    if strcmp(RX.Type, 'UXA')
        [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier, ...
            RX.UXA.AnalysisBandwidth, RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
        Received_test = complex(Received_I, Received_Q);
        [DownSampleUXA, UpSampleUXA] = rat(TX.Fsample / RX.UXA.AnalysisBandwidth);
        %         if (TX.Fsample / 8 > RX.UXA.AnalysisBandwidth)
        if (TX.Fsample > RX.UXA.AnalysisBandwidth)
            FsampleAnalysis = RX.UXA.AnalysisBandwidth;
            Cal.Signal.Fsample = RX.UXA.AnalysisBandwidth;
            In_test = resample(In_test, UpSampleUXA, DownSampleUXA, 100);
        else
            Received_test = resample(Received_test, DownSampleUXA, UpSampleUXA);
        end      
            
    elseif (strcmp(RX.Type, 'Scope') || strcmp(RX.Type, 'Digitizer'))
        CaptureScope_32bit;
        load('Scope_out.mat');
        Received_test = waveform;
        % Downconvert the signal
        [Received_test] = DigitalDownconvert( Received_test, RX.Fsample, RX.Fcarrier, RX.Filter, RX.LOLowerInjectionFlag);
        % Do RX calibration
        if (Cal.RX.Calflag)
            Received_test = ApplyLUTCalibration(Received_test, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
        end
        [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Fsample);
        Received_test = resample(Received_test, DownSampleScope, UpSampleScope);
        % Remove DC offset from LO feedthrough
        Received_test = Received_test - mean(Received_test);
    end
    
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Input Signal']);
    CheckPower(In_test,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Output Signal']);
    CheckPower(Received_test,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    Received_test = SetMeanPower(Received_test, 0);
    Received_test = Received_test(Cal.Signal.TrainingLength+1:end);
    [In_D, Out_D, EVM_Perc] = AlignAndAnalyzeSignals(In_test, Received_test, FsampleAnalysis, alignFrequencyDomainFlag);
    
    [freq, spectrum]   = CalculatedSpectrum(Out_D, FsampleAnalysis);
    [ACLR_L, ACLR_U]   = CalculateACLR(freq, spectrum, 0, Cal.Signal.BW, TX.FGuard);
    [ACPR_L, ACPR_U]   = CalculateACPR(freq, spectrum, 0, Cal.Signal.BW, TX.FGuard);
    
    display([ 'EVM After         = ' num2str(EVM_Perc)      ' % ' ]);
    display([ 'ACLR (L/U)   = ' num2str(ACLR_L) ' / '  num2str(ACLR_U) ' dB ' ]);    
    display([ 'ACPR (L/U)   = ' num2str(ACPR_L) ' / '  num2str(ACPR_U) ' dB ' ]); 
end