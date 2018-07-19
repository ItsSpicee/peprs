function Set_RXCal_VSGParams(type,model,sampleRate,refClockSrc,extRefClockFreq)
    load(".\Measurement Data\RX Calibration Parameters\TX.mat")   
    % Choose between 'AWG' (VSG not ready)
   if type == 1 || type == 2 || type == 3
       TX.Type = "AWG";
   elseif type == 4
       TX.Type = "VSG";
   end
   TX.AWG_Model = model; % Choose bewteen 'M8190A' and 'M8195A'
   TX.Fsample = sampleRate; % AWG sample rate
   TX.ReferenceClockSource = refClockSrc; % Choose between 'Backplane', 'Internal', 'External'
   TX.ReferenceClock = extRefClockFreq; % External reference clock frequency
   save(".\Measurement Data\RX Calibration Parameters\TX.mat","TX") 
end