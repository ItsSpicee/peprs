function [Y] = LimitPAPR(X, PAPR_limit)
% if nargin == 1
%     Display = 0;
% end
Power = abs(X) ;
Power = Power.^2 ;
%Power_dB = 10*log10(Power/100)+30 ;

meanPower = mean(Power) ;
meanPower = 10*log10(meanPower/100)+30 ;
maxPower = max(Power) ;
maxPower = 10*log10(maxPower/100)+30 ;
%CheckPower(X, 1);


Power_limit_dB = meanPower + PAPR_limit - 30; 
Power_limit = 10^(Power_limit_dB/10);

voltage_limit  = sqrt(Power_limit * 100);

Y = X; 
Y (abs(Y) > voltage_limit) = Y(abs(Y) > voltage_limit)./abs(Y(abs(Y) > voltage_limit))* voltage_limit;

%CheckPower(Y, 1);

end
