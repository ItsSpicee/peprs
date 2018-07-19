%% This function is used to plot the Spectrum
function PlotSpectrumNew(varargin)

if nargin > 1
    %Check if frequency is the first argument, eles default to 100 MHz
    if length(varargin{1}) == 1
        idx_offset = 1;
        Fs = varargin{1};
        cc=hsv(nargin-1);
    else
        idx_offset = 0;
        Fs = 100e6;
        cc=hsv(nargin);
    end
end

h = spectrum.welch ;
h.OverlapPercent = 95 ;
h.SegmentLength = 4096 ;
h.windowName = 'Flat Top';
figure()

hold on
grid on

for idx = 1+idx_offset:nargin
    PSD = plot(msspectrum(h, varargin{idx}, 'centerdc', true, 'Fs', Fs)) ;
    set(PSD, 'Color', cc(idx-idx_offset,:), 'LineWidth', 2, ...
        'DisplayName', inputname(idx)) ;
end

l = legend('show');
set(l, 'Interpreter', 'none');
hold off

end
