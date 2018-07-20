% max sample rate for AWG is 12e9: 12 bit mode and 320 minimum segment
% length
% max sample rate is 8e9: 14 bit mode and 240 min segment length
% OLD CODE: TX.MinimumSegmentLength = lcm(240,320);  

function Set_RXCal_VSGParams(dict)
    load(".\Measurement Data\RX Calibration Parameters\TX.mat")   
    % Choose between 'AWG' (VSG not ready)
   if dict.type == 1 || dict.type == 2 || dict.type == 3
       TX.Type = "AWG";
   elseif dict.type == 4
       TX.Type = "VSG";
   end
   TX.AWG_Model = dict.model; % Choose bewteen 'M8190A' and 'M8195A', only use M8190A
   TX.Fsample = dict.sampleRate; % AWG max sample rate
   % Minimum AWG segment length
   if dict.sampleRate == 8e9
       TX.MinimumSegmentLength = 240;
   elseif dict.sampleRate == 12e9
       TX.MinimumSegmentLength = 320;
   end
   % Choose between 'Backplane Ref.', 'Internal Ref.', 'External Ref.', and 'External'
   if dict.refClockSrc == 1
       TX.ReferenceClockSource = "AxieRef";
   elseif dict.refClockSrc == 2
       TX.ReferenceClockSource = "ExtRef";
   elseif dict.refClockSrc == 3
       TX.ReferenceClockSource = "IntRef";   
   elseif dict.refClockSrc == 4
       TX.ReferenceClockSource = "ExtClk"; 
   end
   TX.ReferenceClock = dict.extRefClockFreq; % External reference clock frequency
   save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX") 
   % minimum segment length calculation --> model
end