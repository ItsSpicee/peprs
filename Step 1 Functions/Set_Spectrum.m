% attenuation must be an even number, if an odd number is given, the UXA rounds up

function result = Set_Spectrum(dict)

	errorString = " ";
	partNum = " ";
	dict.atten = str2double(dict.atten);
	dict.resolutionBand = str2double(dict.resolutionBand);
	dict.freq = str2double(dict.freq);
	dict.freqSpan = str2double(dict.freqSpan);
	dict.triggerLevel = str2double(dict.triggerLevel)

	try	
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
		
		%trigger source and trigger level
		if dict.trigger == "3"
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:SOURce %s', 'IMMediate'));
			UXAConfig.SA.TriggerSource = "IMM";
		elseif dict.trigger == "1"
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:SOURce %s', 'EXTernal1'));
			fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal1:LEVel %g', dict.triggerLevel));
			UXAConfig.SA.TriggerSource = "EXT1";
		elseif dict.trigger == "2"
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:SOURce %s', 'EXTernal2'));
			fprintf(spectrum, sprintf(':TRIGger1:SEQuence:EXTernal2:LEVel %g', dict.triggerLevel));
			UXAConfig.SA.TriggerSource = "EXT2";
		elseif dict.trigger == "0"
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
		
		if dict.resolutionBand >= 1 && dict.resolutionBand <= 8e6 
			fprintf(spectrum, sprintf(':SENSe:BANDwidth:RESolution %g', dict.resolutionBand));
			UXAConfig.ResBW = dict.resolutionBand;
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

	catch
	   errorString = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";  
	   instrreset
	end

	resultsString = sprintf("%s;%s",partNum,errorString);
	result = char(resultsString);
end
        
    