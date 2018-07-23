function AWG_M8190A_Output_ON(Channel)
% Turn ON the output of the M8190A
% Channel - Specify the channel to be set (1 or 2)
    load('arbConfig');
    arbConfig = loadArbConfig(arbConfig);
    f = iqopen(arbConfig);

    xfprintf(f, sprintf(':OUTPut%d ON', Channel));

            
end            
