classdef Signal_Analyzer_PXA_N9030A < handle & Instrument
    %Signal_Generator Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        OnOff;
        scale_type;
    end
    
    methods
        %% Constructor
        
         function obj = Signal_Analyzer_PXA_N9030A(Address)
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
            
         end
         
         function err = get_error(obj)
            err = query(obj.handle,'SYST:ERR?');
         end
         
         function connect(obj)
             fopen(obj.handle);
         end
         
         function disconnect(obj)
             fclose(obj.handle);
         end
        
        %% System
        
        function Preset_Mode(obj)
            fprintf(obj.handle,':SYSTem:PRESet');
        end
        
        function Preset_Measurement (obj,Measurement)
            fprintf(obj.handle,[':CONFigure:' Measurement]);
        end
        
        function Auto_Couple (obj)
            fprintf(obj.handle,':COUPle ALL');
        end
        
        function Restore_Mode_Defaults (obj)
            fprintf(obj.handle,':INSTrument:DEFault');
        end
        
        function set_Power_On_Application (obj,app)
            %SA|BASIC|ADEMOD|NFIGURE|PNOISE|CDMA2K|TDSCDMA|VSA|VSA89601|WCDMA|WIMAXOFDMA
            fprintf(obj.handle,[':SYSTem:PON:MODE ' app]);
        end
        
        function app = get_Power_On_Application (obj)
            app = query(obj.handle,':SYSTem:PON:MODE?');
        end
        
        function restarting_analyzer(obj)
            fprintf(obj.handle,':SYST:PUP:PROC');
        end 
        
        function power_down(obj,mode)
            %[NORMal|FORCe]
            if isempty(mode)
                mode = 'NORMal';
            end
            fprintf(obj.handle,['SYSTem:PDOWn ' mode]);
        end
        
        %% AMPTD Y Scale
        
        function set_reference_level(obj,level)
