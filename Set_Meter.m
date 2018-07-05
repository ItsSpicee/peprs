function result = Set_Meter(address, offset, frequency,averaging)
errorString = " ";
partNum = " ";

try
    averaging = str2double(averaging);
    offset = str2double(offset);
    freq = str2double(frequency);
    meter = visa('agilent',address);
    meter.InputBufferSize = 8388608;
    meter.ByteOrder = 'littleEndian';
    fopen(meter);
      
    %commands
    idn = query(meter, '*IDN?');
   
    splitIdn = strsplit(idn,',');
    partNum = splitIdn{2};
    
    if averaging == -2
        fprintf(N1911A, sprintf(':SENSe:AVERage:COUNt:AUTO %d', 0));
    elseif averaging == -1
        fprintf(N1911A, sprintf(':SENSe:AVERage:COUNt:AUTO %d', 1));
    else 
        fprintf(N1911A, sprintf(':SENSe:AVERage:COUNt %d', averaging));
    end
        
    
    
    if freq < 1000 || freq > 1000000000000 
        errorString = "Channel frequency is out of bounds.";
    else
        if offset < -100 || offset > 100
            errorString = "Offset value is out of bounds";
        else
            fprintf(meter, sprintf(':CALCulate:GAIN:MAGNitude %g', offset));
            fprintf(meter, sprintf(':SENSe:FREQuency:CW %g', freq));
            fprintf(meter, sprintf(':SENSe:CORRection:GAIN2:INPut:MAGNitude %g', offset));
        end
    end
    %cleanup
    fclose(meter);
    delete(meter);
    clear meter;
    
catch
    errorString = "A problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";
    instrreset
end
    resultsString = sprintf("%s;%s",partNum,errorString);
    result = char(resultsString);
    