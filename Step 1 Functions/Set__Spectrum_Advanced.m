function result = Set__Spectrum_Advanced(dict)
	dict.traceAvgNum = str2double(dict.traceAvgNum);
	errorString = " ";
	partNum = " ";

	try
		load(".\InstrumentFunctions\SignalCapture_UXA\UXAConfig.mat")
		spectrum = visa('agilent',dict.address);
		spectrum.InputBufferSize = 8388608;
		spectrum.ByteOrder = 'littleEndian';
		fopen(spectrum);
		
		%setting the screen names
		UXAConfig.SAScreenName = dict.SAScreen;
        UXAConfig.ACPScreenName = dict.ACPScreen;
		
		%internal preamp
		if dict.preAmp == 1
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 1));
			UXAConfig.PreampEnable = 1;
		elseif dict.preAmp == 2
			fprintf(spectrum, sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 0));
			UXAConfig.PreampEnable = 0;
		end
		
		%trace number, averaging, number of averages
		% trace number - determines which trace is set
		% traces can be of type WRITe, AVERage, MAXHold, MINHold. Only use WRITe and AVERage
		% averaging - true or false
			% true then type is set to AVERage and must provide number of averages
			% false then type is set to WRIT and no average number needed, default is 20 averages
		UXAConfig.SA.TraceNumber = str2double(dict.traceNum);
		UXAConfig.SA.TraceAverage = trace.avg;
		if trace.avg == 1
			fprintf(spectrum,sprintf(':TRACe%s:TYPE %s', dict.traceNum,'AVERage'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'RMS'));
			fprintf(spectrum, sprintf(':SENSe:DETector:%s %s', dict.traceNum, 'AVERage'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', dict.traceAvgNum);
			UXAConfig.SA.TraceAverageCount = dict.traceAvgNum;
		elseif trace.avg == 2
			fprintf(spectrum,sprintf(':TRACe%s:TYPE %s', dict.traceNum,'WRITe'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'LOG'));
			fprintf(spectrum, sprintf(':SENSe:DETector:%s %s', dict.traceNum, 'NORMal'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', 20);
			UXAConfig.SA.TraceAverageCount = 20;
		end
		
		%Noise Extension
		if dict.noiseExtension == 1
			fprintf(spectrum, sprintf(':SENSe:CORRection:NOISe:FLOor %d', 1));
		elseif dict.noiseExtension == 2
			fprintf(spectrum, sprintf(':SENSe:CORRection:NOISe:FLOor %d', 0));
		end
		
		%Noise Correction
		if dict.ACPCorrection == 1
			fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 1));
		elseif dict.ACPCorrection == 2
			fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 0));
		end
		
		%ACP Integration Bandwidth
		fprintf(spectrum, sprintf(':SENSe:CHPower:BANDwidth:INTegration %g', dict.ACPBand));
		
		%ACP Frequency Offset
		fprintf(spectrum, sprintf(':SENSe:ACPower:OFFSet:LIST:FREQuency %g', dict.ACPOffset));
		
		%Detector Type
		if dict.detector == 1
			fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'NORMal'));
		elseif dict.detector == 2
			fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'AVERage'));
		elseif dict.detector == 3
			fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'POSittive'));
		end
			
		% window type, RBW filter type
			
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

% OLD CODE
% fprintf(spectrum,'INSTrument:SCReen:CREate');
% fprintf(spectrum,['INST:SCR:REN "' dict.SAScreen '"']);