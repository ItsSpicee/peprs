function despurredOutput = RemoveScopeSpurs(Rec, Fs, scopeSpurStart, scopeSpurEnd, scopeSpurSpacing)
    RecFreq = fftshift(fft(Rec)) / length(Rec);
    res = Fs/length(Rec);
    faxis = (-Fs/2 : res : (Fs/2-res))';

    scopeSpurs = scopeSpurStart: scopeSpurSpacing : scopeSpurEnd;
    spurIdx    = find(ismember(faxis,scopeSpurs));
    
    tonesReal = real(RecFreq);
    tonesImag = imag(RecFreq);
    
    startDespurIdx = 1;
    endDespurIdx = length(spurIdx);

    % Interpolate at the end points separately
    if (spurIdx(1) == 1)
        tonesReal(1) = interp1(faxis(2:end), tonesReal(2:end), faxis(1), 'spline');
        tonesImag(1) = interp1(faxis(2:end), tonesImag(2:end), faxis(1), 'spline');
        startDespurIdx = 2;
    end
    if (spurIdx(end) == length(RecFreq))
        tonesReal(end) = interp1(faxis(1:end-1), tonesReal(1:end-1), faxis(end), 'spline');
        tonesImag(end) = interp1(faxis(1:end-1), tonesImag(1:end-1), faxis(end), 'spline');
        endDespurIdx = endDespurIdx - 1;
    end
    
    for i = startDespurIdx:endDespurIdx
        tonesReal(spurIdx(i)) = interp1([faxis(1:spurIdx(i)-1); faxis(spurIdx(i)+1:end)], ...
            [tonesReal(1:spurIdx(i)-1);tonesReal(spurIdx(i)+1:end)], faxis(spurIdx(i)), 'spline');
        tonesImag(spurIdx(i)) = interp1([faxis(1:spurIdx(i)-1); faxis(spurIdx(i)+1:end)], ...
            [tonesImag(1:spurIdx(i)-1);tonesImag(spurIdx(i)+1:end)], faxis(spurIdx(i)), 'spline');
    end
    
    despurredOutput = ifft(ifftshift(complex(tonesReal, tonesImag)));
    
%     figure
%     subplot(2,1,1); plot(faxis,  20*log10(abs(RecFreq)), '.-'); hold all; plot(faxis,  20*log10(abs(despurredOutput)), '.-'); grid on;title('Mag')
%     subplot(2,1,2); plot(faxis,  180/pi*unwrap(phase(RecFreq)), '.-'); hold all; plot(faxis,  180/pi*unwrap(phase(despurredOutput)), '.-'); grid on;title('Phase')
end