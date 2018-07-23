function [status, status_description] = agt_sequencesample
% PSG/ESG Download Assistant, Version 2.0
% Copyright (C) 2003,2005 Agilent Technologies, Inc.
%
% function [status, description] = agt_sequencesample
% This is an example of how to download, build up, and play sequences on the
% signal generator.

% io = agt_newconnection('gpib',1,19);
% Use the next line if connecting via TCPIP and comment out previous line
% For further information on agt_newconnection, type in
% help agt_newconnection at the MATLAB command prompt
io = agt_newconnection('tcpip','172.31.57.114');

% agt_query can send a query to the instrument.
% For further information about the input and output parameters, type in
% help agt_query at the MATLAB command prompt
[status, status_description,query_result] = agt_query(io,'*idn?');
if (status < 0) return; end
    
% Constructing waveform data.  IQ data is in the form of a vector
% that contains a series of complex numbers (the form is i + jq).
fs = 40e6;
T = 1 / fs;
t = [ 1 : 10000 ] * T;
f1 = 1e6;
f2 = 3e6;

IQData = exp( j * 2 * pi * f1 * t);
IQData2 = exp(j * 2 * pi * f2 * t);

% normalize data to range +/- 0.7
% Do not include the following two lines if passing in the flag
% to normalize and scale the data within the function.
maximum = max( [ real( IQData ) imag( IQData ) ] );
IQData = 0.7 * IQData / maximum;

maximum = max( [ real( IQData2 ) imag( IQData2 ) ] );
IQData2 = 0.7 * IQData2 / maximum;

% Markers are also generated here.
Markers = zeros(2,length(IQData));
Markers(1,:) = sign(real(IQData));
Markers(2,:) = sign(imag(IQData));
Markers = (Markers + 1)/2;

% agt_sendcommand sends SCPI strings to the instrument
% For further information about the input and output parameters, type in
% help agt_sendcommand at the MATLAB command prompt
[status, status_description] = agt_sendcommand(io, 'SOURce:FREQuency 3000000000');
[status, status_description] = agt_sendcommand(io, 'POWer 0');

% SCPI command that turns the arb off before downloading the waveform to the
% signal generator
[status, status_description] = agt_sendcommand(io,':source:rad:arb:state off');

% agt_waveformload downloads data to the signal generator.
% For further information about the input and output parameters, type in
% help agt_waveformload at the MATLAB command prompt
[status, status_description] = agt_waveformload(io, IQData, 'agtsample1', 40000000, 'no_play', 'no_normscale', Markers);
[status, status_description] = agt_waveformload(io, IQData2, 'agtsample2', 40000000, 'no_play', 'no_normscale', Markers);

% Building up the SCPI command for building a sequence.
% NOTE:  The SCPI command will be "arbi:agtsample1" instead of "wfm1:agtsample1" and
% "arbi:agtsample2" instead of "wfm1:agtsample2" when working with a 14-bit instrument.
sequence = [' ,"wfm1:agtsample1", 4000,0,0', ' ,"wfm1:agtsample2", 4000,0,0'];

sequencecommand = [':source:rad:arb:seq "agtsequencesample"' sequence];

% Turn the arb off before downloading a sequence
[status, status_description] = agt_sendcommand(io,':source:rad:arb:state off');
if (status < 0)
    return;
end

% SCPI command that is building up the sequence
[status, status_description] = agt_sendcommand(io,sequencecommand);

% This SCPI command will play a sequence on the signal generator
[status, status_description] = agt_sendcommand(io, ':source:rad:arb:wav "seq:agtsequencesample"');

% This SCPI command will turn the arb on
[status, status_description] = agt_sendcommand(io,':source:rad:arb:state on');

% Turn RF output on
% Uncomment the sendcommand if RF output should be turned on.
[ status, status_description ] = agt_sendcommand( io, 'OUTPut:STATe ON' );
agt_closeAllSessions;  