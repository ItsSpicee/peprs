function result = iqvsacqm(varargin);
% iqvsacal generates a calibration file for pre-distortion by reading the
% channel response from the VSA software
% usage: iqvsacal('param_name', value, 'param_name', value, ...)
% valid parameter names are:
%   symbolRate - symbol rate in Hz
%   modType - modulation type ('BPSK', 'QPSK', 'QAM4', 'QAM16', etc.)
%   filterType - type of pulse shaping filter
%   filterBeta - beta value of pulse shaping filter
%   carrierOffset - center frequency in Hz (0 in case of baseband data)
%   recalibrate - add new corr values to existing file
%
% iqvsacal looks for a variable called hVsaApp in the base MATLAB context.
% If it exists, it is assumed to be a handle to an instance of the VSA
% software. If it does not exist, it opens a new instance

result = [];

tone = [0];
mag = [0];
phase = [0];
fc = 0;
carrierOffset = 0;
recalibrate = 0;
useHW = 1;
doCal = 1;
i = 1;
while (i <= nargin)
    if (ischar(varargin{i}))
        switch lower(varargin{i})
            case 'tone';     tone = varargin{i+1};
            case 'mag';        mag = varargin{i+1};
            case 'phase';     phase = varargin{i+1};
            case 'fc';             fc = varargin{i+1};
            case 'carrieroffset';  carrierOffset = varargin{i+1};
            case 'recalibrate';    recalibrate = varargin{i+1};
            case 'usehw';          useHW = varargin{i+1};
            case 'docal';          doCal = varargin{i+1};
            otherwise error(['unexpected argument: ' varargin{i}]);
        end
    else
        error('string argument expected');
        return;
    end
    i = i+2;
end

if (fc == 0)
  fc = median(tone);
  carrierOffset = fc;
end

result = vsaCal(tone, mag, phase, fc, recalibrate, useHW, doCal, carrierOffset);
end


function result = vsaCal(freq, mag, phase, fc, recalibrate, useHW, doCal, carrierOffset)
    result = [];
    vsaApp = vsafunc([], 'open');
    if (~isempty(vsaApp))
        hMsgBox = msgbox('Configuring VSA software. Please wait...');
        if (useHW)
            vsafunc(vsaApp, 'preset');
            vsafunc(vsaApp, 'fromHW');
            fcx = fc;
            vsafunc(vsaApp, 'input', fcx);
            vsafunc(vsaApp, 'channelQuality', freq, mag, phase*360/(2*pi), true);

            spanScale = 1.01;
            
            %Find the span and set the offset correctly
            spanSet = max(freq) - min(freq);
            tuneOffset = (max(freq)+ min(freq))/2;
            
            vsafunc(vsaApp, 'freq', abs(fcx)+tuneOffset, spanSet*spanScale);
        end
        vsafunc(vsaApp, 'autorange');
        vsafunc(vsaApp, 'trace', 6, 'CQM');

        vsafunc(vsaApp, 'start', 1);
        pause(2);
        vsafunc(vsaApp, 'autoscale');
        try
            close(hMsgBox);
        catch
        end
        if (~doCal)
            return;
        end
        
        res = questdlg('VSA measurement running. Please press OK when Equalizer has stabilized. (Don''t forget to check input range...)','VSA Calibration','OK','Cancel','OK');
        
        if (~strcmp(res, 'OK'))
            return;
        end
        
        result = vsafunc(vsaApp, 'readEqDataChannel', recalibrate, freq, abs(fcx)-carrierOffset, false);
        if (result == 0)
                iqshowcorr();           
        end
        
        vsafunc(vsaApp, 'start', 1);
    end
end