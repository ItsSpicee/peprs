function [ ReceivedTones ] = GetDesiredTones_bel(RX, Cal, tones_freq, Rec)
    L               = length(Rec);
    res             = RX.Fsample / L;
    faxis           = -RX.Fsample/2: res : RX.Fsample/2 - res;

    tone_index_inband     = find(ismember(faxis,tones_freq));

    Rec_freq             = fftshift(fft(Rec))/L;
    tones_values         = Rec_freq(tone_index_inband);


    figure
    subplot(2,1,1); plot(tones_freq,  10*log10(abs(tones_values).^2/100)+30, '.-'); hold on; grid on;title('Mag')
    subplot(2,1,2); plot(tones_freq,  180/pi*unwrap(phase(tones_values)), '.-'); hold on; grid on;title('Phase')

    % removing the linear phase shift
    tones_phase           = unwrap(phase(tones_values));
    tones_phase_linear    = polyfit(tones_freq, tones_phase, 1);
    tones_phase_residue   = tones_phase - polyval(tones_phase_linear,tones_freq);

    % removing dc shift
    tones_mag             = abs(tones_values);
    tones_mag_normalize   = tones_mag/mean(tones_mag);

    % ReceivedTones
    ReceivedTones = tones_mag_normalize .* exp(1j*tones_phase_residue);

    figure
    subplot(2,1,1); plot(tones_freq,  20*log10(abs(ReceivedTones)), '.-'); hold on; grid on;title('Mag')
    subplot(2,1,2); plot(tones_freq,  180/pi*unwrap(phase(ReceivedTones)), '.-'); hold on; grid on;title('Phase')
end

