function [  ] = ps( x, fs, mode)
% 0 means input in time
% 1 measn oinput is in frequeency and its already shifter
switch nargin
    case 1
        fs = 10e9;
        mode = 0;
    case 2
        mode = 0;
    otherwise

end


L = length(x);
freq = -fs/2:fs/L:fs/2-fs/L;

switch mode
    case 0 
        %x_p=fftshift(fft(x,L)/L);
        x_p=fftshift(fft(x)/L);
    case 1
        x_p = x;
end
    %%
%     tone_spacing = 10e6;
%     res = fs*2 / L;
%     faxis           = -fs/2: res : fs/2 - res;
%     tone_freq       = (-fs/2 :tone_spacing :fs/2 - tone_spacing);
%     %tone_freq_mod   = tone_freq(2:end);     
%     tone_freq_mod   = faxis           ;    
%     tone_index      = find(ismember(faxis,tone_freq_mod));   % return tones freq index
%     WaveformArray_averages_f = x_p(tone_index);
%     phases = (180/pi*angle(WaveformArray_averages_f));
%     
    %%
    fig = figure;title('Spectrum');hold on;
    %fig.Position = [0 250 570 510];
%      subplot(2,1,1)
        plot(freq, 10*log10(abs(x_p).^2/100) + 30, ...
            'm.-', 'LineWidth',1); grid on;
        xlabel('Frequency (MHz)'); ylabel('Amplitude (dBm)'); 
%      subplot(2,1,2)
%     fig = figure;title('Phase');hold on;
%          plot(freq/1e6, 180/pi*(angle(x_p)), ...
%              'k.-', 'LineWidth',1); grid on;
%          xlabel('Frequency (MHz)'); ylabel('Phase [degrees]'); 
end
