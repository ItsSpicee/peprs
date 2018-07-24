%    This script performs AWG calibration
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

load("C:\Users\leing\Documents\Laura\git\peprs\Measurement Data\AWG Calibration Parameters\Cal.mat")
load("C:\Users\leing\Documents\Laura\git\peprs\Measurement Data\AWG Calibration Parameters\RX.mat")
load("C:\Users\leing\Documents\Laura\git\peprs\Measurement Data\AWG Calibration Parameters\TX.mat")

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Utilize 32-bit MATLAB flag
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Processing32BitFlag = 1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set Calibration Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.LearningParam                    = 0.2; % currently irrelevant
Cal.Mse                              = zeros(Cal.NumIterations,1);
   
% PAPR limits when generating the signals
Cal.Signal.MultitoneOptions.PAPRmin  = 8;
Cal.Signal.MultitoneOptions.PAPRmax  = 9;

% Calibration file complex baseband frequency
tonesBaseband = (Cal.Signal.StartingToneFreq : Cal.Signal.ToneSpacing : Cal.Signal.EndingToneFreq);
tonesBaseband = [-fliplr(tonesBaseband) tonesBaseband];
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set TX Parameters
%  Description: AWG frame time is picked to ensure that the signal length
%  is multiples of minimum segment length at the AWG sampling rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TX Trigger Frame Time Calculation
SamplesPerPeriod               = (1 / Cal.Signal.ToneSpacing) * TX.Fsample;
MinimumNumberOfSegments        = lcm(SamplesPerPeriod,TX.MinimumSegmentLength);
PeriodsPerSegment              = MinimumNumberOfSegments / SamplesPerPeriod;
NumberOfSegments               = ceil(TX.NumberOfTransmittedPeriods / PeriodsPerSegment);
TX.FrameTime                   = TX.NumberOfTransmittedPeriods * MinimumNumberOfSegments / TX.Fsample; 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set RX Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RX.FrameTime               = TX.FrameTime;     % One measurement frame;
RX.PointsPerRecord         = RX.Fsample * RX.FrameTime * RX.NumberOfMeasuredPeriods;

% Digitizer Parameters
if (RX.Fsample > 1e9)
    RX.EnableInterleaving  = true;       % Enable interleaving
end

% UXA
if (RX.UXA.AnalysisBandwidth > 500e6)
    RX.UXA.TriggerPort          = 'EXT3';
else
    RX.UXA.TriggerPort          = 'EXT1';
end

% Downconversion filter
load RX.FilterFile
RX.Filter = Num;

% Load the RX calibration file
if (Cal.RX.Calflag)
    load (Cal.RX.CalFile);
    RX.Cal.ToneFreq = tones_freq;
    RX.Cal.RealCorr = comb_I_cal;
    RX.Cal.ImagCorr = comb_Q_cal;
end

clear Num
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Initialize the RX drivers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
if (Cal.Processing32BitFlag)
    if (strcmp(RX.Type,'Scope'))
        [RX.Scope] = ScopeDriverInit( RX );
    elseif (strcmp(RX.Type,'Digitzer'))
        [RX.Digitizer] = ADCDriverInit( RX );
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate the multitone signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ TrainingSignal ] = GenerateMultiToneSignal( Cal.Signal.StartingToneFreq, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq, ...
    TX.FrameTime, TX.Fsample, Cal.Signal.MultitoneOptions);
