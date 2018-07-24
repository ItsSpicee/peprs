function PlotSignal(varargin)
%% This function is used to plot the abs of signals
cc=hsv(nargin);
figure()

hold on
grid on

for idx = 1:nargin
    PSD = plot(abs(varargin{idx}), '.-');
    set(PSD, 'Color', cc(idx,:), 'DisplayName', inputname(idx));
end

l = legend('show');
set(l, 'Interpreter', 'none');
hold off

end
