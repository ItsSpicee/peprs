%    This script performs offset and IQ imbalance calibration for the IQ
%    modulator
%    MATLAB - 32 bit for signal upload and download and 64 bit for
%    processing
%    1. Baseband Arbitrary Waveform Generator (AWG) {Agilent M8190A}
%    2. Scope (ADC) {MSOS804A}
clc
clear
close all

path(pathdef); % Resets the paths to remove paths outside this folder
addpath(genpath('C:\Program Files (x86)\IVI Foundation\IVI\Components\MATLAB')) ;
addpath(genpath(pwd))%Automatically Adds all paths in directory and subfolders
instrreset
SetFigureDefaults
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Data processing flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Processing32BitFlag = true;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set Calibration Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Type                             = 'Freq_Domain'; % Choose between 'Time_Domain' and 'Freq_Domain'
% Time domain calibration FIR filter order
Cal.FIR_Order                        = 50;
% Frequency domain iterations
Cal.NumberOfIterations               = 5;

Cal.SubRateFlag = 0;

Cal.Signal.UniformSpacing          = 1;
% Cal.Signal.ToneFrequencies         = [2:10:492, 503:10:993, 1004:10:1494, 1501:10:1981]*1e6;   
% Cal.Signal.ToneFrequenciesI        = Cal.Signal.ToneFrequencies(1:2:end);
% Cal.Signal.ToneFrequenciesQ        = Cal.Signal.ToneFrequencies(2:2:end);
% Cal.Signal.ToneSpacing             = 10e6;     
% Cal.Signal.StartingToneFreq_I      = Cal.Signal.ToneFrequenciesI(1);
% Cal.Signal.EndingToneFreq_I        = Cal.Signal.ToneFrequenciesI(end);
% Cal.Signal.StartingToneFreq_Q      = Cal.Signal.ToneFrequenciesQ(1);
% Cal.Signal.EndingToneFreq_Q        = Cal.Signal.ToneFrequenciesQ(end);
% Cal.Signal.BW                      = 2 * max(Cal.Signal.ToneFrequenciesQ(end), Cal.Signal.ToneFrequenciesI(end));

Cal.Signal.ToneSpacing               = 10e6;     
Cal.Signal.StartingToneFreq_I        = 4e6;
Cal.Signal.EndingToneFreq_I          = 1.554e9;
Cal.Signal.StartingToneFreq_Q        = 2e6;
Cal.Signal.EndingToneFreq_Q          = 1.552e9;
Cal.Signal.BW                        = 2 * max(Cal.Signal.EndingToneFreq_Q, Cal.Signal.EndingToneFreq_I);

Cal.IFIQFlag = 0;

% Optional Multitone Settings
Cal.Signal.MultitoneOptions.RealBasisFlag = 1;
Cal.Signal.MultitoneOptions.PhaseDistr = 'Schroeder'; % 'Gaussian', 'Schroeder'
% PAPR limits when generating the signals
Cal.Signal.MultitoneOptions.PAPRmin  = 4;
Cal.Signal.MultitoneOptions.PAPRmax  = 13;

% AWG calibration files
Cal.AWG.Calflag = false;
Cal.AWG.CalFile_I = '.\AWG_CalResults\AWG_Cal_500MHz_I';
Cal.AWG.CalFile_Q = '.\AWG_CalResults\AWG_Cal_500MHz_Q';

% Receiver calibration files
Cal.RX.Calflag = true;
Cal.RX.CalFile = '.\RX_CalResults\RX_CalResults_fc6r25GHz_BW3GHz.mat';

% Calibration file complex baseband frequency
Cal.Directory = 'IQ_Imbalance_CalResults';
Cal.Filename  = ['IQ_Imbalance_fRF6r25GHz_3GHz' Cal.Type];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set TX Parameters
%  Description: AWG frame time is picked to ensure that the signal length
%  is multiples of minimum segment length at the AWG sampling rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TX.Type                       = 'AWG';             % Choose between 'AWG'
TX.AWG_Model                  = 'M8190A';          % Choose bewteen 'M8190A' and 'M8195A'
TX.AWG.BitResolution          = 12;
TX.Fcarrier                   = 1.35e9;
TX.Fsample                    = 12e9;            % Signal sample rate
TX.AWG.FsampleDAC             = 12e09;             % AWG sample rate
TX.AWG.ReferenceClockSource       = 'Backplane';      % Choose between 'Backplane', 'Internal', 'External'
TX.AWG.ReferenceClock             = 10e6;             % External reference clock frequency
TX.AWG.SampleClockSource          = 'Internal';       % Set the sample clock in as a clock source
TX.AWG.SampleClock                = 8e9;              % Sample clock in frequency

