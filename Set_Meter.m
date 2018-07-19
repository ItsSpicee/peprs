function result = Set_Meter(dict)
errorString = " ";
partNum = " ";

try
    averaging = str2double(dict.averaging);
    offset = str2double(dict.offset);
    freq = str2double(dict.frequency);
    meter = visa('agilent',dict.address);
    meter.InputBufferSize = 8388608;
    meter.ByteOrder = 'littleEndian';
    fopen(meter);
      
    %commands
    idn = query(meter, '*IDN?');
   
    splitIdn = strsplit(idn,',');
    partNum = splitIdn{2};
    
    
    if averaging == -1
        fprintf(meter, sprintf(':SENSe:AVERage:COUNt:AUTO %d', 1));
    elseif averaging == -2
        fprintf(meter, sprintf(':SENSe:AVERage:STATe %d', 0));
    elseif averaging <= 1024 && averaging > 0 
        fprintf(meter, sprintf(':SENSe:AVERage:STATe %d', 1));
        fprintf(meter, sprintf(':SENSe:AVERage:COUNt %d', averaging));
    else
        errorString = "Number of averages is out of bounds. Must be 1-1024";
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
    