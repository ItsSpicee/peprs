function AWG_M8190A_EnableSequencing(SlaveFlag,SyncModuleFlag)
    load('arbConfig.mat');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    advanceMode = 'Auto';
    seq(1).segmentNumber = 1;
    seq(1).segmentLoops = 1;
    seq(1).markerEnable = true;
    seq(1).segmentAdvance = advanceMode;
    if (SlaveFlag)
        %% Wait for the trigger from AWG1 to start sending
        xfprintf(f, ':TRIG:SOUR:ADV TRIG')
        if ~SyncModuleFlag
            AWG_iqseq_MultiChannel('define', seq, 'keepOpen', 1, 'run', SlaveFlag);
            AWG_iqseq_MultiChannel('triggerMode', 'triggered', 'keepopen', 1);
            AWG_iqseq_MultiChannel('mode', 'STSC', 'keepopen', 1);
            AWG_iqseq_MultiChannel('run', seq, 'keepOpen', 1, 'run', 1);
        else
            AWG_iqseq_MultiChannel('define', seq, 'keepOpen', 1, 'run', SlaveFlag);
            AWG_iqseq_MultiChannel('triggerMode', 'triggered', 'keepopen', 1);
            AWG_iqseq_MultiChannel('mode', 'STSC', 'keepopen', 1);   
        end
        %% Ensure AWG2 is ready to receive the trigger
        query(f, '*opc?');
    else
        if (SyncModuleFlag)
            AWG_iqseq_MultiChannel('define', seq, 'keepOpen', 1, 'run', SlaveFlag);
            AWG_iqseq_MultiChannel('triggerMode', 'triggered', 'keepopen', 1);
            AWG_iqseq_MultiChannel('mode', 'STSC', 'keepopen', 1);
        else
            AWG_iqseq_MultiChannel('triggerMode', 'continuous', 'keepopen', 1);
            AWG_iqseq_MultiChannel('mode', 'Arbitrary', 'keepopen', 1);
            AWG_iqseq_MultiChannel('run', seq, 'keepOpen', 1, 'run', 1);
        end
    end
    fclose(f);
end            