if TX.AWG.BitResolution == 14
    TX.AWG.MinimumSegmentLength       = 240;              % Minimum AWG segment length
elseif TX.AWG.BitResolution  == 12
    TX.AWG.MinimumSegmentLength       = 320;
end

% Calibration Training Length
Cal.TrainingLength = TX.Fsample / 500e3;

TX.AWG.DataFormat                 = 'DNRZ';
TX.AWG.VFS                        = 0.7;              % AWG full scale voltage amp
TX.AWG.TriggerAmplitude           = 1.5;                % Trigger signal amplitude
% TX.NumberOfTransmittedPeriods = 10;
TX.NumberOfTransmittedPeriods = 100;
% Expansion Margin Settings
TX.AWG.ExpansionMarginSettings.ExpansionMarginEnable = 0;
TX.AWG.ExpansionMarginSettings.ExpansionMargin = 2;

TX.FGuard                     = 300e3;

% DC offset in the I and Q channels
TX.LO_OffsetFreq              = 0;
TX.I_Offset                   = 0;
TX.Q_Offset                   = 0;

% TX Trigger Frame Time Calculation
[num den] = rat(TX.Fsample/ Cal.Signal.ToneSpacing);
SamplesPerPeriod               = (den / Cal.Signal.ToneSpacing) * TX.Fsample;
MinimumNumberOfSegments        = lcm(SamplesPerPeriod,TX.AWG.MinimumSegmentLength);
PeriodsPerSegment              = MinimumNumberOfSegments / SamplesPerPeriod;
NumberOfSegments               = ceil(TX.NumberOfTransmittedPeriods / PeriodsPerSegment);
% TX.FrameTime                   = NumberOfSegments * MinimumNumberOfSegments / TX.Fsample; 
TX.FrameTime                   = TX.NumberOfTransmittedPeriods * MinimumNumberOfSegments / TX.Fsample;

% Load the AWG Calibration files
if (Cal.AWG.Calflag)
    TX.AWG_Correction_I  = load(Cal.AWG.CalFile_I);
    TX.AWG_Correction_Q  = load(Cal.AWG.CalFile_Q);
end

TX.AWG.MultiChannelFlag = 0;
TX.AWG.SyncModuleFlag = 0;
TX.AWG.Position = 1;
if (TX.AWG.MultiChannelFlag)
    if (TX.AWG.Position == 1)
        copyfile('arbConfig_Top.mat', 'arbConfig.mat')
    else
        copyfile('arbConfig_Bottom.mat', 'arbConfig.mat')
    end
end
clear num den

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set RX Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RX.Type                    = 'Scope';    % Choose between 'UXA' 'Digitizer', 'Scope' for the receiver
RX.Fcarrier                = 6.25e9;      % Center frequency of the received tones
% RX.Fcarrier                = 2.626e9;      % Center frequency of the received tones
RX.MirrorSignalFlag        = true;     % Higher or lower LO injection
RX.Analyzer.Fsample        = 40e9;      % Sampling rate of the receiver
RX.FrameTime               = TX.FrameTime;     % One measurement frame;
RX.NumberOfMeasuredPeriods = 2;        % Number of measured frames;
RX.Analyzer.PointsPerRecord         = RX.Analyzer.Fsample * RX.FrameTime * RX.NumberOfMeasuredPeriods;

RX.VisaAddress             = 'USB0::0x0957::0x9001::MY48240314::0::INSTR';
% RX.VisaAddress             = 'TCPIP0::169.254.173.230::inst0::INSTR';

RX.ScopeIVIDriverPath      = 'C:\Users\a38chung\Desktop\Scope\AgilentInfiniium.mdd';
% RX.ScopeIVIDriverPath      = '.\Instrument_Functions\MSOS804A\AgilentInfiniium.mdd';

% UXA Parameters
RX.UXA.AnalysisBandwidth    = 1e9;
RX.UXA.Attenuation          = 12;  % dB
RX.UXA.ClockReference       = 'Internal';
if (RX.UXA.AnalysisBandwidth > 500e6)
    RX.UXA.TriggerPort          = 'EXT3';
else
    RX.UXA.TriggerPort          = 'EXT1';
end
RX.UXA.TriggerLevel         = 700; % mV

% Scope Parameters
RX.EnableExternalReferenceClock = false;
RX.channelVec                   = [1 0 0 0];
% When downconverting, a filter is applied which inserts 0's at the
% beginning so we discard some points to avoid this. If there are no points
% discarded then the delay should always be positive
Cal.Signal.TrainingLength = 0;
if (Cal.Signal.TrainingLength > 0)
    RX.PositiveDelayFlag = 0;
