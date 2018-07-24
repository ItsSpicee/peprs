function iqresult = RxCal(x, Fs, p_fit_mag, p_fit_phase, F_start, F_end)
% F_start and F_end are asssumed to be negative.

points       = length(x) ;
fdata        = fftshift(fft(x(1:points).'));
% newFreq      = -Fs/2 : Fs/points : Fs/2-Fs/points;
% %newFreq      = -Fs/2 : Fs/points : 0-Fs/points;
% 
% Corr_mag1    = interp1(IF_Freq, Corr_mag, newFreq, 'pchip', 1);   % interpolate the magnitude
% Corr_phase1  = interp1(IF_Freq, Corr_phase, newFreq, 'pchip', 0); % interpolate the phase
% 
% Corr_Complex = transpose(Corr_mag1.*exp(1i*(Corr_phase1)));
% temp_bel = fdata .* Corr_Complex;
% iqresult     = ifft(ifftshift(fdata .* Corr_Complex));
% %need only the real signal since the input is assumed to be real.
% iqresult     = real(ifft(ifftshift(fdata .* Corr_Complex))); 

%--------------------------------------------------------------------------
%------------------------------**Start**-----------------------------------
%-----------------------**beltagy's approach1**----------------------------
% res = Fs/points;
% newFreq_postive         = res:res:Fs/2;
% Corr_mag2_postive       = polyval(p_fit_mag,newFreq_postive);
% Corr_phase2_postive     = polyval(p_fit_phase,newFreq_postive);
% Corr_Complex_postive = transpose(Corr_mag2_postive.*exp(1i*Corr_phase2_postive));
% Corr_Complex = [Corr_Complex_postive(end:-1:1) ; 1 ;Corr_Complex_postive(1:end-1)];
% temp_bel = fdata .* Corr_Complex;
% iqresult     = ifft(ifftshift(fdata .* Corr_Complex));
% %need only the real signal since the input is assumed to be real.
% iqresult     = real(ifft(ifftshift(fdata .* Corr_Complex))); 
% ps_bel(iqresult, 1e9, 0)
% ps_bel(fdata, 1e9, 1)
%-----------------------**beltagy's approach2**----------------------------
Corr_Complex = ones(size(fdata));


L = length(x);
freq = -Fs/2 : Fs/L : Fs/2 - Fs/L;
%F_start_index   = find(freq ==F_start);
%F_end_index     = find(freq ==F_end);
[~, F_start_band_index]    = min(abs((freq - F_start)));
[~, F_end_band_index]      = min(abs((freq - F_end)));
F_start = freq(F_start_band_index);
F_end = freq(F_end_band_index);
newFreq_negative         = F_start:Fs/L:F_end;
Corr_mag2_negative       = polyval(p_fit_mag, newFreq_negative);
Corr_phase2_negative     = polyval(p_fit_phase, newFreq_negative);
Corr_Complex_negative    = transpose(Corr_mag2_negative.*exp(1i*Corr_phase2_negative));


Corr_Complex(F_start_band_index:F_end_band_index) = Corr_Complex_negative;
%%
[~, F_start_band_index]    = min(abs((freq - abs(F_start))));
[~, F_end_band_index]      = min(abs((freq - abs(F_end))));
F_start = -freq(F_start_band_index);
F_end = -freq(F_end_band_index);
newFreq_postive         = F_start:Fs/L:F_end;
Corr_mag2_postive      = polyval(p_fit_mag, newFreq_postive);
Corr_phase2_postive     = polyval(p_fit_phase, newFreq_postive);
Corr_Complex_postive    = transpose(Corr_mag2_negative.*exp(1i*Corr_phase2_negative));

Corr_Complex(F_end_band_index:F_start_band_index) = (Corr_Complex_postive(end:-1:1)).';
%%

%Corr_Complex             = [Corr_Complex_negative ; 1 ;conj(Corr_Complex_negative(end:-1:2))];
iqresult                 = ifft(ifftshift(fdata .* Corr_Complex));
%iqresult = digital_filterout_bel(iqresult, Fs ,f_start, f_end);
[~, iqresult, ~, ~]  	=  AdjustPowerAndPhase(x, iqresult.');
%

%ps_bel(iqresult, 1e9, 0)
%ps_bel(fdata, 1e9, 1)
%-----------------------**beltagy's approach**-----------------------------
%------------------------------**End**-------------------------------------
%--------------------------------------------------------------------------

% Beltagy debug signlas
% tone_index      = find(ismember(newFreq,IF_Freq));   % 
% tone_interst_interpolated   = find(ismember(newFreq,[50:10:450]*1e6));   % return tones freq index
% tone_interst_orginal        = find(ismember(IF_Freq,[50:10:450]*1e6));   % return tones freq index
% 
% temp1 = 20*log10(Corr_mag1(tone_interst_interpolated))
% figure;plot(newFreq(tone_interst_interpolated), temp1+63, 'k.-');
% diff(temp1 )
% %abs(IF_Cor(tone_interst_orginal))
% temp2 = transpose(20*log10(abs(fdata(tone_interst_interpolated))))
% hold on; plot(newFreq(tone_interst_interpolated), temp2, 'm.-');
% diff(temp2 )
% 
% temp3 = transpose(20*log10(abs(temp_bel(tone_interst_interpolated))))
% hold on; plot(newFreq(tone_interst_interpolated), temp3, 'b.-');
% diff(temp3 )
% 
% grid on; 
% legend('gain [dB]','input data [dB]','corrected data [dB]')

%hold on 
%plot(newFreq(tone_interst_interpolated), temp1+temp2, 'r.-')
end