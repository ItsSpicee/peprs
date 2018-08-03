function [In_D, Out_D, timedelay] = ...
    AdjustDelay_FreqDomain(In, Out, Fs, BlockSize, InterpolationRate, InterpolationOrder,sign_delay)
%% Estimate the Delay
switch nargin
    case 2
        Fs = 100e6; ...92.16e6 ;
        BlockSize = 200 ;... 1000 ;
        InterpolationRate = 25 ;
        InterpolationOrder = 3 ;
        sign_delay = '' ; % No preference
    case 3
        BlockSize = 2000 ;
        InterpolationRate = 25 ;
        InterpolationOrder = 3 ;
        sign_delay = ''; 
    case 4
        InterpolationRate = 25 ;
        InterpolationOrder = 3 ;
        sign_delay = ''; 
    case 5
        InterpolationOrder = 3 ;
        sign_delay = ''; 
    case 6
        sign_delay = '';
    case 7
        if (~(strcmp(sign_delay,'positive') || strcmp(sign_delay,'negative')) )
            error('Wrong spelling of the delay sign');
        end
end
UpSample = InterpolationRate;

%convert the data to magnitude
mag_in  = abs ( In  );
mag_out = abs ( Out );

orignalDataBlock_x2 = 2 * ( BlockSize + InterpolationOrder );
mag_in_block_x2  = mag_in (  1 : orignalDataBlock_x2 );
mag_out_block_x2 = mag_out ( 1 : orignalDataBlock_x2 );

%Lagrange interpolation
%For the Output Signal
[time_out_Lagrange, mag_out_Lagrange] = LagrangeInterpolation(mag_out_block_x2,UpSample,InterpolationOrder);
%For the Input Signal
[time_in_Lagrange , mag_in_Lagrange]  = LagrangeInterpolation(mag_in_block_x2,UpSample,InterpolationOrder);

maxlags = floor ( length ( mag_in_Lagrange ) / 2 );
option = 'coeff' ; %, to normalize the sequence so the auto-covariances at zero lag are identically 1.0
[Cxy,lags] = xcov(mag_out_Lagrange,mag_in_Lagrange,maxlags,option); %option: 'coeff', 'unbiased', 'biased'

[ maxCxy , maxCxyIndex ] = max ( Cxy );

maxCxyLag = lags ( maxCxyIndex );

Cxy_temp = Cxy;
if (strcmp(sign_delay,'positive'));
    % take the positive delay
    Cxy_temp(lags < 0) = 0;
elseif(strcmp(sign_delay,'negative'))
    % take the negative delay 
    Cxy_temp(lags > 0) = 0;
end
[ maxCxy , maxCxyIndex ] = max ( Cxy_temp );
maxCxyLag = lags ( maxCxyIndex );

disp(['Lag is ',num2str(maxCxyLag) ]);

if (maxCxy < 0.7)
    disp(['WARNING: Maximum cross correlation value is less than 0.7: maxCxy = ',num2str(maxCxy)]);
end

timedelay = ( maxCxyLag / ( ( UpSample + 1 ) * Fs ) );
disp(['time delay is ',num2str(timedelay*1e09), ' nsec' ]);


%plot the corelation results
figure();
plot( lags , Cxy , '.r' ) ;
grid off ;
xlabel ( 'Lags' , 'FontSize' , 12 ) ;
ylabel ( 'Cross-Correlation' , 'FontSize' , 12 ) ;
legend ( 'Cross-Correlation' , 'Location', 'northoutside') ;
% adjust the axis properties for IEEE publication
set( gca , 'LineWidth' , 2  ) ;
set( gca , 'FontSize'  , 12 ) ;



%% Adjust the Estimated Delay
if (timedelay ~= 0) && (isnan ( timedelay ) == 0)
    % Zero pad the vector to ensure that the circular shift property is
    % held
    %Out_D = [Out; zeros(abs(round(timedelay * Fs)),1)];
    %Out = [Out; zeros(3*length(Out),1)];
    
    L = length(Out);
    full_f = -Fs/2:Fs/L:(Fs/2-Fs/L);  

    sample2_spec = fftshift(fft(Out));
    time_shift = timedelay;
    sample2_spec = sample2_spec.*exp(2*pi*1i*time_shift*full_f.');
    Out_D = (ifft(ifftshift(sample2_spec)));
    In_D = In;
else
    In_D = In;
    Out_D = Out;
end

end

