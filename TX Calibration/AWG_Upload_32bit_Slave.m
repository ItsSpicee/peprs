load('IQ_AWG_in.mat');
SlaveFlag = 1;
AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower({AWG_In_signal(1:end)}, ...
    {TX.Fcarrier},{Fsample_signal},TX.AWG.FsampleDAC , ...
    0,false,[],Expansion_Margin,PAPR_input,PAPR_original,TX.I_Offset,TX.Q_Offset,runFlag,TX.AWG.MultiChannelFlag);
AWG_M8190A_Sample_Clk('External', TX.AWG.SampleClock);
AWG_M8190A_EnableSequencing(SlaveFlag, TX.AWG.SyncModuleFlag);
AWG_M8195A_DAC_Amplitude(1,TX.AWG.VFS);
AWG_M8195A_DAC_Amplitude(2,TX.AWG.VFS);
AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
AWG_M8190A_MKR_Amplitude(2,1.5);       % Set the trigger amplitude to 1.5 V 


if (TX.AWG.Position == 1)
    AWG_M8190A_Output_OFF(1);
    AWG_M8190A_Output_OFF(2);
end