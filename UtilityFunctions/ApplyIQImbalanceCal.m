function [xOri, xCor] = ApplyIQImbalanceCal(In, CalResults, FsampleTx)
    ResampleOrder = 80;
    [meanPower, maxPower, PAPR_original] = CheckPower(In, 1);
    
    H_coeff   = CalResults.H_coeff;

    FsampleCal= CalResults.FsampleCal;
    M_Imbalance  = length(H_coeff)/2;
    
    [Cal_Downsample, Cal_Upsample]  = rat(FsampleTx/FsampleCal);
    
    %%
    xOri   = In;
       
    % apply imbalance correction (delay compensated) at FsampleCal    
    In_resampled = resample(In, Cal_Upsample, Cal_Downsample, ResampleOrder);                      
    xCor        = [zeros(M_Imbalance - 1, 1); In_resampled];
    xCor        = ApplyImbalanceCorrection(xCor, H_coeff, M_Imbalance);     
    xCor        = resample(xCor, Cal_Downsample, Cal_Upsample, ResampleOrder);
    
%     H_coeff_I  = [zeros(length(In_resampled)-1, 1); H_coeff(1:end/2)];
%     H_coeff_Q  = [zeros(length(In_resampled)-1, 1); H_coeff(end/2+1:end)];
%     xCor_I        = ifft(fft(real(xCor)) .* fft(H_coeff_I));
%     xCor_I        = xCor_I(M_Imbalance:end);
%     xCor_Q        = ifft(fft(imag(xCor)) .* fft(H_coeff_Q));
%     xCor_Q        = xCor_Q(M_Imbalance:end);
%     xCor          = xCor_I + 1i*xCor_Q;                      
end