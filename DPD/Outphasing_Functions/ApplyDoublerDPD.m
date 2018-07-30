function [ In_cal, memTrunc ] = ApplyDoublerDPD( In_ori, modelParam )
    In_cal = APD_Apply(In_ori, modelParam.g2);
    memTrunc = length(In_ori) - length(In_cal);
    In_cal = [In_cal((end-(memTrunc-1)):end,1); In_cal];
%     In_cal = abs(In_ori).^(1/2) .* exp(1i * unwrap(angle(In_ori), pi) ./ 2);
    In_cal = APD_Apply(abs(In_cal).^(1/2) .* exp(1i * unwrap(angle(In_cal), pi) ./ 2), modelParam.g1);
    memTrunc = length(In_ori) - length(In_cal);
    In_cal = [In_cal((end-(memTrunc-1)):end,1); In_cal];
    
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Predistorted Signal']);
    In_cal = SetMeanPower(In_cal,0);
    CheckPower(In_cal, 1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end

