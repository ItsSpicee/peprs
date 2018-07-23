function IQUpload_Singleband ( In, Power, Freq, Fsample, ESGAdd, SignalName, data_length)

norm_factor = 1.2*max(abs(In));

IQData = In/norm_factor;

agt_closeAllSessions;

io1 = agt_newconnection('gpib', 0, ESGAdd);

[status, status_description,query_result] = agt_query(io1,'*idn?');

if (status < 0) return; end;

SetFreq = ['SOURce:FREQuency','  ',num2str(Freq)];
SetPower = ['POWer', '  ', num2str(Power)];

[status, status_description] = agt_sendcommand(io1,SetFreq);
[status, status_description] = agt_sendcommand(io1,SetPower);

[status, status_description] = agt_waveformload(io1,IQData, SignalName, Fsample, 'play', 'no_normscale');

[status, status_description] = agt_sendcommand(io1,[':SOURce:RADio:ARB:SCALing "', SignalName, '",50'])

[status, status_description] = agt_sendcommand(io1,'OUTPut:STATe OFF');

marker_value=num2str(data_length-96);
data_length_str=num2str(data_length);
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:CLEar "' ,SignalName1, '",1,1,91664'])
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName1, '",1,91664,91664,0'])
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:CLEar "' ,SignalName1, '",2,1,91000'])
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName1, '",2,90904,90904,0'])

[status, status_description] = agt_sendcommand(io1,[':RAD:ARB:CLEar "' ,SignalName, '",1,1,100000']);

%%%% WCDMA 2C
[status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName, '",1,99904,99906,0']);

%%%%% LTE/WCDMA 2C
% [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName1, '",1,92064,92064,0']);


agt_closeAllSessions;
