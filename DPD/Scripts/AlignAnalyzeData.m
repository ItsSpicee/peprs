%% Delay Adjustment and analyzing the signal
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Input Signal']);
CheckPower(In_ori,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Output Signal']);
CheckPower(Rec,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
Rec = SetMeanPower(Rec, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PA Input and Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alignFreqDomainFlag = 1;
xCovLength = 5000;
if (RX.SubRate > 1)
    FractionalDelayFlag = 1;
else 
    FractionalDelayFlag = 0;
end
% In_ori_RX = resample(In_ori, Signal.UpsampleRX,Signal.DownsampleRX);
[In_D,Out_D, ~] = AlignAndAnalyzeSignals(In_ori, Rec, RX.Fsample, alignFreqDomainFlag, xCovLength, FractionalDelayFlag, RX.SubRate);          
[freq, spectrum]   = CalculatedSpectrum(Out_D, RX.Fsample);
[ACLR_L, ACLR_U]   = CalculateACLR(freq, spectrum, 0, Signal.BW, TX.FGuard);
[ACPR_L, ACPR_U]   = CalculateACPR(freq, spectrum, 0, Signal.BW, TX.FGuard);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Desired Output and PA Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[In_D_EVM,Out_D_EVM, EVM_perc] = AlignAndAnalyzeSignals(In_ori_EVM(memTrunc+1:end), Rec, RX.Fsample, alignFreqDomainFlag, xCovLength, FractionalDelayFlag, RX.SubRate);          
%%
display([ 'NMSE         = ' num2str(EVM_perc)      ' % or ' num2str(10*log10((EVM_perc/100)^2))      ' dB ']);
NMSE_vec(IterationCount,:) = [EVM_perc 10*log10((EVM_perc/100)^2)];
display([ 'ACLR (L/U)   = ' num2str(ACLR_L) ' / '  num2str(ACLR_U) ' dB ' ]);
display([ 'ACPR_vsa (L/U)   = ' num2str(ACPR_L) ' / '  num2str(ACPR_U) ' dB ' ]);

switch DPD.Type
    case 'SquareRootBasis'
        if IterationCount == (DL_APD_modelParam.g2.ActivateIter)
            save('g1_FinalStatistics.mat', 'In_ori', 'Rec', 'In_D_EVM', 'Out_D_EVM', 'EVM_perc');
        end
end

% clear Rec
% clear In_ori_RX