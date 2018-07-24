function [SAMeas, figHandle] = Save_Spectrum_Data()
    if exist('UXAConfig.mat', 'file')
        load('UXAConfig.mat');
    else
        UXAConfig = [];
    end
    [ UXAConfig ] = Load_UXA_Config( UXAConfig );
    if strcmp(UXAConfig.Model,'UXA')
        Setup_SA_Windows_UXA ( UXAConfig );
    end
    [ SAMeas ] = SACapture_UXA( UXAConfig )

    figure
    figHandle = plot(SAMeas.SAFreq /1e9, SAMeas.SAPSD);
    xlabel('Frequency (GHz)');
    ylabel('PSD (dBm/Hz)');
    grid on;
end