else
    RX.PositiveDelayFlag = 1;
end

if (TX.AWG.Position == 1)
    RX.TriggerChannel = 3;
else
    RX.TriggerChannel = 3;
%     RX.TriggerChannel = 4;
end

% Digitizer Parameters
RX.EnableExternalClock     = true;
RX.ExternalClockFrequency  = 1.906e9;    % For half rate 1.998 GSa/s, quarter rate 1.906 GSa/s
RX.ACDCCoupling            = 1;
RX.VFS                     = 1;          % Digitzer full scale peak to peak voltage reference (1 or 2 V)
if (RX.Analyzer.Fsample > 1e9)
    RX.EnableInterleaving  = true;       % Enable interleaving
end

% Downconversion filter if we receive at IF
if (~strcmp(RX.Type,'UXA'))
    load FIR_LPF_fs40e9_fpass2r6e9_Order815
    RX.Filter = Num;
    clear Num
end

% Load the RX calibration file
if (Cal.RX.Calflag)
    load(Cal.RX.CalFile);
    RX.Cal.ToneFreq = tones_freq;
    RX.Cal.RealCorr = comb_I_cal;
    RX.Cal.ImagCorr = comb_Q_cal;
end

if (Cal.Processing32BitFlag)
    instrreset
    if (strcmp(RX.Type,'Scope'))
%         global Scope_Driver;
%         [Scope_Driver] = ScopeDriverInit( RX );
    elseif (strcmp(RX.Type,'Digitzer'))
        [RX.Digitizer] = ADCDriverInit( RX );
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate calibration signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TX Calibration Signal
[ TrainingSignal_I ] = GenerateMultiToneSignal( Cal.Signal.StartingToneFreq_I, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq_I, ...
    TX.FrameTime, TX.Fsample, Cal.Signal.MultitoneOptions);
[ TrainingSignal_Q ] = GenerateMultiToneSignal( Cal.Signal.StartingToneFreq_Q, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq_Q, ...
    TX.FrameTime, TX.Fsample, Cal.Signal.MultitoneOptions);

Cal.Signal.TrainingSignal = complex(TrainingSignal_I, TrainingSignal_Q);
Cal.Signal.TrainingSignal = SetMeanPower(Cal.Signal.TrainingSignal,0);
CheckPower(Cal.Signal.TrainingSignal,1)
Cal.Signal.Fsample = TX.Fsample;
% Remove any DC offset
Cal.Signal.TrainingSignal = Cal.Signal.TrainingSignal - mean(Cal.Signal.TrainingSignal);
clear TrainingSignal_I  TrainingSignal_Q

[ VerificationSignal_I ] = GenerateMultiToneSignal( Cal.Signal.StartingToneFreq_I, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq_I, ...
    TX.FrameTime, TX.Fsample, Cal.Signal.MultitoneOptions);
[ VerificationSignal_Q ] = GenerateMultiToneSignal( Cal.Signal.StartingToneFreq_Q, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq_Q, ...
    TX.FrameTime, TX.Fsample, Cal.Signal.MultitoneOptions);
Cal.Signal.VerificationSignal = complex(VerificationSignal_I, VerificationSignal_Q);
Cal.Signal.VerificationSignal = SetMeanPower(Cal.Signal.VerificationSignal,0);
CheckPower(Cal.Signal.VerificationSignal,1)
% Remove any DC offset
Cal.Signal.VerificationSignal = Cal.Signal.VerificationSignal - mean(Cal.Signal.VerificationSignal);
clear VerificationSignal_I VerificationSignal_Q

% Plot the two signal
PlotDFT(Cal.Signal.TrainingSignal,Cal.Signal.VerificationSignal,TX.Fsample);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Main Script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (strcmp(Cal.Type,'Time_Domain'))
    [TX_CAL_RESULTS] = ExtractImbalanceAndVerify_TimeDomain(TX, RX, Cal);
else
    if (~Cal.SubRateFlag)
        [TX_CAL_RESULTS] = ExtractImbalanceAndVerify_FreqDomain(TX, RX, Cal);
    else
        [TX_CAL_RESULTS] = ExtractImbalanceAndVerify_FreqDomain_SubRate(TX, RX, Cal);
    end
end
if (~exist(Cal.Directory,'dir'))
    mkdir(Cal.Directory);
    addpath(genpath(Cal.Directory));
end

save([Cal.Directory '\' Cal.Filename], 'TX_CAL_RESULTS');
save([Cal.Directory '\' Cal.Filename '_CalibrationStructure'], 'Cal');
