function [InstrumentObj] = E4438C_Configuration(VisaAddress)
% Configure the instrument with the following parameters
% - VisaAddress - String value to specify the visa address for the M9703A. 
% It sould be in the format by default 'GPIB0::19::INSTR' 
    
    % Create driver instance
    driver = instrument.driver.AgilentRfSigGen();

    % Edit resource and options as needed.  Resource is ignored if option Simulate=true
    resourceDesc = VisaAddress;
    % resourceDesc = 'TCPIP0::<host_name or IP addr>::INSTR';

    initOptions = 'QueryInstrStatus=, Simulate=false, DriverSetup= Model=, Trace=false';			
    idquery = true;
    reset   = true;
    reset   = false;

    driver.Initialize(resourceDesc, idquery, reset, initOptions);
    disp('E4438C Driver Initialized');
    driver.DeviceSpecific.AnalogModulation.DisableAll;
    InstrumentObj=driver;
    