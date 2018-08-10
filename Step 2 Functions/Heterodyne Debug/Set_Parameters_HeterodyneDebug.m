function error = Set_Parameters_HeterodyneDebug()
clc
clear
close all

path(pathdef); % Resets the paths to remove paths outside this folder
addpath(genpath('C:\Program Files (x86)\IVI Foundation\IVI\Components\MATLAB')) ;
addpath(genpath(pwd))%Automatically Adds all paths in directory and subfolders
instrreset

error = '';
try 
    load('./Measurement Data/Heterodyne Calibration Parameters/Cal.mat')
    load('./Measurement Data/Heterodyne Calibration Parameters/TX.mat')
    load('./Measurement Data/Heterodyne Calibration Parameters/RX.mat')

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

    % TX Trigger Frame Time Calculation
    MinimumNumberOfSegments        = (1 / Cal.Signal.ToneSpacing) * TX.Fsample / TX.MinimumSegmentLength;
    [num den]                      = rat(MinimumNumberOfSegments);
    TX.MinimumNumberOfPeriods      = 1 / MinimumNumberOfSegments * num;
    TX.FrameTime                   = TX.NumberOfTransmittedPeriods / Cal.Signal.ToneSpacing * TX.MinimumNumberOfPeriods; 

    clear num den

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Set RX Parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    RX.FrameTime               = TX.FrameTime;     % One measurement frame;
    RX.Analyzer.PointsPerRecord= RX.Analyzer.Fsample * RX.FrameTime * RX.NumberOfMeasuredPeriods;

    % Scope Parameters
    autoscaleFlag = 1;

    % UXA Parameters
    RX.UXA.SpurFrequency = 250e6; % Spur from the UXA do not put a tone here

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
    load(RX.DownFile)
    RX.Filter = Num;
    clear Num

    % Load the RX calibration file
    Cal.RX.Calflag = 0; % added
    if (Cal.RX.Calflag)
        load(Cal.RX.CalFile);
        RX.Cal.ToneFreq = tones_freq;
        RX.Cal.RealCorr = comb_I_cal;
        RX.Cal.ImagCorr = comb_Q_cal;
    end
    
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
catch
    error = 'A problem occurred while attempting to set parameters.';
end
end