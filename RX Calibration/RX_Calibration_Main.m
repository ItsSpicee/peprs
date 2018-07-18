%    This script performs offset and RX calibration using the comb
%    generator
%    MATLAB version required
%    1. 32-bit MATLAB
%    Instruments Required
%    1. Baseband Arbitrary Waveform Generator (AWG) {Agilent M8190A} for
%       trigger
%    2. Comb Generator
%    3. Analyzer (Scope, Digitizer)
clc
clear
close all

path(pathdef); % Resets the paths to remove paths outside this folder
addpath(genpath('C:\Program Files (x86)\IVI Foundation\IVI\Components\MATLAB')) ;
addpath(genpath(pwd))%Automatically Adds all paths in directory and subfolders
instrreset

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Utilize 32-bit MATLAB flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Processing32BitFlag = 1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set Comb Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.RFToneSpacing             = 10e6;      % Spacing between the adjacent tones at RF
% Cal.IFToneSpacing             = Cal.RFToneSpacing / 2;  % Spacing between the received adjacent tones
Cal.IFToneSpacing             = 5e6;
Cal.Reference.CombReferenceFile           = 'MY51256128';       % Reference comb generator file
Cal.Reference.RFCenterFrequency           = 25e9;  % Starting RF tone for calibration
Cal.Reference.RFCalibrationStartFrequency = 23.49e9;  % Starting RF tone for calibration
Cal.Reference.RFCalibrationStopFrequency  = 26.51e9;  % Last RF tone for calibration
% Cal.Reference.RFCenterFrequency           = 12.5e9;  % Starting RF tone for calibration
% Cal.Reference.RFCalibrationStartFrequency = 10.99e9;  % Starting RF tone for calibration
% Cal.Reference.RFCalibrationStopFrequency  = 14.01e9;  % Last RF tone for calibration
% Cal.Reference.RFCenterFrequency           = 6.25e9;  % Starting RF tone for calibration
% Cal.Reference.RFCalibrationStartFrequency = 4.64e9;  % Starting RF tone for calibration
% Cal.Reference.RFCalibrationStopFrequency  = 7.86e9;  % Last RF tone for calibration
Cal.Reference.StartingTone                = round(min(abs(Cal.Reference.RFCalibrationStopFrequency),abs(Cal.Reference.RFCalibrationStartFrequency)) / Cal.RFToneSpacing);
Cal.Reference.EndingTone                  = round(max(abs(Cal.Reference.RFCalibrationStopFrequency),abs(Cal.Reference.RFCalibrationStartFrequency)) / Cal.RFToneSpacing);

% Find the IF tones to fish out
Cal.LOFrequencyOffset            =    27.002e9;
% Cal.LOFrequencyOffset            =    15.302e9;
% Cal.LOFrequencyOffset            =    6.25e9;
% Inband tones
Cal.DesiredTones.InbandFrequency = ((Cal.Reference.RFCalibrationStartFrequency:...
    Cal.RFToneSpacing:Cal.Reference.RFCalibrationStopFrequency) - Cal.LOFrequencyOffset).';
Cal.DesiredTones.InbandFrequency = Cal.DesiredTones.InbandFrequency(Cal.DesiredTones.InbandFrequency ~= Cal.Reference.RFCenterFrequency);
% Aliased tones for subrate calibration
Cal.SubRateFlag = 0;
Cal.DesiredTones.PositiveAliasFrequency = (251.5e6:Cal.RFToneSpacing:491.5e6).';
Cal.DesiredTones.NegativeAliasFrequency = (2.5e6:Cal.RFToneSpacing:242.5e6).';

