% Set mean power to meanPower in dBm
function [ out ] = SetMeanPower( in , meanPower )

Offset = abs(in).^2;
Offset = mean(Offset);
Offset = 10 * log10( Offset / 100 ) + 30;
Offset = - Offset + meanPower;
Offset = 10^( Offset/20 );
out = in * Offset;

end
