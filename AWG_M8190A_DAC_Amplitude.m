function AWG_M8190A_DAC_Amplitude(Channel,Amplitude)
% Configure the DAC Amplitude for the M8190A
% Channel - Specify the channel to be set (1 or 2)
% Amplitude - Voltage Amplitude (between 0.1 and 0.7 V)
    
    load('arbConfig.mat');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);
    
     if Amplitude < 0.1 || Amplitude > 0.7
        msgbox('The Voltage should be between 0.1 and 0.7 V', 'Error');
        return
     else 
         xfprintf(f, sprintf(':DAC%d:VOLT:AMPL %d',Channel,Amplitude));
     end
    
             
end            
