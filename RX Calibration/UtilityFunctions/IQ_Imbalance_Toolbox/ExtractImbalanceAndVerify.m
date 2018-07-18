function [ score, CalResults ] = ExtractImbalanceAndVerify(svars)

    %% Extract imbalance modelling parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Check the input power of the input training signal
    In_train_raw              = svars.inputTrain;
    In_train_raw              = svars.inputTrain - mean(svars.inputTrain);
    [meanPower, maxPower, PAPR_original] = CheckPower(In_train_raw, 1);
    In_train              = SetMeanPower(In_train_raw, 0);
    [meanPower, maxPower, PAPR_input]	= CheckPower(In_train, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
    
    Q_offset    = svars.iOffset;
    I_offset    = svars.qOffset;
        
    AWG_In_signal = In_train - mean(In_train);
    Fsample_signal = svars.fSampleCal;
    PointsPerRecord = 2 * svars.fSampleScope * svars.frameTime;
    save('Scope_in.mat', 'PointsPerRecord');
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'svars', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
    waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));
%     AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower({In_train}, ...
%         {svars.fCarrier},{svars.fSampleCal},svars.fSampleAWG, ...
%         svars.ampCorr,false,[],0,PAPR_input,PAPR_original, I_offset, Q_offset);
%     AWG_M8190A_Reference_Clk('Backplane');
%     AWG_M8190A_DAC_Amplitude(1,svars.dacVFS);       % -1 dBm input is recommended for external I and Q inputs into PSG
%     AWG_M8190A_DAC_Amplitude(2,svars.dacVFS);
%     AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
%     AWG_M8190A_MKR_Amplitude(2,1.5);       % Set the trigger amplitude to 1.5 V 

    if strcmp(svars.rxType, 'UXA')
        % Get received I and Q signals 
        [Received_I, Received_Q] = IQCapture_UXA(svars.fRXCarrier, ...
            svars.fUxaAnalysisBandwidth, svars.frameTime, svars.uxaAddress, svars.uxaAtten, svars.ClockReference);
        Received_train = complex(Received_I, Received_Q);
  
        [DownSampleUXA, UpSampleUXA] = rat(svars.fSampleCal/ svars.fUxaAnalysisBandwidth);        
        
        Received_train = resample(Received_train, DownSampleUXA, UpSampleUXA);
    elseif strcmp(svars.rxType, 'Scope')
