function [result, fs] = iqreadscope(arbConfig, chan, trigChan, duration, avg, maxAmpl, ~, trigDelay, trigLevel)
% read a waveform from scope
%
% arguments:
% arbConfig - if empty, use realtime scope address configured in IQTools config
% chan - cell array of scope channels to be captured ('1'-'4', 'DIFF1', 'DIFF2', 'REdge1', 'REdge3', 'DIFFREdge')
% trigChan - string with trigger channel ('1'-'4', 'AUX' or 'unused')
% duration - length of capture (in seconds)
% avg - number of averages (1 = no averaging)
% maxAmpl - amplitude of the signal (will be used to set Y scale)
%           if set to 0, will not set amplitude
%           if set to -1, will autoscale
% trigDelay - trigger delay (zero if not specified)
% trigLevel - trigger level (zero if not specified)
%
if (~exist('arbConfig', 'var'))
    arbConfig = [];
end
arbConfig = loadArbConfig(arbConfig);
if ((isfield(arbConfig, 'isScopeConnected') && arbConfig.isScopeConnected == 0) || ~isfield(arbConfig, 'visaAddrScope'))
    error('Scope address is not configured, please use "Instrument Configuration" to set it up');
end
if (~exist('chan', 'var'))
    chan = {'1' '2'};
end
if (~exist('trigChan', 'var'))
    trigChan = 'unused';
end
if (~exist('duration', 'var') || isempty(duration))
    duration = 1e-6;
end
if (~exist('avg', 'var') || isempty(avg) || avg < 1)
    avg = 1;
end
if (~exist('maxAmpl', 'var') || isempty(maxAmpl))
    maxAmpl = 800e-3;
end
if (~exist('trigDelay', 'var') || isempty(trigDelay))
    trigDelay = 0;
end
if (~exist('trigLevel', 'var') || isempty(trigLevel))
    trigLevel = 0;
end
numChan = length(chan);
result = [];
fs = 0;
f = iqopen(arbConfig.visaAddrScope);
if (isempty(f))
    return;
end
xfprintf(f, sprintf('*CLS'));
xfprintf(f, sprintf(':TIMEbase:SCale %g', duration / 10));
xfprintf(f, sprintf(':TIMEbase:REFerence LEFT'));
xfprintf(f, sprintf(':TIMEbase:DELay %g', trigDelay));
%xfprintf(f, sprintf(':STOP'));   % do not stop, otherwise autoscale will not work
%xfprintf(f, sprintf(':ACQuire:BANDwidth MAX'));   % do not set max BW, user might not want that
if (avg > 1)
    xfprintf(f, sprintf(':ACQuire:AVERage:COUNT %d', avg));
    xfprintf(f, sprintf(':ACQuire:AVERage ON'));
else
    xfprintf(f, sprintf(':ACQuire:AVERage OFF'));
end
xfprintf(f, sprintf(':ACQuire:MODE RTIME'));
xfprintf(f, sprintf(':ACQuire:RESPonse FLATmag'));
% turn off the default channel in case it is not used - it will be turned
% back on below if it is part of the configuration
xfprintf(f, ':CHAN1:DISP OFF');
for i = 1:numChan
    if (strncmpi(chan{i}, 'DIFF', 4))
        if (strncmpi(chan{i}, 'DIFFRE', 6))
            chan{i} = '1';      % differential real edge is only available on channel 1
            xfprintf(f, sprintf(':ACQuire:REDGE ON'), 1);
        else                    % differential signalling on a normal channel
            chan{i} = chan{i}(5);
        end
        xfprintf(f, sprintf(':CHAN%s:DIFF ON', chan{i}));
        % amplitude values seem to be specified per channel and NOT for the
        % differential channel
        ampl = maxAmpl(min(i,length(maxAmpl))) / 2;
    elseif (strncmpi(chan{i}, 'REdge', 5))  % real edge, single ended
        chan{i} = chan{i}(6);
        xfprintf(f, sprintf(':ACQuire:REDGE ON'), 1);
        ampl = maxAmpl(min(i,length(maxAmpl)));
    else                                    % normal channel, single ended
        chan{i} = chan{i}(1);
        xfprintf(f, sprintf(':CHAN%s:DIFF OFF', chan{i}));
        ampl = maxAmpl(min(i,length(maxAmpl)));
    end
    xfprintf(f, sprintf(':CHAN%s:DISP ON', chan{i}));
    if (ampl < 0) % autorange, but ignore errors - known bug in scopes
        xfprintf(f, ':RUN');
        xfprintf(f, sprintf(':AUTOSCALE:VERT CHAN%s', chan{i}), 1);
        xquery(f, '*OPC?');
        ampl = 0;
    end
    if (ampl > 0) % zero means do not set amplitude
        xfprintf(f, sprintf(':CHAN%s:RANGe %g', chan{i}, ampl));
        xfprintf(f, sprintf(':CHAN%s:OFFS %g', chan{i}, 0));
    end
