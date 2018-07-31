function SetRxParameters_GUI(dict)
    dict.AnalysisBandwidth = str2double(dict.AnalysisBandwidth);
    dict.Attenuation = str2double(dict.Attenuation);
    dict.TriggerLevel = str2double(dict.TriggerLevel);
    dict.VFS = str2double(dict.VFS);
    channelMap = [0 0; 0 0];
    load('.\DPD Data\Algorithm Parameters\RX.mat')
    
    % Digitizer Parameters
    if dict.EnableExternalClock_Dig == 1
        RX.EnableExternalClock = true;
    else
        RX.EnableExternalClock = false;
    end
    if dict.ExternalClockFrequency == 1   
        RX.ExternalClockFrequency = 1.998; % half rate
    else
        RX.ExternalClockFrequency = 1.906; % quarter rate
    end
    if dict.ACDCCoupling == 1
        RX.ACDCCoupling = 1;
    else
        RX.ACDCCoupling = 0;
    end
    RX.VFS = dict.VFS; % Digitzer full scale peak to peak voltage reference (1 or 2 V)
    
%     if (RX.Fsample > 1e9)
%         RX.EnableInterleaving  = true;       % Enable interleaving
%     end 
    if dict.Interleaving == 1
        RX.Digitzer.interleaving_flag = 1;
    else
        RX.Digitzer.interleaving_flag = 0;
    end
    
    % UXA Parameters
    % RX.UXA.Downconverter_flag = 0; % Use UXA as a downconverter to feed the signal into the scope
    % RX.UXA.Downcversion_RF_Freq = 28e9; % The RF frequency that the UXA is seeing at its RF input port when used in downconversion mode
    RX.UXA.AnalysisBandwidth = dict.AnalysisBandwidth;
    RX.UXA.Attenuation = dict.Attenuation;
    if dict.ClockReference == 1
        RX.UXA.ClockReference = 'Internal';
    elseif dict.ClockReference == 2
        RX.UXA.ClockReference = 'EXTERNAL';
    end 
    if (RX.UXA.AnalysisBandwidth > 500e6)
        RX.UXA.TriggerPort = 'EXT3';
    else
        RX.UXA.TriggerPort = 'EXT1';
    end
    RX.UXA.TriggerLevel = dict.TriggerLevel; % mV
    
    % Scope Parameters
    RX.ScopeIVIDriverPath = dict.DriverPath;
    if dict.EnableExternalClock_Scope == 1
        RX.EnableExternalReferenceClock = true;
    else
        RX.EnableExternalReferenceClock = false;
    end
    if dict.iChannel == 1
        channelMap(1,:) = 1;
    elseif dict.iChannel == 2
        channelMap(1,1) = 1;
    elseif dict.iChannel == 3
        channelMap(2,1) = 1;
    end
    if dict.qChannel == 1
        channelMap(2,:) = 1;
    elseif dict.qChannel == 2
        channelMap(1,2) = 1;
    elseif dict.qChannel == 3
        channelMap(2,2) = 1;
    end  
    RX.channelVec = channelMap;
    
    save('.\DPD Data\Signal Generation Parameters\RX.mat','RX')
end
