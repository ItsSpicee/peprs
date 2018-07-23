function AWG_M8190A_Reference_Clk(IntorExt,ClkFreq)
% Configure the Refernce Clock of the M8190A
% IntorExt - Set the reference clock source for 'Internal', 'External',
% 'Backplane' (Default)
% ClkFreq - Specify the clock frequency of the external clock source
    load('arbConfig');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    

    switch (IntorExt)
        case 'Internal';
            xfprintf(f, sprintf(':ROSC:SOUR INT'));
        case 'Backplane';
            xfprintf(f, sprintf(':ROSC:SOUR AXI'));
        case 'External';
            xfprintf(f, sprintf(':ROSC:FREQ %d', ClkFreq));
            xfprintf(f, sprintf(':ROSC:SOUR EXT'));
        otherwise error('unknown source');
    end
            
end            
