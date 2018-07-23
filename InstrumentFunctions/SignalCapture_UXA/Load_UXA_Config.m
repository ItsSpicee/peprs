function [ UXAConfig ] = Load_UXA_Config( UXAConfig )
    if (~exist('UXAConfig', 'var') || isempty(UXAConfig))
        try
            UXAConfigFileName = 'UXAConfig.mat';
            load(UXAConfigFileName);
        catch
            warning('Could not load UXAConfig.mat file. Loading defaults...')
            
            % General UXA Settings
            UXAConfig.Model = 'PXA'; % 'UXA' or 'PXA'
            UXAConfig.Address = 'USB0::0x2A8D::0x190B::US57210123::0::INSTR';
            UXAConfig.SAScreenName = 'SA';
            UXAConfig.ACPScreenName = 'ACPR';
            UXAConfig.Attenuation = 0; %dB
            UXAConfig.PreampEnable = 0;
            UXAConfig.MWPath = 'STD'; % 'LNPath' or 'STD'
            UXAConfig.Frequency =  25e9;
            UXAConfig.FrequencySpan = 3e9;
            UXAConfig.ResBW = 500e3;
                        
            % UXA SA Measurement Settings
            UXAConfig.SA.TriggerSource = 'IMM'; % EXTernal1|EXTernal2|IMMediate
            UXAConfig.SA.TriggerLevel = 0.5; % V
            UXAConfig.SA.TraceNumber = 1;
            UXAConfig.SA.TraceAverage = 1;
            UXAConfig.SA.TraceAverageCount = 20; 
            
            % UXA ACP Measurement Settings
            UXAConfig.ACP.IntegBW = 200e6;
            UXAConfig.ACP.OffsetFreq = 1e6;
            UXAConfig.ACP.NoiseExtensionEnable = 0;
        end        
    end
end

