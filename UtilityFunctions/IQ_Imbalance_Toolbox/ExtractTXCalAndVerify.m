function [ score, CalResults ] = ExtractTXCalAndVerify(svars)

    %% Extract imbalance modelling parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Check the input power of the input training signal
    In_train_raw              = svars.inputTrain;
    [meanPower, maxPower, PAPR_original] = CheckPower(In_train_raw, 1);
    In_train              = SetMeanPower(In_train_raw, 0);
    [meanPower, maxPower, PAPR_input]	= CheckPower(In_train, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
    
    AWG_M8190A_SignalUpload_ChannelSelect_FixedAvgPower({In_train}, ...
        {svars.fCarrier},{svars.fSampleCal},svars.fSampleAWG, ...
        svars.ampCorr,false,[],0,PAPR_input,PAPR_original);
    AWG_M8190A_Reference_Clk('Backplane');
    AWG_M8190A_DAC_Amplitude(1,svars.dacVFS);       % -1 dBm input is recommended for external I and Q inputs into PSG
    AWG_M8190A_DAC_Amplitude(2,svars.dacVFS);
    AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
    
    if strcmp(svars.rxType, 'UXA')
        % Get received I and Q signals 
        [Received_I, Received_Q] = IQCapture_UXA(svars.fRXCarrier, ...
            svars.fUxaAnalysisBandwidth, svars.frameTime, svars.uxaAddress, svars.uxaAtten, svars.ClockReference);
        Received_train = complex(Received_I, Received_Q);
  
        [DownSampleUXA, UpSampleUXA] = rat(svars.fSampleCal/ svars.fUxaAnalysisBandwidth);        
        
        Received_train = resample(Received_train, DownSampleUXA, UpSampleUXA);
    elseif strcmp(svars.rxType, 'Scope')
        PointsPerRecord = 2 * svars.fSampleScope * svars.frameTime;
        [ obj ] = SignalCapture_Scope(svars.scopeDriver, svars.fSampleScope, PointsPerRecord, svars.scopeRefClock);
        Received_train = obj.Ch1_Waveform;
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
        % Received_train= digital_lpf(Received_train, svars.fSampleScope, 250e6);
%         % Received_train=filter(svars.downconversionFilterTaps, [1 0],Received_train);
%         load RXcal_isolator+vdi+filter+scope_RXlo61r9025ghz_RXIF1e9ghz
%         Received_train = ApplyIfCal_real_imag(Received_train, svars.fSampleScope, ...
%         tones_freq, comb_I_cal, comb_Q_cal);
        [DownSampleScope, UpSampleScope] = rat(svars.fSampleCal / svars.fSampleScope);
        Received_train = resample(Received_train, DownSampleScope, UpSampleScope);
        % Received_train= digital_lpf(Received_train, svars.fSampleCal , 250e6);
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
    
    PlotGain(In_D,Out_D);
    PlotAMPM(In_D,Out_D);
    PlotSpectrum(In_D,Out_D, svars.fSampleTx);
   
    % TODO: Sometimes two AdjustPhase is needed
%         [In_D,Out_D] = AdjustPhase(In_D,Out_D,false);
%         [In_D,Out_D] = AdjustPhase(In_D,Out_D,false);

    % Get the EVM of the uncalibrated training signal
    [EVM_uncal_dB, EVM_uncal_perc] = CalculateEVM(In_D,Out_D);
    display([ 'EVM          = ' num2str(EVM_uncal_perc)      ' % ' ]);

        
    save('./Cal_output/TXCal_DigIQ/TX_CAL_RAW_DATA.mat', 'Out_D', 'In_D');
    
    % If we resample to a higher sampling rate, then the interpolation
    % causes the noise floor to have abrupt changes. The model should not
    % be modelling this, so we add white noise to ensure that the modelling
    % is done with a flat noise floor. 
    
    noise_density = sqrt(1 / 10^6);
    %noise_density  = 0;
    noise = noise_density * (randn(length(Out_D),1) + j * randn(length(Out_D),1));
    
    % Calculate H (modelling) matrix using pseudo-inverse least-squares fitting
    [H_coeff, modeling_NMSE] = TXFilterExtraction(Out_D + noise, In_D, svars.filterTaps);
    display([ 'NMSE          = ' num2str(modeling_NMSE)      ' dB ' ]);
        
    CalResults =        struct( 'H_coeff',      H_coeff,         ... 
                                'FsampleCal',   svars.fSampleCal);
                            
    %% Apply imbalance model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    In_test = svars.inputTest;
    [meanPower, maxPower, PAPR_original] = CheckPower(In_test, 1);
    In_test = SetMeanPower(In_test, 0);
    [meanPower, maxPower, PAPR_input] = CheckPower(In_test, 1);
    
    [In_test, In_test_cal] = ApplyIQImbalanceCal(In_test, CalResults, svars.fSampleTx, svars.fSampleAWG, false);
%     [In_test, In_test_cal] = ApplyTXCalibration(In_test, CalResults, svars.fSampleTx);
    In_test_cal = SetMeanPower(In_test_cal, 0);
    
    AWG_M8190A_SignalUpload_ChannelSelect_FixedAvgPower({In_test_cal}, ...
            {svars.fCarrier},{svars.fSampleCal},svars.fSampleAWG, ...
            svars.ampCorr,false,[],0,PAPR_input,PAPR_original);

    if strcmp(svars.rxType, 'UXA')
        [Received_I, Received_Q] = IQCapture_UXA(svars.fRXCarrier, ...
            svars.fUxaAnalysisBandwidth, svars.frameTime * 1.2, svars.uxaAddress, svars.uxaAtten, svars.ClockReference);
        Received_test = complex(Received_I, Received_Q);
        [DownSampleUXA, UpSampleUXA] = rat(svars.fSampleTx/svars.fUxaAnalysisBandwidth);        
        Received_test = resample(Received_test, DownSampleUXA, UpSampleUXA);
    elseif strcmp(svars.rxType, 'Scope')
        PointsPerRecord = 2 * svars.fSampleScope * svars.frameTime;
        [ obj ] = SignalCapture_Scope(svars.scopeDriver, svars.fSampleScope, PointsPerRecord, svars.scopeRefClock);
        Received_test = obj.Ch1_Waveform;
        % Downconvert the signal
        fDownconversion = svars.fRXCarrier;
        time_IQ = (0:(length(Received_test)-1))./svars.fSampleScope;
        Received_test = (Received_test .* exp(1i*2*pi*fDownconversion*time_IQ)).';
        Received_test=filter(svars.downconversionFilterTaps, [1 0],Received_test);
        %Received_test=filter(svars.downconversionFilterTaps, [1 0],Received_test);
        %Received_test= digital_lpf(Received_test, svars.fSampleScope, 165e6);
        % Filter out the sideband
%         Received_test = ApplyIfCal_real_imag(Received_test, svars.fSampleScope, ...
%         tones_freq, comb_I_cal, comb_Q_cal);
        [DownSampleScope, UpSampleScope] = rat(svars.fSampleCal / svars.fSampleScope);
        Received_test = resample(Received_test, DownSampleScope, UpSampleScope);
        % Received_test= digital_lpf(Received_test, svars.fSampleCal, 250e6);
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
    [d_In,d_Out, timedelay1]  = AdjustDelay(d_In,d_Out, svars.fSampleCal,500);
    [In_D_test,Out_D_test]    = AdjustPowerAndPhase(d_In,d_Out, 0) ; 

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