% visa resource name is the visa address
% visaAddress = "GPIB0::7::INSTR", E3643A
% low voltage range: 35 V/1.4 A 
% high voltage range: 60 V/0.8 A
    
function partNum = Set_Voltage(voltage,address)
% Connect steps
voltage = str2num(voltage);
oldSupply = instrfind('PrimaryAddress',address);
delete(oldSupply);
supply = visa('agilent',address);
supply.InputBufferSize = 8388608;
supply.ByteOrder = 'littleEndian';
fopen(supply);

% Commands
fprintf(supply, sprintf(':OUTPut:STATe %d', 1));
fprintf(supply, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g', voltage));
%fprintf(supply,sprintf(':SOURce:VOLTage:LIMit %g', voltage));
idn = query(supply, '*IDN?');
splitIdn = strsplit(idn,',');
partNum = splitIdn{2};

% Cleanup
%fprintf(supply, sprintf(':OUTPut:STATe %d', 0));
fclose(supply);
delete(supply);
clear supply;
end
