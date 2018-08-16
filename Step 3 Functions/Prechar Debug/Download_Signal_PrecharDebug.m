function error =  Download_Signal_PrecharDebug()
error = '';
load(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");    
try
    if (strcmp(RX.Type,'Scope'))
        CaptureScope_64bit
    end
    %Rec = In_ori;
    DownloadSignal
catch
    error = 'An error has occurred while attempting to download the signal.';
end
save(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
end