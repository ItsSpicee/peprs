function errorString = Set_AdvAWG(dict)
    dict.sampleMarker = str2double(dict.sampleMarker);
    dict.syncMarker = str2double(dict.syncMarker);
    dacRange = str2double(dict.dacRange);
    
    % initialize variables
    errorList = [];
    errorString = "";
        
    % add relevant folders to path
    addpath('.\InstrumentFunctions\M8190A')
    
    % connect to instrument
    load('arbConfig.mat');
    arbConfig = loadArbConfig(arbConfig);
    % set visa address
    if dict.address == "" || dict.genSet == false
        errorString = 'Please fill out general settings before attempting to set advanced parameters.';
        return
    else   
        arbConfig.visaAddr = dict.address;
    end
    f = iqopen(arbConfig);    

    % set DAC Range
    if dacRange < 0.1 || dacRange > 0.7
        error = "The Voltage should be between 0.1 and 0.7 V'";
        errorList = [errorList,error];
    else 
         error = mod_xfprintf(f, sprintf(':SOURce:DAC:VOLTage:LEVel:IMMediate:AMPLitude %g', dacRange));
         if error ~= ""
            errorList = [errorList,error];
         end
         arbConfig.DACRange = dict.dacRange;
    end

    % set trigger mode: continuous, triggered or gated
    if dict.trigMode == 1
        % continuous mode is on. Trigger mode is “automatic”. The value of gate mode is not relevant.
        error = mod_xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 1));
        if error ~= ""
            errorList = [errorList,error];
        end
        arbConfig.triggerMode = "Continuous";
    elseif dict.trigMode == 2
        % continuous mode is off. If gate mode is off, the trigger mode is “triggered”
        error = mod_xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
        if error ~= ""
            errorList = [errorList,error];
        end
        error = mod_xfprintf(f, sprintf(':INITiate:GATE:STATe %d', 0));
        if error ~= ""
            errorList = [errorList,error];
        end
        arbConfig.triggerMode = "Triggered";
    elseif dict.trigMode == 3
        % continuous mode is off. If gate mode is off, the trigger mode is “triggered”, else it is “gated”
        error = mod_xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
        if error ~= ""
            errorList = [errorList,error];
        end
        error = mod_xfprintf(f, sprintf(':INITiate:GATE:STATe %d', 1));
        if error ~= ""
            errorList = [errorList,error];
        end
        arbConfig.triggerMode = "Gated";
    end
    
    % set sample marker out
    error = mod_fprintf(f, sprintf(':SOURce:MARKer:SAMPle:VOLTage:LEVel:IMMediate:AMPLitude %g', dict.sampleMarker));
    if error ~= ""
        errorList = [errorList,error];
    end
    
    % set sync marker out
    error = mod_fprintf(f, sprintf(':SOURce:MARKer:SYNC:VOLTage:LEVel:IMMediate:AMPLitude %g', dict.syncMarker));
    if error ~= ""
        errorList = [errorList,error];
    end
    
    for i=1:length(errorList)
        if i == 1
            errorString = errorList(1);
        else
            errorString = sprintf('%s|%s',errorString,errorList(i));
        end
    end

    rmpath('.\InstrumentFunctions\M8190A')
    fclose(f);
    delete(f);
    clear f; 
    save("arbConfig.mat","arbConfig")
end