function [ACPR1, ACPR2] = CalculateACPR (freq, spectrum, Fc, BW, fG)

% freq = load('Feb5_2.15GHz_freq.txt');
% spectrum = load('Feb5_2.15GHz_data.txt');
% Fc = 2.15e9; BW = 5e6; fG = 300e3;

[value, Index_high] = min(abs(freq - (Fc + BW/2)));
[value, Index_low] = min(abs(freq - (Fc - BW/2)));

[value, Index_high1] = min(abs(freq - (Fc + BW/2 + fG)));
[value, Index_low1] = min(abs(freq - (Fc - BW/2 - fG)));

Inband_power = 10*log10( sum(10.^( spectrum(Index_low:Index_high)./10 ) ));

[value, Index_high2] = min(abs(freq - (Fc + BW/2 + fG + BW)));
[value, Index_low2] = min(abs(freq - (Fc - BW/2 - fG - BW)));

Lowband_power = 10*log10( sum( 10.^ ( (spectrum(Index_low2:Index_low1 - 2))./10 ) ) );
Highband_power = 10*log10( sum( 10.^ ( (spectrum(Index_high1 + 2:Index_high2))./10 ) ) );

ACPR1 = Inband_power - Lowband_power;
ACPR2 = Inband_power - Highband_power;

end
