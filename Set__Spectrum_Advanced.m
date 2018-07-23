function result = Set__Spectrum_Advanced(dict)

errorString = " ";
partNum = " ";

try
    
    spectrum = visa('agilent',dict.address);
    spectrum.InputBufferSize = 8388608;
    spectrum.ByteOrder = 'littleEndian';
    fopen(spectrum);
    
    %setting the screen name
    fprintf(spectrum,'INSTrument:SCReen:CREate');
    fprintf(spectrum,['INST:SCR:REN "' dict.SAScreen '"']);
    
    %internal preamp
    if dict.preAmp == "1"
        fprintf(spectrum, sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 1));
    elseif dict.preAmp == "2"
        fprintf(spectrum, sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 0));
    end
    
    %trigger source
    
    if dict.trigger == "1"
        fprintf(spectrum, sprintf(':SENSe:ACPR:TRIGger:SOURce %s', 'IMMediate'));
    elseif dict.trigger == "2"
        fprintf(spectrum, sprintf(':SENSe:ACPR:TRIGger:SOURce %s', 'EXTernal1'));
    elseif dict.trigger == "3"
        fprintf(spectrum, sprintf(':SENSe:ACPR:TRIGger:SOURce %s', 'EXTernal2'));
    end
    
    %trigger level
    if dict.trigger == "2"
        fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal1:LEVel %g', str2double(dict.triggerLevel)));
    elseif dict.trigger == "3"
        fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal2:LEVel %g', str2double(dict.triggerLevel));
    end
    
    %trace averaging
    
    if dict.traceType == "1"
        fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'LOG'));
        fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', str2double(dict.traceNum)));
    elseif dict.traceType == "2"
        fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'RMS'));
        fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', str2double(dict.traceNum)));
    elseif dict.traceType == "3"
        fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'SCALar'));
        fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', str2double(dict.traceNum)));
    end
    
    %Noise Extension
    
    if dict.ACPNoise == "1"
        fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 1));
    elseif dict.ACPNoise == "2"
        fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 0));
    end
    
    %ACP Integration Bandwidth
    
    fprintf(spectrum, sprintf(':SENSe:CHPower:BANDwidth:INTegration %g', dict.ACPBand));
    
    %ACP Frequency Offset
    
    fprintf(spectrum, sprintf(':SENSe:ACPower:OFFSet:LIST:FREQuency %g', dict.ACPOffset));
    
    %Detector Type
    if dict.detector == "1"
        fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'NORMal'));
    elseif dict.detector == "2"
        fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'AVERage'));
    elseif dict.detector == "3"
        fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'POSittive'));
    end
        
    
    
catch
   errorString = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";  
   instrreset
end

resultsString = sprintf("%s;%s",partNum,errorString);

result = char(resultsString);
end