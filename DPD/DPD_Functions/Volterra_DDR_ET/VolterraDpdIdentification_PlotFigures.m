function VolterraDpdIdentification_PlotFigures(In, Out)
    xin  = In;
    xout = Out;
    figure( )
        hold on
        grid on    
        plot( 10 * log10( abs( xin ) .^ 2 / 100 ) + 30 , ...
              20 * log10( abs( xout ) ./ abs( xin ) )  , 'b.' ) ;
            title(  'AM/AM Distortion' , 'FontSize' , 20 ) ;
            xlabel( 'Pin (dBm)'        , 'FontSize' , 15 ) ;
            ylabel( 'Pout./Pin (dB)'   , 'FontSize' , 15 ) ;
        hold off
    figure( )
        hold on    
        grid on
        Phaseout =   atan2( imag( xout ) , real( xout ) ) ...
                   - atan2( imag( xin )  , real( xin  ) ) ;
        Ind = Phaseout >   pi ;
            Phaseout = Phaseout - 2 * Ind * pi ;
        Ind = Phaseout < - pi ;
            Phaseout = Phaseout + 2 * Ind * pi ;
        plot( 10 * log10( abs( xin) .^ 2 / 100 ) + 30 , ...
              Phaseout .* ( 180 / pi ) , '.' ) ; 
            title(  'AM/PM Distortion'          , 'FontSize' , 20 ) ;
            xlabel( 'Pin (dBm)'                 , 'FontSize' , 15 ) ;
            ylabel( 'Phase distortion (degree)' , 'FontSize' , 15 ) ;
	figure()
        hold on
        grid on
        Fs   = 24 * 3.87e3 ;
        h                =  spectrum.welch ;
        h.OverlapPercent = 40              ;
        h.SegmentLength  = 2048            ;
        h.windowName     = 'Flat Top'      ;
        PSDin = plot( msspectrum( h , xin , 'centerdc' , Fs ) ) ;
            set( PSDin , 'Color' , 'blue' , 'LineWidth' , 2 ) ;
        PSDout = plot( msspectrum( h , xout , 'centerdc' , Fs ) ) ;
            set( PSDout , 'Color' , 'red' , 'LineWidth' , 2 ) ;
            legend( 'Input PSD' , 'Output PSD' , 1);
        hold off