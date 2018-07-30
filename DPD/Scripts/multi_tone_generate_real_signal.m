% FrameTime
tones = 20e6:20e6:0.5e9;
phases = sqrt(pi/sqrt(2)) * randn(size(tones));
%phases = rand(size(tones)) * 2*pi - pi;
FramTime = 0.25e-3;
% FramTime = 3.000e-5;
FsampleTx = 8e9;
t = 0:1/FsampleTx:(FramTime -1/FsampleTx );
signal = zeros(size(t));
for i = 1 :length(tones)
    tone_added = cos(( 2 * pi * tones(i) * t + phases(i)));
    signal  = signal  + tone_added;
end

CheckPower(signal, 1)
signal = SetMeanPower(signal, 0);

% saving 

fidIEH = fopen(['Real_Multi_Tone_0r5GHz_Q_fs_8e9_0.25ms_10r42dB.txt'],'wt');
fprintf(fidIEH,'%12.20f\n',real(signal));
fclose(fidIEH);