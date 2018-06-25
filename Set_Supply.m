% visa resource name is the visa address
% visaAddress = "GPIB0::7::INSTR", E3643A
% low voltage range: 35 V/1.4 A 
% visaAddress = "GPIB0::10::INSTR", E3631A
% instrreset
% address first var
    
function [partNum,errorString] = Set_Supply(address,voltage,current,cNumber)
try
    % Connect steps
    errorString = " ";
    voltage = str2double(voltage);
    current = str2double(current);
    cNumber = str2double(cNumber);
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
        if cNumber ~= 1
            errorString = "Too many channel inputs";
        else
            fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
            fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));
        end
    elseif partNum == "E3631A"
        fprintf(E3631A, sprintf(':INSTrument:SELect %s', 'P25V'));
        if cNumber > 3
            errorString = "Too many channel inputs";
        else
            fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g',voltage));
            fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g',current));
        end
    elseif partNum == "N6700"
        numChannels = fprintf(supply,sprintf('SYSTem:CHANnel:COUNt?'));
        if cNumber > numChannels
            errorString = "too many channel inputs";
        end
       fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g,(%s)',voltage,cNumber));
       fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g,(%s)',current,cNumber));
    else
       fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g,(%s)',voltage));
       fprintf(supply, sprintf(':SOURce:CURRent:LEVel:IMMediate:AMPLitude %g,(%s)',current));
    end

    % Cleanup
    fprintf(supply, sprintf(':OUTPut:STATe %d', 0));
    fclose(supply);
    delete(supply);
    clear supply;
    
catch
    errorString = "A problem has occured, resetting instruments";
    instrreset
end
  
end

% OLD CODE
%oldSupply = instrfind('PrimaryAddress',address);
%delete(oldSupply);