function AWG_M8192_GetTrigger(AWGPosition)
    copyfile('arbConfig_Sync.mat', 'arbConfig.mat')
    load('arbConfig.mat' ,'arbConfig');
    [awg1, awg2, syncCfg] = makeCfg(arbConfig);

    %% start the signal outputs immediately and start the trigger 
    fsync = iqopen(syncCfg);
    xfprintf(fsync, ':inst:mmod:conf 0');
    if (isfield(arbConfig, 'triggerMode') && strcmp(arbConfig.triggerMode, 'Triggered'))
        f = iqopen(awg1);
        for i = 1:2
            xfprintf(f, sprintf(':trace%d:adv auto', i));
        end
        f2 = iqopen(awg2);
        for i = 1:2
            xfprintf(f2, sprintf(':trace%d:adv auto', i));
        end
    end
    xfprintf(fsync, ':init:imm');
    xfprintf(fsync, ':trig:beg');
    query(fsync, '*opc?');
    fclose(fsync);

    if (AWGPosition == 1)
       xfprintf(f2, sprintf(':OUTPut%d OFF', 1));
       xfprintf(f2, sprintf(':OUTPut%d OFF', 2));
    else
       xfprintf(f, sprintf(':OUTPut%d OFF', 1));
       xfprintf(f, sprintf(':OUTPut%d OFF', 2));
    end
    
    function [awg1, awg2, syncCfg] = makeCfg(arbConfig)
        % create separate config structures for AWG#1, AWG#2, SYNC module and scope
        if (~strcmp(arbConfig.connectionType, 'visa'))
            errordlg('Only VISA connection type is supported by this utility');
        end
        if (~isfield(arbConfig, 'visaAddr2'))
            errordlg('Please configure second M8190A module in configuration window');
        end
        awg1 = arbConfig;
        awg2 = arbConfig;
        awg2.visaAddr = arbConfig.visaAddr2;    
        syncCfg = [];
        if (isfield(arbConfig, 'useM8192A') && arbConfig.useM8192A ~= 0)
            syncCfg.model = 'M8192A';
            syncCfg.connectionType = 'visa';
            syncCfg.visaAddr = arbConfig.visaAddrM8192A;
        end
    end
end