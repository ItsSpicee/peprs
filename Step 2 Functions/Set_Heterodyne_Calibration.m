function Set_Heterodyne_Calibration(cd,txd,rxd)
%% Load Files
load('./Measurement Data/Heterodyne Calibration Parameters/Cal.mat')
load('./Measurement Data/Heterodyne Calibration Parameters/TX.mat')
load('./Measurement Data/Heterodyne Calibration Parameters/RX.mat')

%% Convert strings to doubles
% Cal
ToneSpacing = str2double(cd.ToneSpacing);
StartingToneFreq = str2double(cd.StartingToneFreq);
EndingToneFreq = str2double(cd.EndingToneFreq);
PAPRmin = str2double(cd.PAPRmin);
PAPRmax = str2double(cd.PAPRmax);
FreqRes= str2double(cd.FreqRes);
NumIterations = str2double(cd.NumIterations);
% TX
NumberOfTransmittedPeriods = str2double(txd.NumberOfTransmittedPeriods);
Fcarrier = str2double(txd.Fcarrier);
TriggerAmplitude = str2double(txd.TriggerAmplitude);
VFS = str2double(txd.VFS);
ReferenceClock = str2double(txd.ReferenceClock);
Fsample = str2double(txd.Fsample);
ExpansionMargin = str2double(txd.ExpansionMargin);
AWG_Channel = str2double(txd.AWG_Channel);
% RX
FCarrier = str2double(rxd.FCarrier);
XCorrLength = str2double(rxd.XCorrLength);
FSample = str2double(rxd.FSample);
MeasuredPeriods = str2double(rxd.MeasuredPeriods);
TriggerChannel= str2double(rxd.TriggerChannel);
VFS = str2double(rxd.VFS);
AnalysisBandwidth = str2double(rxd.AnalysisBandwidth);
Attenuation = str2double(rxd.Attenuation);
TriggerLevel = str2double(rxd.TriggerLevel);

%% Set Cal Struct Parameters
Cal.Signal.ToneSpacing = ToneSpacing;  
Cal.Signal.StartingToneFreq = StartingToneFreq;
Cal.Signal.EndingToneFreq = EndingToneFreq;

% Optional Multitone Settings
if cd.RealBasisFlag == 1
    Cal.Signal.MultitoneOptions.RealBasisFlag = 1;
else
   Cal.Signal.MultitoneOptions.RealBasisFlag = 0; 
end
if cd.PhaseDistr == 1
    Cal.Signal.MultitoneOptions.PhaseDistr = 'Schroeder';
else
    Cal.Signal.MultitoneOptions.PhaseDistr = 'Gaussian';
end

% PAPR limits when generating the signals
Cal.Signal.MultitoneOptions.PAPRmin  = PAPRmin;
Cal.Signal.MultitoneOptions.PAPRmax  = PAPRmax;

Cal.FreqRes = FreqRes; % Frequency resolution to use to search for the tones

Cal.NumIterations = NumIterations; % Training length to use for getting the LUT table

% Receiver calibration files
if cd.rxCalFlag == 1
    Cal.RX.Calflag = true;
else
    Cal.RX.Calflag = false;
end
Cal.RX.CalFile = cd.rxCalFile;

Cal.SaveLocation = cd.SaveLocation;

% variable reliant
Cal.Signal.BW = Cal.Signal.EndingToneFreq - Cal.Signal.StartingToneFreq;

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
if txd.Fsample == 8e9
   TX.MinimumSegmentLength = 240;
elseif txd.Fsample == 12e9
   TX.MinimumSegmentLength = 320;
end

% AWG channel for calibration
TX.AWG_Channel = AWG_Channel;

TX.VFS = VFS; % AWG full scale voltage amp
TX.TriggerAmplitude = TriggerAmplitude; % Trigger signal amplitude
TX.NumberOfTransmittedPeriods = NumberOfTransmittedPeriods;
TX.Fcarrier = Fcarrier;

% Expansion Margin Settings
if txd.ExpansionMarginEnable == 1
   TX.AWG.ExpansionMarginSettings.ExpansionMarginEnable = 1;
else
    TX.AWG.ExpansionMarginSettings.ExpansionMarginEnable = 0;
end
TX.AWG.ExpansionMarginSettings.ExpansionMargin = ExpansionMargin;

%% Set RX Struct Parameters

% Choose between 'Digitizer', 'UXA', 'Scope' for the receiver
if rxd.Type == 1 || rxd.Type == 5
    RX.Type = "Scope"; 
elseif rxd.Type == 2 || rxd.Type == 6
    RX.Type = "Digitizer"; 
elseif rxd.Type == 3 || rxd.Type == 4
    RX.Type = "UXA"; 
end

RX.Fcarrier = FCarrier; % Center frequency of the received tones

% Receiving the mirror signal or not
if rxd.MirrorSignalFlag == 1 
    RX.MirrorSignalFlag = true;      
else
    RX.MirrorSignalFlag = false;       
end 

RX.XCorrLength = XCorrLength;
RX.Analyzer.Fsample = FSample; % Sampling rate of the receiver
RX.NumberOfMeasuredPeriods = MeasuredPeriods; % Number of measured frames;
RX.VisaAddress = rxd.VisaAddress;

% make path relative first
if contains(rxd.DownconversionFilterFile,'\peprs\')
    refinedString = strsplit(rxd.DownconversionFilterFile,'\peprs\');
    pathString = refinedString(2);
    relativeString = char(strrep(pathString,'Measurement Data\','.\Measurement Data\'));
    RX.DownFile = relativeString;
else
    RX.DownFile = rxd.DownconversionFilterFile;
end

% Scope Parameters
if rxd.EnableExternalClock_Scope == 1
    RX.EnableExternalReferenceClock = true;
else
    RX.EnableExternalReferenceClock = false;
end
RX.TriggerChannel = TriggerChannel;
RX.channelVec = rxd.ChannelVec; % may have type problems

% Digitizer Parameters
if rxd.EnableExternalClock_Dig == 1
    RX.EnableExternalClock = true;
else
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
if (RX.Analyzer.Fsample > 1e9)
    RX.EnableInterleaving  = true;
end

% UXA Parameters
RX.UXA.AnalysisBandwidth = AnalysisBandwidth;
if rxd.IFPath == 0
    RX.UXA.IFPath = 1e9;
elseif rxd.IFPath == 1
    RX.UXA.IFPath = 10e6;
elseif rxd.IFPath == 2
    RX.UXA.IFPath = 25e6;
elseif rxd.IFPath == 3
    RX.UXA.IFPath = 40e6;
elseif rxd.IFPath == 4
    RX.UXA.IFPath = 255e6;
end
RX.UXA.Attenuation = Attenuation;  % dB
if rxd.ClockReference == 1
    RX.UXA.ClockReference = 'Internal';
elseif rxd.ClockReference == 2
    RX.UXA.ClockReference = 'External';
end
if (RX.UXA.IFPath > 500e6)
    RX.UXA.TriggerPort = 'EXT3';
else
    RX.UXA.TriggerPort = 'EXT1';
end
RX.UXA.TriggerLevel = TriggerLevel; % mV

if rxd.AlignFreqDomainFlag == 1
    RX.alignFreqDomainFlag = 1;
else
    RX.alignFreqDomainFlag = 0;
end

%% Save Files
save('./Measurement Data/Heterodyne Calibration Parameters/Cal.mat','Cal')
save('./Measurement Data/Heterodyne Calibration Parameters/TX.mat','TX')
save('./Measurement Data/Heterodyne Calibration Parameters/RX.mat','RX')
end