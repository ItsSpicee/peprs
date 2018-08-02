function Prepare_Signal_Upload_PrecharDebug()
load(".\DPD Data\Signal Generation Parameters\workspace.mat");

% Prepare the signal for upload
% Limits PAPR, and filters out of band noise
ProcessInputFiles
PrepareData

save(".\DPD Data\Signal Generation Parameters\workspace.mat");
end