end
if (~isempty(trigChan))
    if (strncmpi(trigChan, 'REdge', 5))
        trigChan = trigChan(6:end);
    end
    trigAuto = 0;
    if (strcmpi(trigChan, 'unused'))
        xfprintf(f, sprintf(':TRIGger:EDGE:SOURce CHAN1'));
        xfprintf(f, sprintf(':TRIGger:LEVel CHAN1,%g', trigLevel));
        trigAuto = 1;
    elseif (strcmp(trigChan, 'AUX'))
        xfprintf(f, sprintf(':TRIGger:EDGE:SOURce AUX'));
        xfprintf(f, sprintf(':TRIGger:LEVel AUX,%g', trigLevel));
    else
        xfprintf(f, sprintf(':CHAN%s:DISP OFF', trigChan));
        xfprintf(f, sprintf(':TRIGger:EDGE:SOURce CHAN%s', trigChan));
        xfprintf(f, sprintf(':TRIGger:LEVel CHAN%s,%g', trigChan, trigLevel));
        ampl = maxAmpl(1);
        if (ampl < 0) % autorange
            xfprintf(f, sprintf(':CHAN%s:DISP ON', trigChan));
            xfprintf(f, sprintf(':AUTOSCALE:VERT CHAN%s', trigChan));
            xquery(f, '*OPC?');
            ampl = 0;
        end
        if (ampl > 0)
            xfprintf(f, sprintf(':CHAN%s:RANGe %g', trigChan, maxAmpl(1)));
            xfprintf(f, sprintf(':CHAN%s:OFFS %g', trigChan, 0));
        end
        xfprintf(f, sprintf(':CHAN%s:DISP OFF', trigChan));
    end
    xfprintf(f, sprintf(':TRIGger:MODE EDGE'));
    xfprintf(f, sprintf(':TRIGger:EDGE:SLOPe POS'));
    if (trigAuto)
        xfprintf(f, sprintf(':TRIGger:SWEEP AUTO'));
    else
        xfprintf(f, sprintf(':TRIGger:SWEEP TRIGgered'));
    end
end
%xfprintf(f, sprintf(':ACQuire:SRATE MAX'));     % hmmm, does not work...  assume it is already set to max
fs = str2double(xquery(f, ':ACQuire:SRATE?'));
numPts = round(duration * fs);
xfprintf(f, sprintf(':ACQuire:POINts %d', numPts));
xfprintf(f, sprintf(':ACQuire:INTerpolate OFF'));
% chaning the number of points might change the sample rate, so set it back
xfprintf(f, sprintf(':ACQuire:SRATE %g', fs));

xfprintf(f, ':WAVeform:FORMat WORD');
if (strcmp(f.type, 'tcpip'))
    xfprintf(f, ':WAVeform:BYTeorder MSBFIRST');
else
    xfprintf(f, ':WAVeform:BYTeorder LSBFIRST');
