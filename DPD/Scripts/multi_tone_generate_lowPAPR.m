% FrameTime
tones = (-2e9:4e6:(2e9-4e6)) + 2e6;
N = length(tones) - 1;
k = 0:N;
phases = mod(k.*(k-1) * pi/(N+1), 2*pi);
%phases = rand(size(tones)) * 2*pi - pi;
FramTime        = 0.04e-4;
FsampleTx = 12e9;
t = 0:1/FsampleTx:(FramTime -1/FsampleTx );
signal_complex  = zeros(size(t));
for i = 1 :length(tones)
    tone_added = exp(1j * ( 2 * pi * tones(i) * t + phases(i)));
    signal_complex  = signal_complex  + tone_added;
end

CheckPower(signal_complex, 1)
signal_complex1 = SetMeanPower(signal_complex, 0);
%%
% FrameTime
tones = (-2.2e9:40e6:2.2e9);
N = length(tones) - 1;
k = 0:N;
phases = mod(k.*(k-1) * pi/(N+1), 2*pi) + pi/4; 
%phases = rand(size(tones)) * 2*pi - pi;
t = 0:1/FsampleTx:(FramTime -1/FsampleTx );
signal_complex  = zeros(size(t));
for i = 1 :length(tones)
    tone_added = exp(1j * ( 2 * pi * tones(i) * t + phases(i)));
    signal_complex  = signal_complex  + tone_added;
end

CheckPower(signal_complex, 1)
signal_complex2 = SetMeanPower(signal_complex, 0);


%%
S1 = signal_complex1;   
S2 = signal_complex2;   

save('outphasing_S1_S2_lowPAPR_32GSapS_2GHz', 'S1', 'S2');
%%

% saving 


fidIEH = fopen(['Multi_Tone_4r4GHz_I_fs_8e9_0.25ms_2r58dB.txt'],'wt');
fprintf(fidIEH,'%12.20f\n',real(signal_complex2));
fclose(fidIEH);

fidIEH = fopen(['Multi_Tone_4r4GHz_Q_fs_8e9_0.25ms_2r58dB.txt'],'wt');
fprintf(fidIEH,'%12.20f\n',imag(signal_complex2));
fclose(fidIEH);
