
function result = iqdownload_MUXDAC(arbConfig, sampleRate, data, marker1, marker2, segmNum, keepOpen, channelMapping, sequence, run)
    global setupfilename;
    setupfilename = 'muxdac_setup.mat';

    result = [];
    % assume, that arbConfig really points to an M8196A
    % except that the model name and samplerate parameters are incorrect,
    % so let's "fix" them
    arbConfig.model = 'M8196A';
    arbConfig = loadArbConfig(arbConfig);
    defaultFs = 90e9;
    arbConfig.defaultSampleRate = defaultFs;
    arbConfig.maximumSampleRate = defaultFs;
    arbConfig.minimumSampleRate = defaultFs;
    arbConfig.minimumSegmentSize = 128;
    arbConfig.maximumSegmentSize = 512*1024;
    arbConfig.segmentGranularity = 128;
    arbConfig.maxSegmentNumber = 1;
    arbConfig.numChannels = 4;
    global setupfilename;
    try
        load(setupfilename);
    catch ex
        errordlg(sprintf('Can''t open %s. Please double check that calibration has been performed', setupfilename));
        return
    end

    fvirtualawg = 2*fclk;
    if (fvirtualawg ~= sampleRate)
        errordlg(sprintf('Sample rate is %s, expected: %s', iqengprintf(sampleRate), iqengprintf(fvirtualawg)));
        return
    end

    if (channelMapping(1,1))
        gen_MUX(arbConfig, real(data), marker1, segmNum, run, fvirtualawg);
    elseif (channelMapping(1,2))
        gen_MUX(arbConfig, imag(data), marker1, segmNum, run, fvirtualawg);
    end
    if (channelMapping(2,1))
        gen_DCA(arbConfig, real(data), marker1, segmNum, run, fvirtualawg);
    elseif (channelMapping(2,2))
        gen_DCA(arbConfig, imag(data), marker1, segmNum, run, fvirtualawg);
    end
end


function gen_DCA(arbConfig, sig1, marker1, segmNum, run, fvirtualawg)
    newSampleRate = arbConfig.defaultSampleRate;
    sig1 = real(iqresample(sig1, round(length(sig1) * newSampleRate / fvirtualawg)));
    fprintf('download DCA clk...\n');
    iqdownload(sig1, newSampleRate, 'arbConfig', arbConfig, 'channelMapping', [1 0; 0 0; 0 0; 0 0], 'run', run);
end