% Calibration file complex baseband frequency
tones_freq = (-1.51e9:Cal.RFToneSpacing:1.51e9).';
% tones_freq = tones_freq(tones_freq ~= 0);
Cal.Directory = 'RX_CalResults';
% Cal.Filename  = 'RX_CalResults_fc6r25GHz_BW3GHz';
Cal.Filename  = 'RX_CalResults_fc25GHz_fLORX_27r002GHz_fIF_1r802GHz_BW3GHz';
% Cal.Filename  = 'RX_CalResults_fc12r5GHz_fLORX_15r302GHz_fIF_2r802GHz_BW3GHz';
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set RX Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RX.Type                    = 'Scope';    % Choose between 'UXA', 'Digitizer', 'Scope' for the receiver
RX.Fcarrier                = 2.002e9;        % Center frequency of the received tones
RX.LOLowerInjectionFlag    = false;      % Higher or lower LO injection
RX.Analyzer.Fsample                 = 40e9;        % Sampling rate of the receiver
RX.FrameTime               = 6 / Cal.RFToneSpacing;     % One measurement frame;
RX.NumberOfMeasuredPeriods = 95;         % Number of measured frames;
RX.Analyzer.PointsPerRecord         = RX.Analyzer.Fsample * RX.FrameTime * RX.NumberOfMeasuredPeriods;

RX.VisaAddress             = 'USB0::0x0957::0x9001::MY48240314::0::INSTR';
RX.ScopeIVIDriverPath      = 'C:\Users\a38chung\Desktop\Scope\AgilentInfiniium.mdd';

% Scope Parameters
RX.EnableExternalReferenceClock = false;
RX.channelVec = [1 0 0 0];
RX.Scope.autoscaleFlag = true;
RX.TriggerChannel = 3;

% Digitizer Parameters
RX.EnableExternalClock     = false;
RX.ExternalClockFrequency  = 1.906e9;    % For half rate 1.998 GSa/s, quarter rate 1.906 GSa/s
RX.ACDCCoupling            = 1;
RX.VFS                     = 1;          % Digitzer full scale peak to peak voltage reference (1 or 2 V)
if (RX.Analyzer.Fsample > 1e9)
    RX.EnableInterleaving  = true;       % Enable interleaving
end

% UXA
RX.UXA.AnalysisBandwidth    = 1e09;
% RX.UXA.Attenuation          = 0;  % dB
RX.UXA.Attenuation          = 2;  % dB
RX.UXA.ClockReference       = 'Internal';
if (RX.UXA.AnalysisBandwidth > 500e6)
    RX.UXA.TriggerPort          = 'EXT3';
else
    RX.UXA.TriggerPort          = 'EXT1';
end
RX.UXA.TriggerLevel         = 700; % mV

% Downconversion filter if we receive at IF
if (~strcmp(RX.Type, 'UXA'))
    load FIR_LPF_fs40e9_fpass_1r52e9_Order685
    RX.Filter = Num;
    clear Num
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set Trigger Signal Parameters
%  Description: AWG_frame_time will be used to make sure that the trigger 
%  signal period is at an integer multiple of the comb perid. To prevent
%  the AWG from adding more segments to the signal, ensure that the trigger
%  length is an integer of the minimum AWG segment length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TX.Type                 = 'AWG';             % Choose between 'AWG'
TX.AWG_Model            = 'M8190A';          % Choose bewteen 'M8190A' and 'M8195A'
TX.Fsample              = 12e9;               % AWG sample rate
TX.ReferenceClockSource = 'External';       % Choose between 'Backplane', 'Internal', 'External'
TX.ReferenceClock       = 10e6;             % External reference clock frequency
TX.MinimumSegmentLength = lcm(240,320);               % Minimum AWG segment length
TX.VFS                  = 0.7;               % AWG full scale voltage amp
TX.TriggerAmplitude     = 1.5;               % Trigger signal amplitude

% TX Trigger Frame Time Calculation
SamplesPerPeriod               = (1 / Cal.IFToneSpacing) * TX.Fsample;
MinimumNumberOfPoints        = lcm(SamplesPerPeriod,TX.MinimumSegmentLength);
% PeriodsPerSegment              = MinimumNumberOfSegments / SamplesPerPeriod;
% NumberOfSegments               = ceil(RX.NumberOfMeasuredPeriods / PeriodsPerSegment);
TX.FrameTime                   = RX.NumberOfMeasuredPeriods * MinimumNumberOfPoints / TX.Fsample; 

clear num den

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Send Trigger Signal
%  AWG_frame_time will be used to make sure that the trigger signal period 
%  is at an integer multiple of the comb perid 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SendTriggerSignal(TX);
    
