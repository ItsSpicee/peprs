function varargout = iqmod(varargin)
% Generate I/Q modulation waveform
% Parameters are passed as property/value pairs. Properties are:
% 'sampleRate' - sample rate in Hz
% 'numSymbols' - number of symbols
% 'modType' - modulation type (BPSK, QPSK, OQPSK, QAM4, QAM16, QAM64, QAM256)
% 'oversampling' - oversampling rate
% 'filterType' - pulse shaping filter ('Raised Cosine','Square Root Raised Cosine','Gaussian')
% 'filterNsym' - number of symbols for pulse shaping filter
% 'filterBeta' - Alpha/BT for pulse shaping filter
% 'carrierOffset' - frequency of carriers (can be a scalar or vector)
% 'magnitude' - relative magnitude (in dB) for the individual carriers
% 'newdata' - set to 1 if you want separate random bits to be generated for each carrier
% 'correction' - apply amplitude correction stored in iqampCorr()
% 'quadErr' - quadrature error in degrees
% 'plotConstellation' - to plot the constellation diagram
%
% If called without arguments, opens a graphical user interface to specify
% parameters
%
% Thomas Dippon, Keysight Technologies 2011-2016
%
% Disclaimer of Warranties: THIS SOFTWARE HAS NOT COMPLETED KEYSIGHT'S FULL
% QUALITY ASSURANCE PROGRAM AND MAY HAVE ERRORS OR DEFECTS. KEYSIGHT MAKES 
% NO EXPRESS OR IMPLIED WARRANTY OF ANY KIND WITH RESPECT TO THE SOFTWARE,
% AND SPECIFICALLY DISCLAIMS THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR A PARTICULAR PURPOSE.
% THIS SOFTWARE MAY ONLY BE USED IN CONJUNCTION WITH KEYSIGHT INSTRUMENTS. 

if (nargin == 0)
    iqmod_gui;
    return;
end
if (nargout >= 1)
    varargout{1} = [];
end
if (nargout >= 2)
    varargout{2} = [];
end
if (nargout >= 3)
    varargout{3} = [];
end
if (nargout >= 4)
    varargout{4} = [];
end
sampleRate = 4.2e9;
numSymbols = 256;
data = 'Random';
modType = 'QAM16';
oversampling = 4;
filterType = 'Root Raised Cosine';
filterNsym = 8;
filterBeta = 0.35;
filename = '';
dataContent = [];
carrierOffset = 0;
magnitude = 0;
quadErr = 0;
iqskew = 0;
gainImb = 0;
newdata = 1;
correction = 0;
normalize = 1;
plotConstellation = 0;
threshold = 1000000;
savefile = [];
arbConfig = [];
fct = 'display';
channelMapping = [1 0; 0 1];
hMsgBox = [];
i = 1;
while (i <= nargin)
    if (ischar(varargin{i}))
        switch lower(varargin{i})
            case 'samplerate';     sampleRate = varargin{i+1};
            case 'numsymbols';     numSymbols = varargin{i+1};
            case 'modtype';        modType = varargin{i+1};
            case 'data';           data = varargin{i+1};
            case 'datacontent';    dataContent = varargin{i+1};
            case 'filename';       filename = varargin{i+1};
            case 'oversampling';   oversampling = varargin{i+1};
            case 'filtertype';     filterType = varargin{i+1};
            case 'filternsym';     filterNsym = varargin{i+1};
            case 'filterbeta';     filterBeta = varargin{i+1};
            case 'carrieroffset';  carrierOffset = varargin{i+1};
            case 'magnitude';      magnitude = varargin{i+1};
            case 'quaderr';        quadErr = varargin{i+1};
            case 'iqskew';         iqskew = varargin{i+1};
            case 'gainimbalance';  gainImb = varargin{i+1};
            case 'newdata';        newdata = varargin{i+1};
            case 'correction';     correction = varargin{i+1};
            case 'normalize';      normalize = varargin{i+1};
            case 'plotconstellation'; plotConstellation = varargin{i+1};
            case 'arbconfig';      arbConfig = varargin{i+1};
            case 'function';       fct = varargin{i+1};
            case 'threshold';      threshold = varargin{i+1};
            case 'savefile';       savefile = varargin{i+1};
            case 'channelmapping'; channelMapping = varargin{i+1};
            case 'hmsgbox';        hMsgBox = varargin{i+1};
            otherwise error(['unexpected argument: ' varargin{i}]);
        end
    else
        error('string argument expected');
    end
    i = i+2;
