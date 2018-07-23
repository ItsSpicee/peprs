function [error_dB, per]= CalculateEVM (In, Out)
I_in = real(In); Q_in = imag(In);
Out_I = real(Out); Out_Q = imag(Out);

Perror = mean(abs(Out-In).^2);
Pref = mean(abs(In).^2);
error_dB = 10*log10( Perror / Pref );

E = mean((I_in-Out_I).^2 + (Q_in-Out_Q).^2);
ref = mean(I_in.^2 + Q_in.^2);
per = 100 * sqrt(E/ref);

end
