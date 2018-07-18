function [ ReceivedTones ] = GetDesiredTones(RX, Cal, tones_freq, Rec)
    L               = length(Rec);
    res             = RX.Analyzer.Fsample / L;
    faxis           = -RX.Analyzer.Fsample/2: res : RX.Analyzer.Fsample/2 - res;

%     tone_index_inband     = find(ismember(faxis,tones_freq));
    tone_index_inband     = find(ismember(faxis,Cal.DesiredTones.InbandFrequency));

    if (Cal.SubRateFlag)
        tone_index_alias      = find(ismember(faxis,Cal.DesiredTones.PositiveAliasFrequency));
        tone_index_alias_flip = fliplr(tone_index_alias);

        tone_index_imag      = find(ismember(faxis,Cal.DesiredTones.NegativeAliasFrequency));
        tone_index_imag_flip = fliplr(tone_index_imag);

        Rec_freq             =  fftshift(fft(Rec))/L;  
        tones_values_inband  =  Rec_freq(tone_index_inband);
        tones_values_alias   =  conj(Rec_freq(tone_index_alias_flip));
        tones_values_imag    =  conj(Rec_freq(tone_index_imag_flip));

        tones_values = [tones_values_imag ;tones_values_inband  ;tones_values_alias].';
    else
        Rec_freq             = fftshift(fft(Rec))/L;
        tones_values         = Rec_freq(tone_index_inband);
    end
    
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