end

%% create a modulator object
offsetmod = 0;
iscpm = 0;
switch upper(modType)
    case 'BPSK';   hmod = modem.pskmod('M', 2);
    case 'BPSK_X'; hmod = modem.pskmod('M', 2, 'PhaseOffset', pi/2);
    case 'QPSK';   hmod = modem.pskmod('M', 4, 'PhaseOffset', pi/4, 'SymbolOrder', 'Gray');
    case 'OQPSK';  hmod = modem.pskmod('M', 4, 'PhaseOffset', pi/4, 'SymbolOrder', 'Gray'); offsetmod = 1;
    case '8-PSK';  hmod = modem.pskmod('M', 8, 'PhaseOffset', pi/8);
    case 'QAM4';   hmod = modem.qammod('M', 4);
    %case 'QAM8';   hmod = modem.qammod(8);
    case 'QAM16';  hmod = modem.qammod('M', 16, 'SymbolOrder', 'user-defined', 'SymbolMapping', [3 7 11 15 2 6 10 14 1 5 9 13 0 4 8 12]);
    case 'QAM32';  hmod = modem.qammod('M', 32, 'SymbolOrder', 'user-defined', 'SymbolMapping', [3 2 30 31 9 15 21 27 8 14 20 26 7 13 19 25 6 12 18 24 5 11 17 23 4 10 16 22 0 1 29 28]);
    case 'QAM64';  hmod = modem.qammod('M', 64, 'SymbolOrder', 'user-defined', 'SymbolMapping', [7 15 23 31 39 47 55 63 6 14 22 30 38 46 54 62 5 13 21 29 37 45 53 61 4 12 20 28 36 44 52 60 3 11 19 27 35 43 51 59 2 10 18 26 34 42 50 58 1 9 17 25 33 41 49 57 0 8 16 24 32 40 48 56]);
    case 'QAM128'; hmod = modem.qammod('M', 128);
    case 'QAM256'; hmod = modem.qammod('M', 256, 'SymbolOrder', 'user-defined', 'SymbolMapping', [15 31 47 63 79 95 111 127 143 159 175 191 207 223 239 255 14 30 46 62 78 94 110 126 142 158 174 190 206 222 238 254 13 29 45 61 77 93 109 125 141 157 173 189 205 221 237 253 12 28 44 60 76 92 108 124 140 156 172 188 204 220 236 252 11 27 43 59 75 91 107 123 139 155 171 187 203 219 235 251 10 26 42 58 74 90 106 122 138 154 170 186 202 218 234 250 9 25 41 57 73 89 105 121 137 153 169 185 201 217 233 249 8 24 40 56 72 88 104 120 136 152 168 184 200 216 232 248 7 23 39 55 71 87 103 119 135 151 167 183 199 215 231 247 6 22 38 54 70 86 102 118 134 150 166 182 198 214 230 246 5 21 37 53 69 85 101 117 133 149 165 181 197 213 229 245 4 20 36 52 68 84 100 116 132 148 164 180 196 212 228 244 3 19 35 51 67 83 99 115 131 147 163 179 195 211 227 243 2 18 34 50 66 82 98 114 130 146 162 178 194 210 226 242 1 17 33 49 65 81 97 113 129 145 161 177 193 209 225 241 0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240]);
    case 'QAM512'; hmod = modem.qammod('M', 512);
    case 'QAM1024';hmod = modem.qammod('M', 1024);
    case 'QAM2048';hmod = modem.qammod('M', 2048);
    case 'QAM4096';hmod = modem.qammod('M', 4096);
    case 'APSK16'
        r12 = 2.6;
        cst = [exp(j*2*pi*[0.5:1:3.5]/4) exp(j*2*pi*[0.5:1:11.5]/12)*r12];
        % scramble the constellation to avoid strange spectra
        for cnt = 1:2:length(cst)/2
            k = cnt;
            i = cnt + length(cst)/2;
            tmp = cst(i); cst(i) = cst(k); cst(k) = tmp;
        end
        hmod = modem.genqammod('Constellation', cst, 'InputType', 'integer');
    case 'APSK32'
        r12 = 2.84; r13 = 5.27;
        cst = [exp(j*2*pi*[0.5:1:3.5]/4) exp(j*2*pi*[0.5:1:11.5]/12)*r12 ...
            exp(j*2*pi*[0:15]/16)*r13];
        % scramble the constellation to avoid strange spectra
        for cnt = 1:2:length(cst)/2
            k = cnt;
            i = cnt + length(cst)/2;
            tmp = cst(i); cst(i) = cst(k); cst(k) = tmp;
        end
        hmod = modem.genqammod('Constellation', cst, 'InputType', 'integer');
    case 'PAM4'
        hmod = modem.pammod('M', 4, 'SymbolOrder', 'user-defined', 'SymbolMapping', [3 1 0 2]);
    case 'CPM'
        hmod = modem.pskmod(2);
        iscpm = 1;       
    
	% added by Tom Wychock tom.wychock@keysight.com
    % creates a QAM 8 signal (use this setup to create more custom signals)
    case 'QAM8'
        y1Mag = 1;
        y1States = 4;
        y1Phase = 0;
        
        y2Mag = 2;
        y2States = 4;
        y2Phase = pi/4;
        
        cst = [exp(j*(2*pi*[0:y1States-1]/y1States+y1Phase))*y1Mag...
               exp(j*(2*pi*[0:y2States-1]/y2States+y2Phase))*y2Mag];
        % scramble the constellation (Tom Wychock)
        maproute = [1 6 4 5 7 2 8 3];
        cst = cst(maproute);
        hmod = modem.genqammod('Constellation', cst, 'InputType', 'integer');
        
    otherwise; error('unknown modulation type');
