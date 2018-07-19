function [In, Out, Phase] = AdjustPhase(In, Out, KeepInput, SubRate)
% This function is used to make the average phase between the output and the input to zero
if nargin < 3; KeepInput = true; end
if nargin < 4; SubRate = 1; end

[In, Out] = UnifyLength(In, Out, SubRate);
if KeepInput
    Phase = angle(In(1:SubRate:end))-angle(Out);
    Ind = Phase>pi;
    Phase = Phase-2*Ind*pi;
    Ind = Phase<-pi;
    Phase = Phase+2*Ind*pi;
    Phase = mean(Phase);
    Out = Out*exp(1i*Phase);
else
    Phase = angle(Out)-angle(In(1:SubRate:end));
    Ind = Phase>pi;
    Phase = Phase-2*Ind*pi;
    Ind = Phase<-pi;
    Phase = Phase+2*Ind*pi;
    Phase = mean(Phase);
    In = In*exp(1i*Phase);
end

end
