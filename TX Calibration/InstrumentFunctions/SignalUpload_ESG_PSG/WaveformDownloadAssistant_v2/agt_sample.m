function [status, status_description ] = agt_sample
% PSG/ESG Download Assistant, Version 2.0
% Copyright (C) 2003,2009 Agilent Technologies, Inc.
%
% function [status, description] = agt_sample
% This is an example of how to use the PSG/ESG Download Assistant
% to download a simple waveform to the instrument.

% io = agt_newconnection('gpib',1,19);
% Use the next line if connection via TCPIP and comment out previous line
% For further information on agt_newconnection, type in
% help agt_newconnection at the MATLAB command prompt
instid='10.10.10.10'; % use this to set the IP address of the source to use
io = agt_newconnection('tcpip',instid);

% agt_query can send a query to the instrument.
% For further information about the input and output parameters, type in
% help agt_query at the MATLAB command prompt
[status, status_description ,query_result] = agt_query(io,'*idn?');
if (status < 0) return; end
    
% Constructing waveform data.  IQ data is in the form of a vector
% that contains a series of complex numbers (the form is i + jq).
fs = 40e6;
T = 1 / fs;
t = [ 1 : 10000 ] * T;
f1 = 1e6;
f2 = 3e6;
IQData = exp( j * 2 * pi * f1 * t );% + ...
		 %exp( j * 2 * pi * f2 * t );

% normalize data to range +/- 0.7
% Do not include the following two lines if passing in the flag
% to normalize and scale the data within the function agt_waveformload.
maximum = max( [ real( IQData ) imag( IQData ) ] );
IQData = 0.7 * IQData / maximum;

% Markers are also generated here.
Markers = zeros(2,length(IQData));
Markers(1,:) = sign(real(IQData));
Markers(2,:) = sign(imag(IQData));
Markers = (Markers + 1)/2;

% agt_sendcommand sends SCPI strings to the instrument
% For further information about the input and output parameters, type in
% help agt_sendcommand at the MATLAB command prompt
[status, status_description] = agt_sendcommand(io, 'SOURce:FREQuency 1000000000');
[status, status_description] = agt_sendcommand(io, 'POWer -20');

% agt_waveformload downloads (and optionally plays) data on the signal generator.
% For further information about the input and output parameters, type in
% help agt_waveformload at the MATLAB command prompt
[status, status_description] = agt_waveformload(io, IQData, 'agtsample', 40000000, 'play', 'no_normscale', Markers);

% The following call to agt_waveformload demonstrates the minimum set of parameters
% required to download IQ data to the instrument.
% If no ArbFileName is provided, default will be 'Untitled'.
% If no sample frequency is provided, default will be what the signal generator
% has been set to.
% If no play flag has been provided, default will be 'play' so that the waveform will
% be played on the instrument
% If no normscale flag has been provided, default will be to normalize and scale
% the data at 70%
% If no Markers structure has been generated, default will be no markers set.
% [status, status_description] = agt_waveformload(io, IQData);

% Turn RF output on
% Uncomment the agt_sendcommand if RF output should be turned on.
[ status, status_description ] = agt_sendcommand( io, 'OUTPut:STATe ON' );
agt_closeAllSessions;