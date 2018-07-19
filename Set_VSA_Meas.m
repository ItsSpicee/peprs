% Analysis bandwidth only for UXA. 
% If TX Related frame time is true, averaging is also true. 
% True: set the No. Recorded Time Frames and measurement Time (Frame time) is calculated. 
% If it’s false, they specify the measurement time.

function Set_VSA_Meas(centerFreq,sampRate,noFrames,mirror)  
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    RX.Fcarrier = centerFreq; % Center frequency of the received tones
    RX.Analyzer.Fsample = sampRate; % Sampling rate of the receiver
    RX.NumberOfMeasuredPeriods = noFrames; % Number of measured frames, number of recorded time periods
    RX.LOLowerInjectionFlag = mirror; % Higher or lower LO injection
    save(".\Measurement Data\RX Calibration Parameters\RX.mat")
end