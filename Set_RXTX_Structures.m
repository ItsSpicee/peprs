function Set_RXTX_Structures (txd,rxd)

    %load tx and rx structures
    load('.\DPD Data\Signal Generation Parameters\RX.mat')
    load('.\DPD Data\Signal Generation Parameters\TX.mat')
    
    
    %SETTING TX 
    
    TX.Type      = 'AWG';        % Choose between 'AWG'
    TX.AWG.Model = 'M8190A';     % AWG Model 'M8190A', 'M8195A'
    
    TX.FGuard = txd.FGuard;
    TX.FCarrier = txd.FCarrier;
    TX.AWG.FsampleDAC = txd.FSampleDAC;
    TX.AWG.MinimumSegmentLength    = lcm(240,320); % Minimum segment length of the AWG frame

    if txd.SubtractMeanFlag == 1
        TX.SubtractMeanFlag = 1;
    else
        TX.SubtractMeanFlag = 0;
    end
    
    TX.AWG.NumberOfSegments = txd.NumberOfSegments;
    TX.AWG.IQOutput                = 1;   % AWG outputs both I and Q
    TX.AWG.DataFormat              = 'DNRZ';

    if txd.ExpansionMarginEnable == 1
       TX.AWG.ExpansionMarginSettings.ExpansionMarginEnable = 1;
    else
        TX.AWG.ExpansionMarginSettings.ExpansionMarginEnable = 0;
    end
    
    TX.AWG.ExpansionMarginSettings.ExpansionMargin = txd.ExpansionMargin;
    TX.AWG.Amp_Corr = txd.Amp_Corr;
    if txd.TX.GainExpansion_flag == 1
       TX.GainExpansion_flag = 1; 
    else
       TX.GainExpansion_flag = 0;  
    end
    
    TX.GainExpansion = txd.GainExpansion;
    
    if txd.FreqMutiplierFlag == 1
        TX.FreqMultiplier.Flag = 1;
    else
        TX.FreqMultiplier.Flag = 0;
    end
    
    TX.FreqMultiplier.Factor = txd.FreqMultiplierFactor;
    TX.FreqMultiplier.Factor     = txd.FreqMultiplierFactor;

    TX.Outphasing.Flag           = false;

    TX.AWG.SyncModuleFlag = 0;
    TX.AWG.Position = 1;
    
    %SETTING RX
    
    RX.Type    = rxd.Type;    % Choose between 'Digitizer', 'UXA', 'Scope' for the receiver

    RX.Fcarrier             = rxd.FCarrier;      % Center frequency of the received modulated signal
    if rxd.MirrorSignalFlag == 1 
        RX.MirrorSignalFlag     = true;       % If we are receiving the mirror signal then we have to take the conjugate of the spectrum
    else
        RX.MirrorSignalFlag     = false;       % If we are receiving the mirror signal then we have to take the conjugate of the spectrum
    end
    
    RX.VisaAddress             = 'USB0::0x0957::0x9001::MY48240314::0::INSTR';

    RX.Analyzer.Fsample                 = rxd.FSample;           % The sampling rate of the Digitzer when in non-downconversion mode
    if rxd.FrameTimeFlag == 1
        RX.Analyzer.FrameTime               = rxd.FrameTime;     % One measurement frame;
    else
        RX.Analyzer.FrameTime               = TX.FrameTime;     % One measurement frame;
    end
    RX.Analyzer.NumberOfMeasuredPeriods = rxd.MeasuredPeriods;                % Number of measured frames;
    RX.Analyzer.PointsPerRecord         = RX.Analyzer.Fsample * RX.Analyzer.FrameTime * RX.Analyzer.NumberOfMeasuredPeriods;

    RX.SubRate          = 1;           % Reduce sampling rate on the TOR. (1 = Normal Rate)
    RX.FsampleOverwrite = 0 * Signal.Fsample; % Overwrite the sampling rate of the receiver (max 450MHz for digitizer is recommanded)

    % If we are receiving at IF, then we downconvert digitally to process at
    % baseband. After downconversion, we need to filter the signal with a LPF
    RX.DownconversionFilterFile = 'FIR_LPF_fs20e9_fpass1r1e9_Order815';    

    RX.SubtractDCFlag = false;
    RX.TriggerChannel = 3;
    if (TX.AWG.Position == 1)
        RX.TriggerChannel = 3;
    else
        RX.TriggerChannel = 3;
    end
    % load('FIR_filter_fs_0r4GHz_fpass_0r06GHz_Order815');

    
    