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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Set Calibration Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency domain iterations
Cal.NumberOfIterations               = 2;

Cal.Signal.UniformSpacing            = 1;
Cal.Signal.ToneSpacing               = 5e6;     
Cal.Signal.StartingToneFreq_s1        = -0.4840e9;
Cal.Signal.EndingToneFreq_s1          = 0.4840e9;
Cal.Signal.StartingToneFreq_s2        = -0.4850e9;
Cal.Signal.EndingToneFreq_s2          = 0.4850e9;
Signal.BW                        = 2 * max(Cal.Signal.EndingToneFreq_s1, Cal.Signal.EndingToneFreq_s2);

Cal.s1.ToneFreq = (Cal.Signal.StartingToneFreq_s1:Cal.Signal.ToneSpacing:Cal.Signal.EndingToneFreq_s1).';
Cal.s2.ToneFreq = (Cal.Signal.StartingToneFreq_s2:Cal.Signal.ToneSpacing:Cal.Signal.EndingToneFreq_s2).';

Cal.Signal.PAPRmin = 0;
Cal.Signal.PAPRmax = 10;

Cal.AmpMismatch_s1 = 0;
Cal.AmpMismatch_s2 = 0;

% Calibration file complex baseband frequency
Cal.Directory = 'Outphasing_CalResults';
Cal.Filename  = ['Outphasing_Calibration_fc_12r5GHz_BW0r97GHz_SEQOnly'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Transmitter Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TX.Type      = 'AWG';        % Choose between 'AWG'
TX.AWG.Model = 'M8190A';     % AWG Model 'M8190A', 'M8195A'

TX.IQmod_flag = 1;        % AWG generates a baseband signal centered around DC

TX.I_Offset = 0; TX.Q_Offset = 0;

TX.Fcarrier = 0e9; % RF center frequency of the PA stimulus

TX.Fcarrier                = 1.75e9;      % AWG Fcarrier of the for the signal
TX.AWG.BitResolution       = 12;
TX.AWG.FsampleDAC          = 12e9;
%  TX.AWG.MinimumSegmentLength    = 960;
 
if TX.AWG.BitResolution == 14
    TX.AWG.MinimumSegmentLength       = 240;              % Minimum AWG segment length
elseif TX.AWG.BitResolution  == 12
    TX.AWG.MinimumSegmentLength       = 320;
end

TX.AWG.NumberOfSegments        = 300; % Number of segments in the uploaded signal to the AWG

TX.AWG.Expansion_Margin    = 0;  % Used for high speed AWG only. It is used to maintain the average power of AWG when the PAPR of the pre-distorted signal increases.
TX.AWG.Amp_Corr            = false;% amplitude correction for the AWG (set to true - recommended)

TX.GainExpansion_flag       = false;    % Expansion of the original input signal to take into account for the expansion of the DPD
TX.GainExpansion            = 2;        % Expansion of the original input in dB

TX.FreqMultiplier.Flag       = false;     % The TX contains a frequency multiplier
TX.FreqMultiplier.Factor     = 2;

% TX.Outphasing.Flag           = true;
% TX.OutphasingFilter          = load('FIR_LPF_fs2e9_fpass_0r8e9_Order815.mat');
% TX.OutphasingFilter          = TX.OutphasingFilter.Num;
TX.ChannelPosition           = 2;

TX.AWG.MultiChannelFlag = 1;
TX.AWG.SyncModuleFlag        = 0;

% Set remaining TX parameters
SetTxParameters
EVM_flag                    = 0;    % If this flag is one, the code demodulates the received signal and 
                                    % computes the symbol ENM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Signal Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Signal.Fsample = 12e9;
TrainingLength = Signal.Fsample / 500e3;

[TX.AWG.Upsample, TX.AWG.Downsample]     = rat(TX.AWG.FsampleDAC / Signal.Fsample);
TX.FrameTime                   = TX.AWG.NumberOfSegments * TX.AWG.MinimumSegmentLength / (Signal.Fsample * TX.AWG.Upsample / TX.AWG.Downsample);

isRealFlag = 0;
[ s1_ori ] = GenerateMultiToneSignal_minPAPR( Cal.Signal.StartingToneFreq_s1, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq_s1, ...
      Cal.Signal.PAPRmin, Cal.Signal.PAPRmax, TX.FrameTime, Signal.Fsample, isRealFlag);
[ s2_ori ] = GenerateMultiToneSignal_minPAPR( Cal.Signal.StartingToneFreq_s2, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq_s2, ...
    Cal.Signal.PAPRmin, Cal.Signal.PAPRmax, TX.FrameTime, Signal.Fsample, isRealFlag);
s1_ori = SetMeanPower(s1_ori,0);
s2_ori = SetMeanPower(s2_ori,0);

In_ori = SetMeanPower(s1_ori+s2_ori,0);
CheckPower(In_ori,1);
In_ori_EVM = In_ori;

disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Original Multitone Signal']);
[~, ~, PAPR_originals1] = CheckPower(s1_ori,1);
[~, ~, PAPR_originals2] = CheckPower(s2_ori,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

PlotDFT(s1_ori,s2_ori,Signal.Fsample);    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Receiever Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RX.Type    = 'UXA';    % Choose between 'Digitizer', 'UXA', 'Scope' for the receiver

% RX.Fcarrier             = 1.826e9;      % Center frequency of the received modulated signal
RX.Fcarrier             = 12.5e9;      % Center frequency of the received modulated signal
RX.LOLowerInjectionFlag = false;       % If we are receiving the image band then we have to take the conjugate of the spectrum

RX.VisaAddress             = 'USB0::0x2A8D::0x190B::US57010129::0::INSTR';

RX.Analyzer.Fsample                 = 1.25e9;           % The sampling rate of the Digitzer when in non-downconversion mode
RX.Analyzer.FrameTime               = TX.FrameTime;     % One measurement frame;
RX.Analyzer.NumberOfMeasuredPeriods = 2;                % Number of measured frames;
RX.Analyzer.PointsPerRecord         = RX.Analyzer.Fsample * RX.Analyzer.FrameTime * RX.Analyzer.NumberOfMeasuredPeriods;

RX.SubRate          = 1;           % Reduce sampling rate on the TOR. (1 = Normal Rate)
RX.FsampleOverwrite = 0 * Signal.Fsample; % Overwrite the sampling rate of the receiver (max 450MHz for digitizer is recommanded)

% If we are receiving at IF, then we downconvert digitally to process at
% baseband. After downconversion, we need to filter the signal with a LPF
RX.DownconversionFilterFile = 'FIR_LPF_fs20e9_fpass0r8e9_Order815';    

RX.SubtractDCFlag = false;
RX.TriggerChannel = 4;

% load('FIR_filter_fs_0r4GHz_fpass_0r06GHz_Order815');

% Set remaining RX parameters
SetRxParameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set DPD Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DPD.Type = '';
DPD.ApplyFlag = false;

if (DPD.ApplyFlag)
    % Load DPD parameters
    DPD.s1PD = load('.\DPD_Results\s1_DPD_1r2GHz_OutputPowerNeg6r2dBm_v2.mat', 'finalCoeff');
    DPD.s1PD = DPD.s1PD.finalCoeff;
    DPD.s2PD = load('.\DPD_Results\s2_DPD_1r2GHz_OutputPowerNeg6r2dBm_v2.mat','finalCoeff');
    DPD.s2PD = DPD.s2PD.finalCoeff;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Calibration Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Activate calibration
Cal.AWG.Calflag = false;
Cal.TX.Calflag  = true;
Cal.RX.Calflag  = false;

% AWG Calibration file
Cal.AWG.CalFile_I = '';
Cal.AWG.CalFile_Q = '';

% s1 TX Calibration file
Cal.TX.CalFile = '.\IQ_Imbalance_CalResults\IQ_Imbalance_fRF12r5GHz_fIF1r75_BW1r0GHz_TopSequencingOnlyFreq_Domain.mat';
load(Cal.TX.CalFile);
Cal.TX.Type = 'Freq_Domain';  %'Freq_Domain' or 'Time_Domain'

if (strcmp(Cal.TX.Type,'Freq_Domain'))
    % Chooses which iteration of the IQ imbalance calibration file to use
    IQImbalIter = 3; 
    CalResults  = TX_CAL_RESULTS;
    Cal.TX.s1.ToneFreq = CalResults(IQImbalIter).tones;
    Cal.TX.s1.G11 = CalResults(IQImbalIter).G.G11;
    Cal.TX.s1.G12 = CalResults(IQImbalIter).G.G12;
    Cal.TX.s1.G21 = CalResults(IQImbalIter).G.G21; 
    Cal.TX.s1.G22 = CalResults(IQImbalIter).G.G22;
else
    Cal.TX.s1 = CalResults.TX_CAL_Results;
end

Cal.TX.CalFile = '.\IQ_Imbalance_CalResults\IQ_Imbalance_fRF12r5GHz_fIF1r75_BW1r0GHz_BottomSequencingOnlyFreq_Domain.mat';
load(Cal.TX.CalFile);
Cal.TX.Type = 'Freq_Domain';  %'Freq_Domain' or 'Time_Domain'

if (strcmp(Cal.TX.Type,'Freq_Domain'))
    % Chooses which iteration of the IQ imbalance calibration file to use
    IQImbalIter = 3; 
    CalResults  = TX_CAL_RESULTS;
    Cal.TX.s2.ToneFreq = CalResults(IQImbalIter).tones;
    Cal.TX.s2.G11 = CalResults(IQImbalIter).G.G11;
    Cal.TX.s2.G12 = CalResults(IQImbalIter).G.G12;
    Cal.TX.s2.G21 = CalResults(IQImbalIter).G.G21; 
    Cal.TX.s2.G22 = CalResults(IQImbalIter).G.G22;
else
    Cal.TX.s2 = CalResults.TX_CAL_Results;
end

clear TX_CAL_RESULTS CalResults


% RX Calibration file
% Cal.RX.CalFile = '.\RX_CalResults\RX_CalResults_OTA_DPD_EM0_PAbypassed';
Cal.RX.CalFile = '.\RX_CalResults\RX_CalResults_fc25rGHz_fLORX_27r626GHz_fIF_2r626GHz_BW4GHz.mat';
% Cal.RX.CalFile = '.\RX_CalResults\RX_CalResults_fc12r5GHz_fLORX_14r326GHz_fIF_1r826GHz_BW3r6GHz.mat';

% Load the RX calibration file
if (Cal.RX.Calflag)
    load (Cal.RX.CalFile);
    Cal.RX.ToneFreq = tones_freq;
    Cal.RX.RealCorr = comb_I_cal;
    Cal.RX.ImagCorr = comb_Q_cal;
     
    clear tones_freq comb_I_cal comb_Q_cal
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calibrate the outphasing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ignore these tones during calibration
offset = 0;

if ~TX.AWG.SyncModuleFlag
    copyfile('arbConfig_Top.mat', 'arbConfig.mat')
    AWG_M8190A_Reference_Clk(TX.AWG.ReferenceClockSource,TX.AWG.ReferenceClock);
    copyfile('arbConfig_Bottom.mat', 'arbConfig.mat')
    AWG_M8190A_Sample_Clk('External',TX.AWG.FsampleDAC);
end

for i = 1:(Cal.NumberOfIterations+2)
    close all
    if (i < 3)
        s1_cal = s1_ori;
        s2_cal = s2_ori;
    else
        s1_cal = ApplyLUTCalibration(s1_ori, Signal.Fsample, Cal.s1.ToneFreq(1+offset:end-offset), real(Cal.Gs1), imag(Cal.Gs1));
        s2_cal = ApplyLUTCalibration(s2_ori, Signal.Fsample, Cal.s2.ToneFreq(1+offset:end-offset), real(Cal.Gs2), imag(Cal.Gs2));
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        disp('Calibrated  Outphasing Signals');
        [~, ~, PAPR_originals1] = CheckPower(s1_cal, 1);
        [~, ~, PAPR_originals2] = CheckPower(s2_cal, 1);
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    end
%     s1_cal(1:100) = 0;
%     s2_cal = -s1_cal;
    if (~TX.AWG.SyncModuleFlag)
        [s2_cal] = ApplyDelay(s2_cal, Signal.Fsample, 869.5e-9);
    end
    % Apply the DPD
    if DPD.ApplyFlag
        [ s1_cal, memTrunc ] = ApplyDoublerDPD(s1_cal, DPD.s1PD);
        [ s2_cal, memTrunc ] = ApplyDoublerDPD(s2_cal, DPD.s2PD);
    else
        memTrunc = 0;
    end
    % Apply the IQ imbalance compensation
    [ s1_cal ] = ApplyImbalanceCalibration( s1_cal, Signal.Fsample, Cal.TX.s1 );
    [ s2_cal ] = ApplyImbalanceCalibration( s2_cal, Signal.Fsample, Cal.TX.s2 );

    % Start clocks
    Iteration_Count = 1;
    Expansion_Margin1 = Cal.AmpMismatch_s1;
    Expansion_Margin2 = Cal.AmpMismatch_s2;
%     Expansion_Margin2 = 1.85;
    if TX.AWG.SyncModuleFlag
        % Enable the configuration mode in the M8192A to set the sampling
        % rates and waveforms -- This will stop the trigger sent to the
        % AWGs
        copyfile('arbConfig_Sync.mat', 'arbConfig.mat');
        AWG_M8192A_ConfigureMultiChannel();
        copyfile('arbConfig_Top.mat', 'arbConfig.mat')
        AWG_M8190A_Reference_Clk(TX.AWG.ReferenceClockSource,TX.AWG.ReferenceClock);
        copyfile('arbConfig_Bottom.mat', 'arbConfig.mat')
        AWG_M8190A_Reference_Clk(TX.AWG.ReferenceClockSource,TX.AWG.ReferenceClock);
    end
    % Upload signals and start the output after all waveforms and sequences are uploaded
    UploadOutphasingSignals( s1_cal, s2_cal, Signal.Fsample, TX, RX, Expansion_Margin1, Expansion_Margin2, PAPR_originals1, PAPR_originals2);
    if i > 1
      autoscaleFlag = 0;
    end
    save('Scope_in.mat', 'RX', 'autoscaleFlag');
    %% Capture and Analyze
    if strcmp(RX.Type, 'Scope')
        CaptureScope_32bit;
    end
    DownloadSignal
    AlignAnalyzeData
%     pt(In_D,Out_D,1000)
    %% Extract out the filters
    meanPower_s1 = CheckPower(GetDesiredTones(Out_D_EVM(1:TrainingLength), Cal.s1.ToneFreq(1+offset:end-offset), Signal.Fsample),0);
    meanPower_s2 = CheckPower(GetDesiredTones(Out_D_EVM(1:TrainingLength), Cal.s2.ToneFreq(1+offset:end-offset), Signal.Fsample),0);
        
    %% TODO: Ensure that we don't go below 0
    if (meanPower_s1 > meanPower_s2)
        if Cal.AmpMismatch_s2 == 0
            Cal.AmpMismatch_s1 = Cal.AmpMismatch_s1 + meanPower_s1-meanPower_s2;
        else
            Cal.AmpMismatch_s2 = Cal.AmpMismatch_s2 + meanPower_s2-meanPower_s1;
        end
    else
        if Cal.AmpMismatch_s1 == 0
            Cal.AmpMismatch_s2 = Cal.AmpMismatch_s2 + meanPower_s2-meanPower_s1;
        else
            Cal.AmpMismatch_s1 = Cal.AmpMismatch_s1 + meanPower_s1-meanPower_s2;
        end
    end
    
    if ((i < (Cal.NumberOfIterations+2)) && i > 1)
    %% Cascade the filters
        offset = 0;
        if (i > 2)
%             [ Cal.Gs1 ] = Cal.Gs1 .* CalculateInverseResponseModel( In_D_EVM(1:TrainingLength), Out_D_EVM(1:TrainingLength), Cal.s1.ToneFreq, Signal.Fsample);
%             [ Cal.Gs2 ] = Cal.Gs2 .* CalculateInverseResponseModel( In_D_EVM(1:TrainingLength), Out_D_EVM(1:TrainingLength), Cal.s2.ToneFreq, Signal.Fsample);
            learningParam = (1e-2);
            Cal.Gs1 = UpdateOutphasingFilter(Cal.Gs1, learningParam, In_D_EVM(1:TrainingLength), Out_D_EVM(1:TrainingLength), Cal.s1.ToneFreq(1+offset:end-offset), Signal.Fsample);
            Cal.Gs2 = UpdateOutphasingFilter(Cal.Gs2, learningParam, In_D_EVM(1:TrainingLength), Out_D_EVM(1:TrainingLength), Cal.s2.ToneFreq(1+offset:end-offset), Signal.Fsample);
        else
            [ Cal.Gs1 ] = CalculateInverseResponseModel( In_D_EVM(1:TrainingLength), Out_D_EVM(1:TrainingLength), Cal.s1.ToneFreq(1+offset:end-offset), Signal.Fsample);
            [ Cal.Gs2 ] = CalculateInverseResponseModel( In_D_EVM(1:TrainingLength), Out_D_EVM(1:TrainingLength), Cal.s2.ToneFreq(1+offset:end-offset), Signal.Fsample);
        end
    end
end
%% Turn off the AWGs
copyfile('arbConfig_Bottom.mat', 'arbConfig.mat')
AWG_M8190A_Output_OFF(1);
AWG_M8190A_Output_OFF(2);
copyfile('arbConfig_Top.mat', 'arbConfig.mat')
AWG_M8190A_Output_OFF(1);
AWG_M8190A_Output_OFF(2)


%% Save the outphasing filters
figure
subplot(2,1,1);
plot(Cal.s1.ToneFreq(1+offset:end-offset) ./ 1e9, 20*log10(abs(Cal.Gs1)), 'b'); hold all; plot(Cal.s2.ToneFreq(1+offset:end-offset) ./ 1e9, 20*log10(abs(Cal.Gs2)), 'r');
ylabel('Magnitude (dB)'); grid on; legend('Gs1', 'Gs2');
subplot(2,1,2);
plot(Cal.s1.ToneFreq(1+offset:end-offset) ./ 1e9,  180 / pi * unwrap(angle(Cal.Gs1)), 'b'); hold all; plot(Cal.s2.ToneFreq(1+offset:end-offset) ./ 1e9, 180 / pi * unwrap(angle(Cal.Gs2)), 'r');
ylabel('Phase Change (deg)');  grid on; legend('Gs1', 'Gs2');

if (~exist(Cal.Directory,'dir'))
    mkdir(Cal.Directory);
    addpath(genpath(Cal.Directory));
end
save([Cal.Directory '\' Cal.Filename], 'Cal');