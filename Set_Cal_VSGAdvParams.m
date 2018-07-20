function Set_Cal_VSGAdvParams(dacRange)
    load(".\Measurement Data\Calibration Parameters\TX.mat") 
    TX.VFS = dacRange; % AWG full scale voltage amp
    save(".\Measurement Data\Calibration Parameters\TX.mat","TX") 
end