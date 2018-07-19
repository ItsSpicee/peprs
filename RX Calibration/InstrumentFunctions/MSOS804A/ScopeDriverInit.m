function [ Scope_Driver ] = ScopeDriverInit( RX )
    driver = instrument.driver.AgilentInfiniium();
    % Edit resource and options as needed.  Resource is ignored if option Simulate=true
    %resourceDesc = 'GPIB0::07::INSTR';
    resourceDesc = RX.VisaAddress;
    initOptions  = 'QueryInstrStatus=true, Simulate=false, Model=DSO91304A, Trace=false';			
    idquery      = true;
    reset        = false;

    driver.Initialize(resourceDesc, idquery, reset, initOptions);
    driver.Acquisition.Type = 'IviScopeAcquisitionTypeAverage';

    %
    filepath = RX.ScopeIVIDriverPath;
    obj.handle{1} = icdevice(filepath, resourceDesc);
    connect(obj.handle{1});

    %
    interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', resourceDesc, 'Tag', '');

    % Create the VISA-TCPIP object if it does not exist
    % otherwise use the object that was found.
    if isempty(interfaceObj)
        interfaceObj = visa('AGILENT', resourceDesc);
    else
        fclose(interfaceObj);
        interfaceObj = interfaceObj(1);
    end
    interfaceObj.inputbuffersize = [5e06];
    fopen(interfaceObj);

    Scope_Driver.driver =  driver;
    Scope_Driver.obj.handle{1} = obj.handle{1};
    Scope_Driver.interfaceObj = interfaceObj;
end