function gen_MUX(arbConfig, sig1, marker1, segmNum, run, fvirtualawg)
    global setupfilename;
    load(setupfilename);

    [freq, magUpper] = extrapol(fclk, tone, mag1);
    [freq, magLower] = extrapol(fclk, tone, mag2);
    [freq, phaseUpper] = extrapol(fclk, tone, phase1-phase0);
    [freq, phaseLower] = extrapol(fclk, tone, phase2-phase0);

    phaseLower(1) = 0; %dc must be real
    % start at index 2 (don't duplicate zero-frequency)
    freq = [-1 * flipud(freq'); freq(2:end)'];
    cplxCorrUpper  = (10.^(magUpper'/20).*exp(1j*phaseUpper'));
    cplxCorrUpper = [conj(flipud(cplxCorrUpper)); cplxCorrUpper(2:end)]; % negative side must use complex conjugate

    cplxCorrLower  = (10.^(magLower'/20).*exp(1j*phaseLower'));
    cplxCorrLower = [conj(flipud(cplxCorrLower)); cplxCorrLower(2:end)]; % negative side must use complex conjugate

    % ToDo: overall cal

    sig1 = reshape(real(sig1), 1, length(sig1));
    L = length(sig1);
    sp1 = fft(sig1);
    %sp1(L/4+1) = 0;  % force Nyquist component to zero
    fftlower = sp1(1:L/4+1).';
    fftlower = [conj(flipud(fftlower)); fftlower(2:L/4)];
    
    fftupper = fliplr(sp1(L/4+1:L/2+1)).';
%     fftupper = [conj(flipud(fftupper)); fftupper(2:L/4)];
    fftupper = [flipud(fftupper); conj(fftupper(2:L/4))];
    
    points = length(fftlower);
    
    newFreq = linspace(-0.5, 0.5-1/points, points) * fclk;
    newFreq = newFreq';
    
    corrLinLowerMag   = interp1(freq, abs(cplxCorrLower), newFreq, 'linear', 1);
    corrLinLowerPhase = interp1(freq, angle(cplxCorrLower), newFreq, 'linear', 1);
    corrLinLower = corrLinLowerMag.*exp(1j*corrLinLowerPhase);
    
    corrLinUpperMag   = interp1(freq, abs(cplxCorrUpper), newFreq, 'linear', 1);
    corrLinUpperPhase = interp1(freq, angle(cplxCorrUpper), newFreq, 'linear', 1);
    corrLinUpper = corrLinUpperMag.*exp(1j*corrLinUpperPhase);
    % apply the correction 
    correctedLowerFFT = fftlower .* corrLinLower;
    correctedUpperFFT = fftupper .* corrLinUpper;

    %----
    doResample = 0;
    if (doResample)
        newSampleRate = arbConfig.defaultSampleRate;
        resultLower = ifft(fftshift(correctedLowerFFT));
        resultUpper = ifft(fftshift(correctedUpperFFT));
        sig4 = resultLower + resultUpper;
        sig4 = real(iqresample(sig4, round(length(sig4) * newSampleRate / fvirtualawg)));
        resultLowerUncorr = ifft(fftshift(fftlower));
        resultUpperUncorr = ifft(fftshift(fftupper));
        sig3 = resultLowerUncorr + resultUpperUncorr;
        sig3 = real(iqresample(sig3, round(length(sig3) * newSampleRate / fvirtualawg)));
    else
        binSpacing  = fvirtualawg/L;
        newBinCount = floor(arbConfig.defaultSampleRate / binSpacing / arbConfig.segmentGranularity) * arbConfig.segmentGranularity;
        newSampleRate = newBinCount * binSpacing;
        BinsToAdd = newBinCount - L/2;

        %correctedLowerFFTfullRate = [correctedLowerFFT(1:L/4+1); zeros(BinsToAdd, 1);  correctedLowerFFT(L/4+1:end)];
        correctedLowerFFTfullRate = [ zeros(BinsToAdd/2, 1); correctedLowerFFT; zeros(BinsToAdd/2, 1)];
        correctedUpperFFTfullRate = [ zeros(BinsToAdd/2, 1); correctedUpperFFT; zeros(BinsToAdd/2, 1)];

        % apply the correction and convert back to time domain
        resultLower = ifft(fftshift(correctedLowerFFTfullRate));
        resultUpper = ifft(fftshift(correctedUpperFFTfullRate));

        sig4 = resultLower + resultUpper;

        %correctedLowerFFTfullRate = [correctedLowerFFT(1:L/4+1); zeros(BinsToAdd, 1);  correctedLowerFFT(L/4+1:end)];
        uncorrectedLowerFFTfullRate = [ zeros(BinsToAdd/2, 1); fftlower; zeros(BinsToAdd/2, 1)];
        uncorrectedUpperFFTfullRate = [ zeros(BinsToAdd/2, 1); fftupper; zeros(BinsToAdd/2, 1)];

        % apply the correction and convert back to time domain
        resultLowerUncorr = ifft(fftshift(uncorrectedLowerFFTfullRate));
        resultUpperUncorr = ifft(fftshift(uncorrectedUpperFFTfullRate));

        sig3 = resultLowerUncorr + resultUpperUncorr;
    end

    % normalize sig3 and sig4
    scaling = max([ max(abs(sig3)) max(abs(sig4)) ]);
    sig3 = sig3 ./ scaling;
    sig4 = sig4 ./ scaling;
    % set clock phase to 90 degrees - experiment has shown that this causes
    % the phase "jump" at the band boundary to be close to zero.
    phase = 90 * pi / 180;
    sig2 = real(iqtone('arbConfig', arbConfig, 'sampleRate', newSampleRate, 'tone', fclk, 'phase', phase, 'nowarning', 1));
    fprintf('download MUX clk...(%d samples)\n', length(sig2));
    iqdownload(sig2, newSampleRate, 'arbConfig', arbConfig, 'channelMapping', [0 0; 1 0; 0 0; 0 0], 'run', 0);
    fprintf('download MUX Ch1...(%d samples)\n', length(sig3));
    iqdownload(sig3, newSampleRate, 'arbConfig', arbConfig, 'channelMapping', [0 0; 0 0; 1 0; 0 0], 'run', 0);
    fprintf('download MUX Ch2...(%d samples)\n', length(sig4));
    iqdownload(sig4, newSampleRate, 'arbConfig', arbConfig, 'channelMapping', [0 0; 0 0; 0 0; 1 0], 'run', run);
    fprintf('SampleRate: %s\n', iqengprintf(newSampleRate, 8));
end


function [freq, y] = extrapol(fclk, tone, x)
   % consider only the lower half of the tones
   n = length(tone)/2;
   % fit a straight line through the mag or phase values
   pf = polyfit(tone(1:n)/1e9, x(1:n), 1);
   delta = 1 ; % 1 Hz offset to avoid duplicate freq points
   freq = [0 tone(1:n) fclk/2 - delta];
   % use original values and extrapolate using a straihgt line 
   y = [polyval(pf, 0) x(1:n) polyval(pf, fclk/2/1e9)];
   % extrapolate and interpolate using a straight line
end

