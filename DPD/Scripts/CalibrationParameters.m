% Load the AWG Calibration files
if (Cal.AWG.Calflag)
    TX.AWG_Correction_I  = load(Cal.AWG.CalFile_I);
    TX.AWG_Correction_Q  = load(Cal.AWG.CalFile_Q);
    Cal.AWG.ToneFreq_I = TX.AWG_Correction_I.tonesBaseband;
    Cal.AWG.RealCorr_I = real(TX.AWG_Correction_I.H_Tx_freq_inverse);
    Cal.AWG.ImagCorr_I = imag(TX.AWG_Correction_I.H_Tx_freq_inverse);
    Cal.AWG.ToneFreq_Q = TX.AWG_Correction_Q.tonesBaseband;
    Cal.AWG.RealCorr_Q = real(TX.AWG_Correction_Q.H_Tx_freq_inverse);
    Cal.AWG.ImagCorr_Q = imag(TX.AWG_Correction_Q.H_Tx_freq_inverse);
end

% Load the TX Calibration files
if (Cal.TX.Calflag && ~Cal.TX.IQCal)
    load(Cal.TX.CalFile);
    Cal.TX.ToneFreq = tonesBaseband;
    Cal.TX.RealCorr = real(H_Tx_freq_inverse);
    Cal.TX.ImagCorr = imag(H_Tx_freq_inverse);
    clear tonesBaseband H_Tx_freq_inverse H_Tx_freq_inverse
elseif (Cal.TX.Calflag && Cal.TX.IQCal)
    load(Cal.TX.CalFile);
    Cal.TX.Type = 'Freq_Domain';  %'Freq_Domain' or 'Time_Domain'
    
    if (strcmp(Cal.TX.Type,'Freq_Domain'))
        % Chooses which iteration of the IQ imbalance calibration file to use
        IQImbalIter = 4; 
        CalResults  = TX_CAL_RESULTS;
        Cal.TX.ToneFreq = CalResults(IQImbalIter).tones;
        Cal.TX.G11 = CalResults(IQImbalIter).G.G11;
        Cal.TX.G12 = CalResults(IQImbalIter).G.G12;
        Cal.TX.G21 = CalResults(IQImbalIter).G.G21; 
        Cal.TX.G22 = CalResults(IQImbalIter).G.G22;
    else
        Cal.TX = CalResults.TX_CAL_Results;
    end
    
    clear TX_CAL_RESULTS CalResults
end
    
TX.I_Offset    = 0;
TX.Q_Offset    = 0;

% Load the RX calibration file
if (Cal.RX.Calflag)
    load (Cal.RX.CalFile);
    Cal.RX.ToneFreq = tones_freq;
    Cal.RX.RealCorr = comb_I_cal;
    Cal.RX.ImagCorr = comb_Q_cal;
     
    clear tones_freq comb_I_cal comb_Q_cal
end