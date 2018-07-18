%% This function is used to plot the Gain distortion characteristic
function PlotGain(In, Out ,save_string)
[In, Out] = UnifyLength(In, Out) ;
f = figure();
hold on
grid on
plot(abs(In)./max(abs(In)), abs(Out)./max(abs(Out)), '.') ;
% plot(20*log10(abs(In))+10, 20*log10(abs(Out))+10, '.') ;
title('AM/AM Distortion', 'FontSize', 14, 'FontWeight', 'Bold') ;
% xlabel('Input Power (dBm)', 'FontSize', 15) ;
% ylabel('Output Power (dBm)', 'FontSize', 15) ;
xlabel('Normalized Input Voltage (V)', 'FontSize', 14, 'FontWeight', 'Bold') ;
ylabel('Normalized Output Voltage (V)', 'FontSize', 14, 'FontWeight', 'Bold') ;
hold off

if nargin == 3

    xlim([-20 11]);
    ylim([-10 10]);
    saveas(f,[ save_string '.jpg'])
    
end

end
