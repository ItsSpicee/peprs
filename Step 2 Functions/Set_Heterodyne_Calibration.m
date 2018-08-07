function Set_Heterodyne_Calibration(cd,txd)
%% Load Files
load('./Measurement Data/Heterodyne Calibration Parameters/Cal.mat')
load('./Measurement Data/Heterodyne Calibration Parameters/TX.mat')

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
if rxCalFlag == 1
    Cal.RX.Calflag = true;
else
    Cal.RX.Calflag = false;
end
Cal.RX.CalFile = rxCalFile;

Cal.SaveLocation = SaveLocation;

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

TX.VFS = VFS; % AWG full scale voltage amp
TX.TriggerAmplitude = TriggerAmplitude; % Trigger signal amplitude
TX.NumberOfTransmittedPeriods = NumberOfTransmittedPeriods;
TX.Fcarrier = Fcarrier;

%% Set RX Struct Parameters

%% Save Files
save('./Measurement Data/Heterodyne Calibration Parameters/Cal.mat','Cal')
save('./Measurement Data/Heterodyne Calibration Parameters/TX.mat','TX')
end