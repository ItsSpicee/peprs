function Set_VSA_CalFile(vsaFile)
    load(".\Measurement Data\calFiles.mat")
    calFiles.VSACalibrationFile_upconverter = vsaFile;
    clear vsaFile
    save(".\Measurement Data\calFiles.mat")
end