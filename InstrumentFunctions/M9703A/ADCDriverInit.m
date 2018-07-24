function [ ADC ] = ADCDriverInit( RX )
    M9703A_VisaAddress          = RX.VisaAddress;
    ReferenceSource             = 'AgMD1ReferenceOscillatorSourceAXI';
    TriggerSource               = 'External1';
    TriggerLevel                = 0.2;
    Digitizer_EnableCalFlag     = true;
    external_clock_enable       = RX.EnableExternalClock;
    external_clock_frequency    = RX.ExternalClockFrequency;
    NumberOfAverages            = 10;
    
    [ADC.Driver] = M9703A_Configuration_bel(M9703A_VisaAddress, ...
        ReferenceSource, TriggerSource, TriggerLevel, Digitizer_EnableCalFlag, ...
        external_clock_enable, external_clock_frequency, NumberOfAverages);
 
    ADC.Channel1='Channel3';
    ADC.Channel2='Channel4';
    
    M9703A_DDC_Configuration(ADC.Driver, Channel1, 0, 0);
    M9703A_DDC_Configuration(ADC.Driver, Channel2, 0, 0);
    
    pause(2);
end