function Output_Off(address)
% Connect steps
oldSupply = instrfind('PrimaryAddress',address);
delete(oldSupply);
supply = visa('agilent',address);
supply.InputBufferSize = 8388608;
supply.ByteOrder = 'littleEndian';
fopen(supply);

% Commands
fprintf(supply, sprintf(':OUTPut:STATe %d', 0));

% Cleanup
fclose(supply);
delete(supply);
clear supply;

end