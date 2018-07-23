function IQUpload_Singleband ( InI1, InQ1, Power1,  Freq1, Fsample, ESG1Add, SignalName1,data_length)

IQData = InI1 + 1i*InQ1;

norm_IQ = max(abs(IQData));
IQData = IQData./norm_IQ*1 ;

agt_closeAllSessions;

io1 = agt_newconnection('gpib', 0, ESG1Add);

[status, status_description,query_result] = agt_query(io1,'*idn?');

if (status < 0) 
    disp('Connection to ESG not successful');
    agt_closeAllSessions;
    return; 
end;

SetFreq1 = ['SOURce:FREQuency','  ',num2str(Freq1)];
SetPower1 = ['POWer', '  ', num2str(Power1)];

[status, status_description] = agt_sendcommand(io1,SetFreq1);
[status, status_description] = agt_sendcommand(io1,SetPower1);
[status, status_description] = agt_sendcommand(io1,':OUTPut:MODulation:STATe ON');
[status, status_description] = agt_sendcommand(io1,[':SOURce:RADio:ARB:SCALing "', SignalName1, '",50']);
[status, status_description] = agt_waveformload(io1,IQData, SignalName1, Fsample, 'play', 'normscale');
if status < 0
    disp('Failed to download the IQ files to ESG');
    agt_closeAllSessions;
    return; 
end;

[status, status_description] = agt_sendcommand(io1,'OUTPut:STATe OFF');
[status, status_description] = agt_sendcommand(io1,':OUTPut:MODulation:STATe ON');

% marker_value=num2str(data_length-96);
% data_length_str=num2str(data_length);
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:CLEar "' ,SignalName1, '",1,1,' data_length_str]);
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName1, '",1,1,1,0']);

[status, status_description] = agt_sendcommand(io1,[':RAD:ARB:CLEar "' ,SignalName1, '",1,1,100000']);
[status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName1, '",1,99904,99906,0']);   

% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:CLEar "' ,SignalName1, '",2,1,92060'])
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName1, '",2,1,1,0'])

% :MMEMory:CATalog? "WFM1:"
% 
% :SOURce:RADio:ARB:WAVeform "WFM1:<file_name>"
% 
% :SOURce:RADio:ARB:STATe ON
% :OUTPut:MODulation:STATe ON
% :OUTPut:STATe ON


agt_closeAllSessions;