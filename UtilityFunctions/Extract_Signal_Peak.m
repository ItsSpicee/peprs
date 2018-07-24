function [x, y, start_ind, end_ind] = Extract_Signal_Peak(all_x, all_y, training_length, SubRate)
% Extra the peak power region
if nargin < 4
    SubRate = 1;
end

if length(all_x) < length(all_y) * SubRate
	DebugPrint('PA input file smaller than output file');
elseif length(all_x) > length(all_y) * SubRate
	DebugPrint('PA input file larger than output file');
else
	DebugPrint('PA input and output files are same length');
end

[all_x, all_y] = UnifyLength(all_x, all_y, SubRate);
[start_ind, end_ind, ~, y] = ReturnPeakRegion(all_y, floor(training_length/SubRate));
x = all_x((start_ind-1)*SubRate+1:end_ind*SubRate);

end
