%% This function is used to set the maximum power of a signal to a desired value in dBm
function [ Out ] = SetMaxPower( In, maxPower )
% Find the actual mean power
Offset = abs(In).^2 ;
Offset = max(Offset) ;
Offset = 10 * log10(Offset/100) + 30 ;
% Find the offset
Offset = - Offset + maxPower ;
Offset = 10^(Offset/20) ;
% Adjust the power to meanPower
Out = In*Offset ;

end
