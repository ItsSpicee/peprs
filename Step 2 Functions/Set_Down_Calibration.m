% only sets RX Calibration, TX Calibration trigger amplitude set on vsg
% measurement page
function Set_Down_Calibration(dict)
    dict.rfCenterFreq = str2double(dict.rfCenterFreq);
    dict.ifCenterFreq = str2double(dict.ifCenterFreq);
    dict.loFreq = str2double(dict.loFreq);
    dict.trigAmp = str2double(dict.trigAmp);
 
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    load(".\Measurement Data\RX Calibration Parameters\TX.mat") 
    load(".\Measurement Data\RX Calibration Parameters\Downconverter.mat")
    
    % IF = RF - LO
    if isnan(dict.rfCenterFreq)
        Downconverter.RFCenterFrequency = dict.ifCenterFreq + dict.loFreq;
    else
        Downconverter.RFCenterFrequency = dict.rfCenterFreq;
    end
    if isnan(dict.ifCenterFreq)
        Downconverter.IFCenterFrequency = dict.rfCenterFreq - dict.loFreq;
    else
        Downconverter.IFCenterFrequency = dict.ifCenterFreq;
    end
    if isnan(dict.loFreq)
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
    TX.TriggerAmplitude = dict.trigAmp; % Trigger signal amplitude
    clear dict
    
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
    save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX") 
    save(".\Measurement Data\RX Calibration Parameters\Downconverter.mat","Downconverter")
end