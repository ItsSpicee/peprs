% Return Signal Path
function [signal_path, signal_numbers] = ReturnSignalPath(Signals_Files, index)
IQ_Files = Signals_Files(index, :);
signal_name = IQ_Files{1};
signal_path = strcat(pwd, '\IQ Files\', signal_name, '\');
signal_numbers = IQ_Files{2};

end
