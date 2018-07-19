function Set_RXCal_VSGAdvParams(dacRange)
    load(".\Measurement Data\RX Calibration Parameters\TX.mat") 
    TX.VFS = dacRange; % AWG full scale voltage amp
    save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX") 
end