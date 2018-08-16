function error = Analyze_Signal_HeterodyneDebug()
    load('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
    error = '';
    try
        % Resample the signal
        [DownSampleScope, UpSampleScope] = rat(TX.Fsample / RX.Analyzer.Fsample);
        Rec = resample(Rec, DownSampleScope, UpSampleScope);

        % Align and analyze the signals
        [ In_D_test, Out_D_test, NMSE_After] = AlignAndAnalyzeSignals( VerificationSignal, Rec, TX.Fsample, RX.alignFreqDomainFlag, RX.XCorrLength);
        display([ 'NMSE After          = ' num2str(NMSE_After)      ' % ' ]);
        data = sprintf('%f~%f~%f~%f',NMSE,dBnmse,TX.AWG.ExpansionMarginSettings.PAPR_original,TX.AWG.ExpansionMarginSettings.PAPR_input);
    catch
        error = 'A problem has occurred while attempting to perform the final downconvert, align, and anlyze signal.';
    end
    
%     result = sprintf('%s~%s',error,data);
    
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
end