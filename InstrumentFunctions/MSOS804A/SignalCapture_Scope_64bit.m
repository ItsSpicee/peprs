function [ obj ] = SignalCapture_Scope_64bit(RX, autoscaleFlag)

interfaceObj = ScopeInit_64bit( RX );

% Initialize Variables
channelVec = RX.channelVec;
PointsPerRecord = RX.Analyzer.PointsPerRecord;
fSample = RX.Analyzer.Fsample;
clockRef = RX.EnableExternalReferenceClock;
triggerChannel = RX.TriggerChannel;
%%
if autoscaleFlag
    % Auto Sclae The Scope
    fprintf(interfaceObj,':AUTOSCALE');
    % Set The Sampling Rate
    fprintf(interfaceObj,[':ACQuire:SRATe ' num2str(fSample)]); 
    % In Real Time Normal mode (RTIMe), the complete data record is 
    % acquired on a single trigger event.
    fprintf(interfaceObj,':ACQuire:MODE RTIMe');
    % Wait For The Scope To Finish Acquiring The Data Until 100% Complete
    fprintf(interfaceObj,':ACQuire:COMPlete 100');
    % Scale The Time Axis
    fprintf(interfaceObj,[':TIMebase:SCALe ',num2str(PointsPerRecord/fSample/10)]);
    % Set The Number Of Points To Be Acquired
    fprintf(interfaceObj,[':ACQuire:POINts ' num2str(PointsPerRecord)]);
    % Enable or disable the reference clock 
    fprintf(interfaceObj,[':TIMebase:REFClock ', num2str(clockRef)]);
    % Set The Trigger To Be Edge Triggered
    fprintf(interfaceObj,':TRIGger:MODE EDGE');
    % Set The Trigger To Be On Fallinf Edge
    fprintf(interfaceObj,':TRIGger:EDGE:SLOPe POS');
    
    % Set The Trigger Channel To Be In The Back Of the Scope Or On Of The
    % Input Channels
    if (triggerChannel == 0)
        fprintf(interfaceObj,':TRIGger:EDGE:SOURCE AUX');
        fprintf(interfaceObj,':TRIGger:LEVEL AUX,0.25');    
        fprintf(interfaceObj,':TRIGger:HTHReshold AUX,0.25');
    else
        fprintf(interfaceObj,[':TRIGger:EDGE:SOURCE CHANnel' num2str(triggerChannel)]);
        fprintf(interfaceObj,[':TRIGger:LEVEL CHAN' num2str(triggerChannel) ',0.25']);    
        fprintf(interfaceObj,[':TRIGger:HTHReshold CHAN' num2str(triggerChannel) ',0.25']);
    end

    % Enable Averaging
    fprintf(interfaceObj,':ACQuire:AVERage ON');
    % Set Averaging To 100
    fprintf(interfaceObj,':ACQuire:COUNt 100');



    % Set The Received Data To Be Format Word
    fprintf(interfaceObj, ':WAVeform:FORMat WORD');
    % Set The First Received Byte To Be The LSB
    fprintf(interfaceObj, ':WAVeform:BYTeorder LSBFirst');
    
    % Set The Receiving Channels According To channelVec
    CHANnel = [];
    for i = 1:1:length(channelVec)
        if channelVec(i)>0
            CHANnel = [CHANnel; 'CHANnel' num2str(i)];
        end
    end
    DIGitize = CHANnel(1,:);
    for i = 2:length(CHANnel(:,1))
        DIGitize = [DIGitize ', ' CHANnel(i,:)];
    end
    
    % Turn Off the Scope Screen To Speed Up Acquisition And Enable The
    % Selected Channels
    fprintf(interfaceObj, [':DIGitize ' DIGitize]);
    
    % Acquire The DATA
    for i = 1:length(CHANnel(:,1))
        % Select The Channel To Acquire
        fprintf(interfaceObj, [':WAVeform:SOURce ' CHANnel(i,:)]);
        % Acquire The DATA Preamle That Contains The Yaxis Scale the Xaxis
        % Scale and Other Scope Parameters
        preambleBlock = query(interfaceObj,':WAVEFORM:PREAMBLE?');
        % Ask The Scope For the Waveform DATA
        fprintf(interfaceObj, ':WAVeform:DATA?');
        % Acquire The DATA Using int16 Format
        data = binblockread(interfaceObj, 'int16');
        % End The Communication With The Scope
        Junk = fread(interfaceObj, 1, 'uint8');
        
        % Demodulate The Preamble DATA
        preambleBlock = regexp(preambleBlock,',','split');
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Set The Yaxis Max Value, int16 ==> 2^16;
        maxVal = 2^16;
        % Scope Format, This Should be 2 since we're specifying WORD Format
        ScopeData.Format = str2double(preambleBlock{1});
        ScopeData.Type = str2double(preambleBlock{2});
        % Points, This Must Be Equal To PointsPerRecord
        ScopeData.Points = str2double(preambleBlock{3});
        % This is always 1
        ScopeData.Count = str2double(preambleBlock{4}); 
        % The Xaxis in TIME
        ScopeData.XIncrement = str2double(preambleBlock{5});
        ScopeData.XOrigin = str2double(preambleBlock{6}); % in Time
        ScopeData.XReference = str2double(preambleBlock{7});
        % The Yaxis in Voltage
        ScopeData.YIncrement = str2double(preambleBlock{8}); % Voltage
        ScopeData.YOrigin = str2double(preambleBlock{9});
        ScopeData.YReference = str2double(preambleBlock{10});
        % Get VoltsPerDiv, The Sope Yaxis Has 8 Devision
        ScopeData.VoltsPerDiv = (maxVal * ScopeData.YIncrement /8); % V
        ScopeData.Offset = ((maxVal/2 - ScopeData.YReference) * ScopeData.YIncrement + ScopeData.YOrigin); % V
        % Get SecPerDiv, The Sope Yaxis Has 8 Devision
        ScopeData.SecPerDiv = ScopeData.Points * ScopeData.XIncrement/10 ; % seconds
        ScopeData.Delay = ((ScopeData.Points/2 - ScopeData.XReference) * ScopeData.XIncrement + ScopeData.XOrigin); % seconds
        % Scale the ScopeData
        ScopeData.Time = (ScopeData.XIncrement.*(1:length(data))') - ScopeData.XIncrement;
        ScopeData.Volt = (data - ScopeData.YReference) .* ScopeData.YIncrement + ScopeData.YOrigin;
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % The Structure Index Would be The Channel Index
        index = str2num(CHANnel(i,end));
        % Assign The WaveForm To obj structure
        obj.Ch_Waveform{index}= ScopeData.Volt;

    end
    % Turn Back The Screen On After Acquiring The DATA
    fprintf(interfaceObj,':AUTOSCALE');
end

end

