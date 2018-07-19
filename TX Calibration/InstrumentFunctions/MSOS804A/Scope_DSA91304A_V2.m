function [ obj ] = Scope_DSA91304A_V2(Scope_Driver, fSample, PointsPerRecord)

%%

driver        = Scope_Driver.driver;
obj.handle{1} = Scope_Driver.obj.handle{1};
interfaceObj  = Scope_Driver.interfaceObj;


%%

fprintf(interfaceObj,':AUTOSCALE');
fprintf(interfaceObj,[':ACQuire:SRATe ' num2str(fSample)]); 
fprintf(interfaceObj,[':ACQuire:POINts ' num2str(2*PointsPerRecord)]);
fprintf(interfaceObj,':ACQuire:AVERage ON');
fprintf(interfaceObj,':ACQuire:COUNt 100');

pause(5);
driver.Acquisition.NumberOfPointsMin = 2*PointsPerRecord;
%driver.Acquisition.NumberOfAverages  = 1;

%%

obj.handle{1}.Channel(1).Enabled = 'on';
% obj.handle{1}.Channel(2).Enabled = 'on';
% obj.handle{1}.Channel(3).Enabled = 'on';
% obj.handle{1}.Channel(4).Enabled = 'on';     

%             driver.Acquisition.TimePerRecord = obj.tstop_measure;
%             driver.Acquisition.StartTime = obj.tstart_measure;
obj.handle{1}.Trigger.Continuous = 'off';     

 % Analyze Measurement
 % 1- Read waveforms
[statusval] = invoke(obj.handle{1}.Measurements, 'Status', obj.handle{1}.Measurements);
if(int32(statusval)~=0)
    % Read the first waveform from the analog channel.
    obj.Ch1_Waveform = invoke(obj.handle{1}.Measurement(1), 'FetchWaveform');
%     obj.Ch2_Waveform = invoke(obj.handle{1}.Measurement(2), 'FetchWaveform');
%     obj.Ch3_Waveform = invoke(obj.handle{1}.Measurement(3), 'FetchWaveform');
%     obj.Ch4_Waveform = invoke(obj.handle{1}.Measurement(4), 'FetchWaveform');
else
    error('instrument:demo_iviscope:Acquire','Cannot acquire waveform. Check input signal.')
end

% 2- Adjust Range and Offset
Ch1_Range = abs(max(obj.Ch1_Waveform) - min(obj.Ch1_Waveform));
% Ch2_Range = abs(max(obj.Ch2_Waveform) - min(obj.Ch2_Waveform));
% Ch3_Range = abs(max(obj.Ch3_Waveform) - min(obj.Ch3_Waveform));
% Ch4_Range = abs(max(obj.Ch4_Waveform) - min(obj.Ch4_Waveform));

obj.handle{1}.Channel(1).Range = Ch1_Range*1.2;
% obj.handle{1}.Channel(2).Range = Ch2_Range*1.2;
% obj.handle{1}.Channel(3).Range = Ch3_Range*1.2;
% obj.handle{1}.Channel(4).Range = Ch4_Range*1.2;

obj.handle{1}.Channel(1).Offset = (max(obj.Ch1_Waveform) + min(obj.Ch1_Waveform))/2;
% obj.handle{1}.Channel(2).Offset = (max(obj.Ch2_Waveform) + min(obj.Ch2_Waveform))/2;
% obj.handle{1}.Channel(3).Offset = (max(obj.Ch3_Waveform) + min(obj.Ch3_Waveform))/2;
% obj.handle{1}.Channel(4).Offset = (max(obj.Ch4_Waveform) + min(obj.Ch4_Waveform))/2;
% % 
% fprintf(interfaceObj,':AUTOSCALE');
% fprintf(interfaceObj,':ACQuire:SRATe 10E+9'); 
% fprintf(interfaceObj,':ACQuire:POINts 100E+3');
% fprintf(interfaceObj,':ACQuire:AVERage OFF');

obj.handle{1}.Trigger.Continuous = 'on';  
pause(1);
obj.handle{1}.Trigger.Continuous = 'off';  

[statusval] = invoke(obj.handle{1}.Measurements, 'Status', obj.handle{1}.Measurements);
if(int32(statusval)~=0)driver.Acquisition.NumberOfPointsMin = 10e06;

    % Read the first waveform from the analog channel.
    obj.Ch1_Waveform = driver.Measurements.Item('Channel1').FetchWaveform();
%     obj.Ch2_Waveform = driver.Measurements.Item('Channel2').FetchWaveform();
%     obj.Ch3_Waveform = driver.Measurements.Item('Channel3').FetchWaveform();
%     obj.Ch4_Waveform = driver.Measurements.Item('Channel4').FetchWaveform();
else
    error('instrument:demo_iviscope:Acquire','Cannot acquire waveform. Check input signal.')
end

Measurement_start_time = driver.Acquisition.StartTime;
Measurement_stop_time  = driver.Acquisition.TimePerRecord;
Measurement_num_points = driver.Acquisition.RecordLength;          
time = Measurement_start_time:(Measurement_stop_time - Measurement_start_time)/(Measurement_num_points-1):Measurement_stop_time;
obj.Time = time; 
obj.fs   = driver.Acquisition.SampleRate;

end

