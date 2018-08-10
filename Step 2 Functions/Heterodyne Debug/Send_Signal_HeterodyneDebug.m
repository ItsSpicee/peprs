function error = Iterate_HeterodyneDebug()
    load('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
    error = '';
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Send the multitone signal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:Cal.NumIterations  
        try
            if i > 1
                TrainingSignal_Cal = ApplyLUTCalibration(TrainingSignal, TX.Fsample, ...
                    tonesBaseband, real(H_Tx_freq_inverse), imag(H_Tx_freq_inverse));
                TrainingSignal_Cal = SetMeanPower(TrainingSignal_Cal,0);
            else
                TrainingSignal_Cal = TrainingSignal;
            end
            if (strcmp(TX.AWG_Model,'M8195A'))
                AWG_M8195A_SignalUpload_ChannelSelect_FixedAvgPower({TrainingSignal_Cal},{TX.Fcarrier},{TX.Fsample},TX.Fsample,0,false,TX.AWG_Channel,0,0,0);
                AWG_M8195A_DAC_Amplitude(1,TX.VFS);
                AWG_M8195A_DAC_Amplitude(4,TX.VFS);
            else
                AWG_M8190A_IQSignalUpload({TrainingSignal_Cal},{TX.Fcarrier},{TX.Fsample},...
                   TX.Fsample, 'SignalBandwidthCell', {Cal.Signal.BW});
                AWG_M8190A_DAC_Amplitude(1,TX.VFS);       % -1 dBm input is recommended for external I and Q inputs into PSG
                AWG_M8190A_DAC_Amplitude(2,TX.VFS);
                AWG_M8190A_MKR_Amplitude(1,TX.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
                AWG_M8190A_MKR_Amplitude(2,TX.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
            end
            AWG_M8190A_Reference_Clk(TX.ReferenceClockSource,TX.ReferenceClock);
        catch
            error = sprintf('A problem has occurred while attempting to send the multi-tone signal in iteration %d',i);
            return
        end
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Download the signal
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        try
            if (~Cal.Processing32BitFlag)
                if (strcmp(RX.Type,'Scope'))
        %             [ obj ] = SignalCapture_Scope(RX.Scope, RX.Analyzer.Fsample, RX.PointsPerRecord, RX.EnableExternalReferenceClock,RX.ScopeTriggerChannel);
                    [ obj ] = SignalCapture_Scope_64bit(RX, autoscaleFlag);
                    Rec = obj.Ch_Waveform{1};
                    [Rec] = DigitalDownconvert( Rec, RX.Analyzer.Fsample, RX.Fcarrier, RX.Filter, RX.MirrorSignalFlag);
                else
                    Rec = DataCapture_Digitizer_32bit (RX);
                end

                if (strcmp(RX.Type,'UXA'))
                    % Get received I and Q signals 
                    [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier, ...
                        RX.UXA.AnalysisBandwidth, RX.Analyzer.Fsample, RX.NumberOfMeasuredPeriods * RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
                    Rec = complex(Received_I, Received_Q);
                    Rec = filter(RX.Filter, [1 0], Rec);
                    if (RX.MirrorSignalFlag)
                        Rec = conj(Rec);
                    end
                end
            else
                load('Scope_out.mat');
            end
             if (Cal.RX.Calflag)
                Rec = ApplyLUTCalibration(Rec, RX.Analyzer.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
             end

            % Resample the signal
            [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Analyzer.Fsample);
            Rec = resample(Rec, DownSampleScope, UpSampleScope);
        catch
            error = sprintf('A problem has occurred while attempting to download the signal in iteration %d',i);
            return
        end
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Downconvert, align, analyze the signal
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        try
            if (isrow(Rec))
                Rec = Rec.';
            end

            % Align and analyze the signals - if it is real we do not adjust the phase
            if (Cal.Signal.MultitoneOptions.RealBasisFlag)
                [ In_D_test, Out_D_test, NMSE_Before] = AlignAndAnalyzeRealSignals( TrainingSignal, Rec, TX.Fsample);
            else
                [ In_D_test, Out_D_test, NMSE_Before] = AlignAndAnalyzeSignals( TrainingSignal, Rec, TX.Fsample, RX.alignFreqDomainFlag, RX.XCorrLength);
            end
            display([ 'NMSE Before         = ' num2str(NMSE_Before)      ' % ' ]);
        catch
            error = sprintf('A problem has occurred while attempting to downconvert,align, and analyze the signal in iteration %d',i);
            return
        end   
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Find the inverse response
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        try
            % Truncate the signal to a length that allows the frequency resolution to
            % divide into the tone grid
            % Cal.FreqRes = 500000
            Cal.TrainingLength = TX.Fsample / Cal.FreqRes;
            In_D_test       = In_D_test(1:Cal.TrainingLength);
            Out_D_test      = Out_D_test(1:Cal.TrainingLength);

            % Calculate the inverse model
            if i > 1
                [ H_new ] = CalculateInverseResponseModel(In_D_test, Out_D_test, tonesBaseband, TX.Fsample);
                H_Tx_freq_inverse = H_Tx_freq_inverse .* H_new;
                figNumberEnd = get(gcf,'Number');
                close(figNumberStart:figNumberEnd);
        %         [ H_Tx_freq_inverse, Cal.Mse(i)] = UpdateInverseFilter_FFTLMS(In_D_test, Out_D_test, H_Tx_freq_inverse, tonesBaseband, TX.Fsample, Cal.LearningParam);
            else
                [ H_Tx_freq_inverse] = CalculateInverseResponseModel(In_D_test, Out_D_test, tonesBaseband, TX.Fsample);
                figNumberStart = get(gcf,'Number') + 1;
                figNumberEnd = figNumberStart;
            end
         catch
            error = sprintf('A problem has occurred while attempting to find the inverse response in iteration %d',i);
            return
        end 
    end
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
end