end

if (plotConstellation)
    figure(3);
    plot(hmod.constellation, 'rx');
    title(['Constellation diagram for ' modType]);
    for n = 1:hmod.m
        try % if there is no symbolmapping, use symbol index
            if (hmod.m > 64)
                sym = dec2hex(hmod.symbolmapping(n), ceil(ceil(log2(hmod.m))/4));
            else
                sym = dec2bin(hmod.symbolmapping(n), ceil(log2(hmod.m)));
            end
        catch
            sym = dec2bin(n-1, ceil(log2(hmod.m)));
        end
        text(real(hmod.constellation(n)), imag(hmod.constellation(n)) + 0.1, sym, ...
            'FontSize', 8, 'FontUnits', 'points', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    xmin = min(real(hmod.constellation)) - 1;
    xmax = max(real(hmod.constellation)) + 1;
    ymin = min(imag(hmod.constellation)) - 1;
    ymax = max(imag(hmod.constellation)) + 1;
    xlim([xmin xmax]);
    ylim([ymin ymax]);
    hold on;
    plot([xmin xmax], [0 0], 'k-');
    plot([0 0], [ymin ymax], 'k-');
    hold off;
    return;
end

% use the same sequence every time so that results are comparable
randStream = RandStream('mt19937ar'); 
reset(randStream);

%% determine the value of numSymbols (could be reading from file)
sym = generate_sym(numSymbols, length(hmod.Constellation), randStream, data, dataContent, filename);
numSymbols = length(sym);

%% determine the number of samples that we need
% find rational number to approximate the oversampling
[overN overD] = rat(oversampling);
% minimum number of samples that are necessary (must be an integer!)
numSamplesRaw = numSymbols * overN / gcd(overD, numSymbols);
% adjust number of samples to match AWG limitations
arbConfig = loadArbConfig(arbConfig);
numSamples = lcm(numSamplesRaw, arbConfig.segmentGranularity);
% make sure we have at least the minimum number of samples for this AWG
while (numSamples < arbConfig.minimumSegmentSize)
    numSamples = 2 * numSamples;
end
% if the number of samples exceeds the memory size, but the "raw" number of
% samples would fit, ignore the granularity for now and perform arbitrary
% resampling later
if (numSamplesRaw <= arbConfig.maximumSegmentSize && numSamples > arbConfig.maximumSegmentSize)
    numSamples = numSamplesRaw;
    % msgbox('Waveform will be re-sampled to match AWG''s granularity requirements', 'Note', 'replace');
end
% adjust the number of symbols if necessary
newNumSymbols = round(numSamples / overN * overD);
if (numSymbols ~= newNumSymbols)
    sym = repmat(sym, 1, ceil(newNumSymbols / numSymbols));
    sym = sym(1:newNumSymbols);
    numSymbols = newNumSymbols;
end

%% determine if this a "large" waveform that will be downloaded directly
overK = 1;
if (numSamples < threshold)
    % for large oversampling factors, perform the filtering at a lower
    % rate, then upsample. This will save calculation time
    fcs = factor(overN);
    i = 1;
    fc = 1;
    while (i <= length(fcs) && fc < 8 * overD)
        fc = fc * fcs(i);
        i = i+1;
    end
    overK = overN / fc;
    overN = overN / overK;
end

%% create a filter for pulse shaping
if (overN <= 1)  % avoid error when creating a filter when there is nothing to filter
    filterType = 'None';
end
filt = [];
filterParams = [];
switch (filterType)
    case 'None'
        filt.Numerator = 1;
    case 'Rectangular'
        filt.Numerator = ones(1, overN) / overN;
    case {'Root Raised Cosine' 'Square Root Raised Cosine' 'RRC'}
        filterType = 'Square Root Raised Cosine';
        filterParams = 'Nsym,Beta';
    case {'Raised Cosine' 'RC'}
        filterType = 'Raised Cosine';
        filterParams = 'Nsym,Beta';
    case 'Gaussian'
        filterParams = 'Nsym,BT';
        if (exist('filterBeta', 'var') && filterBeta ~= 0)
%            % in MATLAB the BT is given as 1/BT
%            filterBeta = 1 / filterBeta;
        end
    otherwise
        error(['unknown filter type: ' filterType]);
end
if (isempty(filt))
    try
        fdes = fdesign.pulseshaping(overN, filterType, filterParams, filterNsym, filterBeta);
        filt = design(fdes);
    catch ex
        errordlg({'Error during filter design. Please verify that' ...
            'you have the "Signal Processing Toolbox" installed' ...
            'MATLAB error message:' ex.message}, 'Error');
    end
end
%fvtool(filt);

%% calculate the relative magnitudes of each carrier in a multi-carrier case
if (isempty(magnitude))
    magnitude = 0;
end
if (length(magnitude) < length(carrierOffset))
    magnitude = reshape(magnitude, length(magnitude), 1);
    magnitude = repmat(magnitude, ceil(length(carrierOffset) / length(magnitude)), 1);
end

%% handle large waveforms in chunks
if (numSamples >= threshold && length(magnitude) <= 1)
    if (mod(numSamples, arbConfig.segmentGranularity) ~= 0)
        errordlg('re-sampling of large waveforms is not yet implemented');
        error('re-sampling of large waveforms is not yet implemented');
    end
    if (length(magnitude) > 1)
        errordlg('multi-carrier in conjunction with large waveforms is not yet implemented');
        error('multi-carrier in conjunction with large waveforms is not yet implemented');
    end
    if (iqskew ~= 0)
        errordlg('iqskew on large waveforms is not yet implemented');
        error('iqskew on large waveforms is not yet implemented');
    end
    fSave = [];
    if (strcmpi(fct, 'save'))
        if (~isempty(savefile))
            filterIdx = 1;
            if (~isempty(strfind(savefile, '.bin'))) %#ok<STREMP>
                filterIdx = 2;
            end
        else
            [FileName,PathName,filterIdx] = uiputfile({...
                '.csv', 'CSV file (*.csv)'; ...
                '.bin', 'IQBIN, 16-bit I+Q values (*.bin)'}, ...
                'Save Waveform As...');
            if isequal(FileName,0) || isequal(PathName,0)
               return;
            end
            savefile = fullfile(PathName, FileName);
        end
        fSave = fopen(savefile, 'w');
        if (isempty(fSave))
            errordlg(sprintf('Can''t open %s\n', savefile));
            return;
        end
    end
    % close the "Calculating waveform..." dialog box
    try close(hMsgBox); catch; end
    % ...and create a new progress bar
    hMsgBox = waitbar(0, '', 'Name', 'Please wait...', 'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)');
    % use a try-catch block because the waitbar MUST be properly deleted under all circumstances
    try
        % make an overlapsave instances from the pulse shape filter
        ovsPulseShape_I = overlapsave(filt.Numerator', overD);
        ovsPulseShape_Q = overlapsave(filt.Numerator', overD);
        % make overlapsave instances for correction filters
        perChannelCorrection = 0;
        complexCorrection = 0;
        if (correction)
            [complexCorr, perChannelCorr] = iqcorrection([]);  % get default correction
            if (~isempty(perChannelCorr))
                h = overlapsave.makeFIR(sampleRate, perChannelCorr(:,1), perChannelCorr(:,2));
                ovsPerChannel_I = overlapsave(h);                % create filter object
                if (size(perChannelCorr, 2) >= 3)
                    h = overlapsave.makeFIR(sampleRate, perChannelCorr(:,1), perChannelCorr(:,3));
                end
                ovsPerChannel_Q = overlapsave(h);                % create filter object
                perChannelCorrection = 1;
            end
            if (~isempty(complexCorr) && size(complexCorr,1) > 2)
                h = overlapsave.makeFIR(sampleRate, complexCorr(:,1), complexCorr(:,3));
                ovsComplex = overlapsave(h);                     % create filter object
                complexCorrection = 1;
            end
        end
        data = modulate(hmod, sym);
        chunkSize = round(100000 / overN);   % in symbols
        gran = arbConfig.segmentGranularity;
        cy = round(numSamples * carrierOffset(1) / sampleRate); % number of periods for carrier offset
        phi = randStream.rand(1);                               % random phase for carrier offset
        scale = 1;                                              % start with scale of 1 and increase as necessary
        oldWfm = [];
        symCnt = 0;
        sampleCnt = 0;
        tic;
        while (sampleCnt < numSamples)
            % determine the number of symbols to be used in the next chunk
            cnt = min(chunkSize, numSymbols - symCnt);
            % upsample and scale to a value that is guaranteed to be > 1
            modData = 10 * overN * upsample(data(symCnt+1:symCnt+cnt), overN);
            % apply pulse shaping filter - must take I and Q separately because
            % the overlap and save filter does not deal with complex signals
            wfm = complex(ovsPulseShape_I.filter(real(modData)), ovsPulseShape_Q.filter(imag(modData)));
            % apply gain imbalance if requested
            if (gainImb ~= 0)
                wfm = complex(real(wfm) * 10^(gainImb/20), imag(wfm));
            end
            % apply quadrature error if requested
            if (quadErr ~= 0)
                qe = quadErr * pi / 180;
                wfm = complex(real(wfm) * cos(qe) + imag(wfm) * sin(qe), imag(wfm));
            end
            % multiply with carrier frequency (make sure we use the
            % phase that matches the position of the chunk
            if (cy ~= 0 && ~isempty(wfm))
                offset = sampleCnt + length(oldWfm);
                shiftSig = exp(1j * 2 * pi * cy * ((offset:offset+length(wfm)-1)'/numSamples + phi));
                wfm = wfm .* shiftSig;
            end
            % apply per channel correction
            if (perChannelCorrection)
                wfm = complex(ovsPerChannel_I.filter(real(wfm)), ovsPerChannel_Q.filter(imag(wfm)));
            end
            if (complexCorrection)                     % apply complex correction
                wfm = ovsComplex.filter(wfm);
            end
            wfm = [oldWfm; wfm];                       % prepend previous waveform piece
            len = floor(length(wfm) / gran) * gran;    % use in chunks of granularity
            len = min(len, numSamples - sampleCnt);    % no more than numSamples
            oldWfm = wfm(len+1:end);                   % save last part for next loop iteration
            wfm2 = wfm(1:len);

            % check for proper scaling
            maxVal = max(max(abs(real(wfm2))),max(abs(imag(wfm2))));
            if (len > 0 && maxVal > scale)
                % check, if this is the first chunk
                if (sampleCnt == 0)
                    scale = 1.02 * maxVal;  % set new scale value with a 2% margin
                elseif (maxVal / scale <= 1)
                    % do nothing
                elseif (maxVal / scale < 1.01)   % if is less the 1% overflow, just clip the values to avoid excessive re-starts
                    % pretty complicated...  if someone can help me
                    % simplify the code, I'd appreciate it.
                    wfm2r = real(wfm2);
                    wfm2i = imag(wfm2);
                    wfm2r(wfm2r > scale) = scale;
                    wfm2i(wfm2i > scale) = scale;
                    wfm2r(wfm2r < -scale) = -scale;
                    wfm2i(wfm2i < -scale) = -scale;
                    wfm2 = complex(wfm2r, wfm2i);
                else
                    % too bad, we found a larger maxVal somewhere in the
                    % middle of the calculation --> need to start over 
                    scale = 1.02 * maxVal;  % set new scale value and add a 2% margin
                    fprintf('restarting @ sampleCnt = %d, new scale = %g\n', sampleCnt, scale);
                    sampleCnt = 0;
                    symCnt = 0;
                    oldWfm = [];
                    ovsPulseShape_I.reset();
                    ovsPulseShape_Q.reset();
                    if (exist('ovsPerChannel_I', 'var')); ovsPerChannel_I.reset(); end
                    if (exist('ovsPerChannel_Q', 'var')); ovsPerChannel_Q.reset(); end
                    if (exist('ovsComplex', 'var')); ovsComplex.reset(); end
                    if (strcmp(fct, 'save'))    %Wychock close the file then reopen
                        try
                            fclose(fSave);
                            fSave = fopen(savefile, 'w');
                            if (isempty(fSave))
                                errordlg(sprintf('Can''t open %s\n', savefile));
                                return;
                            end
                        catch
                        end
                    end
                    continue;
                end
            end
            if (len > 0)
                wfm2 = wfm2 / scale;
                switch (fct)
                    case 'display'
                        if (sampleCnt == 0)
                            iqplot(wfm2, sampleRate);
                        end
                    case 'download'
                        iqdownload(wfm2, sampleRate, 'channelMapping', channelMapping, 'segmentLength', numSamples, 'segmentOffset', sampleCnt);
                    case 'save'
                        switch (filterIdx)
                            case 1  % CSV
                                for i=1:length(wfm2)
                                    fprintf(fSave, '%g,%g\n', real(wfm2(i)), imag(wfm2(i)));
                                end
                            case 2  % IQ BIN
                                % encode as 16 bit signed value, but leave
                                % least significant bit always zero,
                                % because it is often interpreted as a
                                % marker bit
                                data1 = int16(round(16383 * real(wfm2)) * 2)';
                                data2 = int16(round(16383 * imag(wfm2)) * 2)';
                                dataSave = [data1; data2];
                                dataSave = dataSave(1:end);
                                fwrite(fSave, dataSave, 'int16');
                        end
                    case 'none'
                    otherwise 
                        error('invalid function');
                end
            end
            sampleCnt = sampleCnt + len;
            symCnt = symCnt + cnt;
            if (symCnt >= numSymbols)
                symCnt = 0;
            end
            t = toc;
            if getappdata(hMsgBox,'canceling'); break; end
            waitbar(sampleCnt / numSamples, hMsgBox, sprintf('Processed %d samples, %.1f%%, %.1f sec', sampleCnt, sampleCnt / numSamples * 100, t));
        end
    catch ex
        errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
    end
    iqdata = [];
    if (~isempty(fSave))
        try
            fclose(fSave);
        catch
        end
    end
    delete(hMsgBox);
else
    %% calculate carrier offsets
    %result = zeros(1,len);
    result = [];
    linmag = 10.^(magnitude./20);
    for i = 1:length(carrierOffset)
        if (~isempty(hMsgBox))
            hMsgBox = msgbox(sprintf('Calculating waveform (%d / %d). Please wait...', i, length(carrierOffset)), 'Please wait...', 'replace');
        end
        if (newdata || i == 1)
            iqdata = iqmod_gen(sampleRate, hmod, sym, numSymbols, overN, overK, overD, filt, quadErr, iqskew, gainImb, offsetmod, iscpm, randStream, data, dataContent, filename);
        end
        len = length(iqdata);
        cy = round(len * carrierOffset(i) / sampleRate);
        shiftSig = exp(j * 2 * pi * cy * (linspace(0, 1 - 1/len, len) + randStream.rand(1)));
        if (isempty(result))
            result = zeros(1, len);
        end
        result = result + linmag(i) * (iqdata .* shiftSig);
    end
    iqdata = result;

    %% re-samples, if granularity requirements are not met
    if (mod(len, arbConfig.segmentGranularity) ~= 0)
        newLen = ceil(len / arbConfig.segmentGranularity) * arbConfig.segmentGranularity;
        sampleRate = sampleRate * newLen / len;
        if (sampleRate > arbConfig.maximumSampleRate)
            newLen = floor(len / arbConfig.segmentGranularity) * arbConfig.segmentGranularity;
            sampleRate = sampleRate * newLen / len;
        end
        iqdata = iqresample(iqdata, newLen);
    end

    %% normalize the output
    if (normalize)
        scale = max(max(abs(real(iqdata))), max(abs(imag(iqdata))));
        iqdata = iqdata / scale;
    end

    %% apply freq/phase response correction if necessary
    if (correction)
        iqdata = iqcorrection(iqdata, sampleRate, [], normalize);
    end
end

delete(randStream);
if (nargout >= 1)
    varargout{1} = iqdata;
end
if (nargout >= 2)
    varargout{2} = sampleRate;
end
if (nargout >= 3)
    varargout{3} = numSymbols;
end
if (nargout >= 4)
    varargout{4} = numSamples;
end
end


%% generate a modulated signal
function iqdata = iqmod_gen(fs, hmod, sym, numSymbols, overN, overK, overD, filt, quadErr, iqskew, gainImb, offsetmod, iscpm, randStream, data, dataContent, filename)
if (ischar(data) && strcmpi(data, 'random'))
    sym = generate_sym(numSymbols, length(hmod.Constellation), randStream, data, dataContent, filename);
end
if (iscpm ~= 0)   % no built-in function for CPM modulation
    % modulate_cpm returns a PHASE vector, not IQ. For CPM, we need to run
    % the phase through the pulse shaping filter
    rawIQ = modulate_cpm(sym, overN);
    phOffset = rawIQ(end);   % correct for N * 360° phase offset
else
    rawIQ = upsample(modulate(hmod, sym), overN);
    phOffset = 0;
end
% simulate a differential channel with two separate channels
% rawIQ = complex(real(rawIQ), -real(rawIQ));
len = length(rawIQ);
nfilt = length(filt.Numerator);
% apply the filter to the raw signal with some wrap-around to avoid glitches
wrappedIQ = [rawIQ(end-mod(nfilt,len)+1:end)-phOffset repmat(rawIQ, 1, floor(nfilt/len)+1)];
%tmp = filter(filt.Numerator, 1, wrappedIQ);
tmp = fftfilt(filt.Numerator, wrappedIQ);
iqdata = tmp(nfilt+1:end);
% for CPM modulation, we now convert phase into I/Q
if (iscpm ~= 0)
    iqdata = exp(j*real(iqdata));
end
% if oversampling was a fraction, downsample by the denominator
if (overD ~= 1)
    iqdata = downsample(iqdata, overD);
end
% if low oversampling was used, interpolate now
if (overK ~= 1)
    iqdata = interpft(iqdata, overK * length(iqdata));
end
% for OQPSK, shift Q by 1 symbol
if (offsetmod)
    iqdata = iqdelay(iqdata, fs, 1/2 * (overN * overK / (overD * fs)));
end

%----- apply amplitude-dependent phase correction
% pow = abs(iqdata).^2;
% pow = pow / max(pow);
% pow = pow .^ 1.0;
% phi = 0.6 .* pow - 0.035;
% gain = 1 + (+0.17 .* pow);
% iqdata = iqdata .* gain .* exp(1i*phi);
%-----
% apply quadrature error:  I' = I*cos(phi)+Q*sin(phi) and  Q' = Q
if (quadErr ~= 0)
    qe = quadErr * pi / 180;
    iqdata = complex(real(iqdata) * cos(qe) + imag(iqdata) * sin(qe), imag(iqdata));
end
% apply skew:  I' = delay(I) and  Q' = Q
if (iqskew ~= 0)
    iqdata = iqdelay(iqdata, fs, iqskew);
end
% apply gain imbalance:  I' = gain(I) and  Q' = Q
if (gainImb ~= 0)
    iqdata = complex(real(iqdata) * 10^(gainImb/20), imag(iqdata));
    scale = max(max(real(iqdata)), max(imag(iqdata)));
    if (scale > 1)
        iqdata = iqdata ./ scale;
    end
end
end


%% generate random data stream
function sym = generate_sym(numSymbols, k, randStream, data, dataContent, filename)
% generate symbols
sym = [];
b = floor(log2(k));     % number of bits per symbol (just powers of 2 for now)
numBits = b * numSymbols;
if (ischar(data))
    if (~isempty(strfind(data, 'from file')))
        data = regexprep(data, '(.*) from file', 'User defined $1');
        try
            f = fopen(filename, 'r');
            dataContent = fscanf(f, '%d');
            fclose(f);
        catch ex
            fclose(f);
            dataContent = zeros(numBits, 1);
            errordlg(ex.message);
        end
    end
    % legacy: clock = dataRate/2 pattern
    if (strcmpi(data, 'clock'))
        data = 'clock2';
    end
    switch(lower(data))
        case {'clock2' 'clock4' 'clock8' 'clock16'}
            div = str2double(data(6:end));
            if (mod(numSymbols, div) ~= 0)
                warndlg(sprintf('Number of symbols is not divisible by %d - clock pattern will not be periodic', div));
            end
            sym = repmat([zeros(1,div/2) (k-1)*ones(1,div/2)], 1, ceil(numSymbols / div));
        case 'clockonce'
            sym = [zeros(1,floor(numSymbols/2)) (k-1)*ones(1,numSymbols-floor(numSymbols/2))];
        case 'counter'
            if (mod(numSymbols, k) ~= 0)
                warndlg(sprintf('Number of symbols is not divisible by %d - counter pattern will not be periodic', k));
            end
            sym = repmat(linspace(0, k-1, k), 1, ceil(numSymbols / k));
        case 'random'
            data = randStream.rand(1,numBits) < 0.5;
        case 'prbs2^7-1'
            h = commsrc.pn('GenPoly', [7 6 0], 'NumBitsOut', numBits);
            data = 1 - flipud(h.generate())';
        case 'prbs2^9-1'
            h = commsrc.pn('GenPoly', [9 5 0], 'NumBitsOut', numBits);
            data = 1 - flipud(h.generate())';
        case 'prbs2^10-1'
            h = commsrc.pn('GenPoly', [10 7 0], 'NumBitsOut', numBits);
            data = 1 - flipud(h.generate())';
        case 'prbs2^11-1'
            h = commsrc.pn('GenPoly', [11 9 0], 'NumBitsOut', numBits);
            data = 1 - flipud(h.generate())';
        case 'prbs2^15-1'
            h = commsrc.pn('GenPoly', [15 14 0], 'NumBitsOut', numBits);
            data = 1 - flipud(h.generate())';
        case 'user defined symbols'
            numSymbols = length(dataContent);
            dataContent = round(dataContent);
            if (min(dataContent) < 0 || max(dataContent) >= k)
                dataContent(dataContent < 0) = 0;
                dataContent(dataContent >= k) = k - 1;
                errordlg(sprintf('User defined symbols must be in the range 0 to %d', k-1));
            end
            sym = reshape(dataContent, 1, numSymbols);
        case 'user defined bits'
            numBits = length(dataContent);
            dataContent = round(dataContent);
            if (min(dataContent) < 0 || max(dataContent) > 1)
                dataContent(dataContent < 0) = 0;
                dataContent(dataContent > 1) = 1;
                errordlg('User defined bits must use values 0 and 1');
            end
            if (mod(numBits, b) ~= 0)
                errordlg(sprintf('Number of bits must be a multiple of %d', b));
                numBits = floor(numBits / b) * b;
                dataContent = dataContent(1:numBits);
            end
            numSymbols = numBits / b;
            data = reshape(dataContent, numBits, 1);
        otherwise
            errordlg(['undefined data pattern: ' data]);
    end
elseif (isvector(data))     % legacy: data can be a vector of bits
    numBits = length(data);
    % make sure the data is in the correct format
    data = reshape(data, numBits, 1);
else
    error('data must be a string with a predefined data pattern or a vector of bits');
end
if (isempty(sym))
    % convert from numBits of [0..1] to numSymbols of [0..k-1]
    weight = repmat(fliplr(2.^(0:b-1))', 1, numSymbols);
    data = reshape(data, b, numSymbols);
    sym = sum(weight .* data, 1);
end
end


function phase = modulate_cpm(sym, os)
t = (1:os)/os;
pht = zeros(length(t), 4);
% 4 phase trajectories, depending on previous and current bit
pht(:,1) = -t;
pht(:,2) = -sin(pi*t)/pi;
pht(:,3) = sin(pi*t)/pi;
pht(:,4) = t;
phaseOffset = [-1 0 0 1];
numBits = length(sym);
res = zeros(os, numBits);
flag = sym(numBits);
phMemory = 0;
for k=1:numBits
    % index into array of phase trajectories
    idx = 2*flag + sym(k) + 1;
    flag = sym(k);
    res(:,k) = phMemory + pht(:,idx);
    phMemory = phMemory + phaseOffset(idx);
end 
phase = res(1:end) * pi;
%iq = exp(j*phase);
%n = 100;
%figure(21); plot([res(end-n+1:end) res(1:n)], '.-');
%figure(22); plot([[real(iq(end-n+1:end))' imag(iq(end-n+1:end))']; [real(iq(1:n))' imag(iq(1:n))']], '.-');
end
