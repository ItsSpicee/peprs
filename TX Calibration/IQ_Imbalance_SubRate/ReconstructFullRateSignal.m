function [FullRateEstimate_s2, FullRateEstimate_s4, FullRateEstimate_s8] = ReconstructFullRateSignal...
    (Received_train, TonesEstimate_s2, TonesEstimate_s4, TonesEstimate_s8, TX, Cal);
    tones_freq = [-fliplr(Cal.Signal.ToneFrequencies) Cal.Signal.ToneFrequencies];
    tone = @(f, t, phi) exp(1i*(2*pi*f*t + phi));
    t = (0:1/TX.Fsample:(TX.FrameTime -1/TX.Fsample )).'; % Time vector
    FullRateEstimate_s2 = zeros(length(t),1);
    FullRateEstimate_s4 = zeros(length(t),1);
    FullRateEstimate_s8 = zeros(length(t),1);
    for i = 1:(length(TonesEstimate_s2))
      FullRateEstimate_s2  = FullRateEstimate_s2  + abs(TonesEstimate_s2(i))* ...
        tone(tones_freq(i), t, angle(TonesEstimate_s2(i)));
      FullRateEstimate_s4  = FullRateEstimate_s4  + abs(TonesEstimate_s4(i))* ...
        tone(tones_freq(i), t, angle(TonesEstimate_s4(i)));
      FullRateEstimate_s8  = FullRateEstimate_s8 + abs(TonesEstimate_s8(i))* ...
        tone(tones_freq(i), t, angle(TonesEstimate_s8(i)));
    end
end