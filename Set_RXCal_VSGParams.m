% max sample rate for AWG is 12e9: 12 bit mode and 320 minimum segment
% length
% max sample rate is 8e9: 14 bit mode and 240 min segment length

function Set_RXCal_VSGParams(type,model,sampleRate,refClockSrc,extRefClockFreq)
    load(".\Measurement Data\RX Calibration Parameters\TX.mat")   
    % Choose between 'AWG' (VSG not ready)
   if type == 1 || type == 2 || type == 3
       TX.Type = "AWG";
   elseif type == 4
       TX.Type = "VSG";
   end
   TX.AWG_Model = model; % Choose bewteen 'M8190A' and 'M8195A', only use M8190A
   TX.Fsample = sampleRate; % AWG max sample rate
   % Minimum AWG segment length
   if dict.sampleRate == 8e9
       TX.MinimumSegmentLength = 240;
   elseif dict.sampleRate == 12e9
       TX.MinimumSegmentLength = 320;
   end
   TX.ReferenceClockSource = refClockSrc; % Choose between 'Backplane', 'Internal', 'External'
   TX.ReferenceClock = extRefClockFreq; % External reference clock frequency
   save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX") 
   % minimum segment length calculation --> model
end