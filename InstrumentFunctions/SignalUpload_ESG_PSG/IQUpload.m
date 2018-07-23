function IQUpload ( InI1, InQ1, InI2, InQ2, Power1, Power2, Freq1, Freq2, Fsample, ESG1Add, ESG2Add,SignalName1,SignalName2,data_length)

InI1 = resample(InI1,40,1) ;
InI1 = InI1(18:end) ;
InI1 = resample(InI1,1,40) ;
InQ1 = resample(InQ1,40,1) ;
InQ1 = InQ1(18:end) ;
InQ1 = resample(InQ1,1,40) ;

InI2 = resample(InI2,40,1) ;
InI2 = [InI2(23:end)] ;
InI2 = resample(InI2,1,40) ;
InQ2 = resample(InQ2,40,1) ;
InQ2 = [InQ2(23:end)] ;
InQ2 = resample(InQ2,1,40) ;

norm_factor1 = max(abs([InI1+1i*InQ1]));
norm_factor2 = max(abs([InI2+1i*InQ2]));
% norm_factor1 = max([max(abs(InI1)),max(abs(InQ1))]);
% norm_factor2 = max([max(abs(InI2)),max(abs(InQ2))]);
norm_factor=max(norm_factor1,norm_factor2);
InI1 = InI1/norm_factor;
InQ1 = InQ1/norm_factor;
InI2 = InI2/norm_factor;
InQ2 = InQ2/norm_factor;

IQData1 = InI1 + 1i*InQ1;
IQData2 = InI2 + 1i*InQ2;

agt_closeAllSessions;

io1 = agt_newconnection('gpib', 0, ESG1Add);
    [status, status_description,query_result] = agt_query(io1,'*idn?');
    if (status < 0) return; end;
    SetFreq1 = ['SOURce:FREQuency','  ',num2str(Freq1)];
    SetPower1 = ['POWer', '  ', num2str(Power1)];
    [status, status_description] = agt_sendcommand(io1,SetFreq1);
    [status, status_description] = agt_sendcommand(io1,SetPower1);
    [status, status_description] = agt_waveformload(io1,IQData1, SignalName1, Fsample, 'play', 'no_normscale');
    [status, status_description] = agt_sendcommand(io1,[':SOURce:RADio:ARB:SCALing "', SignalName1, '",50']);
    [status, status_description] = agt_sendcommand(io1,'OUTPut:STATe OFF');
    marker_value = num2str(data_length-96) ;
    data_length_str = num2str(data_length) ;
        [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:CLEar "' ,SignalName1, '",1,1,100000']);
        [status, status_description] = agt_sendcommand(io1,[':RAD:ARB:MARK "' ,SignalName1, '",1,99900,99900,0']);
agt_closeAllSessions;

io2 = agt_newconnection('gpib', 0,ESG2Add);
    [status, status_description,query_result] = agt_query(io2,'*idn?');
    if (status < 0) return; end;
    SetFreq2 = ['SOURce:FREQuency','  ',num2str(Freq2)];
    SetPower2 = ['POWer', '  ', num2str(Power2)];
    [status, status_description] = agt_sendcommand(io2,SetFreq2);
    [status, status_description] = agt_sendcommand(io2,SetPower2);
    [status, status_description] = agt_waveformload(io2,IQData2, SignalName2, Fsample, 'play', 'no_normscale');
    [status, status_description] = agt_sendcommand(io2,[':SOURce:RADio:ARB:SCALing "', SignalName2, '",50']);
    [status, status_description] = agt_sendcommand(io2,'OUTPut:STATe OFF');
%     marker_value = num2str(data_length-96) ;
%     data_length_str = num2str(data_length) ;
%         [status, status_description] = agt_sendcommand(io2,[':RAD:ARB:CLEar "' ,SignalName2, '",1,1,70000']);
%         [status, status_description] = agt_sendcommand(io2,[':RAD:ARB:MARK "' ,SignalName2, '",1,70000,70000,0']);

agt_closeAllSessions;

display('Upload Sucess') ;