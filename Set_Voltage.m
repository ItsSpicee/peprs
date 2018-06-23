% visa resource name is the visa address
% visaAddress = "GPIB0::7::INSTR", E3643A
    
function [ResourceName] = Set_Voltage(voltage,address)
% Connect steps
oldObj = instrfind('PrimaryAddress',address);
delete(oldObj);
supply = visa('agilent',address);
supply.InputBufferSize = 8388608;
supply.ByteOrder = 'littleEndian';
fopen(supply);

% Commands
fprintf(supply, sprintf(':OUTPut:STATe %d', 1));
fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g', voltage));
idn = query(supply, '*IDN?');
splitIdn = strsplit(idn,',');
fprintf('Connected to power supply: %s\n', splitIdn{2}); 
% pause(5);
% Cleanup
% fprintf(supply, sprintf(':OUTPut:STATe %d', 0));
fclose(supply);
% fprintf('Disconnected from power supply: %s\n', splitIdn{2}); 
delete(supply);
clear supply;
end
