function [ACPR1, ACPR2] = CalculateACPR_analysis_bw (freq, spectrum, Fc, BW, fG)

% freq = load('Feb5_2.15GHz_freq.txt');
% spectrum = load('Feb5_2.15GHz_data.txt');
% Fc = 2.15e9; BW = 5e6; fG = 300e3;

[value, Index_high] = min(abs(freq - (Fc + BW/2 + fG)));
[value, Index_low] = min(abs(freq - (Fc - BW/2 - fG)));

Inband_power = 10*log10( sum(10.^( spectrum(Index_low:Index_high)./10 ) ));

Index_low2 = 1;
Index_high2 = length(freq);

Lowband_power = 10*log10( sum( 10.^ ( (spectrum(Index_low2:Index_low - 2))./10 ) ) );
Highband_power = 10*log10( sum( 10.^ ( (spectrum(Index_high + 2:Index_high2))./10 ) ) );

ACPR1 = Inband_power - Lowband_power;
ACPR2 = Inband_power - Highband_power;

end
