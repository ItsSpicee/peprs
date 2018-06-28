% visa resource name is the visa address
% visaAddress = "GPIB0::7::INSTR", E3643A
% low voltage range: 35 V/1.4 A 
% visaAddress = "GPIB0::10::INSTR", E3631A
% channel 1 = 0->6V,5A
% channel 2 = 0->25V,1A
% channel 3 = 0->-25V,1A

function result = Set_Supply(address,voltage,current)
errorString = " ";
partNum = " ";
try
    % Connect steps
    voltage = str2double(voltage);
    current = str2double(current);
    supply = visa('agilent',address);
    supply.InputBufferSize = 8388608;
    supply.ByteOrder = 'littleEndian';
    fopen(supply);

    % Commands
    idn = query(supply, '*IDN?');
    splitIdn = strsplit(idn,',');
    partNum = splitIdn{2};
    fprintf(supply, sprintf(':OUTPut:STATe %d', 0));
    if partNum == "E3643A"
        if voltage > 35 || voltage < 0
            errorString = "Voltage not within bounds";
        elseif current < 0 || current > 1.4
            errorString = "Current not within bounds";
        else
            fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
            fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));
        end
    elseif partNum == "E3631A"
        if 0 <= voltage && voltage <= 25
            if 0 <= current && current <= 1
                fprintf(supply, sprintf(':INSTrument:SELect %s', 'P25V'));
                fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
                fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));
            elseif current <= 5 && current > 1
                if voltage >= 0 && voltage <= 6
                    fprintf(supply, sprintf(':INSTrument:SELect %s', 'P6V'));
                    fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
                    fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));
                else
                    errorString = "Voltage or current not within bounds";
                end
            else
                errorString = "Voltage or current input not within bounds";
            end
        elseif voltage >= -25 && voltage <= 0
            if 0 <= current && current <= 1
               fprintf(supply, sprintf(':INSTrument:SELect %s', 'N25V'));
               fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
               fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current)); 
            else
                errorString = "Voltage or current input not within bounds";
            end
        else 
            errorString = "Voltage or current not within bounds";
        end
    elseif partNum == "E3634A"
        if 0 <= voltage && voltage <= 25
            if 0 <= current && current <= 7
                fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
                fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));     
            else
                errorString = "Current input not within bounds";
            end
        elseif 25 < voltage && voltage <= 50
            if 0 <= current && current <= 4
                fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
                fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));
            else
                errorString = "Current input not within bounds";
            end
        else
            errorString = "Voltage input not within bounds";
        end
    else
       fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
       fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));
    end

    % Cleanup
    fprintf(supply, sprintf(':OUTPut:STATe %d', 0));
    fclose(supply);
    delete(supply);
    clear supply;
    
catch
    errorString = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";
    instrreset
end

resultsString = sprintf("%s;%s",partNum,errorString);
result = char(resultsString);

end

% OLD CODE
%oldSupply = instrfind('PrimaryAddress',address);
%delete(oldSupply);

%     elseif partNum == "N6700"
%        numChannels = fprintf(supply,sprintf('SYSTem:CHANnel:COUNt?'));
%        fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g,(%s)',voltage,cNumber));
%        fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g,(%s)',current,cNumber));