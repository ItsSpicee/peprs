function [H_inv_freq] = ExtractTXFreqResponse(In_D, Out_D, FsampleTx, BW, Tone_Spacing)
    L = length(Out_train);
    res             = FsampleTx / L;
    faxis           = -FsampleTx/2: FsampleTx/L : FsampleTx/2 - res;
    
    tones_freq = ((-BW/2):Tone_Spacing:(BW/2))';
    tone_index      = find(ismember(faxis,tones_freq));   % return tones freq index

    In_Freq = fftshift(fft(In_train))/L;
    Out_Freq = fftshift(fft(Out_train))/L;
    
    in_tones = In_Freq(tone_index);
    out_tones    =  Out_Freq(tone_index);
    figure
    subplot(2,1,1); plot(tones_freq,  10*log10(abs(out_tones).^2/100)+30, '.-'); hold on; grid on;title('Mag')
    subplot(2,1,2); plot(tones_freq,  180/pi*unwrap(phase(out_tones)), '.-'); hold on; grid on;title('Phase')
    
    % removing the linera phase shift 
    out_tones_phase           = unwrap(phase(out_tones));
    tones_phase_linear    = polyfit(tones_freq, out_tones_phase, 1);
    tones_phase_residue   = out_tones_phase - polyval(tones_phase_linear,tones_freq);
    
    out_tones_mag             = abs(out_tones);
    out_tones_mag_normalize   = out_tones_mag/mean(out_tones_mag);
    in_tones = in_tones / mean(abs(in_tones));
    
    % new tones values
    tones_values_new = out_tones_mag_normalize .* exp(1j*tones_phase_residue);
    figure
    subplot(2,1,1); plot(tones_freq,  20*log10(abs(tones_values_new)), '.-'); hold on; grid on;title('Mag')
    subplot(2,1,2); plot(tones_freq,  180/pi*unwrap(phase(tones_values_new)), '.-'); hold on; grid on;title('Phase')
    
    H_inv_freq = in_tones ./ tones_values_new; 
end