function [ G ] = UpdateOutphasingFilter( G, mu, In, Out, ToneFreq, Fsample)
    L = length(In);
    res             = Fsample / L;
    faxis           = -Fsample/2: Fsample/L : Fsample/2 - res;
    tone_index      = find(ismember(faxis,ToneFreq));   % return tones freq index
    if (length(tone_index) ~= length(ToneFreq))
        display('Error')
    end
    In_freq         =  fftshift(fft(In))/L; 
    Rec_freq        =  fftshift(fft(Out))/L;  
    tones_rec       =  Rec_freq(tone_index);
    tones_in        =  In_freq(tone_index);
    
    G = G + mu * (tones_in-tones_rec) .* conj(tones_in) ./ abs(tones_in).^2;
end