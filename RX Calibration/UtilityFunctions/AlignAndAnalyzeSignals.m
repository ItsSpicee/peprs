function [ In_D, Out_D, EVM_Perc] = AlignAndAnalyzeSignals( InputSignal, OutputSignal, Fsample, ...
    AlignFreqDomainFlag, XCovBlockLength, FractionalDelayFlag, SubRate)
    if (nargin < 4)
        AlignFreqDomainFlag = 0;
        XCovBlockLength = 2000;
        FractionalDelayFlag = 0;
        SubRate = 1;
    elseif (nargin < 5)
        XCovBlockLength = 2000;
        FractionalDelayFlag = 0;
        SubRate = 1;
    elseif (nargin < 6)
        FractionalDelayFlag = 0;
        SubRate = 1;
    elseif (nargin < 7)
        SubRate = 1;
    end

    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Input Signal']);
    CheckPower(InputSignal,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Output Signal']);
    CheckPower(OutputSignal,1);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    OutputSignal = SetMeanPower(OutputSignal, 0);
    
    [InputSignal, OutputSignal]  = UnifyLength(InputSignal, OutputSignal);
    [In_D1,Out_D1]    = AdjustPowerAndPhase(InputSignal, OutputSignal, 0) ;
    if (~AlignFreqDomainFlag)
        if (~FractionalDelayFlag)
            [In_D,Out_D, timedelay1]  = AdjustDelay(In_D1,Out_D1, Fsample, XCovBlockLength,25,3);
        else
           [In_D,Out_D, timedelay1]  = AdjustDelayFrac(In_D1,Out_D1, 13, false,SubRate); 
        end
    else
        [In_D,Out_D, timedelay1]  = AdjustDelay_FreqDomain(In_D1,Out_D1, Fsample, XCovBlockLength,25,3,'positive');
    end
    [In_D,Out_D]    = AdjustPowerAndPhase(In_D,Out_D, 0, true, SubRate) ;
    [In_D,Out_D]    = AdjustPowerAndPhase(In_D,Out_D, 0, true, SubRate) ;
    [In_D,Out_D]    = AdjustPowerAndPhase(In_D,Out_D, 0, true, SubRate) ;

    [~, EVM_Perc]      = CalculateEVM(In_D(1:SubRate:end),Out_D);
    
    PlotGain(In_D(1:SubRate:end),Out_D, 1);
    PlotAMPM(In_D(1:SubRate:end),Out_D, 1);
    PlotSpectrum(In_D(1:SubRate:end),Out_D, Fsample);
end

