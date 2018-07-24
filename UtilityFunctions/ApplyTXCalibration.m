% the calibration is done at FsampleCal, which might be different from the
% sample rate of IQ (FsampleTx). 

function [xOri, xCor] = ApplyTXCalibration(In, CalResults, FsampleTx)
    ResampleOrder = 80;
    
    [meanPower, maxPower, PAPR_original] = CheckPower(In, 1);
    
    H_coeff   = CalResults.H_coeff;
    FsampleCal= CalResults.FsampleCal;
    M_Imbalance  = length(H_coeff);
    
    [Cal_Downsample, Cal_Upsample]  = rat(FsampleTx/FsampleCal);
    
    %%
    xOri   = In;
       
    % apply imbalance correction (delay compensated) at FsampleCal    
    In_resampled = resample(In, Cal_Upsample, Cal_Downsample, ResampleOrder);                      
    xCor        = [zeros(M_Imbalance - 1, 1); In_resampled];                        
    xCor        = ApplyTXCorrection(xCor, H_coeff, M_Imbalance);     
    xCor        = resample(xCor, Cal_Downsample, Cal_Upsample, ResampleOrder);                      

end