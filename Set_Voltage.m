% visa resource name is the visa address
% if visaAddress = "GPIB0::7::INSTR"
%     partNumber = "E3643A";
    
function Set_Voltage(voltage)
% Connect steps
E3643A = visa('agilent', 'GPIB0::7::INSTR');
E3643A.InputBufferSize = 8388608;
E3643A.ByteOrder = 'littleEndian';
fopen(E3643A);

% Commands
fprintf(E3643A, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g', voltage));

% Cleanup
fclose(E3643A);
delete(E3643A);
clear E3643A;

end