%         PointsPerRecord = 2 * svars.fSampleScope * svars.frameTime;
%         [ obj ] = SignalCapture_Scope(svars.scopeDriver, svars.fSampleScope, PointsPerRecord, svars.scopeRefClock);
        load('Scope_out.mat');
        Received_train = obj.Ch1_Waveform;
        Received_train = Received_train - mean(Received_train);
        % Downconvert the signal
        fDownconversion = svars.fRXCarrier;
        time_IQ = (0:(length(Received_train)-1))./svars.fSampleScope;
        if (svars.rxImgBand)
            Received_train = (Received_train .* exp(1i*2*pi*fDownconversion*time_IQ)).';
        else
            Received_train = (Received_train .* exp(1i*2*pi*-fDownconversion*time_IQ)).';
        end
        % Filter out the sideband
        Received_train=filter(svars.downconversionFilterTaps, [1 0],Received_train);
        load RXcal_mixer+scope_RXlo27r8025ghz_RXIF2r2ghz_BW4r4GHz
        Received_train = ApplyIfCal_real_imag(Received_train, svars.fSampleScope, ...
        tones_freq, comb_I_cal, comb_Q_cal);
        [DownSampleScope, UpSampleScope] = rat(svars.fSampleCal / svars.fSampleScope);
        Received_train = resample(Received_train, DownSampleScope, UpSampleScope);
        % Remove DC offset from LO feedthrough
        Received_train = Received_train - mean(Received_train);
        %         Received_train= digital_lpf(Received_train, svars.fSampleCal , svars.testBW /2);
        % Add DC tone to prevent the filter from optimizing for DC notch
        
    end
    
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Input Signal']);
    CheckPower(In_train,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Output Signal']);
    CheckPower(Received_train,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    Received_train = SetMeanPower(Received_train, 0);

    % Unify the lengths of the sampled data
    [In_train, Out_train]= UnifyLength(In_train, Received_train);

    [d_In,d_Out]              = AdjustPowerAndPhase(In_train, Out_train, 0);
    [d_In,d_Out, timedelay1]  = AdjustDelay(d_In,d_Out, svars.fSampleCal, 2000);
    [In_D,Out_D]              = AdjustPowerAndPhase(d_In,d_Out, 0) ;
    [In_D,Out_D]              = AdjustPowerAndPhase(In_D,Out_D, 0) ; 
    
    PlotGain(In_D,Out_D);
    PlotAMPM(In_D,Out_D);
    PlotSpectrum(In_D,Out_D, svars.fSampleTx);
   
    % TODO: Sometimes two AdjustPhase is needed
%         [In_D,Out_D] = AdjustPhase(In_D,Out_D,false);
%         [In_D,Out_D] = AdjustPhase(In_D,Out_D,false);

    % Get the EVM of the uncalibrated training signal
    [EVM_uncal_dB, EVM_uncal_perc] = CalculateEVM(In_D,Out_D);
    display([ 'EVM          = ' num2str(EVM_uncal_perc)      ' % ' ]);

        
    save('./Cal_output_MLIQ/TX_CAL_RAW_DATA_20MHz.mat', 'Out_D', 'In_D');
    
    % If we resample to a higher sampling rate, then the interpolation
    % causes the noise floor to have abrupt changes. The model should not
    % be modelling this, so we add white noise to ensure that the modelling
    % is done with a flat noise floor. 
    
    noise_density = sqrt(4 / 10^6);
%     noise_density = 0;
    noise = noise_density * (randn(length(Out_D),1) + j * randn(length(Out_D),1));
    
    % Calculate H (modelling) matrix using pseudo-inverse least-squares fitting
    [H_coeff, modeling_NMSE] = ImbalanceFilterExtraction(Out_D + noise, In_D, svars.filterTaps);
    [H_coeff_test, H_offset_test, modeling_NMSE_test] = ImbalanceFilterExtraction_with_offset(Out_D + noise, In_D, svars.filterTaps);
    display([ 'NMSE          = ' num2str(modeling_NMSE)      ' dB ' ]);
    display([ 'NMSE_test          = ' num2str(modeling_NMSE_test)      ' dB ' ]);
    CalResults =        struct( 'H_coeff',      H_coeff,         ... 
                                'I_offset',     svars.iOffset,   ...
                                'Q_offset',     svars.qOffset,   ...
                                'FsampleCal',   svars.fSampleCal, ...
                                'H_coeff_test', H_coeff_test,    ...
                                'H_offset_test', H_offset_test);
                            
    
                            %% Apply imbalance model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    In_test = svars.inputTest - mean(svars.inputTest);
    [meanPower, maxPower, PAPR_original] = CheckPower(In_test, 1);
    In_test = SetMeanPower(In_test, 0);
    [meanPower, maxPower, PAPR_input] = CheckPower(In_test, 1);
    
    [In_test, In_test_cal] = ApplyIQImbalanceCal(In_test, CalResults, svars.fSampleTx, svars.fSampleAWG, svars.useOffsetModel);
    In_test_cal = SetMeanPower(In_test_cal, 0);
    
    if (svars.useOffsetModel)
        Q_offset    = imag(H_offset_test);
        I_offset    = real(H_offset_test);
    else
        Q_offset    = svars.iOffset;
        I_offset    = svars.qOffset;
    end
    
%     AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower({In_test_cal}, ...
%             {svars.fCarrier},{svars.fSampleCal},svars.fSampleAWG, ...
%             svars.ampCorr,false,[],0,PAPR_input,PAPR_original,I_offset,Q_offset);
%         AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
%         AWG_M8190A_MKR_Amplitude(2,1.5);       % Set the trigger amplitude to 1.5 V 
    AWG_In_signal = In_test_cal;
    Fsample_signal = svars.fSampleTx;
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'svars', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
    waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));

    if strcmp(svars.rxType, 'UXA')
        [Received_I, Received_Q] = IQCapture_UXA(svars.fRXCarrier, ...
            svars.fUxaAnalysisBandwidth, svars.frameTime, svars.uxaAddress, svars.uxaAtten, svars.ClockReference);
        Received_test = complex(Received_I, Received_Q);
        [DownSampleUXA, UpSampleUXA] = rat(svars.fSampleTx/svars.fUxaAnalysisBandwidth);        
        Received_test = resample(Received_test, DownSampleUXA, UpSampleUXA);
    elseif strcmp(svars.rxType, 'Scope')
        PointsPerRecord = 2 * svars.fSampleScope * svars.frameTime;
