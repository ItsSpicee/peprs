function AWG_Output_Toggle(state)
    load('arbConfig');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    if state == 1
        xfprintf(f, sprintf(':OUTPut1:NORMal:STATe %d', 1));
    elseif state == 0
        xfprintf(f, sprintf(':OUTPut1:NORMal:STATe %d', 0));
    end
end            
