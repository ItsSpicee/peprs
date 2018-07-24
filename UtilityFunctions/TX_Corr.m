function [ Out] = TX_Corr( In_I, In_Q,Fs, p_mag, p_phase,  F_start, F_end)
%RX_CORR Summary of this function goes here
%   Detailed explanation goes here
    In = complex(In_I, In_Q);
    % When extract ing the polynimial terms, the values of the frequency
    % used  where from F_start to F_end
%    tones  = (F_start : 10e6 : F_end);
%     hold on; subplot(2,1,1); plot(tones, 20*log10(polyval(p_mag, tones)), 'k.-', 'linewidth', 2); grid on; ylabel('dB')
%     hold on; subplot(2,1,2); plot(tones, 180/pi*(polyval(p_phase,tones)), 'k.-', 'linewidth', 2); grid on; ylabel('Degrees')
%     
    L = length(In_I);
    freq = -Fs/2 : Fs/L : Fs/2 - Fs/L;
    %F_start_index   = find(freq ==F_start);
    %F_end_index     = find(freq ==F_end);
    [~, F_start_band_index]    = min(abs((freq - F_start)));
    [~, F_end_band_index]      = min(abs((freq - F_end)));
    F_start = freq(F_start_band_index);
    F_end = freq(F_end_band_index);
    %
    freq_fit = F_start:Fs/L:F_end;
    mag = polyval(p_mag, freq_fit);
    phase = polyval(p_phase, freq_fit);

    %mag = mag(end:-1:1);
    %phase = phase(end:-1:1);
    H = ones(size(In_Q));
    H(F_start_band_index: F_end_band_index) =  mag .* exp(1j *phase);
    H(1:F_start_band_index-1) = H(F_start_band_index);
    H(F_end_band_index+1:end) = H(F_end_band_index);
    Out = ifft(ifftshift(fftshift(fft(In)) .* H));
    
end

