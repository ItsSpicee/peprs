clc
clear
close all

path(pathdef); % Resets the paths to remove paths outside this folder
addpath(genpath('C:\Program Files (x86)\IVI Foundation\IVI\Components\MATLAB')) ;
addpath(genpath(pwd))%Automatically Adds all paths in directory and subfolders
instrreset
%#ok<*UNRCH>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Instrument control and signal analysis is done with with 32 bit MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cal.Processing32BitFlag = true;
Measure_Pout_Eff = false; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Transmitter Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TX.Type      = 'AWG';        % Choose between 'AWG'
TX.AWG.Model = 'M8190A';     % AWG Model 'M8190A', 'M8195A'

TX.FGuard = 300e3;        % Guard band for ACPR Calculations
TX.Fcarrier                = 1.35e9;      % AWG Fcarrier of the for the signal
TX.SubtractMeanFlag            = 0;

TX.AWG.FsampleDAC              = 12e9;
TX.AWG.MinimumSegmentLength    = lcm(240,320); % Minimum segment length of the AWG frame
TX.AWG.NumberOfSegments        = 1500; % Number of segments in the uploaded signal to the AWG
TX.AWG.IQOutput                = 1;   % AWG outputs both I and Q
TX.AWG.DataFormat              = 'DNRZ';

TX.AWG.ExpansionMarginSettings.ExpansionMarginEnable = 0; % If 0 we just backoff the AWG, if 1 we allow room for the PAPR of the signal to increase while maintaining the same Pavg
TX.AWG.ExpansionMarginSettings.ExpansionMargin = 0; %It is used to maintain the average power of AWG when the PAPR of the pre-distorted signal increases.

TX.AWG.Amp_Corr            = false;% amplitude correction for the AWG (set to true - recommended)

TX.GainExpansion_flag       = false;    % Expansion of the original input signal to take into account for the expansion of the DPD
TX.GainExpansion            = 2;        % Expansion of the original input in dB

TX.FreqMultiplier.Flag       = false;     % The TX contains a frequency multiplier
TX.FreqMultiplier.Factor     = 2;

TX.Outphasing.Flag           = false;

TX.AWG.SyncModuleFlag = 0;
TX.AWG.Position = 1;

% Set remaining TX parameters
SetTxParameters
EVM_flag                    = 0;    % If this flag is one, the code demodulates the received signal and 
                                    % computes the symbol ENM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SignalName = '5G_NR_OFDM_200MHz_64QAM_Pilots';
% Load in the signal
Signal.RemoveDCFlag = false;
ReadInputFiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Receiever Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RX.Type    = 'Scope';    % Choose between 'Digitizer', 'UXA', 'Scope' for the receiver

RX.Fcarrier             = 2.802e9;      % Center frequency of the received modulated signal
RX.MirrorSignalFlag     = false;       % If we are receiving the mirrored signal then we have to take the conjugate of the spectrum

RX.VisaAddress             = 'USB0::0x0957::0x9001::MY48240314::0::INSTR';

RX.Analyzer.Fsample                 = 20e9;           % The sampling rate of the Digitzer when in non-downconversion mode
RX.Analyzer.FrameTime               = TX.FrameTime;     % One measurement frame;
RX.Analyzer.NumberOfMeasuredPeriods = 2;                % Number of measured frames;
RX.Analyzer.PointsPerRecord         = RX.Analyzer.Fsample * RX.Analyzer.FrameTime * RX.Analyzer.NumberOfMeasuredPeriods;

RX.SubRate          = 1;           % Reduce sampling rate on the TOR. (1 = Normal Rate)
RX.FsampleOverwrite = 0 * Signal.Fsample; % Overwrite the sampling rate of the receiver (max 450MHz for digitizer is recommanded)

