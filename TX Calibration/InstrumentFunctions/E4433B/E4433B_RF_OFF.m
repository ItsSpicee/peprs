function E4433B_RF_OFF (E4433B_Add)

agt_closeAllSessions;

io1 = agt_newconnection('gpib', 0, E4433B_Add);

[status, status_description,query_result] = agt_query(io1,'*idn?');

if (status < 0) return; end;

[status, status_description] = agt_sendcommand(io1,'OUTPut:STATe OFF');

agt_closeAllSessions;
