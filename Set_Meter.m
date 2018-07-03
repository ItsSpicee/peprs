function result = Set_Meter(address, offset, frequency)
errorString = " ";
partNum = " ";

try
   
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

    if freq < 1000 && freq > 
    fprintf(meter, sprintf(':CALCulate:GAIN:MAGNitude %g', offset));
    fprintf(meter, sprintf(':SENSe:FREQuency:CW %g', freq));
    fprintf(meter, sprintf(':SENSe:CORRection:GAIN2:INPut:MAGNitude %g', offset));
     
    %cleanup
    fclose(meter);
    delete(meter);
    clear meter;
    
catch
    errorString = "AA problem has occured, resetting instruments. Use Keysight Connection Expert to check your instrument VISA Addresses.";
    instrreset
end
    resultsString = sprintf("%s;%s",partNum,errorString);
    result = char(resultsString);
    