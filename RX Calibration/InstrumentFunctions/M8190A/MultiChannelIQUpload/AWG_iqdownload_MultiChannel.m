function result = AWG_iqdownload_MultiChannel(iqdata, fs, varargin)
% The iqdownload functionality is copied into this file, because of changes in the
% run stop behavior.
% Download a vector of I/Q samples to the configured AWG
% - iqdata - contains a row-vector of complex I/Q samples
%            additional columns may contain marker info
% - fs - sampling rate in Hz
% optional arguments are specified as attribute/value pairs:
% - 'segmentNumber' - specify the segment number to use (default = 1)
% - 'normalize' - auto-scale the data to max. DAC range (default = 1)
% - 'downloadToChannel - string that describes to which AWG channel
%              the data is downloaded. (deprecated, please use
%              'channelMapping' instead)
% - 'channelMapping' - new format for AWG channel mapping:
%              vector with 2 columns and 1..n rows. Columns represent 
%              I and Q, rows represent AWG channels. Each element is either
%              1 or 0, indicating whether the signal is downloaded to
%              to the respective channel
% - 'sequence' - description of the sequence table 
% - 'marker' - vector of integers that must have the same length as iqdata
%              low order bits correspond to marker outputs
% - 'arbConfig' - struct as described in loadArbConfig (default: [])
% - 'keepOpen' - if set to 1, will keep the connection to the AWG open
%              after downloading the waveform
% - 'run' - determines if the AWG will be started immediately after
%              downloading the waveform/sequence. (default: 1)
%
% If arbConfig is not specified, the file "arbConfig.mat" is expected in
% the current directory.
%
% Thomas Dippon, Keysight Technologies 2011-2016
%
% Disclaimer of Warranties: THIS SOFTWARE HAS NOT COMPLETED KEYSIGHT'S FULL
% QUALITY ASSURANCE PROGRAM AND MAY HAVE ERRORS OR DEFECTS. KEYSIGHT MAKES 
% NO EXPRESS OR IMPLIED WARRANTY OF ANY KIND WITH RESPECT TO THE SOFTWARE,
% AND SPECIFICALLY DISCLAIMS THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
% FITNESS FOR A PARTICULAR PURPOSE.
% THIS SOFTWARE MAY ONLY BE USED IN CONJUNCTION WITH KEYSIGHT INSTRUMENTS. 

%% parse optional arguments
segmNum = 1;
result = [];
keepOpen = 0;
normalize = 1;
downloadToChannel = [];
channelMapping = [1 0; 0 1];
sequence = [];
arbConfig = [];
clear marker;
run = 1;
for i = 1:nargin-2
    if (ischar(varargin{i}))
        switch lower(varargin{i})
            case 'segmentnumber';  segmNum = varargin{i+1};
            case 'keepopen'; keepOpen = varargin{i+1};
            case 'normalize'; normalize = varargin{i+1};
            case 'downloadtochannel'; downloadToChannel = varargin(i+1);
            case 'channelmapping'; channelMapping = varargin{i+1};
            case 'marker'; marker = varargin{i+1};
            case 'sequence'; sequence = varargin{i+1};
            case 'arbconfig'; arbConfig = varargin{i+1};
            case 'run'; run = varargin{i+1};
        end
    end
end

% convert old format for "downloadToChannel" to channelMapping
% new format is array with row=channel, column=I/Q
if (~isempty(downloadToChannel))
    disp('downloadToChannel is deprecated, please use channelMapping instead');
    if (iscell(downloadToChannel))
        downloadToChannel = downloadToChannel{1};
    end
    if (ischar(downloadToChannel))
        switch (downloadToChannel)
            case 'I+Q to channel 1+2'
                channelMapping = [1 0; 0 1];
            case 'I+Q to channel 2+1'
                channelMapping = [0 1; 1 0];
            case 'I to channel 1'
                channelMapping = [1 0; 0 0];
            case 'I to channel 2'
                channelMapping = [0 0; 1 0];
            case 'Q to channel 1'
                channelMapping = [0 1; 0 0];
            case 'Q to channel 2'
                channelMapping = [0 0; 0 1];
            case 'RF to channel 1'
                channelMapping = [1 1; 0 0];
            case 'RF to channel 2'
                channelMapping = [0 0; 1 1];
            case 'RF to channel 1+2'
                channelMapping = [1 1; 1 1];
            otherwise
                error(['unexpected value for downloadToChannel argument: ' downloadToChannel]);
        end
    end
