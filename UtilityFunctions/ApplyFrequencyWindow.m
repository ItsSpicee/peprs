function [In_Filtered] = ApplyFrequencyWindow( In, Fsample, Fcutoff)
% Apply a rectangular frequency window to the signal
% TODO: To synthesize arbitrary windows base don the inputs
    
    L = length(In);
    FRes = Fsample/L;
    In_F = fftshift(fft(In));
    F   = -Fsample/2:FRes:Fsample/2-FRes;
    % index of the cutoff freq
    [~, FcNegIndex] = min(abs(F-(-Fcutoff)));  
    [~, FcPosIndex] = min(abs(F-(+Fcutoff))); 
    InFiltered_F    = zeros(size(In));
    InFiltered_F(FcNegIndex:FcPosIndex) = In_F(FcNegIndex:FcPosIndex);
    
    % Apply rectangular freq window
    InFiltered_F(1:FcNegIndex(1)-1) = 0;
    InFiltered_F(FcPosIndex+1 : end) = 0;
    
    In_Filtered     = ifft(ifftshift(InFiltered_F));
end

