function [freq, spectrum1] = CalculatedSpectrum(In, Fs, Display)
if nargin == 2
    Display = false ;
end

h = spectrum.welch;
h.OverlapPercent = 50;
h.SegmentLength  = 2^12;%2048;
% h.SegmentLength  = 600*100;
h.windowName = 'Flat Top';
%     h.windowName = 'Hamming';
%     h.windowName = 'Chebyshev';

In  = msspectrum(h,In,'centerdc',Fs );
freq = Fs/2*(-1:2/(h.SegmentLength-1):1)+2140;
% freq = Fs/2*(-1:2/(h.SegmentLength-1):1)+2140;
spectrum1 = 10*log10(In.Data);

if Display
    figure();
    
    hold on
    grid on
    plot(Fs/2*(-1:2/(h.SegmentLength-1):1)+2140,10*log10(In.data),'r');
    xlabel('Frequency (MHz)','FontSize',10)
    ylabel('Power Spectrum Density (dBm)','FontSize',10)
    % legend('Input PSD','Output PSD',4)
    title('Power Spectrum Density','FontSize',12);
    
    hold off
    
end

end

