function NMSE = CalculateNMSE(In, Out, Display)
%% This function calculate the Normalized mean square error between two signals
if nargin == 2
    Display = false ;
end
[In, Out] = UnifyLength(In, Out);
NMSE = 10*log10(mean(abs(In-Out).^2)/mean(abs(In).^2));
if Display
    display(['NMSE = ' num2str(NMSE)]) ;
end

end
