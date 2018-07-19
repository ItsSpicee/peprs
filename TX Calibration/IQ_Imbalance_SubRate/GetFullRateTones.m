function [f_tones, data_f] = GetFullRateTones( WaveformArray, tones, Fs_adc)
%FISHING_TONES_OUT_BEL Summary of this function goes here
%   Detailed explanation goes here
    if (~isrow(WaveformArray))
        WaveformArray = WaveformArray.';
    end
    [N, L] = size(WaveformArray);    
    res = Fs_adc/L;
    f_adc = -Fs_adc/2:res: Fs_adc/2 - res;
    
    f_tones = tones;
    f_index = find(ismember(f_adc, f_tones )); 
    data_f = fftshift(fft(WaveformArray))/L;
    data_f = data_f(f_index);
end

