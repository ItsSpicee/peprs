function Set_VSA_Meas_AWGCal(dict)
    dict.centerFreq = str2double(dict.centerFreq);
    dict.sampRate = str2double(dict.sampRate);
    load(".\Measurement Data\AWG Calibration Parameters\RX.mat")
    RX.Fcarrier = dict.centerFreq; % Center frequency of the received tones
    RX.Fsample = dict.sampRate; % Sampling rate of the receiver
    save(".\Measurement Data\AWG Calibration Parameters\RX.mat","RX")
end