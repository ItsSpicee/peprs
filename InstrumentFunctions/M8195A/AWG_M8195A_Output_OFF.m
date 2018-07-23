function AWG_M8195A_Output_OFF()
% Turn OFF the output of the M8190A    
% Channel - Specify the channel to be set (1 or 2)

    arbConfig = loadArbConfig();
        % these two lines are written to change the address of the AWG
        % manaually since I could not open it with iqtools.
        % Beltagy
%         arbConfig.visaAddr = 'TCPIP0::localhost::hislip1::INSTR';
%         arbConfig.visaAddrM8192A = 'TCPIP0::localhost::hislip1::INSTR';  
        f = iqopen(arbConfig);
   
    
        xfprintf(f, sprintf(':OUTPut%d OFF', 1));
        xfprintf(f, sprintf(':OUTPut%d OFF', 2));
        xfprintf(f, sprintf(':OUTPut%d OFF', 3));
        xfprintf(f, sprintf(':OUTPut%d OFF', 4));
        

            
end            
            
