function test(voltage)
% Sets the voltage, enables the output, waits for the output to settle, and measures the output.

% Variable declarations

% Connect steps
E3643A = visa('agilent', 'GPIB0::7::INSTR');
E3643A.InputBufferSize = 8388608;
E3643A.ByteOrder = 'littleEndian';
fopen(E3643A);

% Commands
fprintf(E3643A, sprintf(':OUTPut:STATe %d', 1));
fprintf(E3643A, sprintf(':SOURce:VOLTage:LEVel:IMMediate:AMPLitude %g', voltage));
pause(5);
% Cleanup
fprintf(E3643A, sprintf(':OUTPut:STATe %d', 0));
fclose(E3643A);
delete(E3643A);
clear E3643A;

end