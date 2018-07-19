function Set_RXCal_ScopeParams(driver,address,enableClock,autoScale,trigChannel)
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    RX.Type = "Scope";
    RX.ScopeIVIDriverPath = driver;
    RX.VisaAddress = address;
    RX.EnableExternalReferenceClock = enableClock;
    RX.Scope.autoscaleFlag = autoScale;
    RX.TriggerChannel = trigChannel;
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end