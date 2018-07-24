function [ score ] = GetImbalance(svars)

    %% Extract imbalance modelling parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    In_I            = svars.inputITrain;
    In_Q            = svars.inputQTrain;
    
    norm            = max(max(abs(In_I), max(abs(In_Q))));
    In_I            = In_I / norm * 10 ^ (- svars.backoff / 20);
    In_Q            = In_Q / norm * 10 ^ (- svars.backoff / 20);
    In_I_u          = resample(In_I, svars.awgUpSample, svars.awgDownSample);
    In_Q_u          = resample(In_Q, svars.awgUpSample, svars.awgDownSample);
    Waveform        = [In_I_u' + svars.iOffset; In_Q_u' + svars.qOffset];
    AWG_N8241A_SignalUpload(svars.awgHandle, Waveform, svars.awgNormalize);
    [x, y, EVM_perc, targetfSample] = PXA_CaptureResampleAnalyzeEVM( ...
        svars.inputITrain, svars.inputQTrain, svars.fCarrier, svars.fSampleRx, svars.fSampleTx, svars.frameTime, svars.pxaAddress, svars.pxaAtten, 1);
    
    % Calculate H (modelling) matrix using pseudo-inverse least-squares fitting
    if (svars.presetH ~= -1)
        H_coeff = svars.presetH;
        modeling_NMSE = svars.presetNMSE;
    else
        [H_coeff, modeling_NMSE] = ImbalanceFilterExtraction(y, x, svars.filterTaps);
    end
    
    %% Apply imbalance model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Construct the baseband test signal with imbalance calibration applied
    Training_length = svars.frameTimeVerify * svars.fSampleTx;
    x_cor = ApplyImbalanceCorrection(complex(svars.inputITest, ... 
        svars.inputQTest), H_coeff, svars.filterTaps);
    In_I  = real(x_cor(1:Training_length)); 
    In_Q  = imag(x_cor(1:Training_length)); 
    
    norm            = max(max(abs(In_I), max(abs(In_Q))));
    In_I            = In_I / norm * 10 ^ (- svars.backoff / 20);
    In_Q            = In_Q / norm * 10 ^ (- svars.backoff / 20);
    
    In_I_u          = resample(In_I, svars.awgUpSample, svars.awgDownSample);
    In_Q_u          = resample(In_Q, svars.awgUpSample, svars.awgDownSample);
    Waveform        = [In_I_u' + svars.iOffset; In_Q_u' + svars.qOffset];
    AWG_N8241A_SignalUpload(svars.awgHandle, Waveform, svars.awgNormalize);
    [x, y, EVM_perc, targetfSample, RxPower] = PXA_CaptureResampleAnalyzeEVM( ...
    svars.inputITest, svars.inputQTest, svars.fCarrier, svars.fSampleRx, svars.fSampleTx, svars.frameTimeVerify, svars.pxaAddress, svars.pxaAtten, 1);

    fG                = 300e3;       % Guard band for the modulated signal
    [freq, spectrum]  = Calculated_Spectrum_noplot( ... 
        real(y), imag(y), targetfSample);    
    [ACLR_L, ACLR_U]  = Calculate_ACLR(freq, spectrum, 0, svars.testBW, fG);    
    [ACPR_L, ACPR_U]  = Calculate_ACPR(freq, spectrum, 0, svars.testBW, fG);
    
    PlotGain(real(x), imag(x), real(y), imag(y)) ;
    PlotAMPM(real(x), imag(x), real(y), imag(y)) ;
    PlotSpectrum(real(x), imag(x), real(y), imag(y));
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
                   'nmse',          modeling_NMSE,          ...
                   'rx_pow',        RxPower);
end