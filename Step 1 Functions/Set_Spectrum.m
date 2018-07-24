
function result = Set_Spectrum(dict)

errorString = " ";
partNum = " ";

try
    
    
    spectrum = visa('agilent',dict.address);
    spectrum.InputBufferSize = 8388608;
    spectrum.ByteOrder = 'littleEndian';
    fopen(spectrum);
    
    idn = query(spectrum, '*IDN?');
    
    splitIdn = strsplit(idn,',');
    
    partNum = splitIdn{2};
    
    if dict.attenEnabled == 2
        fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation %g', dict.atten));
    end
    
    fprintf(spectrum,['FREQ:CENT ' num2str(dict.freq)]);
    fprintf(spectrum,['FREQ:SPAN ' num2str(dict.freqSpan)]);
    
    % Commands
    if dict.resolutionBand >= 1 && dict.resolutionBand <= 8e6 
        fprintf(spectrum, sprintf(':SENSe:BANDwidth:RESolution %g', dict.resolutionBand));
    else
        errorString = "Resolution bandwidth is out of range.";
    end

    if dict.clockRef == 1
        fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'INTernal'));
    elseif dict.clockRef == 2
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
        
    