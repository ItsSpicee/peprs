% Analysis bandwidth only for UXA. 
% If TX Related frame time is true, averaging is also true. 
% True: set the No. Recorded Time Frames and measurement Time (Frame time) is calculated. 
% If it’s false, they specify the measurement time.

function Set_VSA_Meas(centerFreq,sampRate)  
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    RX.Fcarrier = centerFreq;
    
    RX.Analyzer.Fsample = sampRate;
    save(".\Measurement Data\RX Calibration Parameters\RX.mat")
end