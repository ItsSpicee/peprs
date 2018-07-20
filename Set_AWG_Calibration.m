function Set_AWG_Calibration(dict)
    load(".\Measurement Data\AWG Calibration Parameters\Cal.mat")
    Cal.NumIterations = dict.noIterations;
    Cal.Signal.ToneSpacing = dict.toneSpacing;
    Cal.Signal.StartingToneFreq = dict.startFreq;
    Cal.Signal.EndingToneFreq = dict.endFreq;
    Cal.Fres = dict.freqRes; % Frequency resolution to use to search for the tones
    if dict.realFlag == 1
        Cal.Signal.MultitoneOptions.RealBasisFlag = 1;
    elseif dict.realFlag == 2
        Cal.Signal.MultitoneOptions.RealBasisFlag = 0;
    end
    if dict.phaseDistr == 1
        Cal.Signal.MultitoneOptions.PhaseDistr = "Schroeder";
    elseif dict.phaseDistr == 2
        Cal.Signal.MultitoneOptions.PhaseDistr = "Gaussian";
    end
    Cal.SaveLocation = dict.saveLoc;
    save(".\Measurement Data\AWG Calibration Parameters\Cal.mat","Cal")
end