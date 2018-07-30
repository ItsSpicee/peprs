function NMSE = f_nmse(p,m)
 NMSE = 10*log10(mean(((abs(p-m).^2)/mean(abs(m)).^2)));
%  NMSE = (mean(((abs(p-m).^2)/mean(abs(m)).^2)));