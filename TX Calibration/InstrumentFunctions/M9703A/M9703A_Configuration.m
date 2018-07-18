function [InstrumentObj] = M9703A_Configuration(VisaAddress, ReferenceSource, TriggerSource, TriggerLevel, DoCalibration)
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

% Create driver instance
driver = instrument.driver.AgMD1();

% Edit resource and options as needed.  Resource is ignored if option Simulate=true
resourceDesc = VisaAddress;

initOptions = 'Simulate=false, DriverSetup= Cal=0, Trace=false';
idquery = true;
reset   = true;

driver.Initialize(resourceDesc, idquery, reset, initOptions)
disp('M9703A Driver Initialized');

% Reference Clock Configuration
driver.DeviceSpecific.ReferenceOscillator.Source=ReferenceSource;

% Create pointers to trigger source objects
[pTrigSrc] = driver.DeviceSpecific.Trigger.Sources.Item(TriggerSource);

% Setup the trigger
driver.DeviceSpecific.Trigger.ActiveSource = TriggerSource;
pTrigSrc.Type = 'AgMD1TriggerEdge';
pTrigSrc.Level = TriggerLevel;

% Calibrate
if ~exist('DoCalibration','var') || DoCalibration
    disp('Calibrating Channels...');
    driver.DeviceSpecific.Calibration.SelfCalibrate(0,1);   % 0=AgMD1CalibrateTypeFull
    % Uncomment This section to calibrate all the channels
    %     for n=2:8
    %         driver.DeviceSpecific.Calibration.SelfCalibrate(0,n);   % 0=AgMD1CalibrateTypeFull
    %     end
end
InstrumentObj=driver;
