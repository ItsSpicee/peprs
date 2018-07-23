%% This function is used to plot the Gain distortion characteristic
function PlotGain(In, Out ,save_string)
[In, Out] = UnifyLength(In, Out) ;
f = figure();
hold on
grid on
plot(10*log10(abs(In).^2/100)+30, 20*log10(abs(Out)./abs(In)), '.') ;
title('Gain Distortion', 'FontSize', 20) ;
xlabel('Input Power (dBm)', 'FontSize', 15) ;
ylabel('Gain Distortion (dB)', 'FontSize', 15) ;
hold off

if nargin == 3

    xlim([-20 11]);
    ylim([-5 5]);
%     saveas(f,[ save_string '.jpg'])
    
end

end
