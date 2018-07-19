function [figHandle] = PlotDFT( x, y, fs)
    Lx = length(x);
    Ly = length(y);
    freqx = -fs/2:fs/Lx:fs/2-fs/Lx;
    freqy = -fs/2:fs/Ly:fs/2-fs/Ly;

    Y_F = fftshift(fft(y)/Ly);
    X_F = fftshift(fft(x)/Lx);

    figHandle = figure;title('Raw FFT');hold on;

    plot(freqx/1e6, 10*log10(abs(X_F).^2/100) + 30, 'b.-', 'LineWidth',1); 
    plot(freqy/1e6, 10*log10(abs(Y_F).^2/100) + 30, 'r.-', 'LineWidth',1);
    grid on;
    xlabel('Frequency (MHz)'); ylabel('Amplitude (dBm)'); 
end