% If we are receiving at IF, then we downconvert digitally to process at
% baseband. After downconversion, we need to filter the signal with a LPF
switch SignalName
    case '5G_NR_OFDM_200MHz_64QAM_Pilots'
        RX.DownconversionFilterFile = 'FIR_LPF_fs20e9_fpass0r5e9_Order815';    
    otherwise
        RX.DownconversionFilterFile = 'FIR_LPF_fs20e9_fpass1r1e9_Order815';
end  

RX.SubtractDCFlag = false;
RX.TriggerChannel = 3;
if (TX.AWG.Position == 1)
    RX.TriggerChannel = 3;
else
    RX.TriggerChannel = 3;
end
% load('FIR_filter_fs_0r4GHz_fpass_0r06GHz_Order815');

% VSA Parameters
RX.VSA.DemodSignalFlag = true;
SetVSAParameters

% Set remaining RX parameters
SetRxParameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set DPD Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DPD.Type             = 'SquareRootBasis'; 
DPD.NofIteration     = 10;           % Maximum # of DPD Iterations
DPD.NofDPDPoints     = 30e3;       % # of points used in DPD identification

% Truncation of the signal due to the DPD 
memTrunc = 0;

% View model of DPD after every iteration
DPD.CheckModelFlag = 0;

% Cascade DPD
DPD.CascadeDPDFlag = 0;

% Set remaining DPD parameters
SetDPDParameters
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
    Cal.TX.CalFile = '.\IQ_Imbalance_CalResults\IQ_Imbalance_fRF6r25GHz_3GHzFreq_Domain.mat';
else
    Cal.TX.CalFile = '.\IQ_Imbalance_CalResults\IQ_Imbalance_fRF12r5GHz_fIF1r75_BW3r2GHz_BottomSyncWithBiasTee_v4Freq_Domain.mat';
end

% RX Calibration file
Cal.RX.CalFile = '.\RX_CalResults\RX_CalResults_fc12r5GHz_fLORX_15r302GHz_fIF_2r802GHz_BW3GHz.mat';
Cal.RX.MirrorFrequencyFlag = 1;

% Load in the calibration files
CalibrationParameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepare the signal for upload
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Limits PAPR, and filters out of band noise
ProcessInputFiles
PrepareData

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DPD Model Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DPDModelParamInit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DPD Iteration loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
IterationCount = 1;
if (DPD.CascadeDPDFlag)
    In_ori = finalPr;
end

NMSE_vec = zeros(DPD.NofIteration,2);
for IterationCount = 1:(DPD.NofIteration+1)
    close all
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp([' Iteration nb ',num2str(IterationCount), ' out of ',  num2str(DPD.NofIteration)]);
    disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    
    UploadSignal
    
    if Cal.Processing32BitFlag
        AWG_Upload_Script
        
        if (strcmp(RX.Type,'Scope'))
            CaptureScope_64bit
        end
%         Continue_Flag = Confirmation_Dialogue('Did you capture the signal?','Capture and Continue!');
        Continue_Flag = 1;
    else
        Continue_Flag = Confirmation_Dialogue('Did you capture the signal?','Capture and Continue!');
    end
    
    switch DPD.Type
        case {'SquareRootBasis', 'DirectLearning_MagAPD'}
            if IterationCount == DL_APD_modelParam.g2.ActivateIter
