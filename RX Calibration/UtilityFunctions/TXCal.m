function [ Out ] = TXCal( In,Fs, p_mag, p_phase,  F_start, F_end)
%RX_CORR Summary of this function goes here
%   Detailed explanation goes here
% When extract ing the polynimial terms, the values of the frequency
% used  where from F_start to F_end

L = length(In);
freq = -Fs/2 : Fs/L : Fs/2 - Fs/L;
% this is the bandwidth of the signal used in calibration, is this
% bandwidt, the polynomial is only valid
BW_fit                    = abs((F_start - F_end));


% if the calibration bandwidth is smaller than the signal bandwidth,
% this means the calibration will only be applied to a certain part of
% the input signal specturm. This is the case always in the calibration
% coded
if BW_fit < Fs
    [~, F_start_band_index]    = min(abs((freq - -BW_fit/2)));
    [~, F_end_band_index]      = min(abs((freq - +BW_fit/2)));
    % will keep the same F_start and F_end values
    freq_fit    = F_start:Fs/L:F_end;
    mag         = polyval(p_mag, freq_fit);
    phase       = polyval(p_phase, freq_fit);
    H = ones(size(In));
    
    H(F_start_band_index: F_end_band_index) =  (mag .* exp(1j *phase));
    H(1:F_start_band_index-1) = H(F_start_band_index);
    H(F_end_band_index+1:end) = H(F_end_band_index);
    Out = ifft(ifftshift(fftshift(fft(In)) .* H));
else
% In contranst, the calibration bandwidth is larger that the siganl
% bandwidth, in this case, the error terms will be applied to the whole
% input spectrum. This is the case usually in the dpd code.
    F_start_band_index  = 1;
    F_end_band_index    = length(In) ;
    % must update F_start and F_end values.
    F_start = -Fs/2;
    F_end = +Fs/2;
    freq_fit    = F_start:Fs/L:F_end-Fs/L;
    mag         = polyval(p_mag, freq_fit);
    phase       = polyval(p_phase, freq_fit);
    H           =  mag .* exp(1j *phase);
    Out = ifft(ifftshift(fftshift(fft(In)) .* H.'));
end

end

