function SendTriggerSignal(TX)
    TX.TriggerSignalLength     = TX.FrameTime * TX.Fsample;
    TX.SignalData              = rand(TX.TriggerSignalLength,1);

    if (strcmp(TX.AWG_Model, 'M8190A'))
        AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower({TX.SignalData},{0},{TX.Fsample},TX.Fsample,0,false,[],0,0,0,0,0);
        AWG_M8190A_Reference_Clk(TX.ReferenceClockSource, 10e6);
        AWG_M8190A_DAC_Amplitude(1,TX.VFS);       % -1 dBm input is recommended for external I and Q inputs into PSG
        AWG_M8190A_DAC_Amplitude(2,TX.VFS);
        AWG_M8190A_MKR_Amplitude(1,TX.TriggerAmplitude);          % Set the trigger amplitude to 1.5 V
        AWG_M8190A_MKR_Amplitude(2,TX.TriggerAmplitude);
    else
        AWG_M8195A_SignalUpload_ChannelSelect_FixedAvgPower({TX.SignalData},{0},{TX.Fsample},TX.Fsample,0,0,0,0,0,0);
        AWG_M8195A_DAC_Amplitude(1,TX.VFS);
        AWG_M8190A_Reference_Clk(TX.ReferenceClockSource, TX.ReferenceClock);
        AWG_M8195A_DAC_Amplitude(4,TX.VFS);
    end

    AWG_M8190A_Output_OFF(1)
    AWG_M8190A_Output_OFF(2)
end
