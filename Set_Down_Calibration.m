function Set_Down_Calibration(rfCenterFreq,ifCenterFreq,loFreq,mirror,despurFlag,smoothFlag,trigAmp)
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    % Higher or lower LO injection
    if dict.mirror == 1
        RX.LOLowerInjectionFlag = true;
    elseif dict.mirror == 2
        RX.LOLowerInjectionFlag = false;
    end
    % IF = RF - LO
    save(".\Measurement Data\RX Calibration Parameters\RX.mat")
end