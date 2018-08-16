function error = Analyze_Signal_PrecharDebug()
error = '';
load(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
try
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Input Signal']);
    CheckPower(In_ori,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Output Signal']);
    CheckPower(Rec,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    Rec = SetMeanPower(Rec, 0);

    if (RX.SubRate > 1)
        FractionalDelayFlag = 1;
    else 
        FractionalDelayFlag = 0;
    end

    [In_D, Out_D, NMSE] = AlignAndAnalyzeSignals(In_ori, Rec, RX.Fsample, RX.alignFreqDomainFlag, RX.xCovLength, FractionalDelayFlag, RX.SubRate);
catch
    error = 'An error has occurred while attempting to analyze the signal.';
end
save(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
end
