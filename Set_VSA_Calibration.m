% run when vsa calibration file needs to be generated
% sets comb generator parameters
% To generate structs:
% Cal = struct
% save(".\Measurement Data\RX Calibration Parameters\Cal.mat","Cal")

function Set_VSA_Calibration(dict)
    load(".\Measurement Data\RX Calibration Parameters\Cal.mat")
    Cal.RFToneSpacing = dict.rfSpacing; % Spacing between the adjacent tones at RF
    Cal.IFToneSpacing = dict.ifSpacing; % Spacing between the received adjacent tones
    Cal.LOFrequencyOffset = dict.loFreqOffset; % Find the IF tones to fish out
    Cal.SaveLocation = dict.saveLoc;
    Cal.SubRateFlag = dict.subRate;
    Cal.Reference.CombReferenceFile = dict.refFile; % Reference comb generator file
    Cal.Reference.RFCenterFrequency = dict.rfCenterFreq; % Starting RF tone for calibration
    Cal.Reference.RFCalibrationStartFrequency = dict.rfCalStartFreq; % Starting RF tone for calibration
    Cal.Reference.RFCalibrationStopFrequency = dict.rfCalStopFreq; % Last RF tone for calibration
    save(".\Measurement Data\RX Calibration Parameters\Cal.mat","Cal") 
end