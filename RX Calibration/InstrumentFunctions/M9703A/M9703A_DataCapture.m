function [WaveformArray] = M9703A_DataCapture(repeat, M9703A_Obj, Channel1, PointsPerRecord, FullScaleRange, ACDCCoupling, interleaving_flag, Fs_adc)
    for i = 1: repeat 
        display(['    ' 'Measurment' num2str(i) '/' num2str(repeat)])
        WaveformArray(i, :) = M9703A_Acquisition_bel(M9703A_Obj, Channel1, ...
            PointsPerRecord, Fs_adc, FullScaleRange, ACDCCoupling, interleaving_flag);
    end
end

