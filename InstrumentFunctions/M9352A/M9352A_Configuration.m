function [InstrumentObj] = M9352A_Configuration(VisaAddress)
% Configure the instrument with the following parameters
% - VisaAddress - String value to specify the visa address for the M9352A. 
% It sould be in the format 'PXI32::10::0::INSTR' 


    % Create driver instance
    driver = instrument.driver.AgAmpAtten();	

    % Edit resource and options as needed.  Resource is ignored if option Simulate=true
    resourceDesc = VisaAddress;

    initOptions = 'Simulate=false, DriverSetup=,RangeCheck=';			
    idquery = true;
    reset   = true;

    driver.Initialize(resourceDesc, idquery, reset, initOptions);
    disp('M9352A Driver Initialized');
    
    InstrumentObj=driver;