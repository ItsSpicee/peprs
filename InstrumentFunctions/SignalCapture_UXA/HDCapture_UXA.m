function [ Harmonics ] = HDCapture_UXA( UXAConfig, NumberOfHarmonics )
    if NumberOfHarmonics > 10
        NumberOfHarmonics = 10;
    end
    [ SA ] = Connect_To_UXA( UXAConfig );
    try
        fopen(SA.handle);
        fprintf(SA.handle,':CONF:HARM');
        fprintf(SA.handle,['HARMonics:FREQuency:FUND ' num2str(UXAConfig.Frequency)]);
        HDData = strsplit(query(SA.handle, 'FETCh:HARMonics:AMPLitude:ALL?'),{',','\s*'},'DelimiterType','RegularExpression');
        Harmonics = str2double(HDData(1:NumberOfHarmonics));
        fclose(SA.handle);
    catch
        fclose(SA.handle);
    end
end

