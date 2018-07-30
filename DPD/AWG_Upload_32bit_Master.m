load('IQ_AWG_in.mat')
AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower({AWG_In_signal(1:end)}, ...
    {TX.Fcarrier},{Fsample_signal},TX.AWG.FsampleDAC , ...
    0,false,[],Expansion_Margin,PAPR_input,PAPR_original,TX.I_Offset,TX.Q_Offset,runFlag,TX.AWG.MultiChannelFlag, expansionMarginFlag);
AWG_M8195A_DAC_Amplitude(1,TX.AWG.VFS);
AWG_M8195A_DAC_Amplitude(2,TX.AWG.VFS);
AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
AWG_M8190A_MKR_Amplitude(2,1.5);       % Set the trigger amplitude to 1.5 V 
AWG_M8190A_SyncMKR_Amplitude(1,1.5);
AWG_M8190A_SyncMKR_Amplitude(2,1.5);
clear iqdata iqtotaldata;