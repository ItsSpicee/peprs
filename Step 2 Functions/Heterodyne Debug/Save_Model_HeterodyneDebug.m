function error = Save_Model_HeterodyneDebug()
    load('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
    error = '';
    try
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Save Inverse Model Data
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        addpath(genpath(Cal.SaveLocation));
        save([Cal.SaveLocation], 'H_Tx_freq_inverse', 'tonesBaseband');
    catch
        error = 'A problem has occurred while attempting to save inverse model data';
    end
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
end