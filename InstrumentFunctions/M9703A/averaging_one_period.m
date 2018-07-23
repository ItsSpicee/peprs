function [ y ] = averaging_one_period( x, period_length,  Fs, threshold )
%averafing_one_period average long periodic measurments.

discarded_points = mod(length(x), period_length);
periods_counts = length(x(1:end-discarded_points))/period_length;
y = zeros(periods_counts, period_length);
for i = 1 : periods_counts 
        index_start = (i-1)*period_length + 1;
        y(i, :) = x(index_start:(index_start+period_length-1));
end

[ y delay ] = Delay_Alignment_bel(y, Fs, threshold, 1000);

%y = sum(y, 1)/periods_counts;

end

%pt_bel(real(y(1,:)), imag(y(1,:)), real(y(20,:)), imag(y(20,:)), length(y));