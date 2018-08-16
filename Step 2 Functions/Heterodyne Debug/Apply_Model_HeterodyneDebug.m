function error = Apply_Model_HeterodyneDebug()
    load('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
    error = '';
    try
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Apply the inverse model to the verification signal
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        VerificationSignal_Cal = ApplyLUTCalibration(VerificationSignal, TX.Fsample, ...
             tonesBaseband, real(H_Tx_freq_inverse), imag(H_Tx_freq_inverse));
        VerificationSignal_Cal = SetMeanPower(VerificationSignal_Cal,0);
        if (~Cal.Processing32BitFlag)
            if (strcmp(TX.AWG_Model,'M8195A'))
                AWG_M8195A_SignalUpload_ChannelSelect_FixedAvgPower({VerificationSignal_Cal},{TX.Fcarrier},{TX.Fsample},TX.Fsample,0,false,TX.AWG_Channel,0,0,0);
                AWG_M8195A_DAC_Amplitude(1,TX.VFS);
                AWG_M8195A_DAC_Amplitude(4,TX.VFS);
            else
                AWG_M8190A_IQSignalUpload({VerificationSignal_Cal},{TX.Fcarrier},{TX.Fsample},...
                   TX.Fsample, 'SignalBandwidthCell', {Cal.Signal.BW});        
                AWG_M8190A_DAC_Amplitude(1,TX.VFS);                    % -1 dBm input is recommended for external I and Q inputs into PSG
                AWG_M8190A_DAC_Amplitude(2,TX.VFS);
                AWG_M8190A_MKR_Amplitude(1,TX.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
            end
            AWG_M8190A_Reference_Clk(TX.ReferenceClockSource,TX.ReferenceClock);
        end
    catch
        error = 'A problem has occurred while attempting to apply inverse model to verification signal';
    end
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
end