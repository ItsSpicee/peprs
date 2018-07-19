function [ sum_of_aligned_samples delay ] = Delay_Alignment_bel(data_vector, Fs, threshold, rataio)
% Returns vector with the same measurments but aligned in time
% rataio: the rataion of the input lenght used in finding the max delay
    [N, L]                 = size(data_vector);
    %data_aligned           = zeros(size(data_vector));
    sum_of_aligned_samples = zeros(1, L);
    delay                  = zeros(N,1);
    ref_norm               = data_vector(1, :);
    [num_samples, ~]       = size(data_vector); 
    Data_In                = ref_norm;
    %data_aligned(1, :)     = Data_In;
    % Take the elements of data_vector and find the time-delay vs. first
    % element.
    UpSample            = 20;
    Interpolation_Order = 3;
    Block_Size          = 1000; 
    orignalDataBlock_x2 = 2 * ( Block_Size + Interpolation_Order ) ;
    %mag_in_block_x2     = Data_In (  1 : orignalDataBlock_x2 ) ;
    data_length = floor(length(Data_In)/rataio);
    %data_length = length(Data_In);
    mag_in_block_x2      = Data_In(1:data_length);
    %Lagrange interpolation for the input signal
    [time_in_Lagrange  , mag_in_Lagrange  ] = LagrangeInterpolation ( mag_in_block_x2  , UpSample , Interpolation_Order  ) ;
    maxlags = floor ( length ( mag_in_Lagrange ) / 2 ) ;
    L = length(Data_In);
    full_f = -Fs/2:Fs/L:Fs/2-Fs/L;  
    measurment_discarded = [];
    for i=1:num_samples
        Data_Out = data_vector(i, :);
        %mag_out_block_x2    = Data_Out ( 1 : orignalDataBlock_x2 ) ;
        mag_out_block_x2    = Data_Out(1:data_length);
        %Lagrange interpolation
        %For the Output Signal
        [ time_out_Lagrange , mag_out_Lagrange ] = LagrangeInterpolation ( mag_out_block_x2 , UpSample , Interpolation_Order ) ;
        option = 'coeff' ; %, to normalize the sequence so the auto-covariances at zero lag are identically 1.0
        [ Cxy , lags ] = xcov ( (mag_out_Lagrange) , (mag_in_Lagrange) , maxlags , option ) ; %option: 'coeff', 'unbiased', 'biased'
        [ maxCxy , maxCxyIndex ] = max ( Cxy ) ;
        maxCxyLag = lags ( maxCxyIndex ) ;
        timedelay = ( maxCxyLag / ( ( UpSample + 1 ) * Fs ) ); % in seconds  
        display([  num2str(i) ', ' num2str(abs(maxCxy)) ', ' num2str(timedelay)]);
        %plot(lags, abs(Cxy))
        delay(i)      = timedelay;
        if abs(maxCxy) < threshold
            display('skipped')
            measurment_discarded = [measurment_discarded i];
            continue
        end
        % Time-shift all elements by the time delay relative to first element of
        % data_vector
        sample2_spec = fftshift(fft(Data_Out));
        time_shift = timedelay;
        sample2_spec = sample2_spec.*exp(2*pi*1i*time_shift*full_f);
        sample2_new = (ifft(ifftshift(sample2_spec)));    
        sum_of_aligned_samples = sum_of_aligned_samples + sample2_new; 
        %data_aligned(i, :) = sample2_new;
    end
    %data_aligned(measurment_discarded, :) = [];
    sum_of_aligned_samples = sum_of_aligned_samples/N;
end






