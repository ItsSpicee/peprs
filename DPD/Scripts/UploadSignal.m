%% Uploading the signal
% In_ori                              = SetMeanPower(In_ori, PowerBand);	% Set the mean power of the I/Q signals to be uploaded
In_ori                              = SetMeanPower(In_ori, 0);          % Set the mean power of the I/Q signals to be used for DPD
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' Signal Stats Prior to Calibration ');
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
[~, ~, TX.AWG.ExpansionMarginSettings.PAPR_input]	= CheckPower(In_ori, 1);        % Check the PAPR of the input file to be uploaded to the transmitter

% Wrap the truncated length of the signal back to the beginnning 
% In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];

if (TX.FreqMultiplier.Flag)
    In_ori_mag = abs(In_ori).^(1/TX.FreqMultiplier.Factor);
    In_ori_phase = unwrap(angle(In_ori))/TX.FreqMultiplier.Factor;
    In_cal = In_ori_mag .* exp(1i*In_ori_phase);
    %In_cal = filter(TX.FreqMultiplier.Filter, 1, In_cal);
    %% REMOVE DC TEST 
    %In_cal = In_cal - mean(In_cal);
else
    In_cal = In_ori;
end

% Apply AWG Cal
if (Cal.AWG.Calflag)
    % If the AWG calibration was found at baseband (Cal.AWG.fOffset > 0) vs
    % at the signal IF (Cal.AWG.fOffset = 0)
    if (Cal.AWG.fOffset > 0)
        In_cal = ApplyLUTCalibration(In_cal, Signal.Fsample, ...
            Cal.AWG.ToneFreq_I - Cal.AWG.fOffset, Cal.AWG.RealCorr_I, Cal.AWG.ImagCorr_I);
    else
        In_cal_I = ApplyLUTCalibration(real(In_cal), Signal.Fsample, ...
            Cal.AWG.ToneFreq_I, Cal.AWG.RealCorr_I, Cal.AWG.ImagCorr_I);
        In_cal_I = real(In_cal_I);
        In_cal_Q = ApplyLUTCalibration(imag(In_cal), Signal.Fsample, ...
            Cal.AWG.ToneFreq_Q, Cal.AWG.RealCorr_Q, Cal.AWG.ImagCorr_Q);
        In_cal_Q = real(In_cal_Q);
        In_cal = complex(In_cal_I,In_cal_Q);
    end
end

% Apply TX cal
if (Cal.TX.Calflag && ~Cal.TX.IQCal)
    In_cal = ApplyLUTCalibration(In_cal, Signal.Fsample, ...
        Cal.TX.ToneFreq, Cal.TX.RealCorr, Cal.TX.ImagCorr);
elseif (Cal.TX.Calflag && Cal.TX.IQCal)
    % Apply IQ imbalance in the time or frequency domain
    if (strcmp(Cal.TX.Type,'Freq_Domain'))
        [In_cal_I, In_cal_Q] = ApplyInverseIQImbalanceFilters(real(In_cal), imag(In_cal), Signal.Fsample, ...
            Cal.TX.G11, Cal.TX.G12, Cal.TX.G21, Cal.TX.G22, Cal.TX.ToneFreq, Cal.TX.ToneFreq);        
        In_cal_I = real(In_cal_I);
        In_cal_Q = real(In_cal_Q);
        In_cal = complex(In_cal_I,In_cal_Q);
    else
        % Time domain calibration
        In_cal = ApplyIQImbalanceCal(In_cal, Cal.TX, Signal.Fsample);
    end
end

disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' Signal Stats After Calibration ');
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
In_cal = SetMeanPower(In_cal, 0);      % Set the mean power of the I/Q signals to be used for DPD
[~, ~, TX.AWG.ExpansionMarginSettings.PAPR_input]	= CheckPower(In_cal, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
% if IterationCount == 1
%     [~, ~, PAPR_original]	= CheckPower(In_cal, 1); 
% end

AWG_In_signal = In_cal;
Fsample_signal = Signal.Fsample;
% Fsample_signal = Signal.Fsample * p;
save('IQ_AWG_in.mat', 'AWG_In_signal', 'TX');

if (IterationCount > 1)
    autoscaleFlag = 1;
    save('Scope_in.mat', 'RX', 'autoscaleFlag');
end

clear In_cal In_cal_I In_cal_Q In_ori_mag In_ori_phase
