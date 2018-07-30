function [ In_cal ] = ApplyImbalanceCalibration( In_cal, Fsample, Cal )
    [In_cal_I, In_cal_Q] = ApplyInverseIQImbalanceFilters(real(In_cal), imag(In_cal), Fsample, ...
        Cal.G11, Cal.G12, Cal.G21, Cal.G22, Cal.ToneFreq, Cal.ToneFreq);        
    In_cal_I = real(In_cal_I);
    In_cal_Q = real(In_cal_Q);
    In_cal = complex(In_cal_I,In_cal_Q);

    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' IQ Calibrated Signal']);
    CheckPower(In_cal, 1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end

