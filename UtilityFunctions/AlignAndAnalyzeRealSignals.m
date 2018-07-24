function [ In_D, Out_D, EVM_Perc] = AlignAndAnalyzeRealSignals( InputSignal, OutputSignal, Fsample, XCovBlockLength)
    if nargin < 4
        XCovBlockLength = 2000;
    end
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Input Signal']);
    CheckPower(InputSignal,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Output Signal']);
    CheckPower(OutputSignal,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    
    [InputSignal, OutputSignal]  = UnifyLength(InputSignal, OutputSignal);
    InputSignal = SetMeanPower(InputSignal, 0);
    OutputSignal = SetMeanPower(OutputSignal, 0);
    [In_D,Out_D, timedelay1]  = AdjustDelay(InputSignal,OutputSignal, Fsample, XCovBlockLength,25,3);

    OutputSignal = SetMeanPower(OutputSignal, 0);
    InputSignal = SetMeanPower(InputSignal, 0);
    [~, EVM_Perc]      = CalculateEVM(In_D,Out_D);
    
    PlotGain(In_D,Out_D);
    PlotAMPM(In_D,Out_D);
    PlotSpectrum(In_D,Out_D, Fsample);
end

