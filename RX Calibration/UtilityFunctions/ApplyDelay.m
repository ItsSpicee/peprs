function [In_D] = ApplyDelay(In, Fs, time_shift)
    L = length(In);
    full_f = -Fs/2:Fs/L:(Fs/2-Fs/L);  
    sample2_spec = fftshift(fft(In));
    sample2_spec = sample2_spec.*exp(2*pi*1i*time_shift*full_f.');
    In_D = (ifft(ifftshift(sample2_spec)));
end