if (Cal.Processing32BitFlag)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Initialize the RX drivers
    %  AWG_frame_time will be used to make sure that the trigger signal period 
    %  is at an integer multiple of the comb perid 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    if (strcmp(RX.Type,'Scope'))
        instrreset
        %[RX.Scope] = ScopeDriverInit( RX );
    elseif (strcmp(RX.Type,'Digitzer'))
        [RX.Digitizer] = ADCDriverInit( RX );
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Download Signal
    %  AWG_frame_time will be used to make sure that the trigger signal period 
    %  is at an integer multiple of the comb perid 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (strcmp(RX.Type,'Scope'))
        %[ obj ] = SignalCapture_Scope(RX.Scope, RX.Analyzer.Fsample, 2 * RX.PointsPerRecord, RX.EnableExternalReferenceClock);
        %Rec = obj.Ch1_Waveform;
		[ obj ] = SignalCapture_Scope_64bit(RX, RX.Scope.autoscaleFlag);
        Rec = obj.Ch_Waveform{1};
    else
        Rec = DataCapture_Digitizer_32bit (RX);
%         [Rec] = DigitalDownconvert( Rec, RX.Analyzer.Fsample, RX.Fcarrier, RX.Filter, RX.LOLowerInjectionFlag);
    end
    if (strcmp(RX.Type,'UXA'))
                % Get received I and Q signals 
        [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier + Cal.LOFrequencyOffset, ...
            RX.UXA.AnalysisBandwidth, 200 * RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
        Rec = complex(Received_I, Received_Q);
        Rec = Rec(1:400e3);
    end

    save('Raw_Data', 'Rec');
    display('Scope is done');
    clear obj
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Fish out the desired tones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Raw_Data');
Rec = Rec(1:2e6);

% Ensure the the received
if (isrow(Rec))
    Rec = Rec.';
end

% Remove scope spurs
ReceivedTones  = GetDesiredTones(RX, Cal, tones_freq, Rec);
if (isrow(ReceivedTones))
    ReceivedTones = ReceivedTones.';
end

despurFlag = 0;
if despurFlag == 1
    scopeSpurStart = -1.75e9;
    scopeSpurSpacing = 250e6;
    scopeSpurEnd = 1.75e9;
    ReceivedTones  = RemoveScopeSpurs(ReceivedTones, tones_freq, scopeSpurStart, scopeSpurEnd, scopeSpurSpacing);
%     scopeSpurStart = -1.62e9;
%     scopeSpurSpacing = 250e6;
%     scopeSpurEnd = 1.62e9;
%     ReceivedTones  = RemoveScopeSpurs(ReceivedTones, tones_freq, scopeSpurStart, scopeSpurEnd, scopeSpurSpacing);
end

% tones_phase           = unwrap(phase(ReceivedTones));
% tones_phase_linear    = polyfit(tones_freq, tones_phase, 1);
% tones_phase_residue   = tones_phase - polyval(tones_phase_linear,tones_freq);
% ReceivedTones = abs(ReceivedTones) .* exp(1i * tones_phase_residue);

load(Cal.Reference.CombReferenceFile);
ReferenceTones = tone(Cal.Reference.StartingTone:Cal.Reference.EndingTone);
if RX.Fcarrier == 0
    ReferenceTones = [conj(flipud(ReferenceTones)); ReferenceTones];
end
ReferenceTones = ReferenceTones / mean(ReferenceTones);
tones_cal      = ReferenceTones./ReceivedTones; 

movingAverageFlag = 1;
if movingAverageFlag
    tones_cal = smooth(tones_cal,7);
end

comb_I_cal     = real(tones_cal);
comb_Q_cal     = imag(tones_cal);

% Plot inverse response
figure
subplot(2,1,1); plot(tones_freq./1e9,  20*log10(abs(tones_cal)), '.-'); hold on; grid on;title('Mag')
subplot(2,1,2); plot(tones_freq./1e9,  180/pi*unwrap(phase(tones_cal)), '.-'); hold on; grid on;title('Phase')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Save Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (~exist(Cal.Directory,'dir'))
    mkdir(Cal.Directory);    addpath(genpath(Cal.Directory));
end
save(['.\' Cal.Directory '\' Cal.Filename], 'tones_freq', 'comb_I_cal', 'comb_Q_cal')
