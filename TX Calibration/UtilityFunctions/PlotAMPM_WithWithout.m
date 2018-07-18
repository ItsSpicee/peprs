%% This function is used to plot the AM/PM characteristic
function PlotAMPM_WithWithout(In, Out, Out2)
[In, Out] = UnifyLength(In, Out);
[In, Out2] = UnifyLength(In, Out2);
figure();
hold on;
grid on;
% Compute the phase distortion
Phaseout = atan2(imag(Out), real(Out))-atan2(imag(In), real(In));
Phaseout2 = atan2(imag(Out2), real(Out2))-atan2(imag(In), real(In));
% Wrap the phase to -pi to pi
Ind = Phaseout>pi;
Phaseout = Phaseout-2*Ind*pi;
Ind = Phaseout<-pi;
Phaseout = Phaseout+2*Ind*pi;

Ind2 = Phaseout2>pi;
Phaseout2 = Phaseout2-2*Ind2*pi;
Ind2 = Phaseout2<-pi;
Phaseout2 = Phaseout2+2*Ind2*pi;
% plot the AMPM response in Degrees
plot( 10*log10(abs(In).^ 2/100)+30, Phaseout.*(180/pi), 'b.');
plot( 10*log10(abs(In).^ 2/100)+30, Phaseout2.*(180/pi), 'r.');
title('AM/PM Distortion', 'FontSize', 20);
xlabel('Input Power (dBm)', 'FontSize', 15);
ylabel('Phase Distortion (degree)', 'FontSize', 15);
hold off;

end
