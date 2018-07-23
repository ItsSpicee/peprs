function [waveformArray_clean] = Fishing_Tones_Out_bel( WaveformArray, tones_not_needed, Fs_adc)
%FISHING_TONES_OUT_BEL Summary of this function goes here
%   Detailed explanation goes here
    [N, L] = size(WaveformArray);    
    res = Fs_adc/L;
    f_adc = -Fs_adc/2:res: Fs_adc/2 - res;
    
    f_tones_delete = tones_not_needed;
    f_delete_index = find(ismember(f_adc, f_tones_delete )); 
    for i = 1 : N
        data_f = fftshift(fft(WaveformArray(i,:)))/L;
        nf_adc = min(abs(real(data_f ))) + 1j* min(abs(imag(data_f)));
        data_f(f_delete_index) = nf_adc ;
        %ps_bel(data_f, fs_adc, 1)
        WaveformArray(i,:) = ifft(ifftshift(data_f))*L;
    end
    waveformArray_clean = WaveformArray;
end

