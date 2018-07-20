function Set_AWG_Calibration(dict)
    load(".\Measurement Data\AWG Calibration Parameters\Cal.mat")
    Cal.NumIterations = dict.noIterations;
    Cal.Signal.ToneSpacing = toneSpacing;
    Cal.Signal.StartingToneFreq = startFreq;
    Cal.Signal.EndingToneFreq = endFreq;
    Cal.Fres = freqRes; % Frequency resolution to use to search for the tones
    save(".\Measurement Data\AWG Calibration Parameters\Cal.mat","Cal")
end

% 
% d= {
%     # "realFlag" : self.ui.realBasisFlag_awgCal.text(),
%     # "phaseDistr" : self.ui.phaseDistr_awgCal.text(),
%     # "" : self.ui.freqRes_awgCal.text()
%     # "saveLoc" : self.ui.awgCalSaveLocField_vsgMeas.text()
% # }