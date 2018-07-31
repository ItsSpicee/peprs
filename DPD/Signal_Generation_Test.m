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

% if (TX.AWG.Position == 2)
%     copyfile('arbConfig_Top.mat', 'arbConfig.mat')
% else
%     copyfile('arbConfig_Bottom.mat', 'arbConfig.mat')
% end
% Set remaining TX parameters
SetTxParameters
EVM_flag                    = 0;    % If this flag is one, the code demodulates the received signal and 
                                    % computes the symbol ENM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SignalName = Signal.Name;
% Load in the signal
ReadInputFiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Receiever Parameters | RECEIVER PARAMS ALREADY SET IN SET_RXTX_STRUCTURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('FIR_filter_fs_0r4GHz_fpass_0r06GHz_Order815');

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
Cal.AWG.CalFile_I = '.\AWG_CalResults\AWG_Cal_3105MHz_I.mat';
Cal.AWG.CalFile_Q = '.\AWG_CalResults\AWG_Cal_3105MHz_Q.mat';
% If AWG calibration was done at baseband, offset calibration
Cal.AWG.fOffset = TX.Fcarrier; 

% TX Calibration file
if TX.AWG.Position == 1
%     Cal.TX.CalFile = '.\Upconverter_CalResults\IQ_Imbalance_fRF6r25GHz_3GHzFreq_Domain.mat';
    Cal.TX.CalFile = '.\IQ_Imbalance_CalResults\IQ_Imbalance_fRF6r25GHz_3GHzFreq_Domain.mat';
else
    Cal.TX.CalFile = '.\IQ_Imbalance_CalResults\IQ_Imbalance_fRF12r5GHz_fIF1r75_BW3r2GHz_BottomSyncWithBiasTee_v4Freq_Domain.mat';
end

% RX Calibration file
Cal.RX.CalFile = '.\RX_CalResults\RX_CalResults_fc6r25GHz_BW3GHz.mat';

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

if (strcmp(RX.Type,'Scope'))
    CaptureScope_64bit
end

DownloadSignal

disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Input Signal']);
CheckPower(In_ori,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Output Signal']);
CheckPower(Rec,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
Rec = SetMeanPower(Rec, 0);

alignFreqDomainFlag = 1;
xCovLength = 5000;
if (RX.SubRate > 1)
    FractionalDelayFlag = 1;
else 
    FractionalDelayFlag = 0;
end

[In_D, Out_D, NMSE] = AlignAndAnalyzeSignals(In_ori, Rec, RX.Fsample, alignFreqDomainFlag, xCovLength, FractionalDelayFlag, RX.SubRate);

% Save EVM Results
if (RX.VSA.DemodSignalFlag)
    savevsarecording('Out_D_IFOut.mat', Out_D, Signal.Fsample, 0);
    measEVM = CalculateDemodEVM(RX.VSA.ASMPath,RX.VSA.SetupFile, strcat(RX.VSA.DataFile, 'Out_D_IFOut.mat'));
    display([ 'EVM         = ' num2str(measEVM.evm)      ' %']);
end

display([ 'NMSE         = ' num2str(NMSE)      ' % or ' num2str(10*log10((NMSE/100)^2))      ' dB ']);

% [SAMeas, figHandle] = Save_Spectrum_Data();

SaveSignalGenerationMeasurements
