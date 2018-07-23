function [ H_forward ] = CalculateForwardResponseModel( InputSignal, OutputSignal, ToneFreq, FsampleTx, TrainingLength)
    if nargin < 5
        TrainingLength = 20e3;
    end
%     L = length(InputSignal);
    L = TrainingLength;
%     L = 60e3;
    InputSignal = InputSignal(1:L);
    OutputSignal = OutputSignal(1:L);
    res             = FsampleTx / L;
    faxis           = -FsampleTx/2: FsampleTx/L : FsampleTx/2 - res;
    tone_index      = find(ismember(faxis,ToneFreq));   % return tones freq index
    if (length(tone_index) ~= length(ToneFreq))
        display('Error')
    end
    In_freq         =  fftshift(fft(InputSignal))/L; 
    Rec_freq        =  fftshift(fft(OutputSignal))/L;  
    tones_rec       =  Rec_freq(tone_index);
    tones_in        =  In_freq(tone_index);
%     figure
%     subplot(2,1,1); plot(ToneFreq,  10*log10(abs(tones_rec).^2/100)+30, '.-'); hold on; plot(ToneFreq,  10*log10(abs(tones_in).^2/100)+30, '.-r'); grid on;title('Mag')
%     subplot(2,1,2); plot(ToneFreq,  180/pi*unwrap(phase(tones_rec)), '.-'); hold on; plot(ToneFreq, 180/pi*unwrap(phase(tones_in)), '.-r'); grid on;title('Phase')
    % Construct the LUT
    H_forward =  tones_rec ./ tones_in;
%     figure;
%     subplot(2,1,1); plot(ToneFreq,  20*log10(abs(H_forward)), '.-'); hold on; grid on;title('Mag')
%     subplot(2,1,2); plot(ToneFreq,  180/pi*unwrap(phase(H_forward)), '.-'); hold on; grid on;title('Phase')
end

