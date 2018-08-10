%% This function is used to plot the Spectrum
function PlotSpectrum(In, Out, Fs)
% check if Fs and h are given as input variable or set them to
% default values
switch nargin
    case 2
        Fs = 100e6;
        %             Fs = 92.16e6; %default value
        h = spectrum.welch ;
        h.OverlapPercent = 95 ;
        h.SegmentLength = 4096 ;
        h.windowName = 'Flat Top';
    case 3
        h = spectrum.welch ;
        h.OverlapPercent = 95 ;
        h.SegmentLength = 4096 ;
        h.windowName = 'Flat Top';
end

figure();
hold on
grid on
PSDin = plot(msspectrum(h, In, 'centerDC', true, 'Fs', Fs)) ;
set(PSDin, 'Color', 'blue', 'LineWidth', 2) ;
PSDout = plot(msspectrum(h, Out, 'centerDC', true, 'Fs', Fs)) ;
set(PSDout, 'Color', 'red', 'LineWidth', 2 ) ;
%legend( 'Input Power Spectrum Density' , 'Output Power Spectrum Density' , 1);
legend( 'Input Power Spectrum Density' , 'Output Power Spectrum Density','Location','northoutside');
hold off

saveFig = figure('visible','off');
PSDin = plot(msspectrum(h, In, 'centerDC', true, 'Fs', Fs)) ;
set(PSDin, 'Color', 'blue', 'LineWidth', 2) ;
PSDout = plot(msspectrum(h, Out, 'centerDC', true, 'Fs', Fs)) ;
set(PSDout, 'Color', 'red', 'LineWidth', 2 ) ;
legend( 'Input Power Spectrum Density' , 'Output Power Spectrum Density','Location','northoutside');
title('')
xlabel('')
ylabel('')
saveas(saveFig,".\Figures\Prechar_Spectrum_Output.png")

end
