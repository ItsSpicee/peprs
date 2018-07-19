% creates struct for parameters set in VSA equipment tab that are used in the
% RX Calibration code

% PARAMETER MAPPING:
% Scope (3 params):
    % param1 = external reference clock enable
    % param2 = channel vector
    % param2 = autoscale flag
    % param3 = trigger channel
% Digitizer (4 params):
    % param1 = external clock enable
    % param2 = external clock freq
    % param3 = ACDC boupling
    % param4 = VFS
% UXA (4 params):
    % param1 = analysis bandwidth
    % param2 = attentuation
    % param3 = clock reference
    % param4 = trigger level

function Set_RXCal_VSAParams(type,iviDriver,address,param1,param2,param3,param4)
    typeName = "";
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    if type == 1 || type == 5
        typeName = "Scope"; 
        RX.EnableExternalReferenceClock = param1;
        RX.channelVec = param2;
        RX.Scope.autoscaleFlag = param3; 
        RX.TriggerChannel = param4;
    elseif type == 2 || type == 6
        typeName = "Digitizer";
        RX.EnableExternalClock = param1;
        RX.ExternalClockFrequency = param2; % For half rate 1.998 GSa/s, quarter rate 1.906 GSa/s
        RX.ACDCCoupling = param3;
        RX.VFS = param4; % Digitzer full scale peak to peak voltage reference (1 or 2 V)
    elseif type == 3 || type == 4
        typeName = "UXA";
        RX.UXA.AnalysisBandwidth = param1;
        RX.UXA.Attenuation = param2;
        RX.UXA.ClockReference = param3;
        RX.UXA.TriggerLevel = param4;
    end
    RX.Type = typeName; % Choose between 'UXA', 'Digitizer', 'Scope', for the receiver
    RX.ScopeIVIDriverPatch = iviDriver;
    RX.VisaAddress = address;
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end