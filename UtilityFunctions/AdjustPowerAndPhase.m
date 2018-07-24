function [In, Out, Offset, Phase] = AdjustPowerAndPhase(In, Out, PowerInputdB, KeepInput, SubRate)
%% This function is used to adjust the SSG and the phase of two signals to 0
if nargin < 3; PowerInputdB = 0; end
if nargin < 4; KeepInput = true; end
if nargin < 5; SubRate = 1; end

[In, Out] = UnifyLength(In, Out, SubRate);

% set the small signal gain to 0
[Offset_in, ~, ~] = CheckPower(In);
[Offset_out, ~, ~] = CheckPower(Out);

if KeepInput
    Offset = Offset_in - Offset_out;
    Offset = 10^( Offset/20 );
    Out = Out * Offset;
else
    Offset = Offset_out - Offset_in;
    Offset = 10^( Offset/20 );
    In = In * Offset;
end
% In case the input power is given
if nargin > 2
    [In] = SetMeanPower(In, PowerInputdB);
    [Out] = SetMeanPower(Out, PowerInputdB);
end
[In, Out, Phase] = AdjustPhase(In, Out, KeepInput, SubRate);

end
