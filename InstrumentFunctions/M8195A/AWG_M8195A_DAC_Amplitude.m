function AWG_M8195A_DAC_Amplitude(Channel,Amplitude)
% Configure the DAC Amplitude for the M8190A
% Channel - Specify the channel to be set (1 or 2)
% Amplitude - Voltage Amplitude (between 0.1 and 0.7 V)
    load('arbConfig.mat');
    arbConfig = loadArbConfig(arbConfig);
        % these two lines are written to change the address of the AWG
        % manaually since I could not open it with iqtools.
        % Beltagy
%         arbConfig.visaAddr = 'TCPIP0::localhost::hislip3::INSTR ';
%         arbConfig.visaAddrM8192A = 'TCPIP0::localhost::hislip3::INSTR ';  
    f = iqopen(arbConfig);
    
     if Amplitude < 0.075 || Amplitude > 1
        msgbox('The Voltage should be between 0.075 and 1 V', 'Error');
        return
     else 
         xfprintf(f, sprintf(':SOURce:VOLT%d:AMPL %d',Channel,Amplitude));
     end
    
             
end            


