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
	errorString = "";
	partNum = "";
    errorList = [];
    error = "";

	try
		if dict.address == ""
			errorString = "Fill out general VSA parameters before attempting to set parameters.";
			resultsString = sprintf("%s~%s","",errorString);
			result = char(resultsString);
			return
		end
        instrreset
		load(".\InstrumentFunctions\SignalCapture_UXA\UXAConfig.mat")
		spectrum = visa('agilent',dict.address);
		spectrum.InputBufferSize = 8388608;
		spectrum.ByteOrder = 'littleEndian';
		fopen(spectrum);
		fprintf(spectrum,'*CLS');
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
			if splitCatalog(i) == "IQ Analyzer"
				state = 1;
			end
		end
		if state == 0
			errorList = runCommand(spectrum,':INSTrument:SCReen:CREate',errorList);
			errorList = runCommand(spectrum,sprintf(':INSTrument:SCReen:REName "%s"', 'IQ Analyzer'),errorList);
			errorList = runCommand(spectrum,sprintf(':INSTrument:SELect %s', 'BASIC'),errorList);
			errorList = runCommand(spectrum,':CONFigure:WAVeform:NDEFault',errorList);
		else
			errorList = runCommand(spectrum,sprintf(':INSTrument:SCReen:SELect "%s"', 'IQ Analyzer'),errorList);
		end
		
		% turn averaging on or off
		if dict.averaging == 1
			errorList = runCommand(spectrum,sprintf(':SENSe:WAVeform:AVERage:STATe %d', 1),errorList);
			% determine number of averages
			errorList = runCommand(spectrum,sprintf(':SENSe:WAVeform:AVERage:COUNt %d', dict.noAverages),errorList);
			UXAConfig.NumberSweepAverages = dict.noAverages;
		elseif dict.averaging == 2
			errorList = runCommand(spectrum,sprintf(':SENSe:WAVeform:AVERage:STATe %d', 0),errorList);
			UXAConfig.NumberSweepAverages = 0;
		end
		
		% set attenuation mode (auto or manual), if manual, set attenuation value
		if isnan(dict.atten)
			errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 1),errorList);
			relAmpl = str2double(query(spectrum, ':SENSe:POWer:RF:ATTenuation?'));
			UXAConfig.Attenuation = relAmpl;
		else
			errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:ATTenuation:AUTO %d', 0),errorList);
			errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:ATTenuation %g', dict.atten),errorList);
			UXAConfig.Attenuation = dict.atten;
		end
		
		% set frequency parameters
		errorList = runCommand(spectrum,sprintf(':SENSe:FREQuency:CENTer %g', dict.freq),errorList);
		UXAConfig.Frequency = dict.freq;

		% set frequency reference
		if dict.clockRef == 1
			errorList = runCommand(spectrum,sprintf(':SENSe:ROSCillator:SOURce %s', 'INTernal'),errorList);
			UXAConfig.freqRef = "INT";
		elseif dict.clockRef == 2
			errorList = runCommand(spectrum,sprintf(':SENSe:ROSCillator:SOURce %s', 'EXTernal'),errorList);
			UXAConfig.freqRef = "EXT";
		else
			errorString = "Please select a reference clock";
		end
		
		% Set the digital IF bandwidth
		errorList = runCommand(spectrum,sprintf(':SENSe:WAVeform:DIF:BANDwidth %g', dict.analysisBW),errorList);
		UXAConfig.AnalysisBW = dict.analysisBW;

		% set trigger parameters
        % if analysis BW is greater than 500e6, the trigger source must be
        % EXT3 or IMM
        if dict.analysisBW > 500e6
            if dict.trigSource == 3
                errorList = runCommand(spectrum,sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'EXTernal3'),errorList);
                errorList = runCommand(spectrum,sprintf(':TRIGger:SEQuence:EXTernal3:LEVel %g', dict.trigLevel),errorList);
                UXAConfig.SA.TriggerSource = "EXT3";
            elseif dict.trigSource == 4
                errorList = runCommand(spectrum,sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'IMMediate'),errorList);
                UXAConfig.SA.TriggerSource = "IMM";
            else
                error = "EXT1 and EXT2 trigger sources are not available when the analysis bandwidth is greater than 500e6.";
                errorList = [errorList,error];
            end 
        else    
            if dict.trigSource == 1
                errorList = runCommand(spectrum,sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'EXTernal1'),errorList);
                errorList = runCommand(spectrum,sprintf(':TRIGger:SEQuence:EXTernal1:LEVel %g', dict.trigLevel),errorList);
                UXAConfig.SA.TriggerLevel = dict.trigLevel;
                UXAConfig.SA.TriggerSource = "EXT1";
            elseif dict.trigSource == 2
                errorList = runCommand(spectrum,sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'EXTernal2'),errorList);
                errorList = runCommand(spectrum,sprintf(':TRIGger:SEQuence:EXTernal2:LEVel %g', dict.trigLevel),errorList);
                UXAConfig.SA.TriggerLevel = dict.trigLevel;
                UXAConfig.SA.TriggerSource = "EXT2";
            elseif dict.trigSource == 3
                errorList = runCommand(spectrum,sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'EXTernal3'),errorList);
                errorList = runCommand(spectrum,sprintf(':TRIGger:SEQuence:EXTernal3:LEVel %g', dict.trigLevel),errorList);
                UXAConfig.SA.TriggerSource = "EXT3";
            elseif dict.trigSource == 4
                % immediate or free run trigger
                errorList = runCommand(spectrum,sprintf(':TRIGger:WAVeform:SEQuence:SOURce %s', 'IMMediate'),errorList);
                UXAConfig.SA.TriggerSource = "IMM";
            elseif dict.trigSource == 0
                errorString = "Please fill out all fields before attempting to set parameters."; 
            end
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

	for i=1:length(errorList)
        if i == 1
            errorString = errorList(1);
        else
            errorString = sprintf('%s|%s',errorString,errorList(i));
        end
    end
    resultsString = sprintf("%s~%s",partNum,errorString);

	result = char(resultsString);
end
