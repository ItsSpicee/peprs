function iqsavewaveform(Y, fs, varargin)
% Save a waveform to a file (.MAT, .CSV, .IQBIN)
% A dialog will ask the user for a filename unless a argument 'savefile' is
% given
Y = reshape(Y, 1, length(Y));
marker = '';
savefile = [];
for i = 1:2:nargin-2
    if (ischar(varargin{i}))
        switch lower(varargin{i})
            case 'marker';   marker = varargin{i+1};
            case 'savefile'; savefile = varargin{i+1};
            otherwise error(['unexpected argument: ' varargin{i}]);
        end
    end
end
if (~isempty(savefile))
    if (~isempty(strfind(savefile, '.mat'))) %#ok<STREMP>
        filterindex = 1;
    elseif (~isempty(strfind(savefile, '.csv'))) %#ok<STREMP>
        filterindex = 3;
    elseif (~isempty(strfind(savefile, '.bin'))) %#ok<STREMP>
        filterindex = 4;
    elseif (~isempty(strfind(savefile, '.txt_tab'))) %#ok<STREMP>
        filterindex = 4;
    else
        error('can''t determine file type');
    end
else
    [FileName, PathName, filterindex] = uiputfile({...
        '.mat', 'MATLAB file (*.mat)'; ...
        '.mat', 'MATLAB v6 file (*.mat)'; ...
        '.csv', 'CSV file (*.csv)'; ...
        '.bin', 'IQBIN file (*.bin)'; ...
        '.csv', 'CSV (X/Y) (*.csv)'; ...
        '.txt', 'Signal Studio for Pulse Building IQ Import Compatible text file (*.txt)'}, ...
        'Save Waveform As...');
    if (FileName ~= 0)
        savefile = fullfile(PathName, FileName);
    end
end
if (~isempty(savefile))
    XDelta = 1/fs;
    XStart = 0; %#ok<NASGU>
    InputZoom = 1; %#ok<NASGU>
    try
        switch(filterindex)
            case 1 
                save(savefile, 'Y', 'XDelta', 'XStart', 'InputZoom');
            case 2
                Y = single(Y);
                save(savefile, '-v6', 'Y', 'XDelta', 'XStart', 'InputZoom');
            case 3
                csvwrite(savefile, [real(Y.') imag(Y.')]);
            case 4
                a1 = real(Y);
                a2 = imag(Y);
                scale = max(max(abs(a1)), max(abs(a2)));
                if (scale > 1)
                    a1 = a1 / scale;
                    a2 = a2 / scale;
                end
                if (isempty(marker))
                    marker = [ones(1,floor(length(a1)/2)) zeros(1,length(a1)-floor(length(a1)/2))];
                end
                data1 = int16(round(16383 * a1) * 2);
                data1 = data1 + int16(bitand(uint16(marker), 1));
                data2 = int16(round(16383 * a2) * 2);
                data2 = data2 + int16(bitand(uint16(marker), 1));
                data = [data1; data2];
                data = data(1:end);
                f = fopen(savefile, 'w');
                fwrite(f, data, 'int16');
                fclose(f);
            case 5
                csvwrite(savefile, [linspace(0,(length(Y)-1)*XDelta, length(Y))', real(Y.')]);
            case 6
                YWrite = [real(Y); imag(Y)];
                dlmwrite(savefile, YWrite(:), 'delimiter', '\t', 'precision', 16)
        end
    catch ex
        errordlg(ex.message);
    end
end   