%                 Continue_Flag = Confirmation_Dialogue('Did you capture the PD1 signal?','Capture and Continue!');
            end
    end
    if (Continue_Flag == 1)
        DownloadSignal
        
        % Save Spectrum and VSA Data
        SAMeasResults(IterationCount) = Save_Spectrum_Data();
        
        % Despur the Output Signal
        despurFlag = 0;
        DespurOutputSignal
        
        AlignAnalyzeData
        
        % Save EVM Results
        if (RX.VSA.DemodSignalFlag)
            savevsarecording('Out_D_IFOut.mat', Out_D, Signal.Fsample, 0);
            measEVM = CalculateDemodEVM(RX.VSA.ASMPath,RX.VSA.SetupFile, strcat(RX.VSA.DataFile, 'Out_D_IFOut.mat'));
            display([ 'EVM         = ' num2str(measEVM.evm)      ' %']);
            EVMMeasResults(IterationCount) = measEVM.evm;
        end
        
        if (IterationCount <= DPD.NofIteration)
            coeff_save = DL_APD_modelParam;
            %DL_APD_modelParam = coeff_save;
            %Copying_Coeff 
            IdentifyDPD   
            if RX.SubRate > 1  && Cal.RX.Calflag == 1
                CheckPower(In_ori, 1)
                In_ori_EVM_rx_calibrated = ApplyLUTCalibration(In_ori_EVM, Signal.Fsample, Cal.RX.ToneFreq', Cal.RX.RealCorr, Cal.RX.ImagCorr);
                CheckPower(In_ori_EVM_rx_calibrated , 1)
            else 
                In_ori_EVM_rx_calibrated  = In_ori_EVM;
            end    

            ApplyDPD
            %backupPr = In_ori;
            %In_ori = Pr;
        end
    else
        break;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Final "With DPD" Measurements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' Final DPD measurement with DPD');
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
% In_Ori = Pr;
% UploadSignal
% In_ori = backupIn_ori;
% if Cal.Processing32BitFlag
%     AWG_Upload_32bit
%     if (strcmp(RX.Type,'Scope'))
%         CaptureScope_32bit
%     end
% else
%     Continue_Flag = Confirmation_Dialogue('Did you capture the signal?','Capture and Continue!');
% end
% % Reset the subrate for the final capture;
% if (RX.SubRate > 1)
%     SubRate_O = RX.SubRate;
%     RX.SubRate = 1;
% end
% DownloadSignal
% % Rec = filter(Num, 1, Rec);
% AlignAnalyzeData

ACLR_L_withDPD = ACLR_L;
ACLR_U_withDPD = ACLR_U;
ACPR_L_withDPD = ACPR_L;
ACPR_U_withDPD = ACPR_U;
EVM_perc_withDPD = EVM_perc;
[meanPower, maxPower, PAPRin_withDPD]  = CheckPower(In_ori,0);
[meanPower, maxPower, PAPRout_withDPD] = CheckPower(Rec,0);

