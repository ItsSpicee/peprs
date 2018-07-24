function iqresult = ApplyLUTCalibration(x, Fs, IF_Freq, IF_Cor_real, IF_Cor_imag, MirrorResponse)
    if nargin < 6
        MirrorResponse = 0;
    end
    % If the TX upconversion mirrored response rather than RX
    % downconversion
    if MirrorResponse
        x = conj(x);
    end
    %% This funciton assumes all the inputs are defined for negative frequencies.
    avg_power = CheckPower(x);
    L            = length(x) ;
    fdata        = fftshift(fft(x ,L))/L;
    res          = Fs/L;
    freq         = -Fs/2 : Fs/L: Fs/2-res;

    F_start      = IF_Freq(1);
    F_end        = IF_Freq(end);

    [~, f_start_index]       = min(abs(freq-F_start));
    [~, f_end_index]         = min(abs(freq-F_end));
%     f_start                  = freq(f_start_index);
%     f_end                    = freq(f_end_index);
    
    interpolatingIndices     = f_start_index:f_end_index;
    f_if                     = freq(interpolatingIndices);
    % f_if                     = f_start:res:f_end;
    Corr_real                = ones(size(x));
    Corr_imag                = zeros(size(x));

    % % The fstart and f_if(1) will always be equal, but the f_end will depend
    % % on the res. The construction of f_if will always result in 
    % % f_IF(end) <= f_end. So becasue we are interpolating the points, we can
    % % just increase the f_IF vector by 1 to avoid unequal lengths.
    % if (length(interpolatingIndices) ~= length(f_if))
    %     if (freq(interpolatingIndices(end)) > f_if(end))
    %         f_end_index = f_end_index + 1;
    %     end
    %     f_if = freq(f_start_index):res:freq(f_end_index);
    % else
    % 
    %end
    
    Corr_real(interpolatingIndices)   = interp1(IF_Freq, IF_Cor_real, f_if, 'spline');
    Corr_imag(interpolatingIndices)   = interp1(IF_Freq, IF_Cor_imag, f_if, 'spline');

    Corr_Complex             = complex(Corr_real, Corr_imag);
    iqresult                 = ifft(ifftshift(fdata .* Corr_Complex));
    iqresult                 = SetMeanPower(iqresult, avg_power);
    
    if MirrorResponse
        iqresult = conj(iqresult);
    end
end