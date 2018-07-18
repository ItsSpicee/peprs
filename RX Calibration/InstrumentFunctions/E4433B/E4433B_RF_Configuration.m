function E4433B_RF_Configuration (Frequency, Amplitude, E4433B_Add)

agt_closeAllSessions;

io1 = agt_newconnection('gpib', 0, E4433B_Add);

[status, status_description,query_result] = agt_query(io1,'*idn?');

if (status < 0) return; end;

SetFreq = ['SOURce:FREQuency','  ',num2str(Frequency)];
SetPower = ['POWer', '  ', num2str(Amplitude)];

[status, status_description] = agt_sendcommand(io1,SetFreq);
[status, status_description] = agt_sendcommand(io1,SetPower);

[status, status_description] = agt_sendcommand(io1,'OUTPut:STATe OFF');
[status, status_description] = agt_sendcommand(io1,':OUTPut:MODulation:STATe OFF');

agt_closeAllSessions;

