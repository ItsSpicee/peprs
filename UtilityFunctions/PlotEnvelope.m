function [figHandle] = PlotEnvelope( In, Out, length)
    % Plots the time domain of the signal envelope, I, Q, Magnitude, Phase
    if nargin < 3
        length = 250;
    end

    figHandle = figure;
    subplot(2,2,1); 
    plot(real(In(1:length)), 'k.-')
    hold on
    plot(real(Out(1:length)), 'b.-')
    ylabel('[V]')
    xlabel('Sample Number')
    title('I Component')
    grid on; 
    legend('In','Out')

    subplot(2,2,3); 
    plot(imag(In(1:length)), 'k.-')
    hold on
    plot(imag(Out(1:length)), 'b.-')
    ylabel('[V]')
    xlabel('Sample Number')
    title('Q Component')
    grid on; 

    subplot(2,2,2); 
    plot(abs(In(1:length)), 'k.-')
    hold on
    plot(abs(Out(1:length)), 'b.-')
    ylabel('[V]')
    xlabel('Sample Number')
    title('Envelope Magnitude')
    grid on; 

    subplot(2,2,4); 
    plot((180/pi*(angle(In(1:length)))), 'k.-')
    hold on
    plot((180/pi*(angle(Out(1:length)))), 'b.-')
    ylabel('[Degrees]')
    xlabel('Sample Number')
    title('Envelope Angle')
    grid on; 
end

