function SGConnection = agt_newconnection(varargin)
% PSG/ESG Download Assistant, Version 2.0
% Copyright (C) 2003,2005 Agilent Technologies, Inc.
%
% function SGConnection = agt_newconnection(varargin)
% This function generates connection structures according to the different interface types.
% The valid interface types are: 'GPIB' or 'TCPIP'.
%
% The function call for each interface is:
%
% For GPIB connection:
%     agt_newconnection('GPIB',boardindex, primaryaddress, secondaryaddress)
%     boardindex       integer default 0
%     primaryaddress   integer default 19
%     secondaryaddress integer default 0.  (optional parameter)
%     sample: connection = agt_newconnection('gpib',0,19);
% For TCPIP connection:
%     agt_newconnection('TCPIP',IPAddress)
%     IPAddress  string
%     sample: connection = agt_newconnection('TCPIP','11.11.11.11');

if ~(license('test','instr_control_toolbox'))
    disp([char(10) 'This version of the Agilent Waveform Download Assistant requires a license to the <a href = "http://www.mathworks.com/products/instrument/">Instrument Control Toolbox</a> product.']);
    disp(['To request a trial version of the Instrument Control Toolbox visit The MathWorks <a href = "http://www.mathworks.com/agilent/instrument/tryit.html">web site</a>.' char(10)]);    
    return;
end

if (nargin < 1)
    SGConnection = default;
    return;
end

if (~ischar(varargin{1}))
    error('the first parameter has to be a string showing the connection interface type: ''GPIB'' or ''TCPIP''');
end

interface = varargin{1};

if (strcmpi(interface,'GPIB'))
    SGConnection = GPIBConnection(varargin{2:end});
    return;
end

if (strcmpi(interface,'TCPIP'))
    SGConnection =  TCPIPConnection(varargin{2:end});
    return;
end

msg = sprintf('%s%s%s','Invalid interface type: ''',interface,'''. The interface type should be one of ''GPIB'' or ''TCPIP''');
error(msg);


function SGConnection = default()
SGConnection = visa('agilent','GPIB0::19::0::INSTR');
SGConnection.InputBufferSize = 10000000;
SGConnection.OutputBufferSize = 10000000;
SGConnection.ByteOrder = 'littleEndian';
fopen(SGConnection);

function SGConnection = GPIBConnection(varargin)

boardID = 0;
primaryAddress = 19;
secondaryAddress = 0;

if (nargin ==0)
    return;
end

if (nargin >0)
    boardID = int32 ( checkPositiveInteger(varargin{1},'GPIB board number') );
end

if (nargin >1)
    primaryAddress = int32 ( checkPositiveInteger(varargin{2},'GPIB primary address') );
end

if (nargin >2)
    secondaryAddress = int32 ( checkPositiveInteger(varargin{3},'GPIB secondary address') );
end

SGConnection = visa('agilent',['GPIB' num2str(boardID) '::' num2str(primaryAddress) '::' num2str(secondaryAddress) '::INSTR']);
SGConnection.InputBufferSize = 10000000;
SGConnection.OutputBufferSize = 10000000;
SGConnection.ByteOrder = 'littleEndian';
fopen(SGConnection);

function SGConnection = TCPIPConnection(varargin)

if (nargin ==0)
    return;
end

if (nargin >0)
    tcpipAddress = checkString(varargin{1},'TCPIP address');
end

%SGConnection = visa('agilent',['TCPIP0::' tcpipAddress '::INSTR']); 
%The VISA call above is commenetd out to work around geck g548984 in VISA TCPIP's BINBLOCKWRITE
SGConnection = tcpip(tcpipAddress, 5025);
SGConnection.InputBufferSize = 10000000;
SGConnection.OutputBufferSize = 10000000;
% Note the switch in Endianness for TCPIP objects. 
SGConnection.ByteOrder = 'bigEndian';
fopen(SGConnection);

function val = checkPositiveInteger(input, errormsgHeader)

val = input;
if (~isnumeric(input))
    msg = strcat(errormsgHeader, ' should be an integer');
    error(msg);
end
val = abs(floor(val(1)));

function val = checkString(input,errormsgHeader)
val = input;
if (~ischar(input))
    msg = strcat(errormsgHeader, ' should be a string');
    error(msg);
end