function [ ReceivedTones ] = GetDesiredTones(Rec, DesiredFreq, Fsample)
    L               = length(Rec);
    res             = Fsample / L;
    faxis           = -Fsample/2: res : (Fsample/2 - res);

    Rec_freq             = fftshift(fft(Rec))/L;
    ReceivedTones         = Rec_freq(ismember(faxis,DesiredFreq));
end

