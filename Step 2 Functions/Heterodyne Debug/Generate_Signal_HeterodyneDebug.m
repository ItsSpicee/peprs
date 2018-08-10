function error = Generate_Signal_HeterodyneDebug()
    load('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
    error = '';
    try
        [ TrainingSignal ] = GenerateMultitoneSignal( Cal.Signal.StartingToneFreq, Cal.Signal.ToneSpacing, Cal.Signal.EndingToneFreq, ...
            TX.FrameTime, TX.Fsample, Cal.Signal.MultitoneOptions );
        VerificationSignal = TrainingSignal(end:-1:1);
        PlotSpectrum(TrainingSignal,VerificationSignal,TX.Fsample);
    catch
        error = 'There was a problem while attempting to generate multi-tone signal';
    end
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
end