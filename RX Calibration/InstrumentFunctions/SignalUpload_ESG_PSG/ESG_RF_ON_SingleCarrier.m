function ESG_RF_ON_SingleCarrier (PSGAdd)

agt_closeAllSessions;

io1 = agt_newconnection('gpib', 0, PSGAdd);

[status, status_description,query_result] = agt_query(io1,'*idn?');

if (status < 0) return; end;

[status, status_description] = agt_sendcommand(io1,'OUTPut:STATe ON');

agt_closeAllSessions;

