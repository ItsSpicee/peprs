function Set_Parameters_PrecharDebug() 
clc
clear
close all

path(pathdef); % Resets the paths to remove paths outside this folder
addpath(genpath('C:\Program Files (x86)\IVI Foundation\IVI\Components\MATLAB')) ;
addpath(genpath(pwd))%Automatically Adds all paths in directory and subfolders
instrreset

load(".\DPD Data\Signal Generation Parameters\Signal.mat")
load(".\DPD Data\Signal Generation Parameters\RX.mat");
load(".\DPD Data\Signal Generation Parameters\TX.mat");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Instrument control and signal analysis is done with with 32 bit MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Processing32BitFlag = true;
Measure_Pout_Eff = false; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Transmitter Parameters | RECEIVER PARAMS ALREADY SET IN SET_RXTX_STRUCTURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EVM_flag                    = 0;    % If this flag is one, the code demodulates the received signal and 
                                    % computes the symbol ENM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Signal Parameters | Set in Set_Prechar_Signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SignalName = Signal.Name;
% Load in the signal
ReadInputFiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Receiever Parameters | RECEIVER PARAMS ALREADY SET IN SET_RXTX_STRUCTURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% goes with SubRate flag, leave alone for now
RX.FsampleOverwrite = 0 * Signal.Fsample; % Overwrite the sampling rate of the receiver (max 450MHz for digitizer is recommanded)
RX.Analyzer.FrameTime = TX.FrameTime; % One measurement frame;
RX.Analyzer.Fsample = Signal.Fsample;
RX.Analyzer.PointsPerRecord = RX.Analyzer.Fsample * RX.Analyzer.FrameTime * RX.Analyzer.NumberOfMeasuredPeriods;

% VSA Parameters
RX.VSA.DemodSignalFlag = false;
% if RX.VSA.ASMPath == "" || RX.VSA.ASMPath ==" "
%     SetVSAParameters
% end

% Set remaining RX parameters
SetRxParameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Calibration Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Activate calibration
Cal.AWG.Calflag = false;
Cal.TX.Calflag  = false;
Cal.TX.IQCal    = false;
Cal.RX.Calflag  = false;

% AWG Calibration file
Cal.AWG.CalFile_I = '.\Measurement Data\AWG_CalResults\AWG_Cal_3105MHz_I.mat';
Cal.AWG.CalFile_Q = '.\Measurement Data\AWG_CalResults\AWG_Cal_3105MHz_Q.mat';
% If AWG calibration was done at baseband, offset calibration
Cal.AWG.fOffset = TX.Fcarrier; 

% TX Calibration file
if TX.AWG.Position == 1
%     Cal.TX.CalFile = '.\Upconverter_CalResults\IQ_Imbalance_fRF6r25GHz_3GHzFreq_Domain.mat';
    Cal.TX.CalFile = '.\Measurement Data\IQ_Imbalance_CalResults\IQ_Imbalance_fRF6r25GHz_3GHzFreq_Domain.mat';
else
    Cal.TX.CalFile = '.\Measurement Data\IQ_Imbalance_CalResults\IQ_Imbalance_fRF12r5GHz_fIF1r75_BW3r2GHz_BottomSyncWithBiasTee_v4Freq_Domain.mat';
end

% RX Calibration file
Cal.RX.CalFile = '.\Measurement Data\RX_CalResults\RX_CalResults_fc6r25GHz_BW3GHz.mat';

% Load in the calibration files
CalibrationParameters

save(".\DPD Data\Signal Generation Parameters\workspace.mat");
end