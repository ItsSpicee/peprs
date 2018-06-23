function Disconnect_Supply(voltage,address)
% Cleanup
fprintf(supply, sprintf(':OUTPut:STATe %d', 0));
fclose(supply);
fprintf('Disconnected from power supply: %s\n', splitIdn{2}); 
delete(supply);
clear supply;

end