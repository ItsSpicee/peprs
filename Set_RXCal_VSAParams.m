% creates struct for parameters set in VSA equipment tab that are used in the
% RX Calibration code

function Set_RXCal_VSAParams(type)
    typeName = "";
    load(".\Measurement Data\RX Calibration Parameters\RX.mat")
    if type == 1 || type == 5
        typeName = "Scope"; 
    elseif type == 2 || type == 6
        typeName = "Digitizer";
    elseif type == 3 || type == 4
        typeName = "UXA";
    end
    RX.Type = typeName; % Choose between 'UXA', 'Digitizer', 'Scope', for the receiver
    
    
    save(".\Measurement Data\RX Calibration Parameters\RX.mat")
end