%    This script performs an upconverter calibration
%    MATLAB version required
%    1. 32-bit MATLAB
%    Instruments Required
%    1. Baseband Arbitrary Waveform Generator (AWG) {Agilent M8190A} for
%       trigger
%    2. Analyzer (Scope, Digitizer)
clc
clear
close all

path(pathdef); % Resets the paths to remove paths outside this folder
addpath(genpath('C:\Program Files (x86)\IVI Foundation\IVI\Components\MATLAB')) ;
addpath(genpath(pwd))%Automatically Adds all paths in directory and subfolders
instrreset

load('./Measurement Data/Heterodyne Calibration Parameters/Cal.mat')
load('./Measurement Data/Heterodyne Calibration Parameters/TX.mat')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Utilize 32-bit MATLAB flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Processing32BitFlag = 0;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set Calibration Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calibration file complex baseband frequency
tonesBaseband = (Cal.Signal.StartingToneFreq : Cal.Signal.ToneSpacing : Cal.Signal.EndingToneFreq);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set TX Parameters
%  Description: AWG frame time is picked to ensure that the signal length
%  is multiples of minimum segment length at the AWG sampling rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Expansion Margin Settings
TX.AWG.ExpansionMarginSettings.ExpansionMarginEnable = 0;
TX.AWG.ExpansionMarginSettings.ExpansionMargin = 2;

% AWG channel for calibration
TX.AWG_Channel                = 1;
TX.Fcarrier                   = 1e9;

% TX Trigger Frame Time Calculation
MinimumNumberOfSegments        = (1 / Cal.Signal.ToneSpacing) * TX.Fsample / TX.MinimumSegmentLength;
[num den]                      = rat(MinimumNumberOfSegments);
TX.MinimumNumberOfPeriods      = 1 / MinimumNumberOfSegments * num;
TX.FrameTime                   = TX.NumberOfTransmittedPeriods / Cal.Signal.ToneSpacing * TX.MinimumNumberOfPeriods; 

clear num den

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set RX Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RX.Type                    = 'Scope';    % Choose between 'Digitizer', 'Scope', 'UXA' for the receiver
RX.Fcarrier                = 6.250e9;       % Center frequency of the received tones
RX.MirrorSignalFlag        = true;      % Receiving the mirror signal or not
RX.XCorrLength             = 2e3;
RX.Analyzer.Fsample                 = 40e9;        % Sampling rate of the receiver
RX.FrameTime               = TX.FrameTime;     % One measurement frame;
RX.NumberOfMeasuredPeriods = 2;          % Number of measured frames;
RX.Analyzer.PointsPerRecord= RX.Analyzer.Fsample * RX.FrameTime * RX.NumberOfMeasuredPeriods;

RX.VisaAddress             = 'USB0::0x0957::0x9001::MY48240314::0::INSTR';

% RX.ScopeIVIDriverPath      = 'C:\Users\a38chung\Desktop\Scope\AgilentInfiniium.mdd';
% Scope Parameters
RX.EnableExternalReferenceClock = false;
RX.TriggerChannel               = 3;
RX.channelVec                   = [1 0 0 0];
autoscaleFlag = 1;

% Digitizer Parameters
RX.EnableExternalClock     = false;
RX.ExternalClockFrequency  = 1.906e9;    % For half rate 1.998 GSa/s, quarter rate 1.906 GSa/s
RX.ACDCCoupling            = 1;
RX.VFS                     = 1;          % Digitzer full scale peak to peak voltage reference (1 or 2 V)
if (RX.Analyzer.Fsample > 1e9)
    RX.EnableInterleaving  = true;       % Enable interleaving
end

% UXA Parameters
RX.UXA.AnalysisBandwidth    = 1e9;
RX.UXA.IFPath               = 1e9;
RX.UXA.Attenuation          = 6;  % dB
RX.UXA.SpurFrequency        = 250e6; % Spur from the UXA do not put a tone here
RX.UXA.ClockReference       = 'Internal';
if (RX.UXA.IFPath > 500e6)
    RX.UXA.TriggerPort          = 'EXT3';
else
    RX.UXA.TriggerPort          = 'EXT1';
end
RX.UXA.TriggerLevel         = 250; % mV

if (Cal.Processing32BitFlag)
    instrreset
    if (strcmp(RX.Type,'Scope'))
%         global Scope_Driver;
%         [Scope_Driver] = ScopeDriverInit( RX );
    elseif (strcmp(RX.Type,'Digitzer'))
        [RX.Digitizer] = ADCDriverInit( RX );
    end
end

% Downconversion filter if we receive at IF
load FIR_LPF_fs40e9_fpass1r6e9_Order815
RX.Filter = Num;
clear Num

% Load the RX calibration file
if (Cal.RX.Calflag)
    load(Cal.RX.CalFile);
    RX.Cal.ToneFreq = tones_freq;
    RX.Cal.RealCorr = comb_I_cal;
    RX.Cal.ImagCorr = comb_Q_cal;
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Initialize the RX drivers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if (~Cal.Processing32BitFlag)
    if (strcmp(RX.Type,'Scope'))
%         [RX.Scope] = ScopeDriverInit( RX );
    elseif (strcmp(RX.Type,'Digitzer'))
        [RX.Digitizer] = ADCDriverInit( RX );
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate the multitone signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ TrainingSignal ] = GenerateMultiToneSignal( Cal.Signal.StartingToneFreq, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq, ...
    TX.FrameTime, TX.Fsample, Cal.Signal.MultitoneOptions );
VerificationSignal = TrainingSignal(end:-1:1);
PlotSpectrum(TrainingSignal,VerificationSignal,TX.Fsample);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Send the multitone signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:Cal.NumIterations  
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

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Download the signal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Downconvert, align, analyze the signal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (isrow(Rec))
        Rec = Rec.';
    end

    % Align and analyze the signals - if it is real we do not adjust the phase
    alignFreqDomainFlag = 1;
    if (Cal.Signal.MultitoneOptions.RealBasisFlag)
        [ In_D_test, Out_D_test, NMSE_Before] = AlignAndAnalyzeRealSignals( TrainingSignal, Rec, TX.Fsample);
    else
        [ In_D_test, Out_D_test, NMSE_Before] = AlignAndAnalyzeSignals( TrainingSignal, Rec, TX.Fsample, alignFreqDomainFlag, RX.XCorrLength);
    end
    display([ 'NMSE Before         = ' num2str(NMSE_Before)      ' % ' ]);
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Find the inverse response
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Truncate the signal to a length that allows the frequency resolution to
    % divide into the tone grid
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
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Save Inverse Model Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath(Cal.SaveLocation));
save([Cal.SaveLocation], 'H_Tx_freq_inverse', 'tonesBaseband');
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

% Resample the signal
[DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Analyzer.Fsample);
Rec = resample(Rec, DownSampleScope, UpSampleScope);

% Align and analyze the signals
[ In_D_test, Out_D_test, NMSE_After] = AlignAndAnalyzeSignals( VerificationSignal, Rec, TX.Fsample, alignFreqDomainFlag, RX.XCorrLength);
display([ 'NMSE After          = ' num2str(NMSE_After)      ' % ' ]);
