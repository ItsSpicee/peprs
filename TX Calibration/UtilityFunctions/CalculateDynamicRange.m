function [DR, DR_re, DR_im] = CalculateDynamicRange(Coef, Display)
%% This function calculate the Dynamic Range of the coefficients
if nargin == 1
    Display = 0 ;
end

DR_re = 20*log10((max(abs(real(Coef))))/(min(abs(real(Coef)))));
DR_im = 20*log10((max(abs(imag(Coef))))/(min(abs(imag(Coef)))));
DR = max(DR_re,DR_im);

if Display
    disp([' Dynamic Range = ', num2str(DR), ' dB' ]);
    disp([' DR Real       = ', num2str(DR_re), ' dB' ]);
    disp([' DR Imag       = ', num2str(DR_im), ' dB' ]);
end

end
