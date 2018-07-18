function despurredOutput = RemoveScopeSpurs(ReceivedTones, tones_freq, scopeSpurStart, scopeSpurEnd, scopeSpurSpacing)
    scopeSpurs = scopeSpurStart: scopeSpurSpacing : scopeSpurEnd;
    spurIdx    = find(ismember(tones_freq,scopeSpurs));
    
    tonesReal = real(ReceivedTones);
    tonesImag = imag(ReceivedTones);
    
    startDespurIdx = 1;
    endDespurIdx = length(spurIdx);

    % Interpolate at the end points separately
    if (spurIdx(1) == 1)
        tonesReal(1) = interp1(tones_freq(2:end), tonesReal(2:end), tones_freq(1), 'spline');
        tonesImag(1) = interp1(tones_freq(2:end), tonesImag(2:end), tones_freq(1), 'spline');
        startDespurIdx = 2;
    end
    if (spurIdx(end) == length(ReceivedTones))
        tonesReal(end) = interp1(tones_freq(1:end-1), tonesReal(1:end-1), tones_freq(end), 'spline');
        tonesImag(end) = interp1(tones_freq(1:end-1), tonesImag(1:end-1), tones_freq(end), 'spline');
        endDespurIdx = endDespurIdx - 1;
    end
    
    for i = startDespurIdx:endDespurIdx
        tonesReal(spurIdx(i)) = interp1([tones_freq(1:spurIdx(i)-1); tones_freq(spurIdx(i)+1:end)], ...
            [tonesReal(1:spurIdx(i)-1);tonesReal(spurIdx(i)+1:end)], tones_freq(spurIdx(i)), 'spline');
        tonesImag(spurIdx(i)) = interp1([tones_freq(1:spurIdx(i)-1); tones_freq(spurIdx(i)+1:end)], ...
            [tonesImag(1:spurIdx(i)-1);tonesImag(spurIdx(i)+1:end)], tones_freq(spurIdx(i)), 'spline');
    end
    
    despurredOutput = complex(tonesReal, tonesImag);
    
    figure
    subplot(2,1,1); plot(tones_freq,  20*log10(abs(ReceivedTones)), '.-'); hold all; plot(tones_freq,  20*log10(abs(despurredOutput)), '.-'); grid on;title('Mag')
    subplot(2,1,2); plot(tones_freq,  180/pi*unwrap(phase(ReceivedTones)), '.-'); hold all; plot(tones_freq,  180/pi*unwrap(phase(despurredOutput)), '.-'); grid on;title('Phase')
end