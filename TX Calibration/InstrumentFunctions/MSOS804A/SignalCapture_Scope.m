function [ obj ] = SignalCapture_Scope(Scope_Driver, fSample, PointsPerRecord, clockRef, autoscaleFlag, triggerChannel)
if nargin < 5
    autoscaleFlag = 1;
end
if nargin < 6
    triggerChannel = 3;
end

%%

driver        = Scope_Driver.driver;
obj.handle{1} = Scope_Driver.obj.handle{1};
interfaceObj  = Scope_Driver.interfaceObj;


%%
if autoscaleFlag
    % Autoscale the range
    fprintf(interfaceObj,':AUTOSCALE');
    % fprintf(interfaceObj,'CHANnel1:SCALe 50E-3');
    % Set the analog sampling rate
    fprintf(interfaceObj,[':ACQuire:SRATe ' num2str(fSample)]); 
    % Set the number of points to capture
    fprintf(interfaceObj,[':ACQuire:POINts ' num2str(PointsPerRecord)]);
    % Enable or disable the reference clock 
    fprintf(interfaceObj,[':TIMebase:REFClock ', num2str(clockRef)]);
    % Enable triggering
%     fprintf(interfaceObj,[':TRIGger:AND:ENABle ON']);
    % Set the trigger to look for the rising edge on the auxiliary trigger
    fprintf(interfaceObj,[':TRIGger:MODE EDGE']);
%         fprintf(interfaceObj,[':TRIGger:HTHReshold CHAN3,0.25']);
    fprintf(interfaceObj,[':TRIGger:EDGE:SOURCE CHANnel' num2str(triggerChannel)]);    
    fprintf(interfaceObj,[':TRIGger:LEVEL CHAN' num2str(triggerChannel) ',0.25']);    
    fprintf(interfaceObj,[':TRIGger:HTHReshold CHAN' num2str(triggerChannel) ',0.25']);
    fprintf(interfaceObj,':ACQuire:AVERage ON');
    fprintf(interfaceObj,':ACQuire:COUNt 100');

    pause(10); % Allow the instrument to adjust to the values
    driver.Acquisition.NumberOfPointsMin = PointsPerRecord;
    %driver.Acquisition.NumberOfAverages  = 1;
end
%%

obj.handle{1}.Channel(1).Enabled = 'on';
% obj.handle{1}.Channel(2).Enabled = 'on';
% obj.handle{1}.Channel(3).Enabled = 'on';
% obj.handle{1}.Channel(4).Enabled = 'on';     

%             driver.Acquisition.TimePerRecord = obj.tstop_measure;
%             driver.Acquisition.StartTime = obj.tstart_measure;
% obj.handle{1}.Trigger.Continuous = 'off';     

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
obj.handle{1}.Channel(1).Range = Ch1_Range * 1.8;
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
pause(10);
obj.handle{1}.Trigger.Continuous = 'off';  

[statusval] = invoke(obj.handle{1}.Measurements, 'Status', obj.handle{1}.Measurements);
if(int32(statusval)~=0)
%     driver.Acquisition.NumberOfPointsMin = 10e06;
    % Read the first waveform from the analog channel.
    %pause(15)
    obj.Ch1_Waveform = driver.Measurements.Item('Channel1').FetchWaveform();
%     obj.Ch2_Waveform = driver.Measurements.Item('Channel2').FetchWaveform();
%     obj.Ch3_Waveform = driver.Measurements.Item('Channel3').FetchWaveform();
%     obj.Ch4_Waveform = driver.Measurements.Item('Channel4').FetchWaveform();
else
    error('instrument:demo_iviscope:Acquire','Cannot acquire waveform. Check input signal.')
end

% Measurement_start_time = driver.Acquisition.StartTime;
% Measurement_stop_time  = driver.Acquisition.TimePerRecord;
% Measurement_num_points = driver.Acquisition.RecordLength;          
% time = Measurement_start_time:(Measurement_stop_time - Measurement_start_time)/(Measurement_num_points-1):Measurement_stop_time;
% obj.Time = time; 
obj.fs   = driver.Acquisition.SampleRate;

end

