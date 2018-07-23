function Set_Cal_UXAParams(dict,calType)
    dict.analysisBW = str2double(dict.analysisBW);
    dict.attenuation = str2double(dict.attenuation);
    dict.dict.trigLevel = str2double(dict.trigLevel);
    test = dict.address;
    if calType == "RX"
        load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    elseif calType == "AWG"
        load(".\Measurement Data\AWG Calibration Parameters\RX.mat")
    end
    
    RX.Type = "UXA";
    RX.VisaAddress = test;
    RX.UXA.AnalysisBandwidth =  dict.analysisBW;
    RX.UXA.Attenuation = dict.attenuation; % dB
    if dict.clockRef == 1
        RX.UXA.ClockReference = "Internal";
    elseif dict.clockRef == 2
        RX.UXA.ClockReference = "External";
    end
    RX.UXA.TriggerLevel = dict.trigLevel; % mV
    
    if calType == "RX"
        save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
    elseif calType == "AWG"
        save(".\Measurement Data\AWG Calibration Parameters\RX.mat","RX")
    end
end