%% Prepare Data
% Remove any DC offset due to the current method of IQ offset compensation
if (TX.SubtractMeanFlag)
    In_ori = In_ori - mean(In_ori);
end

In_ori = SetMeanPower(In_ori, 0);
[meanPower, maxPower, TX.AWG.ExpansionMarginSettings.PAPR_original] = CheckPower(In_ori, 1);
data_length = length(In_ori);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' The length of the signals   = ',num2str(data_length)]);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

% The signal that will be used for computing the EVM
In_ori_EVM = resample(In_ori,Signal.UpsampleRX,Signal.DownsampleRX);

% If we are using a sub-sampling TOR, then we first apply the receiver 
% calibration during the training phase before 
if RX.SubRate > 1 && Cal.RX.Calflag == 1
    In_ori = ApplyLUTCalibration(In_ori, Signal.Fsample, Cal.RX.ToneFreq', Cal.RX.RealCorr, Cal.RX.ImagCorr);
end

% Predistort the signal with a certain expansion before performing DPD
% training to train the DPD with the PA stimulated by the expanded signal
if TX.GainExpansion_flag 
    InflectionPoint=0.2;
    [ In_ori ] = Generate_XdB_Expansion(In_ori,TX.GainExpansion,InflectionPoint);
    CheckPower(In_ori, 1);
end
