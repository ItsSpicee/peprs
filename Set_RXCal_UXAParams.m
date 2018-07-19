function Set_RXCal_UXAParams(dict)
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    RX.Type = "UXA";
    RX.VisaAddress = dict.address;
    RX.UXA.AnalysisBandwidth =  dict.analysisBW;
    RX.UXA.Attenuation = dict.attenuation; % dB
    if dict.clockRef == 1
        RX.UXA.ClockReference = "Internal";
    elseif dict.clockRef == 2
        RX.UXA.ClockReference = "External";
    end
    RX.UXA.TriggerLevel = dict.trigLevel; % mV
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end