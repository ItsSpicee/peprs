function [ Signal ] = GenerateMultitoneSignal(StartingToneFreq, ToneSpacing, EndingToneFreq, FrameTime, Fsample, MultitoneSettings)
    if(~isfield(MultitoneSettings,'PAPRmin') || isempty(MultitoneSettings.PAPRmin))
        MultitoneSettings.PAPRmin = 1;
    end
    if(~isfield(MultitoneSettings,'PAPRmax') || isempty(MultitoneSettings.PAPRmax))
        MultitoneSettings.PAPRmax = 100;
    end
    if(~isfield(MultitoneSettings,'PhaseDistr') || isempty(MultitoneSettings.PhaseDistr))
        MultitoneSettings.PhaseDistr = 'Gaussian';
    else
        switch MultitoneSettings.PhaseDistr
            case 'Gaussian'
            case 'Schroeder'
            otherwise
                MultitoneSettings.PhaseDistr = 'Schroeder';
        end
    end
    if(~isfield(MultitoneSettings,'PhaseVariance') || isempty(MultitoneSettings.PhaseVariance))
        MultitoneSettings.PhaseVariance = pi;
    end
    if(~isfield(MultitoneSettings,'RealBasisFlag') || isempty(MultitoneSettings.RealBasisFlag))
        MultitoneSettings.RealBasisFlag = 0;
    end
    if(~isfield(MultitoneSettings,'CustomToneSpacingFlag') || isempty(MultitoneSettings.CustomToneSpacingFlag))
        MultitoneSettings.CustomToneSpacingFlag = 0;
    else
        if(~isfield(MultitoneSettings,'ToneFrequencies') || isempty(MultitoneSettings.ToneFrequencies))
            MultitoneSettings.CustomToneSpacingFlag = 0;
        end
    end
   
    % Tone Frequencies
    if (~MultitoneSettings.CustomToneSpacingFlag)
        ToneFreq = StartingToneFreq:ToneSpacing:EndingToneFreq;
    else
        ToneFreq = MultitoneSettings.ToneFrequencies;
    end
    
    % Basis functions for the multitones
    if(MultitoneSettings.RealBasisFlag)
        tone = @(f, t, phi) cos(2*pi*f*t + phi);
    else
        tone = @(f, t, phi) exp(1i*(2*pi*f*t + phi));
    end
    
    t = 0:1/Fsample:(FrameTime -1/Fsample ); % Time vector
    PAPR = MultitoneSettings.PAPRmin - 1; % PAPR
    Signal = zeros(size(t));
         
    if (strcmp(MultitoneSettings.PhaseDistr,'Gaussian'))
        while (( PAPR < MultitoneSettings.PAPRmin ) || ( PAPR > MultitoneSettings.PAPRmax ))
            % Normally distributed phases with a variance
            phases = sqrt(MultitoneSettings.PhaseVariance) * randn(size(ToneFreq));
            Signal = zeros(size(t));
            % Generate the multitones
            for i = 1 :length(ToneFreq)
                Signal  = Signal  + tone(ToneFreq(i), t, phases(i));
            end
            [~, ~, PAPR] = CheckPower(Signal,0);
        end
    elseif (strcmp(MultitoneSettings.PhaseDistr,'Schroeder'))
        % Follow Schroeder's Phase Function to min PAPR
        totalPhase = pi;
        for i = 1 :length(ToneFreq)            
            phase = (i-1) * i * totalPhase / length(ToneFreq);
            Signal  = Signal  + tone(ToneFreq(i), t, phase);
        end
    end
    Signal = Signal.';
    Signal = SetMeanPower(Signal, 0);
end
