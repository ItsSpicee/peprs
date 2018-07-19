function error = Set_AdvAWG(address,trigMode,dacRange)
    % initialize variables
    error = "";   
    if dacRange == ""
        error = "Please fill out all fields before attempting to set parameters.";
        error = char(error);
        return
    else
        dacRange = str2double(dacRange);
    end
    
    % add relevant folders to path
    addpath(".\RX Calibration\InstrumentFunctions\M8190A")
    
    % connect to instrument
    load('arbConfig.mat');
    arbConfig = loadArbConfig(arbConfig);
    % set visa address
    if address == ""
        error = "Please fill out all fields before attempting to set parameters."; 
    else   
        arbConfig.visaAddr = address;
    end
    f = iqopen(arbConfig);    

    % set DAC Range
    if dacRange < 0.1 || dacRange > 0.7
        error = "The Voltage should be between 0.1 and 0.7 V'";
    else 
         xfprintf(f, sprintf(':SOURce:DAC:VOLTage:LEVel:IMMediate:AMPLitude %g', dacRange));
         arbConfig.DACRange = dacRange;
    end

    % set trigger mode: continuous, triggered or gated
    if trigMode == 1
        % continuous mode is on. Trigger mode is “automatic”. The value of gate mode is not relevant.
        xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 1));
        arbConfig.triggerMode = "Continuous";
    elseif trigMode == 2
        % continuous mode is off. If gate mode is off, the trigger mode is “triggered”
        xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
        xfprintf(f, sprintf(':INITiate:GATE:STATe %d', 0));
        arbConfig.triggerMode = "Triggered";
    elseif trigMode == 3
        % continuous mode is off. If gate mode is off, the trigger mode is “triggered”, else it is “gated”
        xfprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
        xfprintf(f, sprintf(':INITiate:GATE:STATe %d', 1));
        arbConfig.triggerMode = "Gated";
    else
        error = "Please fill out all fields before attempting to set parameters."; 
    end
    
    error = char(error);
    rmpath(".\RX Calibration\InstrumentFunctions\M8190A")
    fclose(f);
    delete(f);
    clear f; 
    save("arbConfig.mat","arbConfig")
end