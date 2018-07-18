%%
    M9703A_VisaAddress='PXI10::0::0::INSTR';
    ReferenceSource='AgMD1ReferenceOscillatorSourceAXI';
    TriggerSource='External1';
    TriggerLevel=0.2;
    Digitizer_EnableCalFlag = true;
    external_clock_enable = 0;
    external_clock_frequency = 1.906e9;
    NumberOfAverages = 10;
    [M9703A_Obj] = M9703A_Configuration_bel(M9703A_VisaAddress, ...
        ReferenceSource, TriggerSource, TriggerLevel, Digitizer_EnableCalFlag, ...
        external_clock_enable, external_clock_frequency, NumberOfAverages);
 %%
    Channel1='Channel3';
    Channel2='Channel4';
    M9703A_DDC_Configuration(M9703A_Obj, Channel1, 0, 0);
    M9703A_DDC_Configuration(M9703A_Obj, Channel2, 0, 0);
    pause(2);
%% 
%     Fs_adc = external_clock_frequency;
    Fs_adc = 2e9;
    FullScaleRange=1;
    ACDCCoupling=1; 
    interleaving_flag  = 1;
  