end

if (ischar(channelMapping))
    error('unexpected format for parameter channelMapping: string');
end

% if markers are not specified, generate square wave marker signal
if (~exist('marker', 'var'))
    marker = [15*ones(floor(length(iqdata)/2),1); zeros(length(iqdata)-floor(length(iqdata)/2),1)];
end
% try to load the configuration from the file arbConfig.mat
load('arbConfig.mat');
arbConfig = loadArbConfig(arbConfig);

% make sure the data is in the correct format
if (isvector(iqdata) && size(iqdata,2) > 1)
    iqdata = iqdata.';
end

% normalize if required
if (normalize && ~isempty(iqdata))
    scale = max(max(abs(real(iqdata(:,1)))), max(abs(imag(iqdata(:,1)))));
    if (scale > 1)
        if (normalize)
            iqdata(:,1) = iqdata(:,1) / scale;
        else
            errordlg('Data must be in the range -1...+1', 'Error');
        end
    end
end

%% extract data
    numColumns = size(iqdata, 2);
    if (~isvector(iqdata) && numColumns >= 2)
        data = iqdata(:,1);
    else
        data = reshape(iqdata, numel(iqdata), 1);
    end
    if (isfield(arbConfig, 'DACRange') && arbConfig.DACRange ~= 1)
        data = data .* arbConfig.DACRange;
    end
    
%% apply I/Q gainCorrection if necessary
    if (isfield(arbConfig, 'gainCorrection') && arbConfig.gainCorrection ~= 0)
        data = complex(real(data) * 10^(arbConfig.gainCorrection/20), imag(data));
        scale = max(max(real(data)), max(imag(data)));
        if (scale > 1)
            data = data ./ scale;
        end
    end

%% extract markers - assume there are two markers per channel
    marker = reshape(marker, numel(marker), 1);
    marker1 = bitand(uint16(marker),3);
    marker2 = marker1;
%     marker2 = bitand(bitshift(uint16(marker),-2),3);
    
    len = length(data);
    if (mod(len, arbConfig.segmentGranularity) ~= 0)
        errordlg(['Segment size is ' num2str(len) ', must be a multiple of ' num2str(arbConfig.segmentGranularity)], 'Error');
        return;
    elseif (len < arbConfig.minimumSegmentSize && len ~= 0)
        errordlg(['Segment size is ' num2str(len) ', must be >= ' num2str(arbConfig.minimumSegmentSize)], 'Error');
        return;
    elseif (len > arbConfig.maximumSegmentSize)
        errordlg(['Segment size is ' num2str(len) ', must be <= ' num2str(arbConfig.maximumSegmentSize)], 'Error');
        return;
    end
    if (isfield(arbConfig, 'interleaving') && arbConfig.interleaving)
        fs = fs / 2;
        data = real(data);                              % take the I signal
        data = complex(data(1:2:end), data(2:2:end));   % and split it into two channels
        if (~isempty(marker1))
            marker1 = marker1(1:2:end);
            marker2 = marker2(1:2:end);
        end
        if (size(channelMapping, 1) == 4)
            if (max(max(channelMapping(1:2,:))) > 0)
                channelMapping(1:2,:) = [1 0; 0 1];
            end
            if (max(max(channelMapping(3:4,:))) > 0)
                channelMapping(3:4,:) = [1 0; 0 1];
            end
        else
            channelMapping = [1 0; 0 1];
        end
    end
    
%% establish a connection and download the data
    result = AWG_iqdownload_M8190A_MultiChannel(arbConfig, fs, data, marker1, marker2, segmNum, keepOpen, channelMapping, sequence, run);
end