%         [ obj ] = SignalCapture_Scope(svars.scopeDriver, svars.fSampleScope, PointsPerRecord, svars.scopeRefClock);
        load('Scope_out.mat');
        Received_test = obj.Ch1_Waveform;
        Received_test= Received_test - mean(Received_test);
        % Downconvert the signal
        fDownconversion = svars.fRXCarrier;
        time_IQ = (0:(length(Received_test)-1))./svars.fSampleScope;
        if (svars.rxImgBand)
            Received_test = (Received_test .* exp(1i*2*pi*fDownconversion*time_IQ)).';
        else
            Received_test = (Received_test .* exp(1i*2*pi*-fDownconversion*time_IQ)).';
        end
        Received_test = filter(svars.downconversionFilterTaps, [1 0],Received_test);
        % Filter out the sideband
        Received_test = ApplyIfCal_real_imag(Received_test, svars.fSampleScope, ...
        tones_freq, comb_I_cal, comb_Q_cal);
        [DownSampleScope, UpSampleScope] = rat(svars.fSampleTx / svars.fSampleScope);
        Received_test = resample(Received_test, DownSampleScope, UpSampleScope);
        % Remove DC offset
        Received_test = Received_test - mean(Received_test);
%         Received_test= digital_lpf(Received_test, svars.fSampleCal, 250e6);
    end
    
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Input Signal']);
    CheckPower(In_test,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Output Signal']);
    CheckPower(Received_test,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    Received_test = SetMeanPower(Received_test, 0);

    [In_test, Received_test]= UnifyLength(In_test, Received_test);
    [d_In,d_Out]              = AdjustPowerAndPhase(In_test, Received_test, 0);
    [d_In,d_Out, timedelay1]  = AdjustDelay(d_In,d_Out, svars.fSampleTx,1000);
    [In_D_test,Out_D_test]    = AdjustPowerAndPhase(d_In,d_Out, 0) ;
    [In_D_test,Out_D_test]    = AdjustPowerAndPhase(In_D_test,Out_D_test, 0) ;

    [EVM_dB, EVM_perc] = CalculateEVM(In_D_test,Out_D_test);
    [freq, spectrum]   = CalculatedSpectrum(Out_D_test,svars.fSampleTx);
    [ACLR_L, ACLR_U]   = CalculateACLR(freq, spectrum, 0, svars.testBW, svars.fGaurd);
    [ACPR_L, ACPR_U]   = CalculateACPR(freq, spectrum, 0, svars.testBW, svars.fGaurd);
    
    PlotGain(In_D_test,Out_D_test);
    PlotAMPM(In_D_test,Out_D_test);
    PlotSpectrum(In_D_test,Out_D_test, svars.fSampleTx);
    
    display([ 'EVM          = ' num2str(EVM_perc)      ' % ' ]);
    display([ 'ACLR (L/U)   = ' num2str(ACLR_L) ' / '  num2str(ACLR_U) ' dB ' ]);    
    display([ 'ACPR (L/U)   = ' num2str(ACPR_L) ' / '  num2str(ACPR_U) ' dB ' ]); 
    score = struct('evm_dB',        20*log10(EVM_perc/100),     ...
                   'evm_perc',      EVM_perc,               ...
                   'aclr_l',        ACLR_L,                 ...
                   'aclr_u',        ACLR_U,                 ...
                   'acpr_l',        ACPR_L,                 ...
                   'acpr_u',        ACPR_U,                 ...
                   'h_coeff',       H_coeff,                ...
                   'nmse',          modeling_NMSE);          ...
                   %'rx_pow',        rxpow);
end