function Set_RXTX_Structures (txd,rxd)

    %load tx and rx structures
    load('.\DPD Data\Signal Generation Parameters\RX.mat')
    load('.\DPD Data\Signal Generation Parameters\TX.mat')
    
    TX.FGuard = txd.FGuard;
    TX.FCarrier = txd.FCarrier
    TX.FSampleDAC = txd.FSampleDAC;
    TX.SubtractMeanFlag = txd.SubtractMeanFlag;
    TX.NumberOfSegments = txd.NumberOfSegments;
    
    TX.ExpansionMarginEnable = txd.ExpansionMarginEnable;
    TX.ExpansionMargin = txd.ExpansionMargin;
    TX.Amp_Corr = txd.Amp_Corr;
    TX.GainExpansion_flag = txd.GainExpansion_flag;
    TX.GainExpansion = txd.GainExpansion;
    
    TX.FreqMutiplierFlag = txd.FreqMutiplierFlag;
    TX.FreqMultiplierFactor = txd.FreqMultiplierFactor;