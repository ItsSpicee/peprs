%% Downloading the output
if strcmp(RX.Type, 'Digitizer')
    %% Signal Acquisition
%     GainValue = M9352A_Gain_value;
%     M9352A_Gain(M9352A_Obj, AmpChannel, GainValue);
    %M9703A_DDC_Configuration(M9703A_Obj, Channel, 0, 0);
    pause(2);
    %% Download the complete signal at the input of the digitizer to check if it is overloaded
    ADC_Capture_bel
    if (DownconversionEnabled == 1)
        DownconversionFrequency1=IF_Frequency;
        M9703A_DDC_Configuration(M9703A_Obj, Channel, DownconversionEnabled, DownconversionFrequency1);
        pause(2);
        [WaveformArray1] = M9703A_Acquisition(M9703A_Obj, Channel, PointsPerRecord, DDC_SamplingFrequency, FullScaleRange, ACDCCoupling);
    end
elseif strcmp(RX.Type, 'PXA')
    [RecI_captured, RecQ_captured] = IQCapture_with_atten(RX.Fcarrier, RX.UXA.AnalysisBandwidth, RX.FrameTime, RX.UXA.Attenuation);
    Rec = complex(RecI_captured(200:end), RecQ_captured(200:end));
    [DownSampleUXA, UpSampleUXA] = rat(Signal.Fsample/RX.Analyzer.Fsample);        
    Rec = resample(Rec, DownSampleUXA, UpSampleUXA);    
    clear RecI_captured RecQ_captured
elseif strcmp(RX.Type, 'Scope')
%     load('Scope_out.mat');
    Rec = waveform;
    Rec = Rec - mean(Rec);
    % Downconvert the signal
    [ Rec ] = DigitalDownconvert(Rec, RX.Analyzer.Fsample, RX.Fcarrier, RX.Filter, RX.MirrorSignalFlag );
    
    % Apply RX Calibration when using a full rate TOR
    if (Cal.RX.Calflag && RX.SubRate == 1)
        if (isfield(Cal.RX, 'MirrorFrequencyFlag') && Cal.RX.MirrorFrequencyFlag)
            Rec = ApplyLUTCalibration(conj(Rec), RX.Analyzer.Fsample, Cal.RX.ToneFreq,...
                Cal.RX.RealCorr, Cal.RX.ImagCorr);
            Rec = conj(Rec);
        else
            Rec = ApplyLUTCalibration(Rec, RX.Analyzer.Fsample, Cal.RX.ToneFreq,...
                Cal.RX.RealCorr, Cal.RX.ImagCorr);
        end
    end
    
    [DownSampleScope, UpSampleScope] = rat(Signal.Fsample / RX.Analyzer.Fsample);
    if (RX.SubRate == 1)
        Rec = resample(Rec, DownSampleScope, UpSampleScope,100);
    end
    % If using IQ modulation, remove DC offset
    if (RX.SubtractDCFlag)
        Rec = Rec - mean(Rec);
    end
    
    clear waveform
elseif strcmp(RX.Type, 'UXA')
    %[Received_I, Received_Q, SA] = IQCapture_UXA(RX.Fcarrier, ...
    [Received_I, Received_Q, ~] = IQCapture_UXA(RX.Fcarrier, ...
            RX.UXA.AnalysisBandwidth, RX.Analyzer.Fsample, RX.Analyzer.NumberOfMeasuredPeriods * RX.Analyzer.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);%, RX.UXA.Attenuation_SA);
    Rec = complex(Received_I, Received_Q);
    if (Cal.RX.Calflag && RX.SubRate == 1)
        Rec = ApplyLUTCalibration(Rec, RX.Analyzer.Fsample, Cal.RX.ToneFreq,...
        Cal.RX.RealCorr, Cal.RX.ImagCorr);
    end
    [DownSampleUXA, UpSampleUXA] = rat(RX.Fsample/RX.Analyzer.Fsample);        
    Rec = resample(Rec, DownSampleUXA, UpSampleUXA);
    if (TX.IQmod_flag && RX.SubtractDCFlag)
        Rec = Rec - mean(Rec);
    end
end
if Measure_Pout_Eff
    PS_m = PowerSupply_N6705A(DCSource_Add);
    PS_m.connect;
    PS_m_chan = 1; % channel to measure from
    V_m = PS_m.voltage(PS_m_chan);
    I_m = PS_m.current(PS_m_chan);
    Pout = PM_obj.measure;
    Pdc = V_m*I_m;
    DE = 100*10^((Pout-30)/10) / Pdc;
end
if strcmp(TX.Type,'AWG')
    %AWG_M8190A_Output_OFF(RF_channel);
elseif strcmp(Transmitter_type,'ESG')
    ESG_RF_OFF_SingleCarrier(ESGAdd)
end
%% TODO: Digital SubSample first
if RX.SubRate > 1;
    disp('********Full Rate Data**********');
    SubRate_O = RX.SubRate;
    RX.SubRate = 1;
    AlignAnalyzeData
    RX.SubRate = SubRate_O;
    disp('******Digital SubSample*********');
end
Rec = Rec(1:RX.SubRate:end);
% save('Scope_out.mat', 'Rec');