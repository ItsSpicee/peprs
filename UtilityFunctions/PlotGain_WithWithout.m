%% This function is used to plot the Gain distortion characteristic
function PlotGain_WithWithout(In, Out, Out2)
[In, Out] = UnifyLength(In, Out);
[In, Out2] = UnifyLength(In, Out2);
figure();
hold on;
grid on;
plot(10*log10(abs(In).^2/100)+30, 20*log10(abs(Out)./abs(In)), '.');
plot(10*log10(abs(In).^2/100)+30, 20*log10(abs(Out2)./abs(In)), '.r');
title('Gain Distortion', 'FontSize', 20);
xlabel('Input Power (dBm)', 'FontSize', 15);
ylabel('Gain Distortion (dB)', 'FontSize', 15);
hold off;

end
