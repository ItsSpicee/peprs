function [ SAMeas ] = SACapture_UXA( UXAConfig )
    % Captures the swept mode data and the ACPR mode results
    try        
        % Capture the desired trace data
        if (strcmp(UXAConfig.Model,'UXA'))
            [ SA ] = Connect_To_UXA( UXAConfig );
            fprintf(SA.handle,[':INSTrument:SCReen:SELect "' UXAConfig.SAScreenName '"']);
        else
            % PXA does not have multiple windows, so we have to manually
            % change the measurement modes 
            UXAConfig.Measurement = 'SA';
            Setup_SA_Windows_UXA ( UXAConfig );
            [ SA ] = Connect_To_UXA( UXAConfig );
        end
        fopen(SA.handle);

        if (~isfield(UXAConfig.SA, 'TraceNumber') && isempty(UXAConfig.SA.TraceNumber))
            traceNumber = 1;
        else
            traceNumber = UXAConfig.SA.TraceNumber;
        end
        % Split the x,y, pair into the freq, PSD values
        fprintf(SA.handle, ':INIT:REST');
        fprintf(SA.handle,':FORM ASCii');
        SAData = strsplit(query(SA.handle, ['FETC:SAN' num2str(traceNumber) '?']),{',','\s*'},'DelimiterType','RegularExpression');
        SAMeas = [];
        SAMeas.SAFreq = str2double(SAData(1:2:end-1));
        SAMeas.SAPSD = str2double(SAData(2:2:end-1));
        
        if (strcmp(UXAConfig.Model,'UXA'))
            fprintf(SA.handle,[':INSTrument:SCReen:SELect "' UXAConfig.ACPScreenName '"']);
        else
            % PXA does not have multiple windows, so we have to manually
            % change the measurement modes 
            fclose(SA.handle);
            UXAConfig.Measurement = 'ACP';
            Setup_SA_Windows_UXA ( UXAConfig );
            [ SA ] = Connect_To_UXA( UXAConfig );
            fopen(SA.handle);
        end
        
        SAData = strsplit(query(SA.handle, 'FETC:ACP?'),{',','\s*'},'DelimiterType','RegularExpression');
        SAMeas.ChannelPower = str2double(SAData(1));
        SAMeas.ACPRLower = str2double(SAData(2));
        SAMeas.ACPRUpper = str2double(SAData(3));
        
        if(strcmp(UXAConfig.Model,'UXA'))
            fprintf(SA.handle,[':INSTrument:SCReen:SELect "' UXAConfig.SAScreenName '"']);
        end
        fclose(SA.handle);
    catch
        fclose(SA.handle);
        error('Cannot capture data from UXA. Please check the connection.'); 
    end
    delete(SA.handle);
end

