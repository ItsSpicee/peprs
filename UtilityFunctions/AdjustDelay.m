function [In_D, Out_D, timedelay] = ...
    AdjustDelay(In, Out, Fs, BlockSize, InterpolationRate, InterpolationOrder,sign_delay)
%% Estimate the Delay
switch nargin
    case 2
        Fs = 100e6; ...92.16e6 ;
        BlockSize = 200 ;... 1000 ;
        InterpolationRate = 25 ;
        InterpolationOrder = 3 ;
        sign_delay = '' ; % No preference
    case 3
        BlockSize = 1000 ;
        InterpolationRate = 25 ;
        InterpolationOrder = 3 ;
        sign_delay = '' ; % No preference
    case 4
        InterpolationRate = 25 ;
        InterpolationOrder = 3 ;
        sign_delay = '' ; % No preference
    case 5
        InterpolationOrder = 3 ;
        sign_delay = '' ; % No preference
    case 6
        sign_delay = '' ; % No preference
    case 7
        if (strcmp(sign_delay,'') || strcmp(sign_delay,'') )
            error('Wrong spelling of the delay sign');
        end
end
length_of_data_used_for_the_correlation = 45e3;
advNum = 1000;
UpSample = InterpolationRate;
%Elimintate excedent data if they exist
if length ( In ) ~= length ( Out )
    N1 = length ( In  );
    N2 = length ( Out );
    if N1 > N2
        In = In(1:N2);
    elseif N1 < N2
        Out = Out(1:N1);
    end
end
if size ( In ) ~= size ( Out )
    Out = transpose ( In );
end
N = length ( In );
%take just the right amount of data that will be used in the delay estimation
if  N > length_of_data_used_for_the_correlation
    N = length_of_data_used_for_the_correlation;
    In = In ( 1 : N );
    Out = Out ( 1 : N );
end

%Discard the first advNum = 1000 data to remove the effects of the system
%initilization
In  = In ( advNum + 1 : N );
Out  = Out ( advNum + 1 : N );

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
disp(['MAx Lag is ',num2str(maxCxyLag) ]);


%~MBR
Cxy_temp = Cxy;
if (strcmp(sign_delay,'positive'));
    % take the positive delay
    Cxy_temp(lags < 0) = 0;
elseif(strcmp(sign_delay,'negative'))
    % take the negative delay 
    Cxy_temp(lags > 0) = 0;
end
[ ~ , maxCxyIndex ] = max ( Cxy_temp );
maxCxyLag = lags ( maxCxyIndex );




timedelay = ( maxCxyLag / ( ( UpSample + 1 ) * Fs ) ) * 1000;

disp(['time delay is ',num2str(timedelay*1e06), ' nsec' ]);
disp(['Taken Lag is ',num2str(maxCxyLag) ]);

%plot the corelation results
figure(99);
plot( lags , Cxy , '.r' ) ;
grid off ;
xlabel ( 'Lags' , 'FontSize' , 12 ) ;
ylabel ( 'Cross-Correlation' , 'FontSize' , 12 ) ;
%legend ( '\fontsize{12}Cross-Correlation' , 4 ) ;
legend ( '\fontsize{12}Cross-Correlation' , 'northoutside' ) ;
% adjust the axis properties for IEEE publication
set( gca , 'LineWidth' , 2  ) ;
set( gca , 'FontSize'  , 12 ) ;

% timedelay = 3.9428e-08 * 1000.0;
%% Adjust the Estimated Delay
if (timedelay ~= 0) && (isnan ( timedelay ) == 0)
    % Set parameters
    %The original signal will be reduced/augmented to UpSample/DownSample
    DownSample = 1;
    %The length of the FIR filter resample uses is proportional to n. The default for n is 10
    n = 20;
    % Upsample the Input ant Output
    Modified_In  = resample ( In , UpSample , DownSample , n ) ;
    Modified_Out  = resample ( Out , UpSample , DownSample , n ) ;
    %Compute the new Sampling Frequency after UpSampling
    Modified_Fs = UpSample * ( Fs ) ;
    timestep    = 1 / Modified_Fs ;
    Modified_L  = length ( Modified_In ) ;
    % Shift the Input and the Output
    shift     = abs ( round ( timedelay * 1e-03 / timestep ) ) ;
    if timedelay < 0
        Modified_In  = Modified_In ( shift+1 : Modified_L ) ;
        Modified_Out = Modified_Out ( 1:Modified_L-shift ) ;
    elseif timedelay > 0
        Modified_In  = Modified_In ( 1 : Modified_L-shift ) ;
        Modified_Out = Modified_Out( shift+1 : Modified_L ) ;
    end
    % Downsample
    Modified_In = resample ( Modified_In , DownSample , UpSample , n ) ;
    Modified_Out = resample ( Modified_Out , DownSample , UpSample , n ) ;
    
    %Eliminate corrupted data caused by the interpolation
    In_D  = Modified_In ( 1 : length(Modified_In)-1 ) ;
    Out_D = Modified_Out ( 1 : length(Modified_Out)-1 ) ;
else
    In_D = In;
    Out_D = Out;
end

end

