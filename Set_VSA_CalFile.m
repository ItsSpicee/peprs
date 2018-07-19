% run when vsa calibration file does not need to be generated
% sets provided vsa cal file in calFiles struct
function Set_VSA_CalFile(vsaFile)
    load(".\Measurement Data\calFiles.mat")
    calFiles.VSACalibrationFile_upconverter = vsaFile;
    save(".\Measurement Data\calFiles.mat","calFiles")
end