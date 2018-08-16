function Set_SignalGen_Structures(txd,rxd,sd,algo)
    txd.FGuard = str2double(txd.FGuard);
    txd.FCarrier = str2double(txd.FCarrier);
    txd.FSampleDAC = str2double(txd.FSampleDAC);
    txd.NumberOfSegments = str2double(txd.NumberOfSegments);
    txd.GainExpansion = str2double(txd.GainExpansion);
    txd.FreqMultiplierFactor = str2double(txd.FreqMultiplierFactor);
    txd.ReferenceClock = str2double(txd.ReferenceClock);
    txd.VFS = str2double(txd.VFS);
    txd.TriggerAmplitude = str2double(txd.TriggerAmplitude);
    rxd.FCarrier = str2double(rxd.FCarrier);
    rxd.MeasuredPeriods = str2double(rxd.MeasuredPeriods);
    rxd.FSample = str2double(rxd.FSample);
    rxd.xLength = str2double(rxd.xLength);
    rxd.TriggerChannel = str2double(rxd.TriggerChannel);
    
    % load RX parameters from SetRXParameters_GUI and pass them to prechar
    % setup
    load('.\DPD Data\Algorithm Parameters\RX.mat')
    save('.\DPD Data\Precharacterization Setup Parameters\RX.mat','RX')
    clear('RX')
    
    %load structures
    if algo == "CalVal"
        load(".\DPD Data\Calibration Validation Parameters\Signal.mat","Signal")
        load('.\DPD Data\Calibration Validation Parameters\RX.mat',"RX")
        load('.\DPD Data\Calibration Validation Parameters\TX.mat',"TX")
    elseif algo == "Prechar"
        load(".\DPD Data\Precharacterization Setup Parameters\Signal.mat","Signal")
        load('.\DPD Data\Precharacterization Setup Parameters\RX.mat',"RX")
        load('.\DPD Data\Precharacterization Setup Parameters\TX.mat',"TX")
    end
    
    %% Set Signal
    if sd.signalName == 1
        Signal.Name = "5G_NR_OFDM_50MHz";
    elseif sd.signalName == 2
        Signal.Name = "5G_NR_OFDM_100MHz";
    elseif sd.signalName == 3
        Signal.Name = "5G_NR_OFDM_200MHz";
    elseif sd.signalName == 4
        Signal.Name = "5G_NR_OFDM_400MHz";
    end

    %% SETTING TX 
    
    % Choose between 'AWG' (VSG not ready)
    if txd.Type == 1 || txd.Type == 2 || txd.Type == 3
	   TX.Type = "AWG";
    elseif txd.Type == 4
	   TX.Type = "VSG";
    end
    
    TX.AWG.Model = txd.Model;     % AWG Model 'M8190A', 'M8195A'
    TX.FGuard = txd.FGuard; % Guard band for ACPR Calculations
    TX.Fcarrier = txd.FCarrier; % AWG Fcarrier of the for the signal
    display(TX.Fcarrier)
    TX.AWG.FsampleDAC = txd.FSampleDAC;
    
    % Minimum segment length of the AWG frame
	if txd.FSampleDAC == 8e9
	   TX.AWG.MinimumSegmentLength = 240;
	elseif txd.FSampleDAC == 12e9
	   TX.AWG.MinimumSegmentLength = 320;
    end
    
    TX.AWG.NumberOfSegments = txd.NumberOfSegments; % Number of segments in the uploaded signal to the AWG
    
    % if AWG outputs both I and Q, TX.AWG.IQOutput is 1
    % ChannelSelectSettings == 2: channelMapping = [0 0; 1 0] ; %Set I to channel 2
    % ChannelSelectSettings == 1: channelMapping = [1 0; 0 1] ; %Set I to channel 1 
    % ChannelSelectSettings == 0: channelMapping = [1 1; 1 1] ; %Set RF to both channels 
    % else channelMapping = [1 0; 0 1] ; %Set I to channel 1 and Q to channel 2 
    % only need one channel, error checking done in GUI parameterFunctions
    % 1: None, 2: Channel 1, 3: Channel 2
    if txd.iChannel == 1 || txd.qChannel == 1 
        TX.AWG.ChannelSelectSettings = 0;
        TX.AWG.IQOutput = 0;
    elseif txd.iChannel == 2
        TX.AWG.ChannelSelectSettings = 1;
        TX.AWG.IQOutput = 1;
    elseif txd.iChannel == 3
        TX.AWG.ChannelSelectSettings = 2;
        TX.AWG.IQOutput = 1;
    end
    
    % the function for formatting the data type doesn't exist anymore,
    % currently irrelevant (AWG_M8190A_DAC_Format_Data)
    TX.AWG.DataFormat = 'DNRZ';
    
    % amplitude correction for the AWG (set to true - recommended)
    if txd.Amp_Corr == 1
        TX.AWG.Amp_Corr = true;
    else
        TX.AWG.Amp_Corr = false;
    end
    
    % Expansion of the original input signal to take into account for the expansion of the DPD
    if txd.GainExpansion_flag == 1
       TX.GainExpansion_flag = true; 
    else
       TX.GainExpansion_flag = false;  
    end
    TX.GainExpansion = txd.GainExpansion; % Expansion of the original input in dB
    
    % The TX contains a frequency multiplier
    if txd.FreqMutiplierFlag == 1
        TX.FreqMultiplier.Flag = true;
    else
        TX.FreqMultiplier.Flag = false;
    end 
    TX.FreqMultiplier.Factor = txd.FreqMultiplierFactor;

    % just hardcoard these for now
    TX.Outphasing.Flag = false;
    TX.AWG.SyncModuleFlag = 0;
    TX.AWG.Position = 1;
    
    % Choose between 'Backplane', 'Internal', 'External'
    if txd.ReferenceClockSource == 1
        TX.AWG.ReferenceClockSource = 'Backplane';
    elseif txd.ReferenceClockSource == 2
        TX.AWG.ReferenceClockSource = 'External';
    elseif txd.ReferenceClockSource == 3
        TX.AWG.ReferenceClockSource = 'Internal';
    end 
    TX.AWG.ReferenceClock = txd.ReferenceClock; % External reference clock frequency
    TX.AWG.VFS = txd.VFS; % AWG full scale voltage amp
    TX.AWG.TriggerAmplitude = txd.TriggerAmplitude; % Trigger signal amplitude
    
    %% SETTING RX
    % Choose between 'Digitizer', 'UXA', 'Scope' for the receiver
    if rxd.Type == 1 || rxd.Type == 5
        RX.Type = "Scope"; 
    elseif rxd.Type == 2 || rxd.Type == 6
        RX.Type = "Digitizer"; 
    elseif rxd.Type == 3 || rxd.Type == 4
        RX.Type = "UXA"; 
    end

    RX.Fcarrier = rxd.FCarrier; % Center frequency of the received modulated signal
    
    % If we are receiving the mirror signal then we have to take the conjugate of the spectrum
    if rxd.MirrorSignalFlag == 1 
        RX.MirrorSignalFlag = true;      
    else
        RX.MirrorSignalFlag = false;       
    end
    
    RX.VisaAddress = rxd.VisaAddress;

    RX.Analyzer.Fsample = rxd.FSample; % The sampling rate of the Digitzer when in non-downconversion mode
    RX.Analyzer.NumberOfMeasuredPeriods = rxd.MeasuredPeriods; % Number of measured frames;

    % Reduce sampling rate on the TOR. (1 = Normal Rate)
    if rxd.SubRate == 1
         RX.SubRate = 0;           
    else
        RX.SubRate = 1;
    end
    
    % If we are receiving at IF, then we downconvert digitally to process at
    % baseband. After downconversion, we need to filter the signal with a LPF
   % make path relative first
    if contains(rxd.DownconversionFilterFile,'\peprs\')
        refinedString = strsplit(rxd.DownconversionFilterFile,'\peprs\');
        pathString = refinedString(2);
        relativeString = char(strrep(pathString,'Measurement Data\','.\Measurement Data\'));
        RX.DownconversionFilterFile = relativeString;  
    else
        RX.DownconversionFilterFile = rxd.DownconversionFilterFile;
    end
    
    RX.TriggerChannel = rxd.TriggerChannel;
    if TX.AWG.Position == 1
        RX.TriggerChannel = 3;
    else
        RX.TriggerChannel = 3;
    end
    
    % Variables moved up from Send Signal and Measure
    if rxd.AlignFreqDomainFlag == 1
        RX.alignFreqDomainFlag = 1;
    else
        RX.alignFreqDomainFlag = 0;
    end
    RX.xCovLength = rxd.xLength;
    
    RX.PositiveDelayFlag = 1; % originally based off of Cal.Signal.TrainingLength, now just make sure it is 1
    
    if rxd.DemodSignalFlag == 1
        RX.VSA.DemodSignalFlag = true;
    else
        RX.VSA.DemodSignalFlag = false;
    end
    
    RX.VSA.ASMPath = rxd.ASMPath;
    RX.VSA.SetupFile = rxd.SetupFile;
    RX.VSA.DataFile = rxd.DataFile;
    
    if algo == "CalVal"
        save('.\DPD Data\Calibration Validation Parameters\RX.mat','RX')
        save('.\DPD Data\Calibration Validation Parameters\TX.mat','TX')
        save(".\DPD Data\Calibration Validation Parameters\Signal.mat","Signal")
    elseif algo == "Prechar"
        save('.\DPD Data\Precharacterization Setup Parameters\RX.mat','RX')
        save('.\DPD Data\Precharacterization Setup Parameters\TX.mat','TX')
        save(".\DPD Data\Precharacterization Setup Parameters\Signal.mat","Signal")
    end
end
