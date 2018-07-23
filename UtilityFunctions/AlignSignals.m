function [varargout] = AlignSignals(varargin)
% Align data according
if nargin < 1 || nargout ~= nargin
    error('Numbers of inputs and outputs not equal');
end

UpRate = 25;
start_idx = zeros(1, nargin);
in_up = cellfun(@(x) resample(x, UpRate, 1, 20), varargin, 'UniformOutput', false);
end_idx = cellfun(@length, in_up);
varargout = cell(1, nargin);

% find the offsets
for idx = 2:nargin
   start_idx(idx) =  FindOffset(in_up{1}, in_up{idx});
end
% make the shift
start_idx = max(start_idx) + 1 - start_idx;
end_idx = min(end_idx - start_idx) + start_idx;
for idx = 1:nargin
    varargout{idx} = in_up{idx}(start_idx(idx):end_idx(idx));
end
varargout = cellfun(@(x) resample(x, 1, UpRate, 20), varargout, 'UniformOutput', false);

end

function [shift] = FindOffset(In, Out)
% Only adjust offset due to recording with s subset of signals
threshold = 10000;
if length(In) > threshold && length(Out) > threshold
    In = In(1:threshold); Out = Out(1:threshold);
end

[Cxy, lags] = xcov(abs(In), abs(Out));
[~, maxCxyIdx] = max(Cxy);
shift = lags(maxCxyIdx);

end
