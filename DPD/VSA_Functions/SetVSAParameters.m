if RX.VSA.DemodSignalFlag 
    % Set the location of the VSA Interface DLL file
    RX.VSA.ASMPath = 'C:\Program Files\Agilent\89600 Software 22.0\89600 VSA Software\Interfaces\';
    % Set the location of the VSA setup file for demod
    switch SignalName
        case '5G_NR_OFDM_200MHz_64QAM_Pilots'
            RX.VSA.SetupFile = strcat(pwd, '\', 'VSA_Related\5G_NR_200MHz\VSA Setup For 200 MHz 64QAM.setx');
        case '5G_NR_OFDM_200MHz_256QAM_Pilots'
            RX.VSA.SetupFile = strcat(pwd, '\', 'VSA_Related\5G_NR_200MHz\VSA Setup For 200 MHz 256QAM.setx');
        case '5G_NR_OFDM_400MHz_64QAM_Pilots'
            RX.VSA.SetupFile = strcat(pwd, '\', 'VSA_Related\5G_NR_400MHz\VSA Setup For 400 MHz 64QAM_v2.setx');
        case '5G_NR_OFDM_400MHz_256QAM_Pilots'
            RX.VSA.SetupFile = strcat(pwd, '\', 'VSA_Related\5G_NR_400MHz\VSA Setup For 400 MHz 256QAM.setx');
        case '5G_NR_OFDM_800MHz_64QAM_Pilots'
            RX.VSA.SetupFile = strcat(pwd, '\', 'VSA_Related\5G_NR_800MHz\VSA Setup For 800 MHz 64QAM.setx');
        case '5G_NR_OFDM_800MHz_256QAM_Pilots'
            RX.VSA.SetupFile = strcat(pwd, '\', 'VSA_Related\5G_NR_800MHz\VSA Setup For 800 MHz 256QAM_1.setx');
    end
    % Set the datafile to be saved in the current directory
    RX.VSA.DataFile = strcat(pwd, '\');
end
