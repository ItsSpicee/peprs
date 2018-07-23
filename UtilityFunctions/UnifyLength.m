function [In, Out] = UnifyLength(In, Out, SubRate)
%% This function allows the unification of the length of 4 vectors to a specific value or to a maximum value
% Check number of argument (i.e. if L was specified or no
% SubRate = In / Out
if nargin < 3
	SubRate = 1;
end
L = min([floor(length(In)/SubRate), length(Out)]);
% Crop the vector to the new length
In  = In (1:L*SubRate);

if (SubRate > 1)
    Out = Out(1:L);
else
    Out = Out(end-L+1:end);
end
end

