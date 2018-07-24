function [ BasebandSignal ] = DigitalDownconvert( Signal, Fsample, Fcarrier, FilterCoeff, MirrorSignalFlag)
    time_IQ = (0:(length(Signal)-1))./Fsample;
    
    if (isrow(Signal))
        Signal = Signal.';
    end
    
    if (MirrorSignalFlag)
        BasebandSignal = Signal .* exp(1i*2*pi*Fcarrier*time_IQ).';
    else
        BasebandSignal = Signal .* exp(1i*2*pi*-Fcarrier*time_IQ).';  
    end
    BasebandSignal = filter(FilterCoeff, [1 0], BasebandSignal);
end

