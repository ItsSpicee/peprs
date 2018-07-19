% channel 1 and 2 are coupled
% iqconfig creates arbConfig file

function result = Set_AWG(dict)
    % load arbConfig file in order to connect to AWG (cannot do so through
    % command expert)
    
    % add relevant folders to path
    addpath(".\RX Calibration\InstrumentFunctions\M8190A")
    
    % initialize variables
    refSrc = "";
    sampSrc = "";
    error = "";
    partNum = "";
    
%     try
        load('arbConfig.mat');
        arbConfig = loadArbConfig(arbConfig);
        % set visa address
        if dict.address == ""
            error = "Please fill out all fields before attempting to set parameters."; 
        else   
            arbConfig.visaAddr = dict.address;
        end
        f = iqopen(arbConfig);

        idn = query(f, '*IDN?');
        splitIdn = strsplit(idn,',');
        partNum = splitIdn{2};
        
        % set model type (12 bit (speed) or 14 bit (precision))
        if dict.model == 1   
            xfprintf(f, sprintf(':TRACe:DWIDth %s', 'WPRecision'));
            arbConfig.model = "M8190A_14bit";
        elseif dict.model == 2
            xfprintf(f, sprintf(':TRACe:DWIDth %s', 'WSPeed'));
            arbConfig.model = "M8190A_12bit";
        elseif dict.model == 0
            error = "Please fill out all fields before attempting to set parameters."; 
        end
        
        % set reference clock
        if dict.refClkSrc == 1
            refSrc = "AXI";
            % CHECK
            % arbConfig.clockSource = "AxieRef";
        elseif dict.refClkSrc == 2
            refSrc = "EXT";
            % CHECK
            % arbConfig.clockSource = "ExtRef";
        elseif dict.refClkSrc == 3
            refSrc = "INT";
            % CHECK
            % arbConfig.clockSource = "IntRef";
        elseif dict.refClkSrc == 0
            error = "Please fill out all fields before attempting to set parameters."; 
        end
        
        % check if ref. clock source is available
        check = sscanf(query(f, sprintf(':SOURce:ROSCillator:SOURce:CHECk? %s', refSrc)), '%d');
        if check == 1
            xfprintf(f, sprintf(':SOURce:ROSCillator:SOURce %s', refSrc));
            % set external clock frequency
            if refSrc == "EXT"
                xfprintf(f, sprintf(':SOURce:ROSCillator:FREQuency %s', dict.refClkFreq));
                arbConfig.clockFreq = dict.refClkFreq;
            end
        else
            error = "No source available of selected type.";
        end
        
        % set sample clock source
        if dict.sampClkSrc == 1
            sampSrc = "EXT";
        elseif dict.sampClkSrc == 2
            sampSrc = "INT";
        else
            error = "Please fill out all fields before attempting to set parameters."; 
        end
        xfprintf(f, sprintf(':OUTPut:SCLK:SOURce %s', sampSrc));
        
        % cleanup
        fclose(f);
        delete(f);
        clear f; 
        rmpath(".\RX Calibration\InstrumentFunctions\M8190A")
        
%     catch
%         error = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Address.";
%         instrreset
%     end

    resultsString = sprintf("%s;%s",partNum,error);
    result = char(resultsString);
    save("arbConfig.mat","arbConfig")
end

% OLD CODE
% start signal generation on channel 1 (both if coupled)
%fprintf(f, ':INITiate:IMMediate1');
%clearvars -except arbConfig result