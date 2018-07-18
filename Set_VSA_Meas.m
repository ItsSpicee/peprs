% Analysis bandwidth only for UXA. 
% If TX Related frame time is true, averaging is also true. 
% True then they set the No. Recorded Time Frames and measurement Time (Frame time) is calculated. 
% If it’s false, they specify the measurement time.

function Set_VSA_Meas(centerFreq,sampRate)  
    RX.Fcarrier = centerFreq;
    
    RX.Analyzer.Fsample = sampRate;
    
end