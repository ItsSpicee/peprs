classdef PowerMeter_N1911A < handle
    properties (SetAccess = private, Hidden)    
        socket % io socket
    end
    
    properties (SetAccess = private)
        GPIB_addr
    end
    
    methods
        % constructor
        function obj = PowerMeter_N1911A(GPIB_addr)
            obj.GPIB_addr = GPIB_addr;            
        end 
 
        % connect to power meter
        function connect(obj)            
            old_obj = instrfind('PrimaryAddress', obj.GPIB_addr);
            delete(old_obj);
            visa_str = sprintf('GPIB0::%d::INSTR', obj.GPIB_addr);        
            obj.socket = visa('agilent', visa_str);
            obj.socket.Timeout = 100;
            fopen(obj.socket);
            ident = query(obj.socket, '*IDN?');
            fprintf('Connected to power meter: %s\n', ident);                            
        end
       
        % disconnect from power meter
        function disconnect(obj)               
            fclose(obj.socket);
            fprintf('Disconnected from power meter\n');                       
        end 
    
        % preset instrument
        function preset(obj)
            fprintf(obj.socket, '*RST');
            fprintf(obj.socket, 'INITiate:CONTinuous 1');
        end
        
        % zero and cal
        function zero_and_cal(obj)
            err = query(obj.socket, 'CALibration?');
            if(str2double(err))
                fprintf('Power meter zero and cal failed: code %s\n', err);
            else
                fprintf('Power meter zero and cal successful\n');
            end
        end
    
        % set/get frequency           
        function output = frequency(obj, freq)
            if(nargin == 1)
                output = query(obj.socket, ':FREQuency?', '%s\n', '%g');
            else
                fprintf(obj.socket, ':FREQuency %d Hz', freq);
            end       
        end 
        
        % set/get offset
         function output = offset(obj, offset)
            if(nargin == 1)
                output = query(obj.socket, ':CORRection:GAIN2?', '%s\n', '%g');
            else
                fprintf(obj.socket, ':CORRection:GAIN2 %d', offset);
            end       
         end 
        
        % measure
        function output = measure(obj)      
            fprintf(obj.socket, 'CONFigure');
            fprintf(obj.socket, 'SENSe:AVERage:COUNt 15');
            output = query(obj.socket, 'READ?', '%s\n', '%g');
            %output = query(obj.socket, 'Measure?', '%s\n', '%g'); % use auto averaging
            fprintf(obj.socket, 'INITiate:CONTinuous 1');
        end 
    end
end


        
