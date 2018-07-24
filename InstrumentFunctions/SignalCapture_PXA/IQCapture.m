function [I, Q] = IQCapture (Freq, Fsample, time, PXAAdd)

% Fsample = 100e6; PXAAdd = 18; time = 1e-3; Freq = 2e9

Frequency = num2str(Freq);
capture_time = num2str(time);
clkrate = num2str(Fsample);% = 100e6;
% time = 1e-3;
Address = PXAAdd ; % = 18;

obj.handle = {};
obj.Address = Address;

oldobjs=instrfind('Tag','Signal_Analyzer_PXA_N9030A');
if ~isempty(oldobjs)
    disp('Cleaning up ...')
    delete(oldobjs);
    clear oldobjs;
end
            
% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 7, 'PrimaryAddress', obj.Address, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('AGILENT', 7, obj.Address);
else
    fclose(obj1);
    obj1 = obj1(1);
end

obj.handle = obj1;

set(obj.handle,'InputBufferSize',10000000);
obj.handle.Timeout = 100;

obj.OnOff = false;
obj.scale_type = '';
obj.Initialized = true;
            
fopen(obj.handle);
freq_read = query(obj.handle,':SENSe:FREQuency:RF:CENTer?');
                        
fprintf(obj.handle,[':INSTrument:SELect BASIC']);     
fprintf(obj.handle,':CONF:WAV');

fprintf(obj.handle,':FORM:DATA REAL,32');
fprintf(obj.handle,':FORM:BORD SWAP');
fprintf(obj.handle,[':SENSe:FREQuency:RF:CENTer ' Frequency]);
%clkrate = clkrate/1.28;
fprintf(obj.handle,[':WAVeform:SRATe ' clkrate]);

% source = 'EXTernal1';
% 
% name0 = query(obj.handle,':CONFigure?');
%             name = '';
%             for i = 1:length(name0)-1
%                 measurement = [name name0(i)];
%             end
% %           measurement = Current_Measurement(obj);
%             if strcmp(measurement,'SAN')
%                 fprintf(obj.handle,[':TRIGger:SOURce ' source]);
%             else
%                 fprintf(obj.handle,[':TRIGger:' measurement ':SOURce ' source]);
%             end

fprintf(obj.handle,[':TRIGger:WAV:SOURce ', 'EXTernal1']);
% set_Trigger_Source(obj,'EXTernal1');
fprintf(obj.handle,[':WAVeform:SWEep:TIME ' capture_time]);
fprintf(obj.handle,':FETCh:WAV0?');
data = binblockread(obj.handle,'float32');
fscanf(obj.handle); %removes the terminator character
I = data(1:2:length(data));
Q = data(2:2:length(data));

fclose(obj.handle);

end                        
