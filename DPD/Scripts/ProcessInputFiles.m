%Lower the noise floor
for i = 1:10
    Y = LimitPAPR(In_ori, Signal.PAPR_limit);
    %CheckPower(Y, 1);
    Y_filtered= digital_lpf(Y, Signal.Fsample, Signal.BW/2);
    %CheckPower(Y_filtered, 1);
    In_ori = Y_filtered;
end

if length(In_ori) < 4096
    error = sprintf('Number of samples must be greater than 4096. The current number of samples is %d',length(In_ori));
    return
end

CheckPower(In_ori, 1);
CheckPower(Y_filtered, 1);
PlotSpectrum(In_ori, In_ori, Signal.Fsample);

clear Y_filtered Y

