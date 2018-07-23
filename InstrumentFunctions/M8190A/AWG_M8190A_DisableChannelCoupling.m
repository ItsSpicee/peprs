function AWG_M8190A_DisableChannelCoupling()
    arbConfig = loadArbConfig();
    f = iqopen(arbConfig);
    xfprintf(f, ':INSTrument:COUPle:STATe OFF');
    fclose(f);
end            
