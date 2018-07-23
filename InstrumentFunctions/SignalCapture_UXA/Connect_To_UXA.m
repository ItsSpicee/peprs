function [ SA ] = Connect_To_UXA( UXAConfig )
    SA.handle = {};
    SA.Address = UXAConfig.Address;
    
    try
        saCfg.connected = 1 ;
        saCfg.connectionType = 'visa';
        saCfg.visaAddr = num2str(UXAConfig.Address) ;
        saCfg.useListSweep = 0 ;
        saCfg.useMarker = 0 ;
        saCfg.InputBufferSize = 1e7;
        obj1 = iqopen(saCfg);
        fclose(obj1);
        obj1 = obj1(1);

        SA.handle = obj1;
        SA.handle.Timeout = 45;
        SA.OnOff = false;
        SA.scale_type = '';
        SA.Initialized = true;
    catch
        error('Cannot connect to UXA. Check the connection and VISA address');
    end
end

