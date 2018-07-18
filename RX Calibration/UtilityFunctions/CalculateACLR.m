function [ACLR1, ACLR2] = CalculateACLR (freq, spectrum, Fc, BW, fG)

% freq = load('Feb5_2.15GHz_freq.txt');
% spectrum = load('Feb5_2.15GHz_data.txt');
% Fc = 2.15e9; BW = 5e6; fG = 300e3;

[value, Index_high] = min(abs(freq - (Fc + BW/2)));
[value, Index_low] = min(abs(freq - (Fc - BW/2)));



[value, Index_high_g] = min(abs(freq - (Fc + BW/2 + fG)));
[value, Index_low_g] = min(abs(freq - (Fc - BW/2 - fG)));



Inband_max = max(spectrum(Index_low:Index_high));

Lowband_max = max(spectrum(1:Index_low_g - 2));
Highband_max = max(spectrum(Index_high_g + 2:end));

ACLR1 = Inband_max - Lowband_max;
ACLR2 = Inband_max - Highband_max;

end
