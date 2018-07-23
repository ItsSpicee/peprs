function Output_Toggle(address,state)
% Connect steps
oldSupply = instrfind('PrimaryAddress',address);
delete(oldSupply);
supply = visa('agilent',address);
supply.InputBufferSize = 8388608;
supply.ByteOrder = 'littleEndian';
fopen(supply);

% Commands
fprintf(supply, sprintf(':OUTPut:STATe %d', state));

% Cleanup
fclose(supply);
delete(supply);
clear supply;

end