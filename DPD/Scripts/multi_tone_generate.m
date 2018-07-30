% FrameTime
tones = -2.2e9:20e6:2.2e9;
phases = sqrt(pi) * randn(size(tones));
%phases = rand(size(tones)) * 2*pi - pi;
FramTime = 0.25e-3;
FsampleTx = 8e9;
t = 0:1/FsampleTx:(FramTime -1/FsampleTx );
signal_complex  = zeros(size(t));
for i = 1 :length(tones)
    tone_added = exp(1j * ( 2 * pi * tones(i) * t + phases(i)));
    signal_complex  = signal_complex  + tone_added;
end

CheckPower(signal_complex, 1)
signal_complex = SetMeanPower(signal_complex, 0);

% saving 


fidIEH = fopen(['Multi_Tone_4r4GHz_I_fs_8e9_0.25ms_11dB_20MHz_Spacing.txt'],'wt');
fprintf(fidIEH,'%12.20f\n',real(signal_complex));
fclose(fidIEH);

fidIEH = fopen(['Multi_Tone_4r4GHz_Q_fs_8e9_0.25ms_11dB_20MHz_Spacing.txt'],'wt');
fprintf(fidIEH,'%12.20f\n',imag(signal_complex));
fclose(fidIEH);
