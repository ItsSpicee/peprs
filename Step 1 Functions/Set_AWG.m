% channel 1 and 2 are coupled
% iqconfig creates arbConfig file
% uses a modified version of xfprintf from the instrument functions in
% order to return the error to the GUI instead of MATLAB

function result = Set_AWG(dict)
    % load arbConfig file in order to connect to AWG (cannot do so through
    % command expert)
    
    % add relevant folders to path
    addpath('.\InstrumentFunctions\M8190A')
    
    % initialize variables
    refSrc = "";
    sampSrc = "";
    errorList = [];
    errorString = "";
    
%     try
        load('arbConfig.mat');
        arbConfig = loadArbConfig(arbConfig);
        arbConfig.visaAddr = dict.address;
        f = iqopen(arbConfig);

        idn = query(f,'*IDN?');
        splitIdn = strsplit(idn,',');
        partNum = splitIdn{2};
        
        % set model type (12 bit (speed) or 14 bit (precision))
        if dict.model == 1   
            s = sprintf(':TRACe:DWIDth %s', 'WPRecision');
            error = mod_xfprintf(f,s);
            if error ~= ""
                if contains(error,'-222')
                    error = sprintf('%s\n 14-bit mode is unavailable on this AWG',error);
                end
                errorList = [errorList,error];
            end
            arbConfig.model = "M8190A_14bit";
        elseif dict.model == 2
            s = sprintf(':TRACe:DWIDth %s', 'WSPeed');
            xfprintf(f,s);
            error = mod_xfprintf(f,s);
            if error ~= ""
                if contains(error,'-222')
                    error = sprintf('%s\n 12-bit mode is unavailable on this AWG',error);
                end
                errorList = [errorList,error];
            end
            arbConfig.model = "M8190A_12bit";
        end
        
        % set reference clock
        if dict.refClkSrc == 1
            refSrc = "AXI";
            sampSrc = "INT";
            arbConfig.clockSource = "AxieRef";
        elseif dict.refClkSrc == 2
            refSrc = "EXT";
            sampSrc = "INT";
            arbConfig.clockSource = "ExtRef";
        elseif dict.refClkSrc == 3
            refSrc = "INT";
            sampSrc = "INT";
            arbConfig.clockSource = "IntRef";
        elseif dict.refClkSrc == 4
            sampSrc = "EXT";
            arbConfig.clockSource = "ExtClk";
        end
        
        % check if ref. clock source is available
        check = sscanf(query(f, sprintf(':SOURce:ROSCillator:SOURce:CHECk? %s', refSrc)), '%d');
        if check == 1
            error = mod_xfprintf(f, sprintf(':SOURce:ROSCillator:SOURce %s', refSrc));
            if error ~= ""
                errorList = [errorList,error];
            end
            error = mod_xfprintf(f, sprintf(':OUTPut:SCLK:SOURce %s', sampSrc));
            if error ~= ""
                errorList = [errorList,error];
            end
            % set external clock frequency
            if refSrc == "EXT" || sampSrc == "EXT"
                error = mod_xfprintf(f, sprintf(':SOURce:ROSCillator:FREQuency %s', dict.refClkFreq));
                if error ~= ""
                    errorList = [errorList,error];
                end
                arbConfig.clockFreq = dict.refClkFreq;
            end
        else
            error = "No source available of selected type.";
            errorList = [errorList,error];
        end
        
        % cleanup
        fclose(f);
        delete(f);
        clear f; 
        rmpath('.\InstrumentFunctions\M8190A')
        
%     catch
%         error = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Address.";
%         instrreset
%     end

    for i=1:length(errorList)
        if i == 1
            errorString = errorList(1);
        else
            errorString = sprintf('%s|%s',errorString,errorList(i));
        end
    end
    resultsString = sprintf("%s~%s",partNum,errorString);
    result = char(resultsString);
    save("arbConfig.mat","arbConfig")
end

% OLD CODE
% start signal generation on channel 1 (both if coupled)
%fprintf(f, ':INITiate:IMMediate1');
%clearvars -except arbConfig result