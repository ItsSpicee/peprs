function Set_RXCal_ScopeParams(dict)
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
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
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end