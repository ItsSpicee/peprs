%% Acquisition from two digitizer channels
clf
clear

%% Set up some user defined variables
  SampleRateInHz = 1.6E9;
  PointsPerRecord = 65536/2; %2097152
  FullScaleRange = 1;
  ACDCCoupling = 1; % AC 0, DC 1, GND 2
  DecimatedSR = 1e8;
  Ch1CenterF = 2e8;
  Ch2CenterF = 2.1e8;
    
%% Create digitizer driver instance
  driver = instrument.driver.AgMD1();
   
%% Edit resource and options as needed.  Resource is ignored if option Simulate=true
  resourceDesc1 = 'PXI136::0::0::INSTR';
  
  initOptions = 'Simulate=false, DriverSetup= Cal=0, Trace=false';			
  idquery = true;
  reset   = true;
  driver.Initialize(resourceDesc1, idquery, reset, initOptions);
  disp('Module Initialized');

%% Create pointers to Channels channel and trigger source objects
  [pCh1] = driver.DeviceSpecific.Channels3.Item3('Channel1');
  [pCh2] = driver.DeviceSpecific.Channels3.Item3('Channel2');
  [pTrigSrc1] = driver.DeviceSpecific.Trigger.Sources.Item('External1');
    
%% Setup acquisition - Records must be 1 for Channel.Measurement methods.
%  For multiple records use Channel.MutiRecordMeasurement methods.
  driver.DeviceSpecific.Acquisition.ConfigureAcquisition(1, PointsPerRecord, SampleRateInHz); % Records, PointsPerRecord, SampleRate
  
%% Configure channels
  pCh1.Configure(FullScaleRange, 0.0, ACDCCoupling, true); % Range, Offset, Coupling, Enabled
  pCh2.Configure(FullScaleRange, 0.0, ACDCCoupling, true); % Range, Offset, Coupling, Enabled

%% Setup triggering
  driver.DeviceSpecific.Trigger.ActiveSource = 'External1';
  pTrigSrc1.Type = 'AgMD1TriggerEdge';
  
%% Setup channel impedance
  pCh1.InputImpedance = 50;
  pCh2.InputImpedance = 50;
  
%% Setup External Clock from AXIe backplane (sync with source)
driver.DeviceSpecific.ReferenceOscillator.Source = 4; % 10 MHz AXIe backplane clock
    
%% Enable Downconversion (will coerce all other channels to DDC)
  pCh1.Downconversion.Enabled = 1;
  
%% set DDC output sample rate
  driver.DeviceSpecific.Acquisition.SampleRate = DecimatedSR;
  
%% Set center freqencies
  pCh1.Downconversion.CenterFrequency = Ch1CenterF;
  pCh2.Downconversion.CenterFrequency = Ch2CenterF;

%% Calibrate
  disp('Calibrating Channels...');
  driver.DeviceSpecific.Calibration.SelfCalibrate(4,0);   % 0=AgMD1CalibrateTypeFull 4=AgMD1CalibrateTypeFast
  
%% Size waveform array as required and initiate acquisition
  arrayElements = driver.DeviceSpecific.Acquisition.QueryMinWaveformMemory(32,1,0,PointsPerRecord);
  WaveformArrayCh1 = zeros(arrayElements,1);
  WaveformArrayCh2 = zeros(arrayElements,1);
  
% Initialize the acquisition
  sprintf('Measuring ...')
  driver.DeviceSpecific.Acquisition.Initiate;
 
%% Wait for 1 second for the acquisition to complete, 
%  if there is no trigger, send a software trigger
  try
   driver.DeviceSpecific.Acquisition.WaitForAcquisitionComplete(1000);
  catch exception
   driver.DeviceSpecific.Trigger.SendSoftwareTrigger;
   disp('No trigger detected on module 1, forcing software trigger');
   driver.DeviceSpecific.Acquisition.WaitForAcquisitionComplete(1000);
  end
         
%% Fetch the acquisition waveform data 
  [WaveformArrayCh1,ActualPoints,FirstValidPoint1,InitialXOffset1,InitialXTimeSeconds1,InitialXTimeFraction1,XIncrement] = pCh1.Measurement.FetchWaveformInt32(WaveformArrayCh1);
  [WaveformArrayCh2,ActualPoints,FirstValidPoint2,InitialXOffset2,InitialXTimeSeconds2,InitialXTimeFraction2,XIncrement] = pCh2.Measurement.FetchWaveformInt32(WaveformArrayCh2);

%% Create complex arrays
for i=1:ActualPoints
    CompCh1(i,1) = double(complex(WaveformArrayCh1(1,((2*i)-1)), WaveformArrayCh1(1,(2*i))));
    CompCh2(i,1) = double(complex(WaveformArrayCh2(1,((2*i)-1)), WaveformArrayCh2(1,(2*i))));
end

%% Generate FFT of magnitude values (shifting the zero point to the centre frequency)
Ch1FFT = abs(fftshift(fft(CompCh1)));
Ch2FFT = abs(fftshift(fft(CompCh2)));

%% Generate FFT x-axis values
FminCh1 = Ch1CenterF - (DecimatedSR/2);
FminCh2 = Ch2CenterF - (DecimatedSR/2);
Ch1freq = linspace(FminCh1, (FminCh1 + DecimatedSR), length(Ch1FFT));
Ch2freq = linspace(FminCh2, (FminCh2 + DecimatedSR), length(Ch2FFT));
    
%% Display the waveforms
  p = semilogy(Ch1freq, Ch1FFT);
  set(p,'Color','red')
  hold('all');
  semilogy(Ch2freq, Ch2FFT);
  
%% Close driver session
driver.Close;

%% Create a savefile name and save the waveform arrays
%  (can be changed to include initial X offset etc.)
SaveFileName = sprintf('C:\\temp\\MATLAB_MeasurementData_%s.mat', date);  
save(SaveFileName, 'WaveformArrayCh1', 'WaveformArrayCh2');