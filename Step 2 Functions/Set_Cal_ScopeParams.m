function Set_Cal_ScopeParams(dict,calType)
    dict.trigChannel = str2double(dict.trigChannel);

    if calType == "RX"
        load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    elseif calType == "AWG"
        load(".\Measurement Data\AWG Calibration Parameters\RX.mat")
    end
    
    RX.Type = "Scope";
    RX.ScopeIVIDriverPath = dict.driver;
    RX.VisaAddress = dict.address;
    if dict.enableClock == 1
        RX.EnableExternalReferenceClock = true;
    elseif dict.enableClock == 2
        RX.EnableExternalReferenceClock = false;
    end
    if dict.autoScale == 1
        RX.Scope.autoscaleFlag = true;
    elseif dict.autoScale == 2
        RX.Scope.autoscaleFlag = false;
    end
    RX.TriggerChannel = dict.trigChannel;
    
    if calType == "RX"
        save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
    elseif calType == "AWG"
        save(".\Measurement Data\AWG Calibration Parameters\RX.mat","RX")
    end
end