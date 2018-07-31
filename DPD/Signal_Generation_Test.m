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

%#ok<*UNRCH>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Instrument control and signal analysis is done with with 32 bit MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Processing32BitFlag = true;
Measure_Pout_Eff = false; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Transmitter Parameters | RECEIVER PARAMS ALREADY SET IN SET_RXTX_STRUCTURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TX.AWG.IQOutput                = 1;   % AWG outputs both I and Q
TX.Outphasing.Flag           = false;
TX.AWG.SyncModuleFlag = 0;
TX.AWG.Position = 1;
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
% Overwrite the sampling rate of the receiver (max 450MHz for digitizer is recommanded)
if RX.FsampleOverwriteGUIFlag == 1
    RX.FsampleOverwrite = 0 * Signal.Fsample;
else
    RX.FsampleOverwrite = 1 * Signal.Fsample;
end
%RX.FsampleOverwrite = 0 * Signal.Fsample; % Overwrite the sampling rate of the receiver (max 450MHz for digitizer is recommanded)

RX.Analyzer.FrameTime = TX.FrameTime; % One measurement frame;
RX.Analyzer.PointsPerRecord = RX.Analyzer.Fsample * RX.Analyzer.FrameTime * RX.Analyzer.NumberOfMeasuredPeriods;

RX.TriggerChannel = 3;

% VSA Parameters
RX.VSA.DemodSignalFlag = true;
SetVSAParameters

% Set remaining RX parameters
SetRxParameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Calibration Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Activate calibration
Cal.AWG.Calflag = false;
Cal.TX.Calflag  = true;
Cal.TX.IQCal    = true;
Cal.RX.Calflag  = true;

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepare the signal for upload
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limits PAPR, and filters out of band noise
ProcessInputFiles
PrepareData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Send Signal and Measure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
IterationCount = 1;
memTrunc = 0;

UploadSignal
AWG_Upload_Script

% if (strcmp(RX.Type,'Scope'))
%     CaptureScope_64bit
% end
% 
% DownloadSignal
% 
% disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
% disp([' Input Signal']);
% CheckPower(In_ori,1);
% disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
% disp([' Output Signal']);
% CheckPower(Rec,1);
% disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
% Rec = SetMeanPower(Rec, 0);
% 
% if (RX.SubRate > 1)
%     FractionalDelayFlag = 1;
% else 
%     FractionalDelayFlag = 0;
% end
% 
% [In_D, Out_D, NMSE] = AlignAndAnalyzeSignals(In_ori, Rec, RX.Fsample, RX.alignFreqDomainFlag, RX.xCovLength, FractionalDelayFlag, RX.SubRate);
% 
% % Save EVM Results
% if (RX.VSA.DemodSignalFlag)
%     savevsarecording('Out_D_IFOut.mat', Out_D, Signal.Fsample, 0);
%     measEVM = CalculateDemodEVM(RX.VSA.ASMPath,RX.VSA.SetupFile, strcat(RX.VSA.DataFile, 'Out_D_IFOut.mat'));
%     display([ 'EVM         = ' num2str(measEVM.evm)      ' %']);
% end
% 
% display([ 'NMSE         = ' num2str(NMSE)      ' % or ' num2str(10*log10((NMSE/100)^2))      ' dB ']);
% 
% % [SAMeas, figHandle] = Save_Spectrum_Data();
% 
% SaveSignalGenerationMeasurements
