% UXA is in the IQ Analyzer (Basic) Mode with the IQ Waveform Measurement when being used as a VSA
% there are spectrum and waveform commands, use the waveform! Complex Spectrum is the other kind of Measurement
% Keep filter type as Flat Top
% resolution bandwidth only appears when filter type is moved from Flat Top (known as filter BW)
% attenuation must be an even number, if an odd number is given, the UXA rounds up
% trigger level appears when appropriate trigger source is selected e.g. external
% there is no frequency span, only center frequency
% IQCapture_UXA is the relevant script

function result = Set_VSA_UXA(dict,model)
	dict.trigLevel = str2double(dict.trigLevel);
	dict.noAverages = str2double(dict.noAverages);
	dict.atten = str2double(dict.atten);
	dict.freq = str2double(dict.freq);
	dict.analysisBW = str2double(dict.analysisBW);    
	errorString = " ";
	partNum = " ";

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
		
		% turn averaging on or off
		if dict.averaging == 1
			fprintf(spectrum, sprintf(':SENSe:WAVeform:AVERage:STATe %d', 1));
			% determine number of averages
			fprintf(spectrum, sprintf(':SENSe:WAVeform:AVERage:COUNt %d', dict.noAverages));
		elseif dict.averaging == 2
			fprintf(spectrum, sprintf(':SENSe:WAVeform:AVERage:STATe %d', 0));
		end
		
		% set attenuation mode (auto or manual), if manual, set attenuation value
		if isnan(dict.atten)
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 1));
		else
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 0));
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:ATTenuation %g', dict.atten));
			UXAConfig.Attenuation = dict.atten;
		end
		
		% set frequency parameters
		fprintf(spectrum, sprintf(':SENSe:FREQuency:CENTer %g', dict.freq));
		UXAConfig.Frequency = dict.freq;

		% set frequency reference
		if dict.clockRef == 1
			fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'INTernal'));
		elseif dict.clockRef == 2
			fprintf(spectrum, sprintf(':SENSe:ROSCillator:SOURce %s', 'EXTernal'));
		else
			errorString = "Please select a reference clock";
		end
		
		% Set the digital IF bandwidth
		fprintf(spectrum, sprintf(':SENSe:WAVeform:DIF:BANDwidth %g', dict.analysisBW);

		% set trigger parameters
		if dict.trigSource == 1
			fprintf(spectrum, sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'EXTernal1'));
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:EXTernal1:LEVel %g', dict.trigLevel));
			UXAConfig.SA.TriggerSource = "EXT1";
		elseif dict.trigSource == 2
			fprintf(spectrum, sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'EXTernal2'));
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:EXTernal2:LEVel %g', dict.trigLevel));
			UXAConfig.SA.TriggerSource = "EXT2";
		elseif dict.trigSource == 3
			fprintf(spectrum, sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'EXTernal3'));
			fprintf(spectrum, sprintf(':TRIGger:SEQuence:EXTernal3:LEVel %g', dict.trigLevel));
			UXAConfig.SA.TriggerSource = "EXT3";
		elseif dict.trigSource == 4
			% immediate or free run trigger
			fprintf(spectrum, sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'IMMediate'));
			UXAConfig.SA.TriggerSource = "IMM";
		elseif dict.trigSource == 0
			errorString = "Please fill out all fields before attempting to set parameters."; 
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