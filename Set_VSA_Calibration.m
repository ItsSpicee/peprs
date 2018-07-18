function Set_VSA_Calibration(rfSpacing,ifSpacing,trigTime,refFile,rfCenterFreq,rfCalStartFreq,rfCalStopFreq,loFreqOffset,saveLoc)
    Cal.RFToneSpacing = rfSpacing;
    Cal.IFToneSpacing = ifSpacing;
    Cal.LOFrequencyOffset = loFreqOffset;
    
    Cal.Reference.CombReferenceFile = refFile;
    Cal.Reference.RFCenterFrequency = rfCenterFreq;
    Cal.Reference.RFCalibrationStartFrequency = rfCalStartFreq;
    Cal.Reference.RFCalibrationStopFrequency = rfCalStopFreq;
    

    TX.FrameTime = trigTime;
    
    % save("C:\Users\leing\Documents\Laura\sup.mat","arbConfig")
    
end