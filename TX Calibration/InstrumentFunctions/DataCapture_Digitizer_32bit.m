function [ReceivedData] = DataCapture_Digitizer_32bit (RX)
    repeat = 1;
    ReceivedData = [];
    if (strcmp(RX.Type,'Digitizer'))
        PointsPerRecord = (RX.FrameTime * RX.Fsample) * RX.NumberOfMeasuredPeriods;
        PeriodLength = (RX.FrameTime * RX.Fsample);
        WaveformArray_averaged = zeros(repeat, floor(PeriodLength));
        
        fftFreqResolution = Fs_adc/PointsPerRecord;    
        disp(['ADC Frequency Resolution: ' num2str(fftFreqResolution)]);
       
        for i = 1: repeat
            WaveformArray0 = ADC_capture_bel(1, 'temp' , RX.Driver, RX.Channel1, PointsPerRecord, RX.VFS, RX.ACDCCoupling, RX.EnableInterleaving, RX.Fsample);
            WaveformArray_averaged(i, :) = averaging_one_period(WaveformArray0, PeriodLength,  RX.Fsample, 0 );
        end

        time = toc;
        display(['End of ADC Measurment. Time: ' num2str(time) ' S']);

        [ WaveformArray_averaged, ~ ] = Delay_Alignment_bel(WaveformArray_averaged, Fs_adc, 0);
        
        ReceivedData = (sum(WaveformArray_averaged, 1)/repeat).';
    end
end