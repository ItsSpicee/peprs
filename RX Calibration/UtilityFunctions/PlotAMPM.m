%% This function is used to plot the AM/PM characteristic
function PlotAMPM(In, Out, save_string)
[In, Out] = UnifyLength(In, Out) ;
figure()
hold on
grid on
% Compute the phase distortion
Phaseout = atan2(imag(Out), real(Out))-atan2(imag(In), real(In)) ;
% Wrap the phase to -pi to pi
Ind = Phaseout>pi ;
Phaseout = Phaseout-2*Ind*pi ;
Ind = Phaseout<-pi ;
Phaseout = Phaseout+2*Ind*pi ;
% plot the AMPM response in Degrees
f = plot( 10*log10(abs(In).^ 2/100)+30, Phaseout.*(180/pi), 'r.') ;
title('AM/PM Distortion', 'FontSize', 20) ;
xlabel('Input Power (dBm)', 'FontSize', 15) ;
ylabel('Phase Distortion (degree)', 'FontSize', 15) ;
hold off


if nargin == 3

    xlim([-20 11]);
	ylim([-40 40]);
%     saveas(f,[ save_string '.jpg'])
    
end

end
