function E4438C_Signal_Configuration(InstrumentObj, Frequency, Amplitude)
% Configure the Signal Frequency and Amplitude
% - Frequency - Value of the Output Frequency in Hz
% - Amplitude - Value of the Output Amplitude in dBm

    InstrumentObj.RF.Configure(Frequency,Amplitude)