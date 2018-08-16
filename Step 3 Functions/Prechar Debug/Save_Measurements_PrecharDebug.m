function result = Save_Measurements_PrecharDebug()
error = '';
data = '';
load(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
try
    SaveSignalGenerationMeasurements
    dBnmse = 10*log10((NMSE/100)^2);
    data = sprintf('%f~%f~%f~%f',NMSE,dBnmse,TX.AWG.ExpansionMarginSettings.PAPR_original,TX.AWG.ExpansionMarginSettings.PAPR_input);
catch
    error = 'An error has occurred while attempting to save measurements.';
end

result = sprintf('%s~%s',error,data);

save(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
end