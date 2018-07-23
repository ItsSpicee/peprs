function Set_AWG_CalFile(awgFile)
    load(".\Measurement Data\calFiles.mat")
    calFiles.AWGCalibrationFile_awgCal = awgFile;
    save(".\Measurement Data\calFiles.mat","calFiles")
end