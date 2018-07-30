if IterationCount == 1 
    measured_periods = 1;
    repeat = 1;
elseif IterationCount> 1 && IterationCount<5
    measured_periods = 50;
    repeat = 1;
else
    measured_periods = 50;
    repeat = 10;
end

PointsPerRecord = floor(FramTime*Digitizer_SamplingFrequency) * measured_periods;
%[WaveformArray0] = M9703A_Acquisition_bel(M9703A_Obj, Channel1, PointsPerRecord , Digitizer_SamplingFrequency, FullScaleRange, ACDCCoupling, interleaving_flag);
period_length = floor(FramTime*Digitizer_SamplingFrequency);
WaveformArray_averaged = zeros(repeat,floor(FramTime*Digitizer_SamplingFrequency));
res = Digitizer_SamplingFrequency/PointsPerRecord;    disp(['ADC Frequency Resolution: ' num2str(res)]);
for i = 1: repeat
    WaveformArray0 = ADC_capture_bel(1, M9703A_Obj, Channel1, PointsPerRecord, FullScaleRange, ACDCCoupling, interleaving_flag, Digitizer_SamplingFrequency);
    WaveformArray_averaged(i, :) = averaging_one_period( WaveformArray0, period_length,  Digitizer_SamplingFrequency, 0 );
end

time = toc;
display(['End of ADC Measurment. Time: ' num2str(time) ' S']);

[ WaveformArray_averaged, ~ ] = Delay_Alignment_bel(WaveformArray_averaged, Digitizer_SamplingFrequency, 0, 500);
%WaveformArray0 = sum(WaveformArray_averaged, 1)/repeat;
WaveformArray0 = WaveformArray_averaged;