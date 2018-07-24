% UXA is in the IQ Analyzer form when being used as a VSA
% resolution bandwidth only appears when filter type is moved from Flat Top (known as filter BW)
% attenuation must be an even number, if an odd number is given, the UXA rounds up

% TO DO: set appropriate screen based on which button is being set, remove trigger level from VSA UXA

"noAverages": self.ui.noAveragesField_sa.text(),
"trigLevel": self.ui.trigLevel_sa.text(),

function Set_VSA_UXA(dict)

dict.atten = str2double(dict.atten);
dict.freq = str2double(dict.freq);
dict.freqSpan = str2double(dict.freqSpan);
dict.analysisBW = str2double(dict.analysisBW);    
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
	
    if isnan(dict.atten)
		fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 1));
	else
		fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 0));
		fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation %g', dict.atten));
	end
    
    fprintf(spectrum, sprintf(':SENSe:FREQuency:CENTer %g', dict.freq));
    fprintf(spectrum, sprintf(':SENSe:FREQuency:SPAN %g', dict.freqSpan));

    if dict.clockRef == 1
        fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'INTernal'));
    elseif dict.clockRef == 2
        fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'EXTernal'));
    else
        errorString = "Please select a reference clock";
    end
	
	% Set the digital IF bandwidth
	fprintf(spectrum, sprintf(':SENSe:WAVeform:DIF:BANDwidth %g', dict.analysisBW);

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