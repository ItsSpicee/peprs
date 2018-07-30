function [x, xp, y, yo] = ReadSignals(folder_path)

if exist(fullfile(folder_path, 'Signals.mat'), 'file') == 2
    load(fullfile(folder_path, 'Signals.mat'));
else
    x_I_path  = fullfile(folder_path, 'I_Input_NoDPD_1.txt');
    xp_I_path = fullfile(folder_path, 'I_Input_PreDist_1.txt');
    y_I_path  = fullfile(folder_path, 'I_Output_WithDPD_1.txt');
    yo_I_path = fullfile(folder_path, 'I_Output_WithoutDPD.txt');
    x_Q_path  = fullfile(folder_path, 'Q_Input_NoDPD_1.txt');
    xp_Q_path = fullfile(folder_path, 'Q_Input_PreDist_1.txt');
    y_Q_path  = fullfile(folder_path, 'Q_Output_WithDPD_1.txt');
    yo_Q_path = fullfile(folder_path, 'Q_Output_WithoutDPD.txt');
    
    x_I  = dlmread(x_I_path, '\t');
    xp_I = dlmread(xp_I_path, '\t');
    y_I  = dlmread(y_I_path, '\t');
    yo_I = dlmread(yo_I_path, '\t');
    x_Q  = dlmread(x_Q_path, '\t');
    xp_Q = dlmread(xp_Q_path, '\t');
    y_Q  = dlmread(y_Q_path, '\t');
    yo_Q = dlmread(yo_Q_path, '\t');
    
    x  = complex(x_I, x_Q);
    xp = complex(xp_I, xp_Q);
    y  = complex(y_I, y_Q);
    yo = complex(yo_I, yo_Q);
    
    save(fullfile(folder_path, 'Signals.mat'), 'x', 'xp', 'y', 'yo');
end

end
