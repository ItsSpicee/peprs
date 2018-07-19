function [ InputSignal_Cal ] = ApplyAWGCorrection( InputSignal, Fsample, AWG_Correction_I, AWG_Correction_Q)
    InputSignal_I = real(InputSignal);
    InputSignal_Q = imag(InputSignal);
    InputSignal_I = real(ApplyLUTCalibration(InputSignal_I, Fsample, ...
     AWG_Correction_I.tonesBaseband, real(AWG_Correction_I.H_Tx_freq_inverse), imag(AWG_Correction_I.H_Tx_freq_inverse)));
    InputSignal_Q = real(ApplyLUTCalibration(InputSignal_Q, Fsample, ...
     AWG_Correction_Q.tonesBaseband, real(AWG_Correction_Q.H_Tx_freq_inverse), imag(AWG_Correction_Q.H_Tx_freq_inverse)));
    InputSignal_Cal = complex(InputSignal_I, InputSignal_Q);
end

