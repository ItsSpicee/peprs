function error = Initialize_Drivers_HeterodyneDebug()
    load('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
    error = '';
    try
        if (~Cal.Processing32BitFlag)
            if (strcmp(RX.Type,'Scope'))
        %         [RX.Scope] = ScopeDriverInit( RX );
            elseif (strcmp(RX.Type,'Digitzer'))
                [RX.Digitizer] = ADCDriverInit( RX );
            end
        end
    catch
        error = 'A problem has occurred while attempting to initialize RX drivers.';
    end
    save('./Measurement Data/Heterodyne Calibration Parameters/workspace.mat')
end