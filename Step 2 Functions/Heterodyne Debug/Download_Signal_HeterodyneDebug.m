function error = Download_Signal_HeterodyneDebug()
    load('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
    error = '';
    try
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Download the signal
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if (~Cal.Processing32BitFlag)
            if (strcmp(RX.Type,'Scope'))
        %         [ obj ] = SignalCapture_Scope(RX.Scope, RX.Analyzer.Fsample, RX.PointsPerRecord, RX.EnableExternalReferenceClock, RX.ScopeTriggerChannel);
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
    catch
        error = 'A problem has occurred while attempting to download the signal';
    end
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
end