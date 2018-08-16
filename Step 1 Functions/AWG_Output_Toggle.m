function AWG_Output_Toggle(state)
    instrreset
    addpath('.\InstrumentFunctions\M8190A')
    load('.\Step 1 Functions\arbConfig');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    xfprintf(f, sprintf(':OUTPut1:NORMal:STATe %d', state));
    xfprintf(f, sprintf(':OUTPut2:NORMal:STATe %d', state));
    rmpath('.\InstrumentFunctions\M8190A')
end            
