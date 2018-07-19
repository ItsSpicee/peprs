% run when vsa calibration file needs to be generated
% sets comb generator parameters
% To generate structs:
% Cal = struct
% save(".\Measurement Data\RX Calibration Parameters\Cal.mat","Cal")

function Set_VSA_Calibration(rfSpacing,ifSpacing,refFile,rfCenterFreq,rfCalStartFreq,rfCalStopFreq,loFreqOffset,saveLoc,subRate)
    load(".\Measurement Data\RX Calibration Parameters\Cal.mat")
    Cal.RFToneSpacing = rfSpacing; % Spacing between the adjacent tones at RF
    Cal.IFToneSpacing = ifSpacing; % Spacing between the received adjacent tones
    Cal.LOFrequencyOffset = loFreqOffset; % Find the IF tones to fish out
    Cal.SaveLocation = saveLoc;
    Cal.SubRateFlag = subRate;
    Cal.Reference.CombReferenceFile = refFile; % Reference comb generator file
    Cal.Reference.RFCenterFrequency = rfCenterFreq; % Starting RF tone for calibration
    Cal.Reference.RFCalibrationStartFrequency = rfCalStartFreq; % Starting RF tone for calibration
    Cal.Reference.RFCalibrationStopFrequency = rfCalStopFreq; % Last RF tone for calibration
    save(".\Measurement Data\RX Calibration Parameters\Cal.mat","Cal")
    
    % IF = RF - LO
    % minimum segment length calculation --> model
    
end