end
xquery(f, ':ADER?');  % clear acquisition done register
xfprintf(f, ':SINGLE');
retry = 0;
done = str2double(xquery(f, ':ADER?'));
% wait max. 5 sec for a trigger event - otherwise fail (Z592 is particularly slow...)
while (~done && retry < 50)
    pause(0.1);
    done = str2double(xquery(f, ':ADER?'));
    retry = retry + 1;
end
if (~done)
    errordlg('Scope did not trigger. Please verify that the connections between AWG and scope match the configuration');
    fclose(f);
    return;
end
result = zeros(numPts, numChan);
for i = 1:numChan
    xfprintf(f, sprintf(':WAVeform:SOURce CHAN%s', chan{i}));
    pre = xquery(f, ':WAVeform:PREamble?');
    pre = eval(['{' regexprep(pre, '"', '''') '}']);
    fields = {'wav_form', 'acq_type', 'wfmpts', 'avgcnt', 'x_increment', 'x_origin', ...
    'x_reference', 'y_increment', 'y_origin', 'y_reference', 'coupling', ...
    'x_display_range', 'x_display_origin', 'y_display_range', ...
    'y_display_origin', 'date', 'time', 'frame_model', 'acq_mode', ...
    'completion', 'x_units', 'y_units', 'max_bw_limit', 'min_bw_limit'};
    prx = cell2struct(pre, fields, 2);
    fprintf(f, ':WAVeform:DATa?');
    r = fread(f, 1);
    if (~strcmp(char(r), '#'))
        error('unexpected binary format');
    end
    r = fread(f, 1);
    nch = str2double(char(r));
    r = fread(f, nch);
    nch = floor(str2double(char(r))/2);
    if (nch > 0)
        a = fread(f, nch, 'int16');
    else
        a = [];
    end
    fread(f, 1); % real EOL
    xval = linspace(prx.x_origin, prx.x_origin + (prx.wfmpts-1)*prx.x_increment, prx.wfmpts);
    yval = a .* prx.y_increment + prx.y_origin;
    result(:,i) = yval;
end
xfprintf(f, sprintf(''));
fclose(f);
if (nargout == 0)
    figure(1);
    plot(xval, result, '.-');
    grid on;
end


function retVal = xfprintf(f, s, ignoreError)
% Send the string s to the instrument object f
% and check the error status
% if ignoreError is set, the result of :syst:err is ignored
% returns 0 for success, -1 for errors
retVal = 0;
if (evalin('base', 'exist(''debugScpi'', ''var'')'))
    fprintf('%s - %s\n', f.RsrcName, s);
end
fprintf(f, s);
rptErr = 0;
while rptErr < 50
    result = query(f, ':syst:err? string');
    if (isempty(result))
        fclose(f);
        errordlg(sprintf(['The instrument at %s did not respond to a :SYST:ERRor query.' ...
            'Please check that the firmware is running and responding to commands.'], f.RsrcName), 'Error');
        retVal = -1;
        return;
    end
    if (strncmp(result, '0', 1))
        break;
    elseif (~exist('ignoreError', 'var') || ignoreError == 0)
        fprintf('%s ERROR: %s -> %s\n', f.RsrcName, s, strtrim(result));
        errordlg({'Instrument returns an error on command:' s 'Error Message:' strtrim(result)}, 'Error', 'replace');
        retVal = -1;
    end
    rptErr = rptErr + 1;
end


function retVal = xquery(f, s)
% send a query to the instrument object f
retVal = query(f, s);
% set debugScpi=1 in MATLAB workspace to log SCPI commands
if (evalin('base', 'exist(''debugScpi'', ''var'')'))
    if (length(retVal) > 60)
        rstr = sprintf('%s... (total %d chars)', retVal(1:60), length(retVal));
    else
        rstr = retVal;
    end
    fprintf('%s - %s -> %s\n', f.RsrcName, s, strtrim(rstr));
end



