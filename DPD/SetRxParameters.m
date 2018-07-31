%% Set the RX parameters
if RX.FsampleOverwrite > 0
    if (RX.SubRate > 1)
        display('SubRate TOR analysis is selected. Ensure Fsample is overwritten.');
    end
    RX.Fsample = RX.FsampleOverwrite;
else
    RX.Fsample = Signal.Fsample;
end

% If we are using a sub-sampling TOR, use the fractional delay alignment
if RX.SubRate > 1
    FractionalDelayFlag = 1;
else
    FractionalDelayFlag = 0;
end
% Default subrate -- will be modified in another script if RX.Subrate >1
SubRate_O = 1;

% IF_Frequency                = 250e6;
RX.UXA.Downconverter_flag     = 0;    % Use UXA as a downconverter to feed the signal into the scope
RX.UXA.Downcversion_RF_Freq    = 28e9;% The RF frequency that the UXA is seeing at its RF input port when used in downconversion mode

% Signal analysis sampling rate
[Signal.DownsampleRX, Signal.UpsampleRX] = rat(Signal.Fsample/RX.Fsample/RX.SubRate);

% Downconversion filter if we receive at IF
if (~strcmp(RX.Type,'UXA'))
    load(RX.DownconversionFilterFile);
    RX.Filter = Num;
    clear Num
end

if (Cal.Processing32BitFlag)
    if (strcmp(RX.Type,'Scope'))
%         global Scope_Driver;
%         [Scope_Driver] = ScopeDriverInit( RX );        
    elseif (strcmp(RX.Type,'Digitzer'))
        [RX.Digitizer] = ADCDriverInit( RX );
    end
end

% If the UXA is used as a downconverter for the scope, then setup the UXA
if (RX.UXA.Downconverter_flag)
    UXA_Downconversion_Mode_Setup (RX.UXA.Downcversion_RF_Freq, RX.UXA.AnalysisBandwidth, ...
        RX.FrameTime, RX.VisaAddress, RX.UXA.Attenuation, RX.UXA.ClockReference)
end

autoscaleFlag = 1;
save('Scope_in.mat', 'RX', 'autoscaleFlag');

%% OLD CODE
% RX.Digitzer.interleaving_flag = 1;    % 1 if the interleaving is enabled
% 
% RX.UXA.Downconverter_flag     = 0;    % Use UXA as a downconverter to feed the signal into the scope
% RX.UXA.Downcversion_RF_Freq    = 28e9;% The RF frequency that the UXA is seeing at its RF input port when used in downconversion mode
% 
% % UXA Parameters
% RX.UXA.AnalysisBandwidth    = 1e9;
% RX.UXA.Attenuation          = 16;  % dB
% RX.UXA.ClockReference       = 'Internal';
% if (RX.UXA.AnalysisBandwidth > 500e6)
%     RX.UXA.TriggerPort      = 'EXT3';
% else
%     RX.UXA.TriggerPort      = 'EXT1';
% end
% RX.UXA.TriggerLevel         = 700; % mV
% 
% % Scope Parameters
% % RX.ScopeIVIDriverPath      = 'C:\Users\ybeltagy\Desktop\Yehia\Scope\AgilentInfiniium.mdd';
% RX.ScopeIVIDriverPath      = 'C:\Users\a38chung\Desktop\Scope\AgilentInfiniium.mdd';
% RX.EnableExternalReferenceClock = false;
% RX.channelVec = [1 0 1 0];
% 
% % When downconverting, a filter is applied which inserts 0's at the
% % beginning so we discard some points to avoid this. If there are no points
% % discarded then the delay should always be positive
% Cal.Signal.TrainingLength = 0;
% if (Cal.Signal.TrainingLength > 0)
%     RX.PositiveDelayFlag = 0;
% else
%     RX.PositiveDelayFlag = 1;
% end
% 
% % Digitizer Parameters
% RX.EnableExternalClock     = true;
% RX.ExternalClockFrequency  = 1.906e9;    % For half rate 1.998 GSa/s, quarter rate 1.906 GSa/s
% RX.ACDCCoupling            = 1;
% RX.VFS                     = 1;          % Digitzer full scale peak to peak voltage reference (1 or 2 V)
% if (RX.Fsample > 1e9)
%     RX.EnableInterleaving  = true;       % Enable interleaving
% end
