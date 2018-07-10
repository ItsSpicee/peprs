
function result = Set_Spectrum(address,attenEnabled, atten, freq, freqSpan, resolutionBand, clockRef)

errorString = " ";
partNum = " ";

try
    atten = str2double(atten);
    freq = str2double(freq);
    resolutionBand = str2double(resolutionBand);
    freqSpan = str2double(freqSpan);
    
    spectrum = visa('agilent',address);
    spectrum.InputBufferSize = 8388608;
    spectrum.ByteOrder = 'littleEndian';
    fopen(spectrum);
    
    idn = query(spectrum, '*IDN?');
    
    splitIdn = strsplit(idn,',');
    
    partNum = splitIdn{2};
    
    if attenEnabled == 1
        fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation %g', atten));
    end
    
    fprintf(spectrum,['FREQ:CENT ' num2str(freq)]);
    fprintf(spectrum,['FREQ:SPAN ' num2str(freqSpan)]);
    
    % Commands
    if resolutionBand >= 1 && resolutionBand <= 8e6 
        disp("hi")
        fprintf(spectrum, sprintf(':SENSe:BANDwidth:RESolution %g', resolutionBand));
    else
        errorString = "Resolution bandwidth is out of range.";
    end

    if clockRef == 1
        fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'INTernal'));
    elseif clockRef == 2
        fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'EXTernal'));
    else
        errorString = "Please select a reference clock";
    end





% Cleanup
fclose(spectrum);
delete(spectrum);
clear spectrum;

catch
   errorString = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";  
   instrreset
end

resultsString = sprintf("%s;%s",partNum,errorString);

result = char(resultsString);
end
        
    