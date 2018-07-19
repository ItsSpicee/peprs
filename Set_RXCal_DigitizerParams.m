function Set_RXCal_DigitizerParams(address,enableClock,clockFreq,coupling,vfs)
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    RX.Type = "Digitizer";
    RX.VisaAddress = address;
    RX.EnableExternalClock = enableClock;
    RX.ExternalClockFrequency = clockFreq; % For half rate 1.998 GSa/s, quarter rate 1.906 GSa/s
    RX.ACDCCoupling = coupling;
    RX.VFS = vfs; % Digitzer full scale peak to peak voltage reference (1 or 2 V)
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end