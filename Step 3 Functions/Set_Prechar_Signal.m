function Set_Prechar_Signal(dict)
    load(".\DPD Data\Signal Generation Parameters\Signal.mat")
    if dict.signalName == 1
        Signal.Name = "5G_NR_OFDM_50MHz";
    elseif dict.signalName == 2
        Signal.Name = "5G_NR_OFDM_100MHz";
    elseif dict.signalName == 3
        Signal.Name = "5G_NR_OFDM_200MHz";
    elseif dict.signalName == 4
        Signal.Name = "5G_NR_OFDM_400MHz";
    end
    save(".\DPD Data\Signal Generation Parameters\Signal.mat","Signal")
end