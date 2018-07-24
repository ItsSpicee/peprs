function [I_corr, Q_corr] = ApplyInverseIQImbalanceFilters(I_in, Q_in, Fs, G11, G12, G21, G22, IF_Freq2, IF_Freq1)
    L            = length(I_in) ;
    I_freq        = fftshift(fft(I_in,L));
    Q_freq        = fftshift(fft(Q_in,L));
    res          = Fs/L;
    freq         = -Fs/2 : Fs/L: Fs/2-res;

    F_start      = min(IF_Freq1(1),IF_Freq2(1));
    F_end        = max(IF_Freq1(end),IF_Freq2(end));

    [~, f_start_index]       = min(abs(freq-F_start));
    [~, f_end_index]         = min(abs(freq-F_end));
%     f_start                  = freq(f_start_index);
%     f_end                    = freq(f_end_index);
% 
%     f_if                    = f_start:res:f_end;
    f_if                    = freq(f_start_index:f_end_index);
    Corr_G11                = ones(size(I_in));
    Corr_G12                = zeros(size(I_in));
    Corr_G21                = zeros(size(I_in));
    Corr_G22                = ones(size(I_in));

    Corr_G11(f_start_index:f_end_index)   = interp1(IF_Freq1, G11, f_if, 'spline');
    Corr_G12(f_start_index:f_end_index)   = interp1(IF_Freq2, G12, f_if, 'spline');

    Corr_G21(f_start_index:f_end_index)   = interp1(IF_Freq1, G21, f_if, 'spline');
    Corr_G22(f_start_index:f_end_index)   = interp1(IF_Freq2, G22, f_if, 'spline');

    I_corr                 = I_freq .* Corr_G11  + Q_freq .*  Corr_G12 ;
    Q_corr                 = Q_freq .* Corr_G22  + I_freq .*  Corr_G21 ; 

    I_corr                 = ifft(ifftshift(I_corr));
    Q_corr                 = ifft(ifftshift(Q_corr));
end