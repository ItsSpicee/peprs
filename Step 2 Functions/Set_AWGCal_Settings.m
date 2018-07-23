function Set_AWGCal_Settings(dict)
    dict.noTXPeriods = str2double(dict.noTXPeriods);
    dict.awgChannel = str2double(dict.awgChannel);
    dict.noRXPeriods = str2double(dict.noRXPeriods);

    load(".\Measurement Data\AWG Calibration Parameters\TX.mat")
    load(".\Measurement Data\AWG Calibration Parameters\RX.mat")
    load(".\Measurement Data\AWG Calibration Parameters\Cal.mat")
    
    TX.NumberOfTransmittedPeriods = dict.noTXPeriods;
    TX.AWG_Channel = dict.awgChannel; % AWG channel for calibration
    if dict.mirror == 1
        RX.LOLowerInjectionFlag = true;
    elseif dict.mirror == 2
        RX.LOLowerInjectionFlag = false;
    end  
    RX.NumberOfMeasuredPeriods = dict.noRXPeriods; % Number of measured frames;
    
    if dict.vsaCalEnabled == 1
        Cal.RX.Calflag = true;
    elseif dict.vsaCalEnabled == 2
        Cal.RX.Calflag = false;
    end
    Cal.RX.CalFile = dict.vsaCalFile;
    
    save(".\Measurement Data\AWG Calibration Parameters\TX.mat","TX")
    save(".\Measurement Data\AWG Calibration Parameters\RX.mat","RX")
    save(".\Measurement Data\AWG Calibration Parameters\Cal.mat","Cal")
end