% run when vsa calibration file needs to be generated
% sets comb generator parameters
% To generate structs:
% Cal = struct
% save(".\Measurement Data\RX Calibration Parameters\Cal.mat","Cal")

function Set_VSA_Calibration(dict)
    % convert strings to doubles    
    dict.rfSpacing = str2double(dict.rfSpacing);
    dict.ifSpacing = str2double(dict.ifSpacing);
    dict.loFreqOffset = str2double(dict.loFreqOffset);
    dict.freqRes = str2double(dict.freqRes);
    dict.spurStart = str2double(dict.spurStart);
    dict.spurSpacing = str2double(dict.spurSpacing);
    dict.spurEnd = str2double(dict.spurEnd);
    dict.smoothOrder = str2double(dict.smoothOrder);
    dict.rfCenterFreq = str2double(dict.rfCenterFreq);
    dict.rfCalStartFreq = str2double(dict.rfCalStartFreq);
    dict.rfCalStopFreq = str2double(dict.rfCalStopFreq);
    
    load(".\Measurement Data\RX Calibration Parameters\Cal.mat")
    Cal.RFToneSpacing = dict.rfSpacing; % Spacing between the adjacent tones at RF
    Cal.IFToneSpacing = dict.ifSpacing; % Spacing between the received adjacent tones
    Cal.LOFrequencyOffset = dict.loFreqOffset; % Find the IF tones to fish out
    Cal.SaveLocation = dict.saveLoc;
    if dict.subRate == 1
        Cal.SubRateFlag = 1;
    elseif dict.subRate == 2
        Cal.SubRateFlag = 0;
    end
    
    % Processing Parameters
    Cal.FreqRes = dict.freqRes; % FFT bin size
    if dict.despurFlag == 1
        Cal.DespurFlag = 1;  % Interpolate between the scope spurs
    elseif dict.despurFlag == 2
        Cal.DespurFlag = 0;
    end
    Cal.ScopeSpurs.ScopeSpurStart = dict.spurStart;
    Cal.ScopeSpurs.ScopeSpurSpacing = dict.spurSpacing;
    Cal.ScopeSpurs.ScopeSpurEnd = dict.spurEnd;
    if dict.smoothFlag == 1
        Cal.MovingAverageFlag = 1; % Smooth out the inverse frequency response
    elseif dict.smoothFlag == 2
        Cal.MovingAverageFlag = 0;
    end
    Cal.MovingAverageOrder = dict.smoothOrder; % Number of taps on the moving average filter
    
    Cal.Reference.CombReferenceFile = dict.refFile; % Reference comb generator file
    Cal.Reference.RFCenterFrequency = dict.rfCenterFreq; % Starting RF tone for calibration
    Cal.Reference.RFCalibrationStartFrequency = dict.rfCalStartFreq; % Starting RF tone for calibration
    Cal.Reference.RFCalibrationStopFrequency = dict.rfCalStopFreq; % Last RF tone for calibration
    save(".\Measurement Data\RX Calibration Parameters\Cal.mat","Cal") 
end