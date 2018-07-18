    
    % Create driver instance
    driver = instrument.driver.AgMD1();

    % Edit resource and options as needed.  Resource is ignored if option Simulate=true
    resourceDesc = 'PXI21::0::0::INSTR';

    initOptions = 'Simulate=false, DriverSetup= Cal=0, Trace=false';			
    idquery = true;
    reset   = true;

    driver.Initialize(resourceDesc, idquery, reset, initOptions);
    disp('Driver Initialized');
    %Downconversion Configuration
    ChannelUsed='Channel1';
    DownconversionEnabled=1;
    DownconversionFrequency=100e6;
    Configure(driver.DeviceSpecific.Channels3.Item3(ChannelUsed).Downconversion,DownconversionEnabled,DownconversionFrequency);
    
    %Reference Clock Configuration
    driver.DeviceSpecific.ReferenceOscillator.Source='AgMD1ReferenceOscillatorSourceExternal'; %use 'AgMD1ReferenceOscillatorSourceInternal' for internal reference
    
      
    
%     driver.DeviceSpecific.Acquisition.Mode='AgMD1AcquisitionModeDownconverter'; %to be used for normal aquisition 'AgMD1AcquisitionModeNormal'


%     % Print a few IIviDriver.Identity properties
%     disp(['Identifier:      ', driver.Identity.Identifier]);
%     disp(['Revision:        ', driver.Identity.Revision]);
%     disp(['Vendor:          ', driver.Identity.Vendor]);
%     disp(['Description:     ', driver.Identity.Description]);
%     disp(['InstrumentModel: ', driver.Identity.InstrumentModel]);
%     disp(['FirmwareRev:     ', driver.Identity.InstrumentFirmwareRevision]);
%     simulate = driver.DriverOperation.Simulate;
%     if simulate == true
% 		disp(blanks(1));
% 		disp('Simulate:        True');
%     else
%         disp('Simulate:        False');
%     end
%     disp(blanks(1));
    
    % Create pointers to Channel1 channel and trigger source objects
    [pCh1] = driver.DeviceSpecific.Channels.Item('Channel1');
    [pTrigSrc] = driver.DeviceSpecific.Trigger.Sources.Item('External1');
    pTrigSrc.Level=0.5; %set the trigger level to 0.4V
    
	% Setup acquisition - Records must be 1 for Channel.Measurement methods.
	% For multiple records use Channel.MutiRecordMeasurement methods.
    PointsPerRecord = 189888;
    driver.DeviceSpecific.Acquisition.WaitForAcquisitionComplete(-1);
	driver.DeviceSpecific.Acquisition.ConfigureAcquisition(1, PointsPerRecord, 0.25E9); % Records, PointsPerRecord, SampleRate
    pCh1.Configure(1.0, 0.0, 1, true); % Range, Offset, Coupling, Enabled

	% Setup triggering
% 	driver.DeviceSpecific.Trigger.ActiveSource = 'Channel1';
%     pTrigSrc.Type = 'AgMD1TriggerImmediate';

    % Calibrate and measure waveform
    disp('Calibrating Channel1...');
    driver.DeviceSpecific.Calibration.SelfCalibrate(0,1);   % 0=AgMD1CalibrateTypeFull
    
     % Size waveform array as required and measure
    arrayElements = driver.DeviceSpecific.Acquisition.QueryMinWaveformMemory(64,1,0,PointsPerRecord);
    WaveformArray = zeros(arrayElements,1);
    disp('Measuring Waveform on Channel1...');
 	[WaveformArray,ActualPoints,FirstValidPoint,InitialXOffset,InitialXTimeSeconds,InitialXTimeFraction,XIncrement] = pCh1.Measurement.ReadWaveformReal64(10000, WaveformArray );
    
    starting=int32(FirstValidPoint)+1;
%     ending=int32(ActualPoints);
    RecI=WaveformArray(starting:2:end-1);
    RecQ=WaveformArray(starting+1:2:end);
    
    figure();      
    plot(WaveformArray(starting:2:ending))
    figure();      
    plot(WaveformArray(starting+1:2:ending))
    
% 	voltsMax = pCh1.Measurement.FetchWaveformMeasurement(6); % 6=AgMD1MeasurementVoltageMax
%     voltsMin = pCh1.Measurement.FetchWaveformMeasurement(7); % 7=AgMD1MeasurementVoltageMin
% 	voltsAvg = pCh1.Measurement.FetchWaveformMeasurement(10); % 10=AgMD1MeasurementVoltageAverage
%     disp(blanks(1));

%     % Output results
%     disp(['VMax: ', num2str(voltsMax), '    VMin: ', num2str(voltsMin), '    VAvg: ', num2str(voltsAvg)])
%     disp(blanks(1));
%     disp(['WaveformArray Points: ', num2str(ActualPoints), '   Voltage Data:']);
%     % Print Waveform.  Array may be larger than actual data so
%     % use FirstValidPoint and ActualPoints.
%     for  n = int32(FirstValidPoint)+1:int32(ActualPoints)
%         fprintf(' %s,', num2str(WaveformArray(n)));
%     end
%     fprintf('\n\n');



    driver.Close();
    disp('Driver Closed');