%         The maximum Ref Level is typically: +30 dBm + RL Offset – External Gain (for MXA and PXA)
        fprintf (obj.handle,['DISP:WIND:TRAC:Y:RLEV ' level 'dBm']);
        end
        
        function level = get_reference_level(obj)
            level = query(obj.handle,'DISP:WIND:TRAC:Y:RLEV?');
            %level = [level 'dBm'];
        end
        
        function set_attenuation(obj,att)
            fprintf (obj.handle,[':SENSe:POWer:RF:ATTenuation ' att]);
        end
        
        function att = get_attenuation(obj)
            att = query(obj.handle,':SENSe:POWer:RF:ATTenuation?');
            %att = [att 'dB'];
        end
        
        function set_auto_attenuation(obj,state)
            fprintf (obj.handle,[':SENSe:POWer:RF:ATTenuation:AUTO ' state]);
        end
        
        function state = get_auto_attenuation(obj)
            state = query(obj.handle,':SENSe:POWer:RF:ATTenuation:AUTO?');
        end
        
        function set_scale_type(obj,type)
            %LINear|LOGarithmic
            st = true;
            try
            fprintf (obj.handle,[':DISPlay:WINDow:TRACe:Y:SCALe:SPACing ' type]);
            catch exception
                st = false;
            end
            if st
                obj.scale_type = type;
            end
        end
        
        function type = get_scale_type(obj)
            type = query(obj.handle,':DISPlay:WINDow:TRACe:Y:SCALe:SPACing?');
        end
        
        function set_scale_div(obj,scale)
            if strcmp(obj.scale_type,'LOG')
                fprintf (obj.handle,[':DISPlay:WINDow:TRACe:Y:SCALe:PDIVision ' scale]);
            end
        end
        
        function scale = get_scale_div(obj)
            scale = query(obj.handle,':DISPlay:WINDow:TRACe:Y:SCALe:PDIVision?');
        end
        
        function set_Y_unit (obj,unit)
            %DBM|DBMV|DBMA|V|W|A|DBUV|DBUA|DBUVM|DBUAM|DBPT|DBG
            fprintf(obj.handle,[':UNIT:POWer ' unit]);
        end
        
        function unit = get_Y_unit(obj)
            unit = query(obj.handle,':UNIT:POWer?');
        end
        
        function set_reference_level_offset(obj,offset)
            fprintf(obj.handle,[':DISPlay:WINDow:TRACe:Y:SCALe:RLEVel:OFFSet ' offset]);
        end
        
        %% FREQ Channel
        
        function Auto_Tune(obj)
            fprintf(obj.handle,':SENSe:FREQuency:TUNE:IMMediate');
        end
        
        function set_start_freq(obj, freq)
            fprintf(obj.handle,[':SENSe:FREQuency:STARt ' freq]);
        end
        
        function freq = get_start_freq(obj)
            freq = query(obj.handle,':SENSe:FREQuency:STARt?');
        end
        
        function set_stop_freq(obj, freq)
            fprintf(obj.handle,[':SENSe:FREQuency:STOP ' freq]);
        end
        
        function freq = get_stop_freq(obj)
            freq = query(obj.handle,':SENSe:FREQuency:STOP?');
        end
        
        function set_RF_center_freq(obj, freq)
            fprintf(obj.handle,[':SENSe:FREQuency:RF:CENTer ' freq]);
        end
        
        function freq = get_RF_center_freq(obj)
            freq = query(obj.handle,':SENSe:FREQuency:RF:CENTer?');
        end
        
        function set_offset_frequency(obj,freq)
            fprintf(obj.handle,[':SENSe:FREQuency:OFFSet ' freq]);
        end
        
        function freq = get_offset_frequency(obj)
            freq = query(obj.handle,':SENSe:FREQuency:OFFSet?');
        end
        
        %% Continuous Measurement/Sweep
        
        function set_Cont_Meas(obj,state)
            fprintf(obj.handle,[':INITiate:CONTinuous ' state]);
        end
        
        function state = get_Cont_Meas(obj)
            state = query(obj.handle,':INITiate:CONTinuous?');
        end
        
        %% Input/Output
        
        function set_feed(obj,feed)
            %RF|AIQ|IQ|IONLy|QONLy|INDependent|AREFerence
            fprintf(obj.handle,[':SENSe:FEED ' feed]);
        end
        
        function feed = get_feed(obj)
            feed = query(obj.handle,':SENSe:FEED?');
        end
        
        function set_RF_Input_Port(obj,port)
            %RFIN|RFIN2|RFIO1|RFIO2
            fprintf(obj.handle,[':SENSe:FEED:RF:PORT:INPut ' port]);
        end
        
        function port = get_RF_Input_Port(obj)
            port = query(obj.handle,':SENSe:FEED:RF:PORT:INPut?');
        end
        
        function set_RF_Calibrator(obj,ref)
            %REF50|REF4800|OFF
            fprintf(obj.handle,[':SENSe:FEED:AREFerence ' ref]);
        end
        
        function ref = get_RF_Calibrator(obj)
            ref = query(obj.handle,':SENSe:FEED:AREFerence?');
        end
        
        function set_data_source(obj,data)
            %INPut|STORed|RECorded
            fprintf(obj.handle,[':FEED:DATA ' data]);
        end
        
        function data = get_data_source(obj)
            data = query(obj.handle,':FEED:DATA?');
        end
        
        function set_Freq_Ref_In(obj,ref)
            %INTernal|EXTernal|SENSe
            fprintf(obj.handle,[':SENSe:ROSCillator:SOURce:TYPE ' ref]);
        end
        
        function ref = get_Freq_Ref_In(obj)
            ref = query(obj.handle,':SENSe:ROSCillator:SOURce:TYPE?');
        end
        
        function set_Freq_Ext_Ref(obj,freq)
            %INTernal|EXTernal|SENSe
            fprintf(obj.handle,[':SENSe:ROSCillator:EXTernal:FREQuency ' freq]);
        end
        
        function freq = get_Freq_Ext_Ref(obj)
            freq = query(obj.handle,':SENSe:ROSCillator:EXTernal:FREQuency?');
        end
        
        %% Restart
        
        function restart(obj)
            fprintf(obj.handle,':INITiate:RESTart');
        end
            
        %% Span
        
        function set_span(obj,span)
            fprintf(obj.handle,[':SENSe:FREQuency:SPAN ' span]);
        end
        
        function span = get_span(obj)
            span = query(obj.handle,':SENSe:FREQuency:SPAN?');
        end
        
        function set_full_span(obj)
            fprintf(obj.handle,':SENSe:FREQuency:SPAN:FULL');
        end
        
        function set_zero_span(obj)
            fprintf(obj.handle,':SENSe:FREQuency:SPAN: 0');
        end
        
        function set_bandwidth_resolution(obj,res)
             fprintf(obj.handle,[':SENSe:BANDwidth:RESolution ' res]);
        end
        
        function res = get_bandwidth_resolution(obj)
            res = query(obj.handle,':SENSe:BANDwidth:RESolution?');
        end
        
        function set_Video_bandwidth_resolution(obj,vbw)
             fprintf(obj.handle,[':SENSe:BANDwidth:VIDeo ' vbw]);
        end
        
        function vbw = get_Video_bandwidth_resolution(obj)
            vbw = query(obj.handle,':SENSe:BANDwidth:VIDeo?');
        end
        
        %% Marker
        
        function set_Marker_mode(obj,marker,mode)
            %POSition|DELTa|FIXed|OFF
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':MODE ' mode]);
        end
        
        function mode = get_Marker_mode(obj,marker)
            mode = query(obj.handle,[':CALCulate:MARKer' marker ':MODE?']);
        end

        function set_Marker_X_Axis_Value(obj,marker,freq)
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':X ' freq]);
        end
        
        function freq = get_Marker_X_Axis_Value(obj,marker)
            freq = query(obj.handle,[':CALCulate:MARKer' marker ':X?']);
        end
        
        function set_Trace_Marker_X_Axis_Value(obj,marker,freq)
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':X:POSition ' freq]);
        end
        
        function freq = get_Trace_Marker_X_Axis_Value(obj,marker)
            freq = query(obj.handle,[':CALCulate:MARKer' marker ':X:POSition?']);
        end
        
        function set_Marker_Y_Axis_Value(obj,marker,freq)
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':Y ' freq]);
        end
        
        function freq = get_Marker_Y_Axis_Value(obj,marker)
            freq = query(obj.handle,[':CALCulate:MARKer' marker ':Y?']);
        end
        
        function select_Marker1_reference_To_Marker2(obj,marker1,marker2)
            fprintf(obj.handle,[':CALCulate:MARKer' marker1 ':REFerence ' marker2]);
        end
        
        function marker2 = get_Marker_reference(obj,marker1)
            marker2 = query(obj.handle,[':CALCulate:MARKer' marker1 ':REFerence?']);
        end
        
        function set_Marker_X_Scale(obj,marker,scale)
            %FREQuency|TIME|ITIMe|PERiod
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':X:READout ' scale]);
        end
        
        function scale = get_Marker_X_Scale(obj,marker)
            scale = query(obj.handle,[':CALCulate:MARKer' marker ':X:READout?']);
        end
        
        function set_Marker_Trace(obj,marker,trace)
            %trace : 1..6
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':TRACe ' trace]);
        end
        
        function trace = get_Marker_Trace(obj,marker)
            trace = query(obj.handle,[':CALCulate:MARKer' marker ':TRACe?']);
        end
        
        function set_Marker_Table_Status(obj,state)
            fprintf(obj.handle,[':CALCulate:MARKer:TABLe ' state]);
        end
        
        function state = get_Marker_Table_Status(obj)
            state = query(obj.handle,':CALCulate:MARKer:TABLe?');
        end
        
        function set_All_Markers_Off(obj)
            fprintf(obj.handle,':CALCulate:MARKer:AOFF');
        end
        
        % Marker to 
        
        function set_Marker_To(obj,marker,to)
            % CENT|STAR|STOP|RLEV|DELT:SPAN|DELT:CENT
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':' to]);
        end
        
        %% Display
        
        % System Display Setting
        
        function set_Annotation_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:WINDow:ANNotation ' state]);
        end
        
        function state = get_Annotation_Status(obj)
            state = query(obj.handle,':DISPlay:WINDow:ANNotation?');
        end
        
        function set_Theme(obj,theme)
            %TDColor|TDMonochrome|FCOLor|FMONochrome
            fprintf(obj.handle,[':DISPlay:THEMe ' theme]);
        end
        
        function theme = get_Theme(obj)
            theme = query(obj.handle,':DISPlay:THEMe?');
        end
        
        function set_Backlight_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:BACKlight ' state]);
        end
        
        function state = get_Backlight_Status(obj)
            state = query(obj.handle,':DISPlay:BACKlight?');
        end
        
        function set_Full_Screen_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:FSCReen ' state]);
        end
        
        function state = get_Full_Screen_Status(obj)
            state = query(obj.handle,':DISPlay:FSCReen?');
        end
        
        function set_Display_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:ENABle ' state]);
        end
        
        function state = get_Display_Status(obj)
            state = query(obj.handle,':DISPlay:ENABle?');
        end
        
        % Annotation
        
        function set_Annotation_Meas_Bar_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:ANNotation:MBAR ' state]);
        end
        
        function state = get_Annotation_Meas_Bar_Status(obj)
            state = query(obj.handle,':DISPlay:ANNotation:MBAR?');
        end
        
        function set_Annotation_Screen_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:ANNotation:SCReen ' state]);
        end
        
        function state = get_Annotation_Screen_Status(obj)
            state = query(obj.handle,':DISPlay:ANNotation:SCReen?');
        end
        
        function set_Annotation_Trace_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:ANNotation:TRACe ' state]);
        end
        
        function state = get_Annotation_Trace_Status(obj)
            state = query(obj.handle,':DISPlay:ANNotation:TRACe?');
        end
              
        function set_Annotation_Active_Function_Values_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:ACTivefunc ' state]);
        end
        
        function state = get_Annotation_Active_Function_Values_Status(obj)
            state = query(obj.handle,':DISPlay:ACTivefunc?');
        end
        
        % Graticule
        
        function set_Graticule_Status(obj,state)
            fprintf(obj.handle,[':DISPlay:WINDow:TRACe:GRATicule:GRID ' state]);
        end
        
        function state = get_Graticule_Status(obj)
            state = query(obj.handle,':DISPlay:WINDow:TRACe:GRATicule:GRID?');
        end
        
        %% Meas
        
        function name = Current_Measurement(obj)
            name0 = query(obj.handle,':CONFigure?');
            name = '';
            for i = 1:length(name0)-1
                name = [name name0(i)];
            end
        end
        
        function status = Limit_Test_Current_Results(obj)
            status = str2double(query(obj.handle,':CALCulate:CLIMits:FAIL?'));
            if status
                status = 'Test Failed';
            else
                status = 'Test Succeded';
            end
        end
        
        function tab = Calculate_Peaks_of_Trace_Data(obj,trace,threshold,excursion,type,option)
            % trace: [1]|2|3|4|5|6
            % threshold: the level below which trace data peaks are ignored
            % excursion: the minimum amplitude variation (rise and fall) required for a signal to be identified as peak
            % type: AMPLitude|FREQuency|TIME
            %option: ALL|GTDLine|LTDLine
            tab = query(obj.handle,[':CALCulate:DATA' trace ':PEAKs?' threshold ',' excursion ',' type ',' option]);
        end
        
        %% Meas setup
        
        function set_averge_count_number(obj,number)
            fprintf(obj.handle,[':SENSe:AVERage:COUNt ' number]);
        end
        
        function number = get_averge_count_number(obj)
            number = query(obj.handle,':SENSe:AVERage:COUNt?');
        end
        
        function set_Average_Type(obj,type)
            % type: RMS|LOG|SCALar
            fprintf(obj.handle,[':SENSe:AVERage:TYPE ' type]);
        end
        
        function type = get_Average_Type(obj)
            type = query(obj.handle,':SENSe:AVERage:TYPE?');
        end
        
        %% Mode
        
        function select_Measurement_Mode(obj,mode)
            %type:
            %SA|BASIC|WCDMA|CDMA2K|EDGEGSM|PNOISE|CDMA1XEV|CWLAN|WIM...
            %AXOFDMA|CWIMAXOFDM|VSA|VSA89601|LTE|IDEN|WIMAXFIXED|LTE...
            %TDD|TDSCDMA|NFIGURE|ADEMOD|DVB|DTMB|ISDBT|CMMB|RLC|SCPI...
            %LC|SANalyzer|RECeiver|SEQAN|BT
            fprintf(obj.handle,[':INSTrument:SELect ' mode]);
        end
        
        function mode = get_Measurement_Mode(obj)
            mode = query(obj.handle,':INSTrument:SELect?');
        end
            
        %% Peak search 
        
        function set_marker_to_peak(obj,marker)
            fprintf(obj.handle,[':CALCulate:MARKer' marker ':MAXimum']);
        end
        
        function max = get_highest_Peak(obj)
            fprintf(obj.hadle,':CALCulate:MARKer:PEAK:SEARch:MODE MAXimum');
            max = 1;
        end
        
        %% Trigger
        
        function set_Trigger_Source(obj,source)
            %source: EXTernal1|EXTernal2|IMMediate|LINE|FRAMe|RFBurst|VIDeo|IF|ALARm|LAN|IQMag|IDEMod|QDEMod|IINPut|QINPut|AIQMag
            measurement = Current_Measurement(obj);
            if strcmp(measurement,'SAN')
                fprintf(obj.handle,[':TRIGger:SOURce ' source]);
            else
                fprintf(obj.handle,[':TRIGger:' measurement ':SOURce ' source]);
            end
        end
        
        function source = get_Trigger_Source(obj)
            measurement = Current_Measurement(obj);
            if strcmp(measurement,'SAN')
                source = query(obj.handle,':TRIGger:SOURce?');
            else
                source = query(obj.handle,[':TRIGger:' measurement ':SOURce?']);
            end
        end
        
        function set_RF_Trigger_Source(obj,source)
            %source: EXTernal1|EXTernal2|IMMediate|LINE|FRAMe|RFBurst|VIDeo|IF|ALARm|LAN
            measurement = Current_Measurement(obj);
            if strcmp(measurement,'SAN')
                fprintf(obj.handle,[':TRIGger:RF:SOURce ' source]);
            else
                fprintf(obj.handle,[':TRIGger:' measurement ':RF:SOURce ' source]);
            end
        end
        
        function source = get_RF_Trigger_Source(obj)
            measurement = Current_Measurement(obj);
            if strcmp(measurement,'SAN')
                source = query(obj.handle,':TRIGger:RF:SOURce?');
            else
                source = query(obj.handle,[':TRIGger' measurement ':RF:SOURce?']);
            end
        end
        
        %% Memory
        
        % Saving
         
        function save_state(obj,MyStateFile)
            fprintf(obj.handle,[':MMEM:STOR:STATe "' MyStateFile '.state"']);
        end
        
        function save_state_trace(obj,trace,MyTraceFile)
            fprintf(obj.handle,[':MMEM:STOR:STATe TRACE' trace ',"' MyTraceFile '.trace"']);
        end
        
        function save_measurement_results(obj,MyMeasFile)
            fprintf(obj.handle,[':MMEM:STOR:RES "' MyMeasFile '.xml"']);
        end
        
        function save_screen(obj,MyScreenFile)
            fprintf(obj.handle,[':MMEM:STOR:SCR "' MyScreenFile '.png"']);
        end
        
        function save_csv_trace(obj,trace,MytraceFile)
            fprintf(obj.handle,[':MMEM:STOR:TRAC:DATA TRACE' trace ',"' MytraceFile '.csv"']);
        end
        
        % Recall
        
        function load_state(obj,MyStateFile)
            fprintf(obj.handle,[':MMEM:LOAD:STATe "' MyStateFile '"']);
        end
        
        function load_state_trace(obj,trace,MyTraceFile)
            fprintf(obj.handle,[':MMEM:LOAD:STATe TRACE' trace ',"' MyTraceFile '"']);
        end
        
        function load_measurement_results(obj,MyMeasFile)
            fprintf(obj.handle,[':MMEM:LOAD:RES "' MyMeasFile '"']);
        end
        
        function load_screen(obj,MyScreenFile)
            fprintf(obj.handle,[':MMEM:LOAD:SCR "' MyScreenFile '"']);
        end
        
        function load_csv_trace(obj,trace,MytraceFile)
            fprintf(obj.handle,[':MMEM:LOAD:TRAC:DATA TRACE' trace ',"' MytraceFile '"']);
        end
        
        % Download trace
        
        function [freq data] = download_spectre(obj)
            % avant de se connecter
            mode = get_Measurement_Mode(obj);
            if ~strcmp(mode,'SA')
                select_Measurement_Mode(obj,'SA');
            end
            fprintf(obj.handle,':FORM:DATA REAL,32');
            fprintf(obj.handle,':FORM:BORD SWAP');
            nr_points = str2double(query(obj.handle,':SWE:POIN?'));
            freq_center = str2double(get_RF_center_freq(obj));
            freq_span = str2double(get_span(obj));
            freq = [1:nr_points]';
            for point_index = 0:(nr_points-1);
            freq(point_index+1) = freq_center + freq_span * [point_index/(nr_points-1) - 0.5];
            end
            
            ref_lev = str2double(query(obj.handle,'DISP:WIND:TRAC:Y:RLEV?'));
            % Get the trace data
            fprintf(obj.handle,':TRACe1:UPDate:STATe OFF');
            fprintf(obj.handle,':TRACe:DATA? TRACE1');
            data = binblockread(obj.handle,'float32');
            fscanf(obj.handle); %removes the terminator character
            fprintf(obj.handle,':TRACe1:UPDate:STATe ON');
