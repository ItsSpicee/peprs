function error = Prepare_Signal_Upload_PrecharDebug()
load(".\DPD Data\Signal Generation Parameters\workspace.mat");
error = '';
try
    % Prepare the signal for upload
    % Limits PAPR, and filters out of band noise
    ProcessInputFiles
    PrepareData
catch
    error = 'An error has occurred while attempting to prepare signal for upload.';
end

save(".\DPD Data\Signal Generation Parameters\workspace.mat");
end