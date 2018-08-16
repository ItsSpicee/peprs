function errorString = Set_AdvAWG(dict)
    dict.sampleMarker = str2double(dict.sampleMarker);
    dict.syncMarker = str2double(dict.syncMarker);
    dict.dacRange = str2double(dict.dacRange);
    
    % initialize variables
    errorList = [];
    errorString = '';
        
    % add relevant folders to path
    addpath('.\InstrumentFunctions\M8190A')
    
    % connect to instrument
    load('.\Step 1 Functions\arbConfig.mat');
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
    if dict.dacRange < 0.1 || dict.dacRange > 0.7
        error = 'The Voltage should be between 0.1 and 0.7 V';
        errorList = [errorList,error];
    else 
         error = mod_xfprintf(f, sprintf(':SOURce:DAC:VOLTage:LEVel:IMMediate:AMPLitude %g', dict.dacRange));
         errorList = addToErrorList(error,errorList);
         arbConfig.DACRange = dict.dacRange;
    end

    % set trigger mode: continuous, triggered or gated
    if dict.trigMode == 1
        % continuous mode is on. Trigger mode is “automatic”. The value of gate mode is not relevant.
        error = mod_xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 1));
        errorList = addToErrorList(error,errorList);
        arbConfig.triggerMode = "Continuous";
    elseif dict.trigMode == 2
        % continuous mode is off. If gate mode is off, the trigger mode is “triggered”
        error = mod_xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
        errorList = addToErrorList(error,errorList);
        error = mod_xfprintf(f, sprintf(':INITiate:GATE:STATe %d', 0));
        errorList = addToErrorList(error,errorList);
        arbConfig.triggerMode = "Triggered";
    elseif dict.trigMode == 3
        % continuous mode is off. If gate mode is off, the trigger mode is “triggered”, else it is “gated”
        error = mod_xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
        errorList = addToErrorList(error,errorList);
        error = mod_xfprintf(f, sprintf(':INITiate:GATE:STATe %d', 1));
        errorList = addToErrorList(error,errorList);
        arbConfig.triggerMode = "Gated";
    end
    
    % set sample marker out
    error = mod_xfprintf(f,sprintf(':SOURce:MARKer:SAMPle:VOLTage:LEVel:IMMediate:AMPLitude %g', dict.sampleMarker));
    errorList = addToErrorList(error,errorList);
    
    % set sync marker out
    error = mod_xfprintf(f, sprintf(':SOURce:MARKer:SYNC:VOLTage:LEVel:IMMediate:AMPLitude %g', dict.syncMarker));
    errorList = addToErrorList(error,errorList);
    
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
    save(".\Step 1 Functions\arbConfig.mat","arbConfig")
end