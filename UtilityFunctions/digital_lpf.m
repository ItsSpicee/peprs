function [x_filtered_t] = digital_lpf( x, fs, fc);
%digiatl_lpf is a lpf filter applied digitall

    % Up conveting the signal and filtering the needed band
    l = length(x);
    res = fs/l;
    x_f = fftshift(fft(x));
    f   = -fs/2:res:fs/2-res;
    [~, fc_neg_index] = min(abs(f-(-fc)));  % the index of the cutoff freq
    [~, fc_pos_index] = min(abs(f-(+fc))); 
    x_filtered_f     = zeros(size(x));
    x_filtered_f(fc_neg_index:fc_pos_index) = x_f(fc_neg_index:fc_pos_index);
    nf            = min(abs(real(x_f))) + 1j* min(abs(imag(x_f)));
    x_filtered_f(1:fc_neg_index(1)-1) = nf;
    x_filtered_f(fc_pos_index+1 : end) = nf;
    x_filtered_t     = ifft(ifftshift(x_filtered_f));
end

