function [Adjusted_In, Adjusted_Out, shift] = AdjustOffset(In, Out)
% Only adjust offset due to recording
[Cxy, lags] = xcov(abs(In), abs(Out));
[~, maxCxyIdx] = max(Cxy);
shift = lags(maxCxyIdx);
if (shift < 0)
    Adjusted_In  = In(1:end+shift);
    Adjusted_Out = Out(-shift+1:end);
elseif shift > 0
    Adjusted_In  = In(shift+1:end);
    Adjusted_Out = Out(1:end-shift+1);
end