function Set_AWG_Calibration(cd,txd,rxd)
    %% Load Files
    load(".\Measurement Data\AWG Calibration Parameters\Cal.mat")
    load(".\Measurement Data\AWG Calibration Parameters\TX.mat")
    load(".\Measurement Data\AWG Calibration Parameters\RX.mat")
    
    %% Convert strings to doubles
    % Cal
    NumIterations = str2double(cd.NumIterations);
    ToneSpacing = str2double(cd.ToneSpacing);
    StartingToneFreq = str2double(cd.StartingToneFreq);
    EndingToneFreq = str2double(cd.EndingToneFreq);
    Fres = str2double(cd.Fres);
    PAPRmin = str2double(cd.PAPRmin);
    PAPRmax = str2double(cd.PAPRmax);
    % TX
    Fsample = str2double(txd.Fsample);
    VFS = str2double(txd.VFS);
    TriggerAmplitude = str2double(txd.TriggerAmplitude);
    ReferenceClock = str2double(txd.ReferenceClock);
    Fcarrier = str2double(txd.Fcarrier);
    NumberOfTransmittedPeriods = str2double(txd.NumberOfTransmittedPeriods);
    AWG_Channel = str2double(txd.AWG_Channel);
    % RX
    Fcarrier = str2double(rxd.Fcarrier);
    Fsample = str2double(rxd.Fsample);
    NumberOfMeasuredPeriods = str2double(rxd.NumberOfMeasuredPeriods);
    VFS = str2double(rxd.VFS);
    AnalysisBandwidth = str2double(rxd.AnalysisBandwidth);
    Attenuation = str2double(rxd.Attenuation);
    TriggerLevel = str2double(rxd.TriggerLevel);
    
    %% Set Cal Struct Parameters
    Cal.NumIterations = NumIterations;
    Cal.Signal.ToneSpacing = ToneSpacing;
    Cal.Signal.StartingToneFreq = StartingToneFreq;
    Cal.Signal.EndingToneFreq = EndingToneFreq;
    
    if cd.RealBasisFlag == 1
        Cal.Signal.MultitoneOptions.RealBasisFlag = 1;
    elseif cd.RealBasisFlag == 2
        Cal.Signal.MultitoneOptions.RealBasisFlag = 0;
    end
    if cd.PhaseDistr == 1
        Cal.Signal.MultitoneOptions.PhaseDistr = "Schroeder";
    elseif cd.PhaseDistr == 2
        Cal.Signal.MultitoneOptions.PhaseDistr = "Gaussian";
    end
    
    % PAPR limits when generating the signals
    Cal.Signal.MultitoneOptions.PAPRmin  = PAPRmin;
    Cal.Signal.MultitoneOptions.PAPRmax  = PAPRmax;
    
    Cal.Fres = Fres; % Frequency resolution to use to search for the tones
    Cal.SaveLocation = cd.SaveLocation;
    
    if cd.vsaCalFlag == 1
        Cal.RX.Calflag = true;
    elseif cd.vsaCalFlag== 2
        Cal.RX.Calflag = false;
    end
    Cal.RX.CalFile = cd.vsaCalFile;
    
    %% Set TX Struct Parameters
    % Choose between 'AWG' (VSG not ready)
    if txd.Type == 1 || txd.Type == 2 || txd.Type == 3
       TX.Type = "AWG";
    elseif txd.Type == 4
       TX.Type = "VSG";
    end
    
    TX.AWG_Model = txd.Model;     % AWG Model 'M8190A', 'M8195A'
    TX.Fsample = Fsample; % AWG sample rate

    % Choose between 'Backplane', 'Internal', 'External'
    if txd.ReferenceClockSource == 1
        TX.ReferenceClockSource = 'Backplane';
    elseif txd.ReferenceClockSource == 2
        TX.ReferenceClockSource = 'External';
    elseif txd.ReferenceClockSource == 3
        TX.ReferenceClockSource = 'Internal';
    end 
    TX.ReferenceClock = ReferenceClock; % External reference clock frequency
    
    % Minimum segment length of the AWG frame
    if Fsample == 8e9
       TX.MinimumSegmentLength = 240;
    elseif Fsample == 12e9
       TX.MinimumSegmentLength = 320;
    end
    
    TX.VFS = VFS;
    TX.TriggerAmplitude = TriggerAmplitude;
    TX.NumberOfTransmittedPeriods = NumberOfTransmittedPeriods;
    TX.AWG_Channel = AWG_Channel; % AWG channel for calibration
    
    %% Set RX Struct Parameters
    % Choose between 'Digitizer', 'UXA', 'Scope' for the receiver
    if rxd.Type == 1 || rxd.Type == 5
        RX.Type = "Scope"; 
    elseif rxd.Type == 2 || rxd.Type == 6
        RX.Type = "Digitizer"; 
    elseif rxd.Type == 3 || rxd.Type == 4
        RX.Type = "UXA"; 
    end
    
    RX.Fcarrier = Fcarrier; % Center frequency of the received tones
    RX.Fsample = Fsample; % Sampling rate of the receiver
    if rxd.MirrorFlag == 1
        RX.LOLowerInjectionFlag = true;
    elseif rxd.MirrorFlag == 2
        RX.LOLowerInjectionFlag = false;
    end  
    RX.NumberOfMeasuredPeriods = NumberOfMeasuredPeriods; % Number of measured frames;
    RX.VisaAddress = rxd.VisaAddress;
    RX.ScopeIVIDriverPath = rxd.DriverPath;
    
    % Scope Parameters
    if rxd.EnableExternalClock_Scope == 1
        RX.EnableExternalReferenceClock = true;
    elseif rxd.EnableExternalClock_Scope == 2
        RX.EnableExternalReferenceClock = false;
    end
    RX.channelVec = rxd.ChannelVec;
    
    % Digitizer Parameters
    if rxd.EnableExternalClock_Dig == 1
        RX.EnableExternalClock = true;
    elseif rxd.EnableExternalClock_Dig == 2
        RX.EnableExternalClock = false;
    end
    if rxd.ExternalClockFrequency == 1
        RX.ExternalClockFrequency = 1.998e9;
    elseif rxd.ExternalClockFrequency == 2
        RX.ExternalClockFrequency = 1.906e9;
    end
    if rxd.ACDCCoupling == 1
        RX.ACDCCoupling = 1;
    else
        RX.ACDCCoupling = 0;
    end
    RX.VFS = VFS; % Digitzer full scale peak to peak voltage reference (1 or 2 V)
    % Enable interleaving
    if rxd.Interleaving == 1
        RX.EnableInterleaving  = true;       
    else
        RX.EnableInterleaving  = false;
    end
    if (RX.Fsample > 1e9)
        RX.EnableInterleaving  = true;
    end
    
    % UXA Parameters
    RX.UXA.AnalysisBandwidth = AnalysisBandwidth;
    RX.UXA.Attenuation = Attenuation;  % dB
    if rxd.ClockReference == 1
        RX.UXA.ClockReference = 'Internal';
    elseif rxd.ClockReference == 2
        RX.UXA.ClockReference = 'External';
    end
    if (RX.UXA.AnalysisBandwidth > 500e6)
        RX.UXA.TriggerPort          = 'EXT3';
    else
        RX.UXA.TriggerPort          = 'EXT1';
    end
    RX.UXA.TriggerLevel = TriggerLevel; % mV
    
    RX.FilterFile = rxd.FilterFile;
    
    %% Save Files
    save(".\Measurement Data\AWG Calibration Parameters\Cal.mat","Cal")
    save(".\Measurement Data\AWG Calibration Parameters\TX.mat","TX")
    save(".\Measurement Data\AWG Calibration Parameters\RX.mat","RX")
end