function Set_VSA_Calibration(cd,rxd,txd)
%% Load Files
load(".\Measurement Data\RX Calibration Parameters\Cal.mat")
load(".\Measurement Data\RX Calibration Parameters\RX.mat")
load(".\Measurement Data\RX Calibration Parameters\TX.mat")

%% Convert Strings to Doubles    
% Cal
RFToneSpacing = str2double(cd.RFToneSpacing);
IFToneSpacing = str2double(cd.IFToneSpacing);
RFCenterFrequency = str2double(cd.RFCenterFrequency);
RFCalibrationStartFrequency = str2double(cd.RFCalibrationStartFrequency);
RFCalibrationStopFrequency = str2double(cd.RFCalibrationStopFrequency);
LOFrequencyOffset = str2double(cd.LOFrequencyOffset);
FreqRes = str2double(cd.FreqRes);
ScopeSpurStart = str2double(cd.ScopeSpurStart);
ScopeSpurSpacing = str2double(cd.ScopeSpurSpacing);
ScopeSpurEnd = str2double(cd.ScopeSpurEnd);
MovingAverageOrder = str2double(cd.MovingAverageOrder);
% RX
Fcarrier = str2double(rxd.Fcarrier);
AnalyzerFsample = str2double(rxd.Fsample);
NumberOfMeasuredPeriods = str2double(rxd.NumberOfMeasuredPeriods);
TriggerChannel = str2double(rxd.TriggerChannel);
rxVFS = str2double(rxd.VFS);
AnalysisBandwidth = str2double(rxd.AnalysisBandwidth);
Attenuation = str2double(rxd.Attenuation);
TriggerLevel = str2double(rxd.TriggerLevel);
% TX
Fsample = str2double(txd.Fsample);
ReferenceClock = str2double(txd.ReferenceClock);
txVFS = str2double(txd.VFS);
TriggerAmplitude = str2double(txd.TriggerAmplitude);

%% Set Cal Struct Parameters
Cal.RFToneSpacing = RFToneSpacing; % Spacing between the adjacent tones at RF
Cal.IFToneSpacing = IFToneSpacing; % Spacing between the received adjacent tones
Cal.Reference.CombReferenceFile = cd.CombReferenceFile; % Reference comb generator file
Cal.Reference.RFCenterFrequency = RFCenterFrequency; % Starting RF tone for calibration
Cal.Reference.RFCalibrationStartFrequency = RFCalibrationStartFrequency; % Starting RF tone for calibration
Cal.Reference.RFCalibrationStopFrequency = RFCalibrationStopFrequency; % Last RF tone for calibration
Cal.LOFrequencyOffset = LOFrequencyOffset; % Find the IF tones to fish out

if cd.SubRateFlag == 1
    Cal.SubRateFlag = 1;
elseif cd.SubRateFlag == 2
    Cal.SubRateFlag = 0;
end

% Processing Parameters
Cal.FreqRes = FreqRes; % FFT bin size
if cd.DespurFlag == 1
    Cal.DespurFlag = 1;  % Interpolate between the scope spurs
elseif cd.DespurFlag == 2
    Cal.DespurFlag = 0;
end
Cal.ScopeSpurs.ScopeSpurStart = ScopeSpurStart;
Cal.ScopeSpurs.ScopeSpurSpacing = ScopeSpurSpacing;
Cal.ScopeSpurs.ScopeSpurEnd = ScopeSpurEnd;
if cd.MovingAverageFlag == 1
    Cal.MovingAverageFlag = 1; % Smooth out the inverse frequency response
elseif cd.MovingAverageFlag == 2
    Cal.MovingAverageFlag = 0;
end
Cal.MovingAverageOrder = MovingAverageOrder; % Number of taps on the moving average filter

Cal.SaveLocation = cd.SaveLocation;

%% Set RX Struct Parameters
% If TX Related frame time is true, averaging is also true. 
% True: set the No. Recorded Time Frames and measurement Time (Frame time) is calculated. 
% If it’s false, they specify the measurement time.

% Choose between 'Digitizer', 'UXA', 'Scope' for the receiver
if rxd.Type == 1 || rxd.Type == 5
    RX.Type = "Scope"; 
elseif rxd.Type == 2 || rxd.Type == 6
    RX.Type = "Digitizer"; 
elseif rxd.Type == 3 || rxd.Type == 4
    RX.Type = "UXA"; 
end

RX.Fcarrier = Fcarrier; % Center frequency of the received tones

if rxd.mirrorFlag == 1
    RX.LOLowerInjectionFlag = true;
elseif rxd.mirrorFlag == 2
    RX.LOLowerInjectionFlag = false;
end

RX.Analyzer.Fsample = AnalyzerFsample;
RX.NumberOfMeasuredPeriods = NumberOfMeasuredPeriods;
RX.VisaAddress = rxd.VisaAddress;

% Scope Parameters
RX.ScopeIVIDriverPath = rxd.DriverPath;
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
RX.VFS = rxVFS; % Digitzer full scale peak to peak voltage reference (1 or 2 V)
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
RX.UXA.Attenuation = Attenuation;  % dB
if rxd.ClockReference == 1
    RX.UXA.ClockReference = 'Internal';
elseif rxd.ClockReference == 2
    RX.UXA.ClockReference = 'External';
end
if (RX.UXA.AnalysisBandwidth > 500e6)
    RX.UXA.TriggerPort = 'EXT3';
else
    RX.UXA.TriggerPort = 'EXT1';
end
RX.UXA.TriggerLevel = TriggerLevel; % mV

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
   TX.ReferenceClockSource = "AxieRef";
elseif txd.ReferenceClockSource == 2
   TX.ReferenceClockSource = "ExtRef";
elseif txd.ReferenceClockSource == 3
   TX.ReferenceClockSource = "IntRef";   
elseif txd.ReferenceClockSource == 4
   TX.ReferenceClockSource = "ExtClk"; 
end
TX.ReferenceClock = ReferenceClock; % External reference clock frequency

% Minimum segment length of the AWG frame
% max sample rate for AWG is 12e9: 12 bit mode and 320 minimum segment
% length
% max sample rate is 8e9: 14 bit mode and 240 min segment length
% OLD CODE: TX.MinimumSegmentLength = lcm(240,320);  
if txd.Fsample == 8e9
   TX.MinimumSegmentLength = 240;
elseif txd.Fsample == 12e9
   TX.MinimumSegmentLength = 320;
end

TX.VFS = txVFS; % AWG full scale voltage amp
TX.TriggerAmplitude = TriggerAmplitude; % Trigger signal amplitude

%% Save Files
save(".\Measurement Data\RX Calibration Parameters\Cal.mat","Cal") 
save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX")
end