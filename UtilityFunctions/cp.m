function [meanPower, maxPower, PAPR] = cp(X, Display)
if nargin == 1
    Display = 1;
end
Power = abs(X) ;
Power = Power.^2 ;
meanPower = mean(Power) ;
meanPower = 10*log10(meanPower/100)+30 ;
maxPower = max(Power) ;
maxPower = 10*log10(maxPower/100)+30 ;
PAPR = maxPower - meanPower ;
if Display
    display([ 'Average Power = ' num2str(floor(100*meanPower)/100) ' dBm' ]);
    display([ 'Max Power     = ' num2str(floor(100*maxPower)/100)  ' dBm' ]);
    display([ 'PAPR          = ' num2str(floor(100*PAPR)/100)      ' dB ' ]);
end

end
