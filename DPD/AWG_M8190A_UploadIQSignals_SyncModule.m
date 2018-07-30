function [ output_args ] = AWG_M8190A_UploadIQSignals_SyncModule( input_args )
    load('arbConfig.mat');
    [awg1, awg2, syncCfg] = makeCfg(arbConfig);
    
    fsync = iqopen(syncCfg);
    if (isempty(fsync))
        return;
    end
    % Stop sending the trigger to the two AWGs
    xfprintf(fsync, ':abor');
    % always go to configuration mode and remote all modules
    % so that we can set the sample rate and mode
    xfprintf(fsync, ':inst:mmod:conf 1');
    
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

