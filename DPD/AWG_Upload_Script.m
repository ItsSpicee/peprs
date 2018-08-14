load('IQ_AWG_in.mat')

instrreset % so we do not get timeout errors

% already done in Set_AWG
AWG_M8190A_Reference_Clk(TX.AWG.ReferenceClockSource,TX.AWG.ReferenceClock)

% AWG run settings
RunSettings.RunFlag = 1;
RunSettings.SyncModuleFlag = 0;

AWG_M8190A_IQSignalUpload({AWG_In_signal},{TX.Fcarrier},{Fsample_signal},...
    TX.AWG.FsampleDAC,'ChannelSelectSettings',TX.AWG.ChannelSelectSettings,'ExpansionMarginSettings', TX.AWG.ExpansionMarginSettings, ...
    'RunSettings', RunSettings);

AWG_M8190A_DAC_Amplitude(1,TX.AWG.VFS);
AWG_M8190A_DAC_Amplitude(2,TX.AWG.VFS);
AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
AWG_M8190A_MKR_Amplitude(2,1.5);       % Set the trigger amplitude to 1.5 V 
%AWG_M8190A_DAC_Format_Data(TX.AWG.DataFormat);

clear AWG_In_signal iqtotaldata;