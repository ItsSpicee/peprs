% channel 1 and 2 are coupled

function result = Set_AWG(address,refClkSrc,refClkFreq,sampClkSrc,model,trigMode,dacRange)
%function error = Set_AWG(refClkSrc,refClkFreq,Channel,Amplitude)
    % load arbConfig file in order to connect to AWG (cannot do so through
    % command expert)
    try 
        load('arbConfig.mat');
        arbConfig = loadArbConfig(arbConfig);
        % set visa address
        arbConfig.visaAddr = address;
        f = iqopen(arbConfig);

        % initialize variables
        refSrc = "";
        sampSrc = "";
        error = "";
        idn = query(f, '*IDN?');
        splitIdn = strsplit(idn,',');
        partNum = splitIdn{2};
        
        % set model type (12 bit (speed) or 14 bit (precision))
        if model == 1   
            fprintf(f, sprintf(':TRACe:DWIDth %s', 'WPRecision'));
        elseif model == 2
            fprintf(f, sprintf(':TRACe:DWIDth %s', 'WSPeed'));
        elseif model == 0
            error = "Please fill out all fields before attempting to set parameters."; 
        end
        
        % set reference clock
        if refClkSrc == 1
            refSrc = "AXI";
        elseif refClkSrc == 2
            refSrc = "EXT";
        elseif refClkSrc == 3
            refSrc = "INT";
        elseif refClkSrc == 0
            error = "Please fill out all fields before attempting to set parameters."; 
        end

        % check if ref. clock source is available         
        check = sscanf(query(f, sprintf(':SOURce:ROSCillator:SOURce:CHECk? %s', refSrc)), '%d');
        if check == 1
            fprintf(f, sprintf(':SOURce:ROSCillator:SOURce %s', refSrc));
            % set external clock frequency
            if refSrc == "EXT"
                fprintf(f, sprintf(':SOURce:ROSCillator:FREQuency %s', refClkFreq));
            end
        else
            error = "No source available of selected type.";
        end
        
        % set sample clock source
        if sampClkSrc == 1
            sampSrc = "EXT";
        elseif sampClkSrc == 2
            sampSrc = "INT";
        else
            error = "Please fill out all fields before attempting to set parameters."; 
        end
        fprintf(f, sprintf(':OUTPut:SCLK:SOURce %s', sampSrc));

        % set DAC Range
        if dacRange < 0.1 || dacRange > 0.7
            error = "The Voltage should be between 0.1 and 0.7 V'";
         else 
             fprintf(f, sprintf(':SOURce:DAC:VOLTage:LEVel:IMMediate:AMPLitude %g', dacRange));
        end
        
        % set trigger mode: continuous, triggered or gated
        if trigMode == 1
            % continuous mode is on. Trigger mode is “automatic”. The value of gate mode is not relevant.
            fprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 1));
        elseif trigMode == 2
            % continuous mode is off. If gate mode is off, the trigger mode is “triggered”
            fprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
            fprintf(f, sprintf(':INITiate:GATE:STATe %d', 0));
        elseif trigMode == 3
            % continuous mode is off. If gate mode is off, the trigger mode is “triggered”, else it is “gated”
            fprintf(f, sprintf(':INITiate:CONTinuous:STATe %d', 0));
            fprintf(f, sprintf(':INITiate:GATE:STATe %d', 1));
        else
            error = "Please fill out all fields before attempting to set parameters."; 
        end
        
        % start signal generation on channel 1 (both if coupled)
        %fprintf(f, ':INITiate:IMMediate1');
        
        % cleanup
        fclose(f);
        delete(f);
        clear f;
        
    catch
        error = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Address.";
        instrreset
    end
    
    resultsString = sprintf("%s;%s",partNum,error);
    result = char(resultsString);
end