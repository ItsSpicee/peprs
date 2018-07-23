function AWG_M8192A_ConfigureMultiChannel()
    % Set the M8192A synchronization module to configuration mode to set
    % the sample rates and modes of all M8190A modules
    load('arbConfig_Sync.mat', 'arbConfig');
    syncCfg = [];
    if (isfield(arbConfig, 'useM8192A') && arbConfig.useM8192A ~= 0)
        syncCfg.model = 'M8192A';
        syncCfg.connectionType = 'visa';
        syncCfg.visaAddr = arbConfig.visaAddrM8192A;
    end
    
    fsync = iqopen(syncCfg);
    if (isempty(fsync))
        return;
    end
    
    % Stop sending the trigger to the two AWGs
    xfprintf(fsync, ':abor');
    % always go to configuration mode and remote all modules
    % so that we can set the sample rate and mode
    xfprintf(fsync, ':inst:mmod:conf 1');
    %     xfprintf(fsync, ':inst:slave:del:all');
    %     xfprintf(fsync, ':inst:mast ""');
    query(fsync, '*opc?');
    fclose(fsync);
end