disp(  ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([ ' Input PAPR with DPD     = ' num2str(PAPRin_withDPD)  ' dB ' ]);
disp([ ' Output PAPR with DPD    = ' num2str(PAPRout_withDPD) ' dB ' ]);
if Measure_Pout_Eff
    Pout_measured_with_DPD = Pout;
    DE_measured_with_DPD   = DE;
    V_m_with_DPD = V_m;
    I_m_with_DPD = I_m;
    disp([ ' Measured Pout with DPD  = ' num2str(Pout_measured_with_DPD) ' dBm ' ]);
    disp([ ' Measured DE with DPD    = ' num2str(DE_measured_with_DPD) ' % ' ]);
end
disp(  ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saving Measurement Results - With DPD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SaveWithDPDMeasurements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear In_Q_withDPD In_I_withDPD Out_I_withDPD Out_Q_withDPD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Final "Without DPD" Measurements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' Without DPD measurement');
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
% In_ori = In_ori_EVM_rx_calibrated;
if (~DPD.CascadeDPDFlag)
finalPr = In_ori;
finalMemTrunc = memTrunc;
finalCoeff = DL_APD_modelParam;
else
finalPr2 = In_ori;
finalMemTrunc2 = memTrunc;
finalCoeff2 = DL_APD_modelParam;
end
memTrunc = 0;
In_ori = resample(In_ori_EVM,Signal.DownsampleRX,Signal.UpsampleRX);
TX.AWG.ExpansionMarginSettings.ExpansionMargin = TX.AWG.ExpansionMarginSettings.ExpansionMargin +...
    (-SAMeasResults(end).ChannelPower + SAMeasResults(1).ChannelPower)/2;
UploadSignal
if Cal.Processing32BitFlag
    if (~TX.AWG.SyncModuleFlag)
        AWG_Upload_Script
    end
    if (strcmp(RX.Type,'Scope'))
%         CaptureScope_32bit
        CaptureScope_64bit
    end
    SAMeasResults(end+1) = Save_Spectrum_Data();
else
    Continue_Flag = Confirmation_Dialogue('Did you capture the signal?','Capture and Continue!');
end
DownloadSignal
% Rec = filter(Num, 1, Rec);
AlignAnalyzeData

% Save EVM Results
if (RX.VSA.DemodSignalFlag)
    savevsarecording('Out_D_IFOut.mat', Out_D, Signal.Fsample, 0);
    measEVM = CalculateDemodEVM(RX.VSA.ASMPath,RX.VSA.SetupFile, strcat(RX.VSA.DataFile, 'Out_D_IFOut.mat'));
    display([ 'EVM         = ' num2str(measEVM.evm)      ' %']);
    EVMMeasResults(end+1) = measEVM.evm;
end
        
PlotAMAM(In_D_EVM,Out_D_EVM);
switch DPD.Type
    case 'SquareRootBasis'
        [~, ~, PAPRsqin] = CheckPower(In_D_EVM,0);
        [a, b] = AdjustPhase(In_D_EVM.^2,Out_D_EVM);
        [~, ~, PAPRsqout] = CheckPower(a,0);
        a = SetMeanPower(a,PAPRsqin-PAPRsqout);
        [a, b] = AdjustPhase(a, b);
        [a, b] = AdjustPhase(a, b);
        PlotGain(a, b*10^((PAPRsqin-PAPRsqout+2)/20));
        xlim([-20,11])
        ylim([-3.5,3.5])
        PlotAMPM(a, b);
        xlim([-20,11])
        ylim([-40,20])
end
ACLR_L_withoutDPD = ACLR_L;
ACLR_U_withoutDPD = ACLR_U;
ACPR_L_withoutDPD = ACPR_L;
ACPR_U_withoutDPD = ACPR_U;
EVM_perc_withoutDPD = EVM_perc;
[meanPower, maxPower, PAPRin_withoutDPD] = CheckPower(In_ori,0);
[meanPower, maxPower, PAPRout_withoutDPD] = CheckPower(Rec,0);

disp(  ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([ 'Input PAPR without DPD   = ' num2str(PAPRin_withoutDPD) ' dB ' ]);
disp([ 'Output PAPR without DPD  = ' num2str(PAPRout_withoutDPD) ' dB ' ]);
if Measure_Pout_Eff
    Pout_measured_without_DPD = Pout;
    DE_measured_without_DPD   = DE;
    V_m_without_DPD = V_m;
    I_m_without_DPD = I_m;
    disp([ ' Measured Pout with DPD  = ' num2str(Pout_measured_without_DPD) ' dBm ' ]);
    disp([ ' Measured DE with DPD    = ' num2str(DE_measured_without_DPD) ' % ' ]);
end
disp(  ' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saving Measurement Results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
spectrumFig = gcf;
plot(SAMeasResults(end).SAFreq/1e9,SAMeasResults(end).SAPSD);
hold all;
grid on;
plot(SAMeasResults(DL_APD_modelParam.g2.ActivateIter).SAFreq/1e9,SAMeasResults(DL_APD_modelParam.g2.ActivateIter).SAPSD);
plot(SAMeasResults(end-1).SAFreq/1e9,SAMeasResults(end-1).SAPSD);
xlabel('Frequency (GHz)');
ylabel('PSD (dBm/Hz)');
legend('Without DPD', 'After PD1', 'After PD2');

SaveWithoutDPDMeasurements

NMSE_vec

EVMMeasResults

[[SAMeasResults.ACPRLower].', [SAMeasResults.ACPRUpper].']

AWG_M8190A_Output_OFF(1);
AWG_M8190A_Output_OFF(2);