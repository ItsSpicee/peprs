% centerFreq, ampCorr, ampCorrfile are used in DPD and Signal Gen.

function Set_AWGCal_General(dict)
    dict.vfs = str2double(dict.vfs);
    dict.trigAmp = str2double(dict.trigAmp);
    dict.clkFreq = str2double(dict.clkFreq);
    dict.centerFreq = str2double(dict.centerFreq);
    
    load(".\Measurement Data\AWG Calibration Parameters\TX.mat")
    TX.VFS = dict.vfs;
    TX.TriggerAmplitude = dict.trigAmp;
    TX.ReferenceClock = dict.clkFreq;
    save(".\Measurement Data\AWG Calibration Parameters\TX.mat")
    clear TX
    load(".\DPD Data\Algorithm Parameters\TX.mat","TX")
    if dict.ampCorr == 1
        TX.AWG.Amp_Corr = true;
    elseif dict.ampCorr == 2
        TX.AWG.Amp_Corr = false;
    end
    TX.Fcarrier = dict.centerFreq;
    TX.AWG.Amp_Corr_File = dict.ampCorrFile; % CHECK
    save(".\DPD Data\Algorithm Parameters\TX.mat","TX")
end