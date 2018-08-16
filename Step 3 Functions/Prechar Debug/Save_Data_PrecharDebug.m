function error = Save_Data_PrecharDebug()
error = '';
load(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
try
    % Save EVM Results
    if (RX.VSA.DemodSignalFlag)
        savevsarecording('Out_D_IFOut.mat', Out_D, Signal.Fsample, 0);
        measEVM = CalculateDemodEVM(RX.VSA.ASMPath,RX.VSA.SetupFile, strcat(RX.VSA.DataFile, 'Out_D_IFOut.mat'));
        display([ 'EVM         = ' num2str(measEVM.evm)      ' %']);
    end

    display([ 'NMSE         = ' num2str(NMSE)      ' % or ' num2str(10*log10((NMSE/100)^2))      ' dB ']);

%     [SAMeas, figHandle] = Save_Spectrum_Data();
catch
    error = 'An error has occurred while attempting to save data.';
end
save(".\DPD Data\Precharacterization Setup Parameters\workspace.mat");
end