%             % create and bring to front fi gure number 1
%             figure()
%             % Plot trace data vs sweep point index
%             plot(freq,data)
%             %xlim([1 nr_points]);
%             ylim([ref_lev-100 ref_lev]);
%             % activate the grid lines
%             grid on
%             title('Swept SA trace');
%             xlabel('Frequency (Hz)');
%             ylabel('Amplitude (dBm)');
        end
        
        function [I Q data] = download_IQ(obj,time,clkrate)
            freq = get_RF_center_freq(obj);
            select_Measurement_Mode(obj,'BASIC');
            display_IQ(obj);
            fprintf(obj.handle,':FORM:DATA REAL,32');
            fprintf(obj.handle,':FORM:BORD SWAP');
            fprintf(obj.handle,[':SENSe:FREQuency:RF:CENTer ' freq]);
            %clkrate = clkrate/1.28;
            set_sampling_rate(obj,clkrate);
            set_Trigger_Source(obj,'EXTernal1');
            fprintf(obj.handle,[':WAVeform:SWEep:TIME ' time]);
            fprintf(obj.handle,':FETCh:WAV0?');
            data = binblockread(obj.handle,'float32');
            fscanf(obj.handle); %removes the terminator character
            I = data(1:2:length(data));
            Q = data(2:2:length(data));
            %I  = resample ( I , 32 , 25 , 20);
            %Q  = resample ( Q , 32 , 25 , 20);
        end
        
        % liste
        
        function list = get_list(path,ext)
            % mode = SA/VSA...
            % For all of the Trace Data Files:
            % My Documents\<mode name>\data\traces
            % For all of the Limit Data Files:
            % My Documents\<mode name>\data\limits
            % For all of the Measurement Results Data Files:
            % My Documents\<mode name>\data\<measurement name>\results
            % For State files:
            % D:\User_My_Documents\Instrument\My Documents\<mode name>\state
            
            liste = query(obj.handle,[':MMEMory:CATalog? "' path '"']);
            % research of ',' to determin the number of files
            T = [];
            number = 0; 
            for i = 1:length(liste)
                if strcmp(liste(i),',')
                    number = number+1;
                    T(number)=i;
                end
            end
            if number < 3
                %list is emplty
                list = {};
            else
                % extraction
                j = 1;
                list = {};
                tmp = '';
                indice = number;
                while indice~=1
                   k = T(indice-1);
                   l = T(indice-2);
                   for i=l+2:k-1
                       tmp = [tmp liste(i)];
                   end
                   if isempty(strfind(tmp,ext))
                      tmp = '';
                      indice = indice - 3;
                   else
                        list(j) = cellstr(tmp);
                        j = j+1;
                        tmp = '';
                        indice = indice - 3;
                   end
                end
            end
        end
        
        %% calculate
        
        function bw = calculate_bandwidth(obj,NdB)
            fprintf (obj.handle,':CALCulate:BWIDth ON');
            fprintf (obj.handle,[':CALCulate:BWIDth:NDB' NdB]);
            bw = query(obj.handle,':CALCulate:BANDwidth:NDB?');
        end
        
        function power = calc_channel_power(obj,BW)
            fprintf(obj.handle,[':CHPower:BANDwidth' BW]);
            power = query(obj.handle,'MEASure:CHPower:CHPower?');
        end
        
        %% Trace
        
        function set_Trace_type(obj,trace,type)
            %TYPE: WRITe|AVERage|MAXHold|MINHold
            fprintf(obj.handle,[':TRACe' trace ':Type ' type]);
        end
        
        function type = get_Trace_type(obj,trace)
            type = query(obj.handle,[':TRACe' trace ':Type?']);
        end
        
        %% Basic mode
        
        function rate = get_sampling_rate(obj)
            rate = query(obj.handle,':WAVeform:SRATe?');
        end
        
        function set_sampling_rate(obj,rate)
            fprintf(obj.handle,[':WAVeform:SRATe ' rate]);
        end
        
        function display_IQ(obj)
            fprintf(obj.handle,':CONF:WAV');
        end
        
        %% VSA Mode
        
        function rate = get_input_sampling_rate(obj)
            rate = query(obj.handle,'VECT:SWE:ISR?');
        end
        
        function set_input_sampling_rate(obj,rate)
            fprintf(obj.handle,['VECT:SWE:ISR ' rate]);
        end
        
        function level = get_VSA_Y_level(obj)
            level = query(obj.handle,'DISP:VECT:TRAC:Y:RLEV?');
        end
        
        function set_VSA_Y_level(obj,level)
            fprintf(obj.handle,['DISP:VECT:TRAC:Y:RLEV ' level]);
        end
        
        function scale = get_VSA_scale_div(obj)
            scale = query(obj.handle,'DISP:VECT:TRAC:Y:PDIV?');
        end
        
        function set_VSA_scale_div(obj,scale)
            fprintf(obj.handle,['DISP:VECT:TRAC:Y:PDIV ' scale]);
        end
        
        function pref = get_Y_Unit_Preference(obj,trace)
            pref = query(obj.handle,[':DISPlay:VECT:TRACe' trace ':Y:UNIT:PREFerence?']);
        end
        
        function set_Y_Unit_Preference(obj,trace,pref)
            %AUTO|PEAK|RMS|POWer|MRMS
            fprintf(obj.handle,[':DISPlay:VECT:TRACe' trace ':Y:UNIT:PREFerence ' pref]);
        end
        
        function bw = get_VSA_Res_BW(obj)
            bw = query(obj.handle,':VECT:BANDwidth:RESolution?');
        end
        
        function set_VSA_Res_BW(obj,bw)
            fprintf(obj.handle,[':VECT:BANDwidth:RESolution ' bw]);
        end
        
        function freq = get_VSA_center_freq(obj)
            freq = query(obj.handle,':SENSe:FREQuency:CENTer?');
        end
        
        function set_VSA_center_freq(obj,freq)
            fprintf(obj.handle,[':SENSe:FREQuency:CENTer ' freq]);
        end
        
        function format = get_VSA_data_format(obj,trace)
            format = query(obj.handle,[':DISPlay:VECT:TRACe' trace ':FORMat?']);
        end
        
        function set_VSA_data_format(obj,trace,format)
            %MLOG|MLINear|REAL|IMAGinary|VECTor|CONS|PHASe|UPHase|IEYE|QEYE|TRELlis|GDELay|MLGLinear
            fprintf(obj.handle,[':DISPlay:VECT:TRACe' trace ':FORMat ' format]);
        end
        
        
    end
    
end