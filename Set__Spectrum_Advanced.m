function result = Set__Spectrum_Advanced(spectrumStruc)

errorString = " ";
partNum = " ";

try
    
    spectrum = visa('agilent',address);
    spectrum.InputBufferSize = 8388608;
    spectrum.ByteOrder = 'littleEndian';
    fopen(spectrum);
    
    %setting the screen name
    fprintf(SA.handle,'INSTrument:SCReen:CREate');
    fprintf(SA.handle,['INST:SCR:REN "' spectrumStruc.SAScreen '"']);
    
    %internal preamp
    if spectrumStruc.preAmp == "1"
        fprintf(spectrum, sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 1));
    elseif spectrumStruc.preAmp == "2"
        fprintf(spectrum, sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 0));
    end
    
    %trigger source
    
    if spectrumStruc.trigger == "1"
        fprintf(spectrum, sprintf(':SENSe:ACPR:TRIGger:SOURce %s', 'IMMediate'));
    elseif spectrumStruc.trigger == "2"
        fprintf(spectrum, sprintf(':SENSe:ACPR:TRIGger:SOURce %s', 'EXTernal1'));
    elseif spectrumStruc.trigger == "3"
        fprintf(spectrum, sprintf(':SENSe:ACPR:TRIGger:SOURce %s', 'EXTernal2'));
    end
    
    %trigger level
    if spectrumStruc.trigger == "2"
        fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal1:LEVel %g', str2double(spectrumStruc.triggerLevel)));
    elseif spectrumStruc.trigger == "3"
        fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal2:LEVel %g', str2double(spectrumStruc.triggerLevel));
    end
    
    %trace averaging
    
    if spectrumStruc.traceType == "1"
        fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'LOG'));
        fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', str2double(spectrumStruc.traceNum)));
    elseif spectrumStruc.traceType == "2"
        fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'RMS'));
        fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', str2double(spectrumStruc.traceNum)));
    elseif spectrumStruc.traceType == "3"
        fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'SCALar'));
        fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', str2double(spectrumStruc.traceNum)));
    end
    
    %Noise Extension
    
    if spectrumStruc.ACPNoise == "1"
        fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 1));
    elseif spectrumStruc.ACPNoise == "2"
        fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 0));
    end
    
    %ACP Integration Bandwidth
    
    fprintf(spectrum, sprintf(':SENSe:CHPower:BANDwidth:INTegration %g', spectrumStruc.ACPBand));
    
    %ACP Frequency Offset
    
    fprintf(spectrum, sprintf(':SENSe:ACPower:OFFSet:LIST:FREQuency %g', spectrumStruc.ACPOffset));
    
    
    
    
catch
   errorString = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";  
   instrreset
end

resultsString = sprintf("%s;%s",partNum,errorString);

result = char(resultsString);
end