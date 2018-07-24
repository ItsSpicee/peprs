function Set_Cal_DigitizerParams(dict,calType)
    dict.vfs = str2double(dict.vfs);

    if calType == "RX"
        load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    elseif calType == "AWG"
        load(".\Measurement Data\AWG Calibration Parameters\RX.mat")
    end
    
    RX.Type = "Digitizer";
    RX.VisaAddress = dict.address;
    if dict.enableClock == 1
        RX.EnableExternalClock = true;
    elseif dict.enableClock == 2
        RX.EnableExternalClock = false;
    end
    % For half rate 1.998 GSa/s, quarter rate 1.906 GSa/s
    if dict.clockFreq == 1
        RX.ExternalClockFrequency = 1.998e9;
    elseif dict.clockFreq == 2
        RX.ExternalClockFrequency = 1.906e9;
    end
    if dict.coupling == 1
         RX.ACDCCoupling = 1;
    elseif dict.coupling == 2
         RX.ACDCCoupling = 0;
    end
    RX.VFS = dict.vfs; % Digitzer full scale peak to peak voltage reference (1 or 2 V)
    
    if calType == "RX"
        save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
    elseif calType == "AWG"
        save(".\Measurement Data\AWG Calibration Parameters\RX.mat","RX")
    end
end