function UXA_Downconversion_Mode_Setup (Freq, Fsample, time, UXAAdd, Atten, ...
    ClockReference)

    clkrate = Fsample * 1.25;
    if clkrate >= 600e6;
        clkrate = 600e6;
    end

    Frequency = num2str(Freq);
    capture_time = num2str(time);
    Address = UXAAdd ;
    Attenuation = num2str(Atten);
    digital_IF_BW = num2str(Fsample);

    obj.handle = {};
    obj.Address = Address;

    saCfg.connected = 1 ;
    saCfg.connectionType = 'visa';
    saCfg.visaAddr = ['USB0::' num2str(Address) '::INSTR'] ;
    saCfg.useListSweep = 0 ;
    saCfg.useMarker = 0 ;
    saCfg.InputBufferSize = 1e7;
    % Test connection
    obj1 = iqopen(saCfg);
    fclose(obj1);
    obj1 = obj1(1);

    obj.handle = obj1;

    obj.handle.Timeout = 25;

    obj.OnOff = false;
    obj.scale_type = '';
    obj.Initialized = true;
    try 
        fopen(obj.handle);
        fprintf(obj.handle,[':INSTrument:SELect BASIC']);     
        fprintf(obj.handle,':CONF:WAV');

        fprintf(obj.handle,':FORM:DATA REAL,32');
        fprintf(obj.handle,':FORM:BORD SWAP');
        % Set the center RF Frequency
        fprintf(obj.handle,[':SENSe:FREQuency:RF:CENTer ' Frequency]);
        % Set the complex sampling rate
        fprintf(obj.handle,[':WAVeform:SRATe ' num2str(clkrate)]);
    %     % Enable the low noise path
    %     fprintf(obj.handle,[':POW:MW:PATH LNP']);
        % Set the digital IF bandwidth
        fprintf(obj.handle,[':WAVeform:DIF:BANDwidth ' digital_IF_BW]);
        % Set the mechanical attenuator value
        fprintf(obj.handle,[':SENSe:POW:Attenuation ' Attenuation]);
        % Set the oscillator source to use the external reference
        fprintf(obj.handle,[':ROSCillator:SOURce:TYPE ', ClockReference]);
        % Set the measuring time
        fprintf(obj.handle,[':WAVeform:SWEep:TIME ' capture_time]);
        
        % Enable the auxiliary IF output
        fprintf(obj.handle,[':OUTPut:AUX SIF']);
        
        % Close the connection to the UXA
        fclose(obj.handle);
    catch
        warning('Problem during capture IQ, please check memory.')
        fclose(obj.handle);
    end
end                        
