% Check Coefficient Dynamic Range
function [DR, DR_real, DR_imag] = CheckDR(Coef)
        DR_real = 20*log10( (max(abs(real(Coef))))/(min(abs(real(Coef)))));
        DR_imag = 20*log10( (max(abs(imag(Coef))))/(min(abs(imag(Coef)))));
        DR = max(DR_real,DR_imag);
end
