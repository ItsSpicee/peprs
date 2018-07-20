function AWG_M8190A_Reference_Clk(IntorExt,ClkFreq)
% Configure the Refernce Clock of the M8190A
% IntorExt - Set the reference clock source for 'Internal', 'External',
% 'Backplane' (Default)
% ClkFreq - Specify the clock frequency of the external clock source
    load('arbConfig');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    
    switch (IntorExt)
        case 'IntRef'
            xfprintf(f, sprintf(':SOURce:ROSCillator:SOURce %s', 'INT'));
            xfprintf(f, sprintf(':OUTPut:SCLK:SOURce %s', 'INT'));
        case 'AxieRef'
            xfprintf(f, sprintf(':SOURce:ROSCillator:SOURce %s', 'AXI'));
            xfprintf(f, sprintf(':OUTPut:SCLK:SOURce %s', 'INT'));
        case 'ExtRef'
            xfprintf(f, sprintf(':SOURce:ROSCillator:FREQuency %s', ClkFreq));
            xfprintf(f, sprintf(':SOURce:ROSCillator:SOURce %s', 'EXT'));
            xfprintf(f, sprintf(':OUTPut:SCLK:SOURce %s', 'INT'));
        case 'ExtClk'
            xfprintf(f, sprintf(':SOURce:ROSCillator:FREQuency %s', ClkFreq));
            xfprintf(f, sprintf(':OUTPut:SCLK:SOURce %s', 'EXT'));
    end    
end            
   