% only sets for RX calibration, TX calibration vfs is set in vsg measurment page
function Set_Cal_VSGAdvParams(dacRange)
    dacRange = str2double(dacRange);
    load(".\Measurement Data\RX Calibration Parameters\TX.mat")   
    TX.VFS = dacRange; % AWG full scale voltage amp 
    save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX")   
end