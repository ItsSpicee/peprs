function Set_RXCal_UXAParams(address,bandwidth,attenuation,clockRef,trigLevel)
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    RX.Type = "UXA";
    RX.VisaAddress = address;
    RX.UXA.AnalysisBandwidth =  bandwidth;
    RX.UXA.Attenuation = attenuation;
    RX.UXA.ClockReference = clockRef;
    RX.UXA.TriggerLevel = trigLevel;
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end