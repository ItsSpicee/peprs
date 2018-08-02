function result = Set_VSA_AdvUXA(dict)
	errorString = " ";
	partNum = " ";
	errorList = [];
    error = "";
	phaseType = 0;

	% try
		if dict.address == ""
			errorString = "Fill out general VSA parameters before attempting to set advanced parameters.";
			resultsString = sprintf("%s~%s","",errorString);
			result = char(resultsString);
			return
		end
		
		load(".\InstrumentFunctions\SignalCapture_UXA\UXAConfig.mat")
		spectrum = visa('agilent',dict.address);
		spectrum.InputBufferSize = 8388608;
		spectrum.ByteOrder = 'littleEndian';
		fopen(spectrum);
		fprintf(spectrum, '*CLS');
		
        % turn off electronic attenuator
        errorList = runCommand(spectrum, sprintf(':SENSe:POWer:RF:EATTenuation:STATe %d', 0),errorList);
        
		%internal preamp
		if dict.preamp == 1
			errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 1),errorList);
		elseif dict.preamp == 2
			errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:GAIN:STATe %d', 0),errorList);
		end
		
		% IF Path
		if dict.ifPath == 0
			errorList = runCommand(spectrum,sprintf(':SENSe:IFPath:AUTO %d', 1),errorList);
		elseif dict.ifPath == 1
			errorList = runCommand(spectrum,sprintf(':SENSe:IFPath %s', 'B10M'),errorList);
		elseif dict.ifPath == 2
			errorList = runCommand(spectrum,sprintf(':SENSe:IFPath %s', 'B25M'),errorList);
		elseif dict.ifPath == 3
			errorList = runCommand(spectrum,sprintf(':SENSe:IFPath %s', 'B40M'),errorList);
		elseif dict.ifPath == 4
			% 255 MHz isn't an option, trying to set to 160MHz sets it to 255
			errorList = runCommand(spectrum,sprintf(':SENSe:IFPath %s', 'B160M'),errorList);
		% elseif dict.ifPath == 5
			% % 1GHz isn't a scpi selectable option, automatically selected by some setups
			% fprintf(spectrum, sprintf(':SENSe:IFPath %s', 'B1G'));
		end
		
		%low noise/microwave path
        if dict.mwPath == 1
            errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:MW:PATH %s', 'STD'),errorList);
            UXAConfig.MWPath = "STD";
        elseif dict.mwPath == 2
            errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:MW:PATH %s', 'LNP'),errorList);
            UXAConfig.MWPath = "LNP";
        elseif dict.mwPath == 3
            errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:MW:PATH %s', 'MPBY'),errorList);
            UXAConfig.MWPath = "MPBY";
        elseif dict.mwPath == 4
            errorList = runCommand(spectrum,sprintf(':SENSe:POWer:RF:MW:PATH %s', 'FULL'),errorList);
            UXAConfig.MWPath = "FULL";
        end
		
		 % phase noise optimization
        if dict.phaseNoise == 1
            %balanced
            phaseType = 1;
        elseif dict.phaseNoise == 2
            % best wide
            phaseType =2;
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
			errorList = runCommand(spectrum,sprintf(':SENSe:SPECtrum:FREQuency:SYNThesis:AUTO:STATe %d', 1),errorList);
        end
        errorList = runCommand(spectrum,sprintf(':SENSe:WAVeform:FREQuency:SYNThesis:STATe %d', phaseType),errorList);
        UXAConfig.SA.PhaseNoiseOpt = phaseType;
		
		%filtering
        if dict.filterType == 1
            errorList = runCommand(spectrum,sprintf(':SENSe:WAVeform:BANDwidth:SHAPe %s', 'GAUSsian'),errorList);
        elseif dict.filterType == 2
            errorList = runCommand(spectrum,sprintf(':SENSe:WAVeform:BANDwidth:SHAPe %s', 'FLATtop'),errorList);
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