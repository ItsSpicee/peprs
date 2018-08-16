function error = Upload_Signal_PrecharDebug()
error = '';
load(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
try
    % Send Signal 
    IterationCount = 1;
    memTrunc = 0;
    UploadSignal
    AWG_Upload_Script
catch
    error = 'An error has occurred while attempting to upload the signal.';
end

save(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
end