function Output_On(address)
% Connect steps
oldSupply = instrfind('PrimaryAddress',address);
delete(oldSupply);
supply = visa('agilent',address);
supply.InputBufferSize = 8388608;
supply.ByteOrder = 'littleEndian';
fopen(supply);

% Commands
fprintf(supply, sprintf(':OUTPut:STATe %d', 1));

% Cleanup
fclose(supply);
delete(supply);
clear supply;

end