function UploadOutphasingSignals( s1_cal, s2_cal, Fsample_signal, TX, RX, Expansion_Margin1, Expansion_Margin2, PAPR_originals1, PAPR_originals2)
    s1_cal              = SetMeanPower(s1_cal, 0);      % Set the mean power of the I/Q signals to be used for DPD
    [~, ~, PAPR_input]	= CheckPower(s1_cal, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
    
    s2_cal              = SetMeanPower(s2_cal, 0);      % Set the mean power of the I/Q signals to be used for DPD
    [~, ~, PAPR_input]	= CheckPower(s2_cal, 1);        % Check the PAPR of the input file to be uploaded to the transmitter
    
    PAPR_original = PAPR_originals1;
    Expansion_Margin = Expansion_Margin1;
    expansionMarginFlag = 0;
    copyfile('arbConfig_Top.mat', 'arbConfig.mat')
    AWG_In_signal = s1_cal;
    runFlag = 0;
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'Fsample_signal', 'TX', 'PAPR_input', 'PAPR_original', 'runFlag');
    AWG_Upload_32bit_Master
    AWG_M8190A_SyncMKR_Amplitude(1,1.5);
    
    PAPR_original = PAPR_originals2;
    Expansion_Margin = Expansion_Margin2;
    copyfile('arbConfig_Bottom.mat', 'arbConfig.mat')
    AWG_In_signal = s2_cal;
    save('IQ_AWG_in.mat', 'AWG_In_signal', 'Fsample_signal', 'TX', 'PAPR_input', 'PAPR_original', 'runFlag');
    AWG_Upload_32bit_Slave

    % Start AWG 1 now
    copyfile('arbConfig_Top.mat', 'arbConfig.mat')
    SlaveFlag = 0;
    AWG_M8190A_EnableSequencing(SlaveFlag, TX.AWG.SyncModuleFlag);
    
    %% Start sending the M8192A triggers and stop configuration
    if TX.AWG.SyncModuleFlag
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
        fclose(f);
        fclose(f2);
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

