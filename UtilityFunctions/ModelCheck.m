function [NMSE] = ModelCheck(x, y, y_model, varargin)

xin = x ;
xout = y ;
xmod = y_model;
if nargin == 4
    figure('name', varargin{1})
else
    figure( )
end
subplot(2,1,1);
hold on
grid on
plot( 10 * log10( abs( xin ) .^ 2 / 100 ) + 30 , ...
    20 * log10( abs( xout ) ./ abs( xin ) )  , 'ro' ) ;
title(  'AM/AM Distortion' , 'FontSize' , 20 ) ;
xlabel( 'Pin (dBm)'        , 'FontSize' , 15 ) ;
ylabel( 'Pout./Pin (dB)'   , 'FontSize' , 15 ) ;

plot( 10 * log10( abs( xin ) .^ 2 / 100 ) + 30 , ...
    20 * log10( abs( xmod) ./ abs( xin ) )  , 'b.' ) ;

h1 = subplot(2,1,1);
legend( 'Y' , 'Y Model' , 1);
hold off

subplot(2,1,2);
hold on
grid on

phChange_actual = radtodeg(angle(xout./xin));
phChange_model = radtodeg(angle(xmod./xin));

plot( 10 * log10( abs( xin ) .^ 2 / 100 ) + 30, ...
    phChange_actual, 'ro');
title(  'AM/PM Distortion' , 'FontSize' , 20 ) ;
xlabel( 'Pin (dBm)'        , 'FontSize' , 15 ) ;
ylabel( 'Phaseout-Phasein (deg)'   , 'FontSize' , 15 ) ;

plot( 10 * log10( abs( xin ) .^ 2 / 100 ) + 30, ...
    phChange_model, 'b.');

h2 = subplot(2,1,2);
legend( 'Y' , 'Y Model' , 1);
hold off

NMSE = CalculateNMSE(y, y_model, 0);

end
