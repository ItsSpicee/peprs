function [In_D, Out_D] = ...
    AdjustDelayFrac(In, Out, FilterOrder, KeepInput, SubRate)
% Adjust delay using fractional delay filter
% FilterOrder must be odd, SubRate = Fs_In/Fs_Out
% KeepInput 
if nargin < 3
    FilterOrder = 13;
else
    if ~mod(FilterOrder, 2)
        warning('Fractional Delay Filter Order has to be odd');
    end
end
if nargin < 4; KeepInput = true; end
if nargin < 5; SubRate = 1; end

% Delay Estimation
%L = floor(length(In)/2.2);
L = 20000;
if mod(L, 2) > 0; L = L - 1; end;
InterpRate = 20;
% InT  = In(1000*SubRate+1:1000+L*SubRate);
% OutT = Out(1001:1000+floor(L/SubRate));
% [InT, OutT] = Extract_Signal_Peak(In, Out, 1000, SubRate);
% InT  = resample(InT,InterpRate,1);
% OutT = resample(OutT,SubRate*InterpRate,1);
% 
% [Cxy, lags] = xcov(abs(InT), abs(OutT));
% [~, maxCxyIdx] = max(Cxy);
% shift = lags(maxCxyIdx)
% delay_coarse = -1*(floor(-shift/InterpRate));
% delay_fine = mod(-shift,InterpRate)/InterpRate;

% The new delay estimation method
[InT, OutT] = Extract_Signal_Peak(In, Out, L, SubRate);
OutT = upsample(OutT,SubRate);
% OutT = resample(OutT,SubRate,1);

[Cxy, lags] = xcov(abs(InT), abs(OutT));
% [Cxy, lags] = xcov((InT), (OutT));
[~, maxCxyIdx] = max(Cxy);
%shift = lags(maxCxyIdx);
%delay_coarse = shift;
Cxy_up = resample(Cxy, InterpRate, 1);
lags_up = (0:length(Cxy_up)-1) + lags(1)*InterpRate;
[~, maxCxyIdx_up] = max(Cxy_up);
shiftXf = lags_up(maxCxyIdx_up);
delay_coarse = -1*(floor(-shiftXf/InterpRate));
delay_fine = mod(-shiftXf,InterpRate)/InterpRate;

display(['Coarse Delay ', num2str(delay_coarse), '  Fine Delay ', num2str(delay_fine)]);

% Delay Alignment
start_idx = [0, delay_coarse];
end_idx = [length(In), length(Out)*SubRate];
start_idx = max(start_idx) + 1 - start_idx;
end_idx = min(end_idx - start_idx) + start_idx;

InD = In(start_idx(1):end_idx(1));
OutD = Out(ceil(start_idx(2)/SubRate):ceil(end_idx(2)/SubRate));

SS = mod(delay_coarse, SubRate)+1;
DD = 1+(SS>1);
if KeepInput
    [Out_D, h_w] = FracDelayWin(OutD, -delay_fine, FilterOrder);
    In_D = InD(SS:end);
    Out_D = Out_D(DD:end-DD+1);
else
    [In_D, h_w] = FracDelayWin(InD, delay_fine, FilterOrder);
    In_D = In_D(SS:end);
    Out_D = OutD(DD:end-DD+1);
end

end
