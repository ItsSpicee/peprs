AWG_M8190A_IQSignalUpload({AWG_In_signal},{TX.Fcarrier},{TX.Fsample},...
   TX.Fsample, 'SignalBandwidthCell', {Cal.Signal.BW});
AWG_M8190A_DAC_Amplitude(1,TX.AWG.VFS );       % -1 dBm input is recommended for external I and Q inputs into PSG
AWG_M8190A_DAC_Amplitude(2,TX.AWG.VFS );
AWG_M8190A_MKR_Amplitude(1,TX.AWG.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
AWG_M8190A_MKR_Amplitude(2,TX.AWG.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
AWG_M8190A_DAC_Format_Data(TX.AWG.DataFormat);           % Format the Data
