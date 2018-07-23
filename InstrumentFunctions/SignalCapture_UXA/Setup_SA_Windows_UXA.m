function Setup_SA_Windows_UXA ( UXAConfig )

    [ SA ] = Connect_To_UXA( UXAConfig );
    
    if (~isfield(UXAConfig, 'Model') && isempty(UXAConfig.Model))
        warning('SA Model not specified. Setting to UXA');
        UXAConfig.Model = 'UXA';
    end
    
    try
        fopen(SA.handle);
        % Setup the SA screen
        if (strcmp(UXAConfig.Model,'UXA'))
            screenList = strsplit(query(SA.handle,':INST:SCR:CAT?'),{'"',','});
            if (sum(strcmp(screenList,UXAConfig.SAScreenName)) == 0)
                fprintf(SA.handle,'INSTrument:SCReen:CREate');
                fprintf(SA.handle,['INST:SCR:REN "' UXAConfig.SAScreenName '"']);
            else
                fprintf(SA.handle,[':INSTrument:SCReen:SELect "' UXAConfig.SAScreenName '"']);
            end
        end
        fprintf(SA.handle,':INST:SEL SA');
        fprintf(SA.handle,':CONFigure:SANalyzer');
        if (~strcmp(UXAConfig.Model,'UXA') && strcmp(UXAConfig.Measurement,'ACP'))
            fprintf(SA.handle,':CONFigure:ACP');
        end
        fprintf(SA.handle,['FREQ:CENT ' num2str(UXAConfig.Frequency)]);
        fprintf(SA.handle,['FREQ:SPAN ' num2str(UXAConfig.FrequencySpan)]);
        
        if (isfield(UXAConfig, 'ResBW') && ~isempty(UXAConfig.ResBW))
            fprintf(SA.handle,['BWID '  num2str(UXAConfig.ResBW)]);
        end
        
        if (isfield(UXAConfig, 'Attenuation') && ~isempty(UXAConfig.Attenuation))
            fprintf(SA.handle,[':POW:ATT ' num2str(UXAConfig.Attenuation)]);
        end
        
        if (isfield(UXAConfig.SA, 'TriggerSource') && ~isempty(UXAConfig.SA.TriggerSource))
            fprintf(SA.handle,[':TRIG:PULS:SOUR ' UXAConfig.SA.TriggerSource]);
        end
        
        if (isfield(UXAConfig.SA, 'TriggerLevel') && ~isempty(UXAConfig.SA.TriggerLevel))
            fprintf(SA.handle,[':TRIG:' UXAConfig.SA.TriggerSource ':LEV ' num2str(UXAConfig.SA.TriggerLevel)]);
        end
                
        if (isfield(UXAConfig.SA, 'TraceNumber') && ~isempty(UXAConfig.SA.TraceNumber))
            fprintf(SA.handle,[':TRAC' num2str(UXAConfig.SA.TraceNumber) ':TYPE WRIT']);
            if (isfield(UXAConfig.SA, 'TraceAverage') && ~isempty(UXAConfig.SA.TraceAverage))
                fprintf(SA.handle,[':TRAC' num2str(UXAConfig.SA.TraceNumber) ':TYPE AVER']);
                fprintf(SA.handle,[':DET:TRAC' num2str(UXAConfig.SA.TraceNumber) ' AVER']);
                fprintf(SA.handle,':AVER:TYPE RMS');
                if (isfield(UXAConfig.SA, 'TraceAverageCount') && ~isempty(UXAConfig.SA.TraceAverageCount))
                    fprintf(SA.handle,[':AVER:COUN ' num2str(UXAConfig.SA.TraceAverageCount)]);
                else
                    fprintf(SA.handle,':AVER:COUN 20');
                end
            end
        end
        
        if (isfield(UXAConfig, 'MWPath') && ~isempty(UXAConfig.MWPath))
            fprintf(SA.handle,[':POW:MW:PATH ' UXAConfig.MWPath]);
        end
        
        if (isfield(UXAConfig, 'PreampEnable') && ~isempty(UXAConfig.PreampEnable))
            if (UXAConfig.PreampEnable)
                fprintf(SA.handle,':POW:GAIN ON');
                fprintf(SA.handle,':POW:GAIN:BAND FULL');
            else
                fprintf(SA.handle,':POW:GAIN OFF');
            end
        end
        
        if (isfield(UXAConfig.SA, 'PhaseNoiseOpt') && ~isempty(UXAConfig.SA.PhaseNoiseOpt))
            switch UXAConfig.SA.PhaseNoiseOpt
                case 'BestCloseInPN'
                    PNOpt = '1';
                case 'BestWideOffsetPN'
                    PNOpt = '2';
                case 'FastTune'
                    PNOpt = '3';
                case 'BalanceNoiseAndSpurs'
                    PNOpt = '4';
                case 'BestSpurs'
                    PNOpt = '5';          
                otherwise
                    PNOpt = 'AUTO';
            end
        end
               
        % Setup the ACPR screen
        if (strcmp(UXAConfig.Model,'UXA'))
            screenList = strsplit(query(SA.handle,':INST:SCR:CAT?'),{'"',','});
            if (sum(strcmp(screenList,UXAConfig.ACPScreenName)) == 0)
                fprintf(SA.handle,'INSTrument:SCReen:CREate');
                fprintf(SA.handle,['INST:SCR:REN "' UXAConfig.ACPScreenName '"']);
            else
                fprintf(SA.handle,[':INSTrument:SCReen:SELect "' UXAConfig.ACPScreenName '"']);
            end
            fprintf(SA.handle,':INST:SEL SA');
            fprintf(SA.handle,':CONF:ACP');
        end
        fprintf(SA.handle,['FREQ:CENT ' num2str(UXAConfig.Frequency)]);
        fprintf(SA.handle,['FREQ:SPAN ' num2str(UXAConfig.FrequencySpan)]);
        if (isfield(UXAConfig, 'Attenuation') && ~isempty(UXAConfig.Attenuation))
            fprintf(SA.handle,[':POW:ATT ' num2str(UXAConfig.Attenuation)]);
        end
        
        if (isfield(UXAConfig, 'PreampEnable') && ~isempty(UXAConfig.PreampEnable))
            if (UXAConfig.PreampEnable)
                fprintf(SA.handle,':POW:GAIN ON');
                fprintf(SA.handle,':POW:GAIN:BAND FULL');
            else
                fprintf(SA.handle,':POW:GAIN OFF');
            end
        end
        
        if (isfield(UXAConfig.ACP, 'IntegBW') && ~isempty(UXAConfig.ACP.IntegBW))
            fprintf(SA.handle,[':ACP:BAND:INT ' num2str(UXAConfig.ACP.IntegBW)]);         
        end
        
        if (isfield(UXAConfig.ACP, 'OffsetFreq') && ~isempty(UXAConfig.ACP.OffsetFreq))
            fprintf(SA.handle,[':ACP:OFFS:LIST ' num2str(UXAConfig.ACP.IntegBW + UXAConfig.ACP.OffsetFreq)]);
            fprintf(SA.handle,[':ACP:OFFS:LIST:BAND ' num2str(UXAConfig.ACP.IntegBW)]);            
        end
        
        if (isfield(UXAConfig.ACP, 'NoiseExtensionEnable') && ~isempty(UXAConfig.ACP.NoiseExtensionEnable))
            if UXAConfig.ACP.NoiseExtensionEnable
                fprintf(SA.handle,':ACP:CORR:NOIS ON');
            else
                fprintf(SA.handle,':ACP:CORR:NOIS OFF');
            end
        end
		
		if (isfield(UXAConfig, 'MWPath') && ~isempty(UXAConfig.MWPath))
            fprintf(SA.handle,[':POW:MW:PATH ' UXAConfig.MWPath]);
        end
        
        % Switch back to the SA screen
        if (strcmp(UXAConfig.Model,'UXA'))
            fprintf(SA.handle,[':INSTrument:SCReen:SELect "' UXAConfig.SAScreenName '"']);
        end
        fclose(SA.handle);
    catch 
        fclose(SA.handle);
        error('Cannot write SCPI commands to UXA. Check Connection');
    end
    delete(SA.handle);
end                        

