function error = Plot_Prechar_Spectrum(In, Out, Fs)
    error = '';
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

    if h.SegmentLength > length(In)
        error = sprintf('Number of samples must be greater than %f. The current number of samples is %f',h.SegmentLength,length(In));
        return
    end
    
    fig = figure();
    hold on
    grid on
    PSDin = plot(msspectrum(h, In, 'centerDC', true, 'Fs', Fs)) ;
    set(PSDin, 'Color', 'blue', 'LineWidth', 2) ;
    PSDout = plot(msspectrum(h, Out, 'centerDC', true, 'Fs', Fs)) ;
    set(PSDout, 'Color', 'red', 'LineWidth', 2 ) ;
    %legend( 'Input Power Spectrum Density' , 'Output Power Spectrum Density' , 1);
    legend( 'Input Power Spectrum Density' , 'Output Power Spectrum Density','Location','northoutside');
    title('')
    xlabel('')
    ylabel('')
    hold off
    
    saveas(fig,".\Figures\Prechar_Spectrum_Input.png")
end