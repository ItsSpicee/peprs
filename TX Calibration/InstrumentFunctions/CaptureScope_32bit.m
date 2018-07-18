load('Scope_in.mat');
global Scope_Driver
PointsPerRecord = RX.Analyzer.PointsPerRecord;
scopeRefClock = 'OFF';
MSO_SamplingFrequency = 20e9;

[ obj ] = SignalCapture_Scope(Scope_Driver, MSO_SamplingFrequency, PointsPerRecord, scopeRefClock, autoscaleFlag, RX.TriggerChannel);
waveform = obj.Ch1_Waveform;
save('Scope_out.mat', 'waveform');
display('Scope is done')