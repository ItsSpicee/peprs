load('Scope_in.mat');

% measured_periods = 150;
repeat = 1;
% FramTime = 16e-5;

PointsPerRecord = (FramTime*Fs_adc) * measured_periods;
period_length = (FramTime*Fs_adc);
WaveformArray_averaged = zeros(repeat, floor(period_length));
res = Fs_adc/PointsPerRecord;    
disp(['ADC Frequency Resolution: ' num2str(res)]);
for i = 1: repeat
    WaveformArray0 = ADC_capture_bel(1, 'temp' ,M9703A_Obj, Channel1, PointsPerRecord, FullScaleRange, RX.ACDCCoupling, RX.ACDCCoupling , Fs_adc);
    WaveformArray_averaged(i, :) = averaging_one_period( WaveformArray0, period_length,  Fs_adc, 0 );
end

time = toc;
display(['End of ADC Measurment. Time: ' num2str(time) ' S']);

[ WaveformArray_averaged, ~ ] = Delay_Alignment_bel(WaveformArray_averaged, Fs_adc, 0);
WaveformArray0 = sum(WaveformArray_averaged, 1)/repeat;
waveform = WaveformArray0.';
Rec = WaveformArray0.';

save('Scope_out.mat', 'waveform');
display('Scope is done')

save('Raw_Data', 'Rec');
display('Scope is done')

ps_bel(Rec,Fs_adc, 0);

clear WaveformArray0 waveform Rec WaveformArray_averaged