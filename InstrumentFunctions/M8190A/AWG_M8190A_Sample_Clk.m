function AWG_M8190A_Sample_Clk( IntorExt,ClkFreq )
% Configure the sample clock of the M8190A
% IntorExt - Set the reference clock source for 'External', 'Internal' (Default)
% ClkFreq - Specify the clock frequency of the external clock source
    
    load('arbConfig.mat');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    

    switch (IntorExt)
        case 'External';
            xfprintf(f, sprintf(':FREQ:RAST:EXT %d', ClkFreq));
            xfprintf(f, sprintf(':FREQ:RAST:SOUR EXT'));
        otherwise
            xfprintf(f, sprintf(':FREQ:RAST:SOUR INT'));
    end
            
end