TrainingSignal = SetMeanPower(TrainingSignal,0);
VerificationSignal = SetMeanPower(TrainingSignal(end:-1:1),0);
CheckPower(TrainingSignal,1);
CheckPower(VerificationSignal,1);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Send the multitone signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:Cal.NumIterations  
    if i > 1
        TrainingSignal_Cal = ApplyLUTCalibration(TrainingSignal, TX.Fsample, ...
            tonesBaseband, real(H_Tx_freq_inverse), imag(H_Tx_freq_inverse));
        TrainingSignal_Cal = real(TrainingSignal_Cal);
    else
        TrainingSignal_Cal = TrainingSignal;
    end
    if (strcmp(TX.AWG_Model,'M8195A'))
        AWG_M8195A_SignalUpload_ChannelSelect_FixedAvgPower({TrainingSignal_Cal},{0},{TX.Fsample},TX.Fsample,0,false,TX.AWG_Channel,0,0,0);
        AWG_M8195A_DAC_Amplitude(1,TX.VFS);
        AWG_M8195A_DAC_Amplitude(4,TX.VFS);
    else
        AWG_M8190A_SignalUpload_ChannelSelect_FixedAvgPower({TrainingSignal_Cal},{0},{TX.Fsample},TX.Fsample,0,false,TX.AWG_Channel,0,0,0);
        AWG_M8190A_DAC_Amplitude(1,TX.VFS);       % -1 dBm input is recommended for external I and Q inputs into PSG
        AWG_M8190A_DAC_Amplitude(2,TX.VFS);
        AWG_M8190A_MKR_Amplitude(1,TX.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
        AWG_M8190A_MKR_Amplitude(2,TX.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
    end
    AWG_M8190A_Reference_Clk(TX.ReferenceClockSource,TX.ReferenceClock);

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Download the signal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Cal.Processing32BitFlag)
        if (strcmp(RX.Type,'Scope'))
%             [ obj ] = SignalCapture_Scope(RX.Scope, RX.Fsample, RX.PointsPerRecord, RX.EnableExternalReferenceClock);
%             Rec = obj.Ch1_Waveform;
            [ obj ] = SignalCapture_Scope_64bit(RX, autoscaleFlag);
            Rec = obj.Ch1_Waveform;
        else
            Rec = DataCapture_Digitizer_32bit (RX);
        end

        if (strcmp(RX.Type,'UXA'))
                    % Get received I and Q signals 
            [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier, ...
                RX.UXA.AnalysisBandwidth, 2 * RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
            Received_train = complex(Received_I, Received_Q);
            Rec = Received_train(1:20e3);
            if (Cal.RX.Calflag)
    %             Rec = ApplyLUTCalibration(Rec, RX.Fsample, RX.Cal.ToneFreq, abs(RX.Cal.RealCorr+1i*RX.Cal.ImagCorr), zeros(length(RX.Cal.ToneFreq),1));
                Rec = ApplyLUTCalibration(Rec, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
            end
            [DownSampleUXA, UpSampleUXA] = rat(TX.Fsample / RX.UXA.AnalysisBandwidth);
            Rec = resample(Rec, DownSampleUXA, UpSampleUXA, 100);
        end
    else
        load('Scope_out.mat');
    end

    Rec = filter(RX.Filter, [1 0], Rec);

    % Resample the signal
    [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Fsample);
    Rec = resample(Rec, DownSampleScope, UpSampleScope);
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Downconvert, align, analyze the signal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (isrow(Rec))
        Rec = Rec.';
    end
    Rec = Rec - mean(Rec);

    % Align and analyze the signals - if it is real we do not adjust the phase
    if (Cal.Signal.MultitoneOptions.RealBasisFlag)
        [ In_D_test, Out_D_test, EVM_Perc_Before] = AlignAndAnalyzeRealSignals( TrainingSignal, Rec, TX.Fsample);
    else
        [ In_D_test, Out_D_test, EVM_Perc_Before] = AlignAndAnalyzeSignals( TrainingSignal, Rec, TX.Fsample);
    end
    display([ 'NMSE Before         = ' num2str(EVM_Perc_Before)      ' % ' ]);
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Find the inverse response
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Truncate the signal to a length that allows the frequency resolution to
    % divide into the tone grid
    L = TX.Fsample / Cal.Fres;
    In_D_test       = In_D_test(1:L);
    Out_D_test      = Out_D_test(1:L);

    % Calculate the inverse model
    if i > 1
        H_Tx_freq_inverse = H_Tx_freq_inverse(tonesBaseband>0);
        [ H_new, Cal.Mse(i)] = CalculateInverseResponseModel(In_D_test, Out_D_test, tonesBaseband(tonesBaseband>0), TX.Fsample);
        H_Tx_freq_inverse = H_Tx_freq_inverse .* H_new;
%         [ H_Tx_freq_inverse, Cal.Mse(i)] = UpdateInverseFilter_FFTLMS(In_D_test, Out_D_test, H_Tx_freq_inverse(tonesBaseband>0), tonesBaseband(tonesBaseband>0), TX.Fsample, Cal.LearningParam);
    else
        [ H_Tx_freq_inverse, Cal.Mse(i)] = CalculateInverseResponseModel(In_D_test, Out_D_test, tonesBaseband(tonesBaseband>0), TX.Fsample);
    end
    H_Tx_freq_inverse = [conj(flipud(H_Tx_freq_inverse)); H_Tx_freq_inverse];
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Save Inverse Model Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save(Cal.SaveLocation, 'H_Tx_freq_inverse', 'tonesBaseband');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Apply the inverse model to the verification signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VerificationSignal_Cal = ApplyLUTCalibration(VerificationSignal, TX.Fsample, ...
     tonesBaseband, real(H_Tx_freq_inverse), imag(H_Tx_freq_inverse));
VerificationSignal_Cal = real(VerificationSignal_Cal);
 
if (strcmp(TX.AWG_Model,'M8195A'))
    AWG_M8195A_SignalUpload_ChannelSelect_FixedAvgPower({VerificationSignal_Cal},{0},{TX.Fsample},TX.Fsample,0,false,TX.AWG_Channel,0,0,0);
    AWG_M8195A_DAC_Amplitude(1,TX.VFS);
    AWG_M8195A_DAC_Amplitude(4,TX.VFS);
else
    AWG_M8190A_SignalUpload_ChannelSelect_FixedAvgPower({VerificationSignal_Cal},{0},{TX.Fsample},TX.Fsample,0,false,TX.AWG_Channel,0,0,0);
    AWG_M8190A_DAC_Amplitude(1,TX.VFS);       % -1 dBm input is recommended for external I and Q inputs into PSG
    AWG_M8190A_DAC_Amplitude(2,TX.VFS);
    AWG_M8190A_MKR_Amplitude(1,TX.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
    AWG_M8190A_MKR_Amplitude(2,TX.TriggerAmplitude);       % Set the trigger amplitude to 1.5 V 
end
AWG_M8190A_Reference_Clk(TX.ReferenceClockSource,TX.ReferenceClock);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Download the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (Cal.Processing32BitFlag)
    if (strcmp(RX.Type,'Scope'))
%         [ obj ] = SignalCapture_Scope(RX.Scope, RX.Fsample, RX.PointsPerRecord, RX.EnableExternalReferenceClock);
%         Rec = obj.Ch1_Waveform;
        [ obj ] = SignalCapture_Scope_64bit(RX, autoscaleFlag);
        Rec = obj.Ch1_Waveform;
    else
        Rec = DataCapture_Digitizer_32bit (RX);
    end
    if (strcmp(RX.Type,'UXA'))
                % Get received I and Q signals 
        [Received_I, Received_Q] = IQCapture_UXA(RX.Fcarrier, ...
            RX.UXA.AnalysisBandwidth, 2 * RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference, RX.UXA.TriggerPort, RX.UXA.TriggerLevel);
        Received_train = complex(Received_I, Received_Q);
        Rec = Received_train(1:20e3);
        if (Cal.RX.Calflag)
%             Rec = ApplyLUTCalibration(Rec, RX.Fsample, RX.Cal.ToneFreq, abs(RX.Cal.RealCorr+1i*RX.Cal.ImagCorr), zeros(length(RX.Cal.ToneFreq),1));
            Rec = ApplyLUTCalibration(Rec, RX.Fsample, RX.Cal.ToneFreq, RX.Cal.RealCorr, RX.Cal.ImagCorr);
        end
        [DownSampleUXA, UpSampleUXA] = rat(TX.Fsample / RX.UXA.AnalysisBandwidth);
        Rec = resample(Rec, DownSampleUXA, UpSampleUXA, 100);
    end
else
    load('Scope_out.mat');
end

Rec = filter(RX.Filter, [1 0], Rec);

% Resample the signal
[DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Fsample);
Rec = resample(Rec, DownSampleScope, UpSampleScope);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Downconvert, align, analyze the signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rec = filter(RX.Filter, [1 0], Rec);
% Resample the signal
% [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Fsample);
% Rec = resample(Rec, DownSampleScope, UpSampleScope);
if (isrow(Rec))
    Rec = Rec.';
end
Rec = Rec - mean(Rec);
% Align and analyze the signals - if it is real we do not adjust the phase
if (Cal.Signal.MultitoneOptions.RealBasisFlag)
    [ In_D_test, Out_D_test, EVM_Perc_After] = AlignAndAnalyzeRealSignals( VerificationSignal, Rec, TX.Fsample);
else
    [ In_D_test, Out_D_test, EVM_Perc_After] = AlignAndAnalyzeSignals( VerificationSignal, Rec, TX.Fsample);
end
display([ 'NMSE After          = ' num2str(EVM_Perc_After)      ' % ' ]);
