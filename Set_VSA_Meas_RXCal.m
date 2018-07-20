% Analysis bandwidth only for UXA. 
% If TX Related frame time is true, averaging is also true. 
% True: set the No. Recorded Time Frames and measurement Time (Frame time) is calculated. 
% If it’s false, they specify the measurement time.

function Set_VSA_Meas_RXCal(dict)  
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    RX.Fcarrier = dict.centerFreq; % Center frequency of the received tones
    RX.Analyzer.Fsample = dict.sampRate; % Sampling rate of the receiver
    RX.Fsample = dict.sampRate; % Sampling rate of the receiver for AWG calibration
    RX.NumberOfMeasuredPeriods = dict.noFrames; % Number of measured frames, number of recorded time periods
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end