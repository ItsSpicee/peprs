function Set_RXTX_Structures (txd,rxd)

    %load tx and rx structures
    load('.\DPD Data\Signal Generation Parameters\RX.mat')
    load('.\DPD Data\Signal Generation Parameters\TX.mat')
    
    
    %TX 
    
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
    %RX
    
    