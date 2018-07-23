function [I, Q] = IQCapture_UXA (Freq, AnalysisBW, Fsample, time, UXAAdd, Atten, ...
    ClockReference, TriggerPort, TriggerLevel)
    numAvg = 50;

    Frequency = num2str(Freq);
    capture_time = num2str(time - 1/Fsample,8);
    Address = UXAAdd ;
    Attenuation = num2str(Atten);    

    obj.handle = {};
    obj.Address = Address;

    saCfg.connected = 1 ;
    saCfg.connectionType = 'visa';
    saCfg.visaAddr = [num2str(Address)] ;
    saCfg.useListSweep = 0 ;
    saCfg.useMarker = 0 ;
    saCfg.InputBufferSize = 1e7;
    % Test connection
    obj1 = iqopen(saCfg);
    fclose(obj1);
    obj1 = obj1(1);

    obj.handle = obj1;

    obj.handle.Timeout = 25;

    obj.OnOff = false;
    obj.scale_type = '';
    obj.Initialized = true;
            
    complexData = zeros(round(time*Fsample),1);
    try 
        fopen(obj.handle);
        freq_read = query(obj.handle,':SENSe:FREQuency:RF:CENTer?');
        
        fprintf(obj.handle,[':INSTrument:SELect BASIC']);     
        fprintf(obj.handle,':CONF:WAV');
        fprintf(obj.handle,':FORM:DATA REAL,32');
        fprintf(obj.handle,':FORM:BORD SWAP');
        % Set the center RF Frequency
        fprintf(obj.handle,[':SENSe:FREQuency:RF:CENTer ' Frequency]);
        % Set the complex sampling rate
        fprintf(obj.handle,[':WAVeform:SRATe ' num2str(Fsample)]);
        fprintf(obj.handle,[':WAVeform:AVERage OFF']);
        fprintf(obj.handle,[':WAVeform:AVERage:COUNt 100']);
        % Set the digital IF bandwidth
        fprintf(obj.handle,[':WAVeform:DIF:BANDwidth ' num2str(AnalysisBW)]);
        % Set the mechanical attenuator value
%        fprintf(obj.handle,[':SENSe:POW:EATTenuation:STATE OFF']);
%         fprintf(obj.handle,[':POWer:RF:GAIN:STATe ON']);
%         fprintf(obj.handle,[':POWer:RF:GAIN:BAND FULL']);	
        fprintf(obj.handle,[':SENSe:POW:Attenuation ' Attenuation]);
        % Set the oscillator source to use the external reference
        fprintf(obj.handle,[':ROSCillator:SOURce:TYPE ', ClockReference]);
        % Set the trigger to the external 1 trigger
        fprintf(obj.handle,[':TRIGger:WAV:SOURce ', TriggerPort]);	
        fprintf(obj.handle,[':TRIGger:' TriggerPort ':LEV ' num2str(TriggerLevel) ' mV']);
        % Set the measuring time
        fprintf(obj.handle,[':WAVeform:SWEep:TIME ' capture_time]);
%         fprintf(obj.handle,':READ:WAV0?');

        for i  = 1:numAvg
            fprintf(obj.handle,':FETCh:WAV0?');
            data = binblockread(obj.handle,'float32');
            fscanf(obj.handle); %removes the terminator character
%             if (i == 1)
%                 ref = complex(data(1:2:length(data)),  data(2:2:length(data)));
%             else
%                 [~,~] = AdjustDelay(ref,complex(data(1:2:length(data)),  data(2:2:length(data))),100);
%             end
            complexData = complexData + complex(data(1:2:length(data)),  data(2:2:length(data)));
        end
        
        I = real(complexData) ./ numAvg;
        Q = imag(complexData) ./ numAvg;
        
%         I = data(1:2:length(data));
%         Q = data(2:2:length(data));
        
        % Resample the data to the IF analysis bandwidth
        % Drop the uncorrelated samples from UXA settling
        uncorrelatedSamples = 0; 
        % Apply a high order filter to supress the decimation artifacts
%         resamplingFilterOrder = 80;
%         I = resample(I(1:(end-uncorrelatedSamples)), downsample, upsample, resamplingFilterOrder);
%         Q = resample(Q(1:(end-uncorrelatedSamples)), downsample, upsample, resamplingFilterOrder);
        fclose(obj.handle);
    catch
        warning('Problem during capture IQ, please check memory.')
        fclose(obj.handle);
    end
end                        
