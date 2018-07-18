function interfaceObj = ScopeInit_64bit( RX )

newobjs = instrfind;  
if isempty(newobjs) == false;
    fclose(newobjs);
    delete(newobjs);
end
clear newobjs

% Set The Number Of Points To Capture
PointsPerRecord = RX.Analyzer.PointsPerRecord;
% Set The Driver Location
resourceDesc = RX.VisaAddress;
% Intitiate the Driver
interfaceObj = visa('agilent', resourceDesc);
% Set Time Out Length In Seconds
GLOBAL_TIMEOUT = 40;
interfaceObj.Timeout = GLOBAL_TIMEOUT;
% Set The Scope Buffer Size at least X2.5 The Number of Points
interfaceObj.inputbuffersize = uint64(PointsPerRecord*3);
% Set The Byte Order "Little Endian" or "Big Endian"
interfaceObj.ByteOrder = 'littleEndian';
% Open the Communication Link With The Scope
fopen(interfaceObj);
clrdevice(interfaceObj);
% Assigne The Stucture interfaceObj To RX.interfaceObj


end