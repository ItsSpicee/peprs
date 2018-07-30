function meas = CalculateDemodEVM(asmPath,setupFile,recallFile)
    asmName = 'Agilent.SA.Vsa.Interfaces.dll';
    asm = NET.addAssembly(strcat(asmPath, asmName));
    import Agilent.SA.Vsa.*;

    % Attach to a running instance of VSA. If there no running instance, 
    % create one.
    vsaApp = ApplicationFactory.Create();
    if (isempty(vsaApp))
        wasVsaRunning = false;
        vsaApp = ApplicationFactory.Create(true, '', '', -1);
    else
        wasVsaRunning = true;
    end

    % Make VSA visible
    vsaApp.IsVisible = true;

    % Label analyzer display
    vsaApp.Title = '5G NR Demodulation';

    % Get interfaces to major items
    vsaMeas = vsaApp.Measurements.SelectedItem;
    vsaDisp = vsaApp.Display;

    vsaApp.RecallSetup(setupFile)
    pause(2);
    vsaApp.Measurements.SelectedItem.Input.Recording.RecallFile(recallFile,'mat')
    vsaApp.Measurements.SelectedItem.Restart
    pause(2);
    meas.evm = vsaApp.Display.Traces.Item(7).MeasurementData.Summary(4); %% EVM
    meas.dataEvm = vsaApp.Display.Traces.Item(7).MeasurementData.Summary(19); %% Data EVM
    meas.pmblEVm = vsaApp.Display.Traces.Item(7).MeasurementData.Summary(20); %% Preamble EVM

    %  Quit VSA if it was started by the demo
    if (~wasVsaRunning)
        vsaApp.Quit;
    end
    vsaApp.delete;
    vsaDisp.delete;
    vsaMeas.delete;
end