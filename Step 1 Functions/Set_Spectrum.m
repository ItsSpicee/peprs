% attenuation must be an even number, if an odd number is given, the UXA rounds up

function result = Set_Spectrum(dict,model)

	errorString = " ";
	partNum = " ";
	dict.atten = str2double(dict.atten);
	dict.resBand = str2double(dict.resBand);
	dict.freq = str2double(dict.freq);
	dict.freqSpan = str2double(dict.freqSpan);
	dict.trigLevel = str2double(dict.trigLevel)

	% try	
		load(".\InstrumentFunctions\SignalCapture_UXA\UXAConfig.mat")
		spectrum = visa('agilent',dict.address);
		spectrum.InputBufferSize = 8388608;
		spectrum.ByteOrder = 'littleEndian';
		fopen(spectrum);
		UXAConfig.Address = dict.address;
		
		idn = query(spectrum, '*IDN?');
		splitIdn = strsplit(idn,',');
		partNum = splitIdn{2};
		
		UXAConfig.Model = model;
		
		% set instrument screens
		C = textscan(query(spectrum, ':INSTrument:SCReen:CATalog?'), '%q', 'Delimiter', ',');
		catalog = C{1}{1};
		splitCatalog = strsplit(catalog,',');
		catalogLength = length(splitCatalog);
		
		state = 0;
		for i=1:catalogLength
			if splitCatalog(i) == "Spectrum Analyzer"
				state = 1;
			end
		end
		if catalogLength == 1
			if state == 1
				fprintf(spectrum, sprintf(':INSTrument:SELect %s', 'SA'));
				fprintf(spectrum, ':CONFigure:SANalyzer:NDEFault');
			else
				fprintf(spectrum, sprintf(':INSTrument:SCReen:REName "%s"', 'Spectrum Analyzer'));
				fprintf(spectrum, sprintf(':INSTrument:SELect %s', 'SA'));
				fprintf(spectrum, ':CONFigure:SANalyzer:NDEFault');
			end
		else
			if state == 0
				fprintf(spectrum, ':INSTrument:SCReen:CREate');	
				fprintf(spectrum, sprintf(':INSTrument:SCReen:REName "%s"', 'Spectrum Analyzer'));
				fprintf(spectrum, sprintf(':INSTrument:SELect %s', 'SA'));
				fprintf(spectrum, ':CONFigure:SANalyzer:NDEFault');
			else
				fprintf(spectrum, sprintf(':INSTrument:SCReen:SELect "%s"', 'Spectrum Analyzer'));
			end
		end
		
		%trigger source and trigger level
		if dict.trigger == 3
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:SOURce %s', 'IMMediate'));
			UXAConfig.SA.TriggerSource = "IMM";
		elseif dict.trigger == 1
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:SOURce %s', 'EXTernal1'));
			fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal1:LEVel %g', dict.trigLevel));
			UXAConfig.SA.TriggerSource = "EXT1";
		elseif dict.trigger == 2
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:SOURce %s', 'EXTernal2'));
			fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal2:LEVel %g', dict.trigLevel));
			UXAConfig.SA.TriggerSource = "EXT2";
		elseif dict.trigger == 0
			errorString = "Please fill out all fields before attempting to set parameters."; 
		end
		UXAConfig.SA.TriggerLevel = dict.trigLevel;
		
		if isnan(dict.atten)
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 1));
			relAmpl = str2double(query(spectrum, ':SENSe:POWer:RF:ATTenuation?'));
			UXAConfig.Attenuation = relAmpl;
		else
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 0));
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation %g', dict.atten));
			UXAConfig.Attenuation = dict.atten;
		end
		
		fprintf(spectrum, sprintf(':SENSe:FREQuency:CENTer %g', dict.freq));
		UXAConfig.Frequency = dict.freq;
		fprintf(spectrum, sprintf(':SENSe:FREQuency:SPAN %g', dict.freqSpan));
		UXAConfig.FrequencySpan = dict.freqSpan;
		
		if dict.resBand >= 1 && dict.resBand <= 8e6 
			fprintf(spectrum, sprintf(':SENSe:BANDwidth:RESolution %g', dict.resBand));
			UXAConfig.ResBW = dict.resBand;
		else
			errorString = "Resolution bandwidth is out of range.";
		end

		if dict.clockRef == 1
			fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'INTernal'));
			UXAConfig.freqRef = "INT";
		elseif dict.clockRef == 2
			fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'EXTernal'));
			UXAConfig.freqRef = "EXT";
		else
			errorString = "Please select a reference clock";
		end

		save(".\InstrumentFunctions\SignalCapture_UXA\UXAConfig.mat","UXAConfig")
		% Cleanup
		fclose(spectrum);
		delete(spectrum);
		clear spectrum;

	% catch
	   % errorString = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";  
	   % instrreset
	% end

	resultsString = sprintf("%s;%s",partNum,errorString);
	result = char(resultsString);
end
        
    