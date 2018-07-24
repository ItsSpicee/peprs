function [Out, h] = FracDelayWin(In, delay, filter_order)
% implementing fractional delay by window sinc
w = window(@chebwin,filter_order,100);  % Chebyshev window with sidelobes at -100dB
%w = window(@hanning,filter_order);  % Hanning window
%w = window(@rectwin,filter_order);  % Rectangular window

sample_times = -(filter_order-1)/2:1:(filter_order-1)/2;
sample_times = sample_times - delay;

h = sinc(sample_times') .* w;

Out = filter(h,1,In);
Out = Out((filter_order+1)/2:end)/sum(h);

end
