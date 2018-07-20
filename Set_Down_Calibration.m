function Set_Down_Calibration(dict)
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    load(".\Measurement Data\RX Calibration Parameters\TX.mat")
    load(".\Measurement Data\RX Calibration Parameters\Downconverter.mat")
    load(".\Measurement Data\RX Calibration Parameters\RXFlags.mat")
    % IF = RF - LO
    if dict.rfCenterFreq == ""
        Downconverter.RFCenterFrequency = dict.ifCenterFreq + dict.loFreq;
    else
        Downconverter.RFCenterFrequency = dict.rfCenterFreq;
    end
    if dict.ifCenterFreq == ""
        Downconverter.IFCenterFrequency = dict.rfCenterFreq - dict.loFreq;
    else
        Downconverter.IFCenterFrequency = dict.ifCenterFreq;
    end
    if dict.loFreq == ""
        Downconverter.LOFrequency = dict.rfCenterFreq - dict.ifCenterFreq;
    else
        Downconverter.LOFrequency = dict.loFreq;
    end
    % Higher or lower LO injection
    if dict.mirrorFlag == 1
        RX.LOLowerInjectionFlag = true;
    elseif dict.mirrorFlag == 2
        RX.LOLowerInjectionFlag = false;
    end
    if dict.despurFlag == 1
        RXFlags.despurFlag = 1;
    elseif dict.despurFlag == 2
        RXFlags.despurFlag = 0;
    end
    if dict.smoothFlag == 1
        RXFlags.movingAverageFlag = 1;
    elseif dict.smoothFlag == 2
        RXFlags.movingAverageFlag = 0;
    end
    TX.TriggerAmplitude = dict.trigAmp; % Trigger signal amplitude
    clear dict
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
    save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX")
    save(".\Measurement Data\RX Calibration Parameters\Downconverter.mat","Downconverter")
    save(".\Measurement Data\RX Calibration Parameters\RXFlags.mat","RXFlags")
end