function [diff_log_m, diff_arg] = LogDetector(x1, x2)

diff_log_m = log(abs(x1)) - log(abs(x2));
diff_arg = angle(x1) - angle(x2);

end
