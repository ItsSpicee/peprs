function result = Set__Spectrum_Advanced(dict)
	dict.traceAvgNum = str2double(dict.traceAvgNum);
    dict.ACPBand = str2double(dict.ACPBand);
    dict.ACPOffset = str2double(dict.ACPOffset);
    dict.avgCount = str2double(dict.avgCount);
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
        fprintf(spectrum, sprintf(':INSTrument:SCReen:REName "%s"', dict.SAScreen))
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
		if dict.traceAvg == 1
            fprintf(spectrum,sprintf(':TRACe%s:TYPE %s', dict.traceNum,'AVERage'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'RMS'));
			fprintf(spectrum, sprintf(':SENSe:DETector:%s %s', dict.traceNum, 'AVERage'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', dict.traceAvgNum);
			UXAConfig.SA.TraceAverage = 1;
            UXAConfig.SA.TraceAverageCount = dict.traceAvgNum;
		elseif dict.traceAvg == 2
			fprintf(spectrum,sprintf(':TRACe%s:TYPE %s', dict.traceNum,'WRITe'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:TYPE %s', 'LOG'));
			fprintf(spectrum, sprintf(':SENSe:DETector:%s %s', dict.traceNum, 'NORMal'));
			fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', 20);
			UXAConfig.SA.TraceAverage = 0;
            UXAConfig.SA.TraceAverageCount = 20;
		end
		
		%Noise Extension
		if dict.noiseExtension == 1
			fprintf(spectrum, sprintf(':SENSe:CORRection:NOISe:FLOor %d', 1));
            UXAConfig.NoiseExtensionEnable = 1;
		elseif dict.noiseExtension == 2
			fprintf(spectrum, sprintf(':SENSe:CORRection:NOISe:FLOor %d', 0));
            UXAConfig.NoiseExtensionEnable = 0;
		end
		
		%Noise Correction
		if dict.ACPCorrection == 1
			fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 1));
            UXAConfig.ACP.NoiseExtensionEnable =1;
		elseif dict.ACPCorrection == 2
			fprintf(spectrum, sprintf(':SENSe:ACPower:CORRection:NOISe:AUTO %d', 0));
            UXAConfig.ACP.NoiseExtensionEnable = 0;
		end
		
		%ACP Integration Bandwidth
        fprintf(spectrum, sprintf(':SENSe:ACPower:BANDwidth:INTegration %g', dict.ACPBand));
		fprintf(spectrum, sprintf(':SENSe:ACPower:OFFSet:LIST:BWIDth:INTegration %g', dict.ACPBand));
        UXAConfig.ACP.IntegBW = dict.ACPBand;
        
		%ACP Frequency Offset
        fprintf(spectrum, sprintf(':SENSe:ACPower:OFFSet:OUTer:LIST:FREQuency %g', dict.ACPOffset));
		UXAConfig.ACP.OffsetFreq = dict.ACPOffset;
        
        %low noise/microwave path
        if dict.mw == 1
            fprintf(spectrum, sprintf(':SENSe:POWer:RF:MW:PATH %s', 'STD'));
            UXAConfig.MWPath = "STD";
        elseif dict.mw == 2
            fprintf(spectrum, sprintf(':SENSe:POWer:RF:MW:PATH %s', 'LNP'));
            UXAConfig.MWPath = "LNP";
        elseif dict.mw == 3
            fprintf(spectrum, sprintf(':SENSe:POWer:RF:MW:PATH %s', 'MPBY'));
            UXAConfig.MWPath = "MPBY";
        elseif dict.mw == 4
            fprintf(spectrum, sprintf(':SENSe:POWer:RF:MW:PATH %s', 'FULL'));
            UXAConfig.MWPath = "FULL";
        end
        
        % phase noise optimization
        if dict.phaseNoise == 1
            %balanced
            phaseType = 1;
        elseif dict.phaseNoise == 2
            % best wide
            phaseType = =2;
            UXAConfig.SA.PhaseNoiseOpt = 2;
        elseif dict.phaseNoise == 3
            % fast
            phaseType = 3;
            UXAConfig.SA.PhaseNoiseOpt = 3;
        elseif dict.phaseNoise == 4
            % best close in
            phaseType = 4;
            UXAConfig.SA.PhaseNoiseOpt = 4;
        elseif dict.phaseNoise == 5
            % best spurs
            phaseType = 5;
            UXAConfig.SA.PhaseNoiseOpt = 5;
        elseif dict.phaseNoise == 0
            fprintf(spectrum, sprintf(':SENSe:FREQuency:SYNThesis:AUTO:STATe %d', 1));
        end
        fprintf(spectrum, sprintf(':SENSe:ACPower:FREQuency:SYNThesis:STATe %d', phaseType));
        fprintf(spectrum, sprintf(':SENSe:FREQuency:SYNThesis:STATe %d', phaseType));
        UXAConfig.SA.PhaseNoiseOpt = phaseType;
        
        % averaging
        if dict.averaging == 1
            fprintf(spectrum, sprintf(':SENSe:AVERage:STATe %d', 1));
            fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', dict.avgCount));
        elseif dict.averaging == 2
            fprintf(spectrum, sprintf(':SENSe:AVERage:STATe %d', 0));
            fprintf(spectrum, sprintf(':SENSe:AVERage:COUNt %d', 20));
        end
        
        %filtering
        if dict.filterType == 1
            fprintf(spectrum, sprintf(':SENSe:BWIDth:SHAPe %s', 'GAUSsian'));
        elseif dict.filterTpe == 2
            fprintf(spectrum, sprintf(':SENSe:ACPower:BWIDth:SHAPe %s', 'FLATtop'));
        end
                
		%Detector Type
		if dict.detector == 1
			fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'NORMal'));
		elseif dict.detector == 2
			fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'AVERage'));
		elseif dict.detector == 3
			fprint(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'POSittive'));
        elseif dict.detector == 4
            fprintf(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'SAMPle'));
        elseif dict.detector == 5
            fprintf(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'NEGative'));
        elseif dict.detector == 6
            fprintf(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'QPEak'));
        elseif dict.detector == 7
            fprintf(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'EAVerage'));
        elseif dict.detector == 8
            fprintf(spectrum, sprintf(':SENSe:DETector:FUNCtion %s', 'RAVerage'));
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

% OLD CODE
% fprintf(spectrum,'INSTrument:SCReen:CREate');
% fprintf(spectrum,['INST:SCR:REN "' dict.SAScreen '"']);