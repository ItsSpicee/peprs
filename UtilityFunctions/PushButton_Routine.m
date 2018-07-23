function [RF_ON_Continue] = PushButton_Routine (RF_ON_Continue,Transmitter_type,ESGAdd,RF_channel)

% RF_ON_Continue = 0;
while RF_ON_Continue == 0
    choice_RF_ON = questdlg('Turn ON the RF Source?', ...
    'RF ON', ...
    'RF ON and Continue','RF ON', 'RF OFF', 'RF OFF');
    % Handle response
    switch choice_RF_ON
        case 'RF ON and Continue'
            disp(['Turn ON the RF Source and Continue'])
            RF_ON_Continue = 1;                    
        case 'RF ON'
            disp(['Turn ON the RF Source'])
            RF_ON_Continue = 0;
            if strcmp(Transmitter_type,'ESG')  
                ESG_RF_ON_SingleCarrier(ESGAdd);
            elseif strcmp(Transmitter_type,'AWG')  
                AWG_M8190A_Output_ON(RF_channel);
            end            
        case 'RF OFF'
            disp(['Turn OFF the RF Source'])
            RF_ON_Continue = 0;
            if strcmp(Transmitter_type,'ESG')  
                ESG_RF_OFF_SingleCarrier(ESGAdd);
            elseif strcmp(Transmitter_type,'AWG')  
                AWG_M8190A_Output_OFF(RF_channel);
            end   
            pause(1)
    end
end      
RF_ON_Continue = 0;  

end