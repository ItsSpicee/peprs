function [ CalResults ] = ExtractImbalanceAndVerify_WithAWGCorrection_Freq(svars)

    %% Extract imbalance modelling parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Check the input power of the input training signal
    In_train_raw              = svars.inputTrain - mean(svars.inputTrain);
    [meanPower, maxPower, PAPR_original] = CheckPower(In_train_raw, 1);
    In_train              = SetMeanPower(In_train_raw, 0);
    [meanPower, maxPower, PAPR_input]	= CheckPower(In_train, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
    
    
    In_train_I = real(In_train);
    In_train_Q = imag(In_train);
    % Apply AWG Correction
    if (svars.awgCalFlag)
        tones_ref_validation = ApplyIfCal_real_imag(In_train_I, svars.fSampleCal, ...
         svars.awgCorrectionI.tonesBaseband, real(svars.awgCorrectionI.H_Tx_freq_inverse), imag(svars.awgCorrectionI.H_Tx_freq_inverse));
        In_train_I = real(tones_ref_validation);
        tones_ref_validation = ApplyIfCal_real_imag(In_train_Q, svars.fSampleCal, ...
         svars.awgCorrectionQ.tonesBaseband, real(svars.awgCorrectionQ.H_Tx_freq_inverse), imag(svars.awgCorrectionQ.H_Tx_freq_inverse));
        In_train_Q = real(tones_ref_validation);
    end
    In_train_cal = complex(In_train_I, In_train_Q);

    Q_offset    = svars.iOffset;
    I_offset    = svars.qOffset;
        
    AWG_In_signal = In_train_cal - mean(In_train_cal);
    Fsample_signal = svars.fSampleCal;
    measured_periods = 75;
    FramTime = svars.frameTime;
    PointsPerRecord = measured_periods * svars.fSampleScope * svars.frameTime;
    save('Scope_in.mat', 'PointsPerRecord', 'measured_periods', 'FramTime');
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'svars', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
    waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));

    if strcmp(svars.rxType, 'UXA')
        % Get received I and Q signals 
        [Received_I, Received_Q] = IQCapture_UXA(svars.fRXCarrier, ...
            svars.fUxaAnalysisBandwidth, svars.frameTime, svars.uxaAddress, svars.uxaAtten, svars.ClockReference);
        Received_train = complex(Received_I, Received_Q);
  
        [DownSampleUXA, UpSampleUXA] = rat(svars.fSampleCal/ svars.fUxaAnalysisBandwidth);        
        
        Received_train = resample(Received_train, DownSampleUXA, UpSampleUXA);
    elseif (strcmp(svars.rxType, 'Scope') || strcmp(svars.rxType, 'Digitizer')) 
%         PointsPerRecord = 2 * svars.fSampleScope * svars.frameTime;
%         [ obj ] = SignalCapture_Scope(svars.scopeDriver, svars.fSampleScope, PointsPerRecord, svars.scopeRefClock);
        load('Scope_out.mat');
