function [InstrumentObj] = M9703A_Configuration_bel(VisaAddress, ReferenceSource, TriggerSource, TriggerLevel, EnableCalFlag, external_clock_enable, external_clock_frequency)
% Configure the instrument with the following parameters
% - VisaAddress - String value to specify the visa address for the M9703A. It sould be in the format 
% 'PXI21::0::0::INSTR' 
% - ReferenceSource - String value to specify the Reference Oscillator
% Source. Possible values are
% 'AgMD1ReferenceOscillatorSourceInternal','AgMD1ReferenceOscillatorSourceAXI'
% and 'AgMD1ReferenceOscillatorSourceExternal' for Internal Source, AXI
% Backplane source (used to synchronize with the AWG) and External Source, respectively.
% - TriggerSource - String value to specify the Source of Trigger. Possible values are Channel1, ..., 
% Channel<n> or External1, ..., External<n> trigger sources where <n> is 
% the number of available channels or external trigger inputs.
% - TriggerLevel - The Level of the Trigger in Volts
% - external_clock_enable : if the ADC is driven by an external clock
% - external_clock_frequency : The value of this external clock. It is
% needed that this clock must be twice the needed sampling frequency as
% this clock will be divided by two inside the adc.
% For external clock, a input clock of 4dBm worked with me. 

    % Create driver instance
    driver = instrument.driver.AgMD1();

    % Edit resource and options as needed.  Resource is ignored if option Simulate=true
    resourceDesc = VisaAddress;

    initOptions = 'Simulate=false, DriverSetup= Cal=0, Trace=false';			
    idquery = true;
    reset   = true;

    driver.Initialize(resourceDesc, idquery, reset, initOptions);
    disp('M9703A Driver Initialized');
    
    % Reference Clock Configuration
    driver.DeviceSpecific.ReferenceOscillator.Source=ReferenceSource;
    
    % Enternal Clock Configuration
    if external_clock_enable == 1 
        driver.DeviceSpecific.SampleClock.Source = 'AgMD1SampleClockSourceExternal';
        disp('External Clock Enabled !')
        %driver.DeviceSpecific.SampleClock.ExternalFrequency = 1.984e9;
        driver.DeviceSpecific.SampleClock.ExternalFrequency = external_clock_frequency;
        disp(['External Clock Frequency ' num2str(external_clock_frequency/1e9)]);
        disp(['Operating Sampling Frequency ' num2str(external_clock_frequency)/2e9]);
        disp(['Fs/2 ' num2str(external_clock_frequency)/4e9]);
    end
    
    % Create pointers to trigger source objects
    [pTrigSrc] = driver.DeviceSpecific.Trigger.Sources.Item(TriggerSource);
    
    % Setup the trigger
    driver.DeviceSpecific.Trigger.ActiveSource = TriggerSource;
    pTrigSrc.Type = 'AgMD1TriggerEdge';
    pTrigSrc.Level = TriggerLevel; 
    
%     % Calibrate
    if EnableCalFlag == true
        disp('Calibrating Channels...');
        driver.DeviceSpecific.Calibration.SelfCalibrate(0,1);   % 0=AgMD1CalibrateTypeFull
    end  
    % Uncomment This section to calibrate all the channels    
%     for n=2:8
%         driver.DeviceSpecific.Calibration.SelfCalibrate(0,n);   % 0=AgMD1CalibrateTypeFull
%     end
  
    InstrumentObj=driver;
    