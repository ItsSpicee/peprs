function AWG_Output_Toggle(state)
    instrreset
    addpath('.\InstrumentFunctions\M8190A')
    load('arbConfig');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    if state == 1
        xfprintf(f, sprintf(':OUTPut1:NORMal:STATe %d', 1));
    elseif state == 0
        xfprintf(f, sprintf(':OUTPut1:NORMal:STATe %d', 0));
    end
    rmpath('.\InstrumentFunctions\M8190A')
end            