%         Received_train = obj.Ch1_Waveform;
        Received_train = waveform;
        if (strcmp(svars.rxType, 'Scope'))
            Received_train = Received_train(end-200e3+1:end);
        else
            Received_train = Received_train(end-40000+1:end).';
        end
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
%         load RXcal_mixer+scope_RXlo27r8025ghz_RXIF2r2ghz_BW4r4GHz
        Received_train = ApplyIfCal_real_imag(Received_train, svars.fSampleScope, ...
            svars.rxCorrectionTonesFreq, svars.rxCorrectionCombICal, svars.rxCorrectionCombQCal);
        [DownSampleScope, UpSampleScope] = rat(svars.fSampleCal / svars.fSampleScope);
        Received_train = resample(Received_train, DownSampleScope, UpSampleScope);
        % Remove DC offset from LO feedthrough
        Received_train = Received_train - mean(Received_train);
        ps(Received_train,Received_train,svars.fSampleCal);
    end
    
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Input Signal']);
    CheckPower(In_train,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Output Signal']);
    CheckPower(Received_train,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    Received_train = SetMeanPower(Received_train, 0);
    Received_train = Received_train(end-100000+1:end);

    % Unify the lengths of the sampled data
    [In_train, Out_train]= UnifyLength(In_train, Received_train);
    
    [d_In,d_Out]              = AdjustPowerAndPhase(In_train, Out_train, 0);
    [d_In, d_Out, timedelay1] = AdjustDelay_FreqDomain(d_In,d_Out, svars.fSampleCal, 1000);
%     [d_In, d_Out, timedelay1] = AdjustDelay(d_In,d_Out, svars.fSampleCal, 1000);
    [In_D,Out_D]              = AdjustPowerAndPhase(d_In,d_Out, 0) ;
    [In_D,Out_D]              = AdjustPowerAndPhase(In_D,Out_D, 0) ; 

    PlotGain(In_D,Out_D);
    PlotAMPM(In_D,Out_D);
    PlotSpectrum(In_D,Out_D, svars.fSampleTx);

    % Get the EVM of the uncalibrated training signal
    [EVM_uncal_dB, EVM_uncal_perc] = CalculateEVM(In_D,Out_D);
    display([ 'EVM          = ' num2str(EVM_uncal_perc)      ' % ' ]);
    
  
  
%% Extraction of fitlers
Num_iter = 4;
G = cell(Num_iter,1);
iter = 1;
[ tones_22, G{iter} ] = ImbalanceFilterExtraction_FreqDomain( In_D, Out_D, svars.fSampleCal );

for iter = 2:Num_iter
    filter_BW   = 481e6;
    [ In_test,In_test_awgcal ] = prepare_signal( svars, filter_BW );    
    [I_corr, Q_corr ] = apply_inverseFilters(real(In_test_awgcal), imag(In_test_awgcal),  svars.fSampleTx, G{iter-1}.G11, G{iter-1}.G12, G{iter-1}.G21, G{iter-1}.G22, tones_22, tones_22); 
    I_corr   = real(I_corr);
    Q_corr   = real(Q_corr);
    % Upload
        In_test_cal = complex(I_corr,Q_corr);
        In_test_cal = SetMeanPower(In_test_cal, 0);
        ps(In_test_cal,In_test_cal,8e9);
        AWG_In_signal = In_test_cal - mean(In_test_cal);
        Fsample_signal = svars.fSampleTx;
        PointsPerRecord = 2 * svars.fSampleScope * svars.frameTimeVerify;
        save('Scope_in.mat', 'PointsPerRecord');
        save('IQ_AWG_in.mat', 'AWG_In_signal', 'svars', 'Fsample_signal', 'PAPR_input', 'PAPR_original', 'I_offset', 'Q_offset');
        waitfor(msgbox('Upload and download signal from 32 bit MATLAB. Press OK when finished.'));
    % Download
        load('Scope_out.mat');
%         Received_test = obj.Ch1_Waveform;
        Received_test = waveform.';
        if (strcmp(svars.rxType, 'Scope'))
            Received_test = Received_test(end-2*200e3+1:end);
        else
            Received_test = Received_test(end-40000+1:end);
        end
        Received_test = Received_test - mean(Received_test);
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
            svars.rxCorrectionTonesFreq, svars.rxCorrectionCombICal, svars.rxCorrectionCombQCal);
        [DownSampleScope, UpSampleScope] = rat(svars.fSampleTx / svars.fSampleScope);
        Received_test = resample(Received_test, DownSampleScope, UpSampleScope);
        % Remove DC offset
        Received_test = Received_test - mean(Received_test);
         disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        disp([' Input Signal']);
        CheckPower(In_test,1);
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        disp([' Output Signal']);
        CheckPower(Received_test,1);
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        Received_test = SetMeanPower(Received_test, 0);
        Received_test = Received_test(end-100000+1:end);

        
        
        [In_test, Received_test]= UnifyLength(In_test, Received_test);
        [d_In,d_Out]              = AdjustPowerAndPhase(In_test, Received_test, 0);
        [d_In, d_Out, timedelay1] = AdjustDelay_FreqDomain(d_In,d_Out, svars.fSampleTx, 1000);
    %     [d_In,d_Out, timedelay1]  = AdjustDelay(d_In,d_Out, svars.fSampleTx,5000);
        [In_D_test,Out_D_test]    = AdjustPowerAndPhase(d_In,d_Out, 0) ;
        [In_D_test,Out_D_test]    = AdjustPowerAndPhase(In_D_test,Out_D_test, 0) ;

    [EVM_dB, EVM_perc] = CalculateEVM(In_D_test,Out_D_test);
    [freq, spectrum]   = CalculatedSpectrum(Out_D_test,svars.fSampleTx);
    [ACLR_L, ACLR_U]   = CalculateACLR(freq, spectrum, 0, svars.testBW, svars.fGaurd);
    [ACPR_L, ACPR_U]   = CalculateACPR(freq, spectrum, 0, svars.testBW, svars.fGaurd);
    display([ 'EVM          = ' num2str(EVM_perc)      ' % ' ]);
    display([ 'ACLR (L/U)   = ' num2str(ACLR_L) ' / '  num2str(ACLR_U) ' dB ' ]);    
    display([ 'ACPR (L/U)   = ' num2str(ACPR_L) ' / '  num2str(ACPR_U) ' dB ' ]); 

    L = 500;
    PlotGain(In_D_test(L:end-L),Out_D_test(L:end-L));
    PlotAMPM(In_D_test(L:end-L),Out_D_test(L:end-L));
    
    [ tones_22, G{iter} ] = ImbalanceFilterExtraction_FreqDomain( In_D_test, Out_D_test, svars.fSampleTx );
    [ G{iter} ] = CascadedFreqImbalanceFilters ( G{iter-1}, G{iter} );


end

 CalResults =        struct( 'tones', tones_22, ...
                                'G',         G );

end