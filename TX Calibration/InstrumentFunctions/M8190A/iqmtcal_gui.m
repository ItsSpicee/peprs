function varargout = iqmtcal_gui(varargin)
% IQMTCAL_GUI MATLAB code for iqmtcal_gui.fig
%      IQMTCAL_GUI, by itself, creates a new IQMTCAL_GUI or raises the existing
%      singleton*.
%
%      H = IQMTCAL_GUI returns the handle to a new IQMTCAL_GUI or the handle to
%      the existing singleton*.
%
%      IQMTCAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IQMTCAL_GUI.M with the given input arguments.
%
%      IQMTCAL_GUI('Property','Value',...) creates a new IQMTCAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before iqmtcal_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to iqmtcal_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help iqmtcal_gui

% Last Modified by GUIDE v2.5 03-Jul-2017 13:54:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @iqmtcal_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @iqmtcal_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before iqmtcal_gui is made visible.
function iqmtcal_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iqmtcal_gui (see VARARGIN)

% Choose default command line output for iqmtcal_gui
handles.output = hObject;

% signal to in-system cal that it is being called from iqmain8070
if nargin > 3 && isreal(varargin{1})
    if (varargin{1} == 8070)
        handles.M8070Cal = 1;
    end
end
handles.result = [];
set(handles.popupmenuMemory, 'Value', 3); % 64K
set(handles.pushbuttonSave, 'Enable', 'off');  % no save without data
set(handles.pushbuttonUseAsDefault, 'Enable', 'off');
% make sure initial setting is valid
if ((size(varargin, 1) >= 1) && strcmp(varargin{1}, 'single'))
    set(handles.popupmenuQAWG, 'Value', 5);
    values = get(handles.popupmenuQScope, 'String');
    set(handles.popupmenuQScope, 'Value', length(values));
end
try
    arbConfig = loadArbConfig();
    if (isempty(get(handles.editSampleRate, 'String')))
        set(handles.editSampleRate, 'String', iqengprintf(arbConfig.defaultSampleRate));
    end
    if (isempty(get(handles.editMaxFreq, 'String')))
        set(handles.editMaxFreq, 'String', iqengprintf(floor(0.5 * arbConfig.defaultSampleRate/1e8)*1e8));
    end
    if (~isempty(strfind(arbConfig.model, 'M8190A')))
        set(handles.popupmenuTrigAWG, 'String', {'1', '2', '3', '4', 'Sample Marker', 'unused'});
        set(handles.popupmenuTrigAWG, 'Value', 5);
        if (get(handles.popupmenuQAWG, 'Value') >= 3 && get(handles.popupmenuQAWG, 'Value') <= 4)
            set(handles.popupmenuQAWG, 'Value', 2);
        end
    elseif (~isempty(strfind(arbConfig.model, 'M8195A_1ch')) || ~isempty(strfind(arbConfig.model, 'M8196A'))) % 1ch + 1ch_mrk
        set(handles.popupmenuTrigAWG, 'String', {'1', '2', '3', '4', 'Marker', 'unused'});
        if (~isempty(strfind(arbConfig.model, 'M8195A_1ch')))
            set(handles.popupmenuTrigAWG, 'Value', 5);
            set(handles.popupmenuQAWG, 'Value', 5);
            list = get(handles.popupmenuQScope, 'String');
            set(handles.popupmenuQScope, 'Value', length(list));
        end
    elseif (strcmp(arbConfig.model, 'M8195A_2ch_mrk')) % 2ch_mrk
        set(handles.popupmenuTrigAWG, 'String', {'1', '2', '3', '4', 'Marker', 'unused'});
        set(handles.popupmenuTrigAWG, 'Value', 5);
        set(handles.popupmenuQAWG, 'Value', 5);
        list = get(handles.popupmenuQScope, 'String');
        set(handles.popupmenuQScope, 'Value', length(list));
    else
        set(handles.popupmenuTrigAWG, 'String', {'1', '2', '3', '4', 'unused'});
    end
catch ex
    throw(ex);
end

% Update handles structure
guidata(hObject, handles);

checkfields(hObject, [], handles);

% UIWAIT makes iqmtcal_gui wait for user response (see UIRESUME)
% uiwait(handles.iqtool);


function checkfields(hObject, eventdata, handles)
try
    arbConfig = loadArbConfig();
catch
    errordlg('Please set up connection to AWG and Scope in "Configure instrument connection"');
    close(handles.iqtool);
    return;
end
rtsConn = ((~isfield(arbConfig, 'isScopeConnected') || arbConfig.isScopeConnected ~= 0) && isfield(arbConfig, 'visaAddrScope'));
dcaConn = (isfield(arbConfig, 'isDCAConnected') && arbConfig.isDCAConnected ~= 0);
if (~rtsConn && ~dcaConn)
    errordlg('You must set up either a connection to a real-time scope or DCA in "Configure instrument connection"');
    close(handles.iqtool);
    return;
end
if (~rtsConn || ~dcaConn)
    set(handles.radiobuttonRTScope, 'Value', rtsConn);
    set(handles.radiobuttonDCA, 'Value', dcaConn);
    radiobuttonDCA_Callback([], [], handles);
    radiobuttonRTScope_Callback([], [], handles);
end
% --- editSampleRate
value = -1;
try
    value = evalin('base', get(handles.editSampleRate, 'String'));
catch ex
    msgbox(ex.message);
end
if (isscalar(value) && value >= arbConfig.minimumSampleRate && value <= arbConfig.maximumSampleRate)
    set(handles.editSampleRate, 'BackgroundColor', 'white');
else
    set(handles.editSampleRate, 'BackgroundColor', 'red');
end



% --- Outputs from this function are returned to the command line.
function varargout = iqmtcal_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
try
    varargout{1} = handles.output;
catch
end


% --- Executes on button press in pushbuttonRun.
function pushbuttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
doCalibrate(hObject, handles, 0);


function doCalibrate(hObject, handles, doCode)
% doCode = 0: perform an in-system calibration and update the correct file
% doCode = 1: generate MATLAB code that performs the in-system calibration
try
    maxFreq = evalin('base', ['[' get(handles.editMaxFreq, 'String') ']']);
    numTones = evalin('base', ['[' get(handles.editNumTones, 'String') ']']);
    scopeAvg = evalin('base', ['[' get(handles.editScopeAverage, 'String') ']']);
    analysisAvg = evalin('base', ['[' get(handles.editAnalysisAverages, 'String') ']']);
    amplitude = evalin('base', ['[' get(handles.editAmplitude, 'String') ']']);
    awgChannels = [get(handles.popupmenuIAWG, 'Value') get(handles.popupmenuQAWG, 'Value') get(handles.popupmenuTrigAWG, 'Value')];
    trigList = get(handles.popupmenuTrigAWG, 'String');
    if (strcmpi(trigList{awgChannels(3)}, 'unused'))
        awgChannels(3) = 0;
    end
    iList = get(handles.popupmenuIScope, 'String');
    qList = get(handles.popupmenuQScope, 'String');
    trigList = get(handles.popupmenuTrigScope, 'String');
    scopeChannels = { iList{get(handles.popupmenuIScope, 'Value')} ...
                      qList{get(handles.popupmenuQScope, 'Value')} ...
                      trigList{get(handles.popupmenuTrigScope, 'Value')}};
    % if we are not triggering, then don't do averaging
    if (strcmpi(trigList{get(handles.popupmenuTrigScope, 'Value')}, 'unused'))
        scopeAvg = 1;
    end
    skewIncluded = get(handles.checkboxSkewIncluded, 'Value');
    scopeRST = get(handles.checkboxScopeRST, 'Value');
    AWGRST = get(handles.checkboxAWGRST, 'Value');
    recalibrate = get(handles.checkboxReCalibrate, 'Value');
    sampleRate = evalin('base', ['[' get(handles.editSampleRate, 'String') ']']);
    autoScopeAmplitude = get(handles.checkboxAutoScopeAmplitude, 'Value');
    plotAxes = [handles.axesMag handles.axesPhase];
    cla(plotAxes(1));
    cla(plotAxes(2));
    removeSinc = get(handles.checkboxRemoveSinc, 'Value');
    sim = get(handles.popupmenuSimulation, 'Value') - 1;
    debugLevel = get(handles.popupmenuDebugLevel, 'Value') - 1;
    memory = 2^(get(handles.popupmenuMemory, 'Value') + 13);
    toneDevList = get(handles.popupmenuToneDev, 'String');
    toneDev = toneDevList{get(handles.popupmenuToneDev, 'Value')};
    if (get(handles.radiobuttonRTScope, 'Value'))
        scope = 'RTScope';
    elseif (get(handles.radiobuttonDCA, 'Value'))
        scope = 'DCA';
    else
        errordlg('Please select a scope');
        return;
    end
catch ex
    errordlg({'Invalid parameter setting', ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
    return;
end
if (doCode)
    awgChannelsString = '[ ';
    for i=1:size(awgChannels,2)
        awgChannelsString = sprintf('%s%d ', awgChannelsString, awgChannels(i));
    end
    awgChannelsString = sprintf('%s]', awgChannelsString);
    scopeChannelsString = '{ ';
    for i=1:size(awgChannels,2)
        scopeChannelsString = sprintf('%s''%s'' ', scopeChannelsString, scopeChannels{i});
    end
    scopeChannelsString = sprintf('%s}', scopeChannelsString);

    code = sprintf(['result = iqmtcal(''scope'', ''%s'', ''sim'', %d, ''scopeAvg'', %d, ...\n' ...
        '    ''numTones'', %d, ''scopeRST'', %d, ''AWGRST'', %d, ...\n' ...
        '    ''sampleRate'', %s, ''recalibrate'', %d, ...\n' ...
        '    ''autoScopeAmpl'', %d, ''memory'', %d, ...\n' ...
        '    ''awgChannels'', %s, ''scopeChannels'', %s, ...\n' ...
        '    ''maxFreq'', %s, ''analysisAvg'', %d, ''toneDev'', ''%s'', ...\n' ...
        '    ''amplitude'', %g, ''hMsgBox'', %s, ''axes'', [], ...\n' ...
        '    ''skewIncluded'', %d, ''removeSinc'', %d, ''debugLevel'', %d);\n'], ...
        scope, sim, scopeAvg, numTones, scopeRST, AWGRST, iqengprintf(sampleRate), recalibrate, ...
        autoScopeAmplitude, memory, awgChannelsString, scopeChannelsString, ...
        iqengprintf(maxFreq), analysisAvg, toneDev, amplitude, '[]', ...
        skewIncluded, removeSinc, debugLevel);
    iqgeneratecode(handles, code);
else
    result = [];
    try
        if (sim == 0)
            hMsgBox = waitbar(0, 'Please wait...', 'Name', 'Please wait...', 'CreateCancelBtn', 'setappdata(gcbf,''cancel'',1)');
            setappdata(hMsgBox, 'cancel', 0);
        else
            hMsgBox = [];
        end
        result = iqmtcal('scope', scope, 'sim', sim, 'scopeAvg', scopeAvg, ...
                'numTones', numTones, 'scopeRST', scopeRST, 'AWGRST', AWGRST, ...
                'sampleRate', sampleRate, 'recalibrate', recalibrate, ...
                'autoScopeAmpl', autoScopeAmplitude, 'memory', memory, ...
                'awgChannels', awgChannels, 'scopeChannels', scopeChannels, ...
                'maxFreq', maxFreq, 'analysisAvg', analysisAvg, 'toneDev', toneDev, ...
                'amplitude', amplitude, 'hMsgBox', hMsgBox, 'axes', plotAxes, ...
                'skewIncluded', skewIncluded, 'removeSinc', removeSinc, 'debugLevel', debugLevel);
    catch ex
        errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
    end
    try delete(hMsgBox); catch; end
    handles.result = result;
    guidata(hObject, handles);
    if (~isempty(result))
        set(handles.pushbuttonSave, 'Enable', 'on');
        set(handles.pushbuttonUseAsDefault, 'Enable', 'on');
        if (sim == 0)
            if (isfield(handles, 'M8070Cal') && handles.M8070Cal == 1)
                res = questdlg('Save freq/phase response?', 'Save this measurement?', 'Yes', 'No', 'Yes');
                if (strcmp(res, 'Yes'))
                    pushbuttonSave_Callback([], [], handles);
                end
            else
                res = questdlg('Use this result as default freq/phase response for IQTools per-channel correction and adjust DC offset?', 'Save this measurement?', 'Yes', 'No', 'Yes');
                if (strcmp(res, 'Yes'))
                    pushbuttonUseAsDefault_Callback([], [], handles);
                end
                res = questdlg('Close the In-system correction window?', 'Close?', 'Yes', 'No', 'No');
                if (strcmp(res, 'Yes'))
                    % close the window to avoid confusion
                    close(handles.iqtool);
                end
            end
        end
    else
        set(handles.pushbuttonSave, 'Enable', 'off');
        set(handles.pushbuttonUseAsDefault, 'Enable', 'off');
    end
end


function editScopeAverage_Callback(hObject, eventdata, handles)
% hObject    handle to editScopeAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = [];
try
    val = evalin('base', ['[' get(hObject, 'String') ']']);
catch ex
end
if (isempty(val) || ~isscalar(val) || val < 0)
    set(hObject, 'Background', 'red');
else
    set(hObject, 'Background', 'white');
end


% --- Executes during object creation, after setting all properties.
function editScopeAverage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editScopeAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAnalysisAverages_Callback(hObject, eventdata, handles)
% hObject    handle to editAnalysisAverages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = [];
try
    val = evalin('base', ['[' get(hObject, 'String') ']']);
catch ex
end
if (isempty(val) || ~isscalar(val) || val < 0)
    set(hObject, 'Background', 'red');
else
    set(hObject, 'Background', 'white');
end


% --- Executes during object creation, after setting all properties.
function editAnalysisAverages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAnalysisAverages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobuttonRTScope.
function radiobuttonRTScope_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonRTScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobuttonRTScope, 'Value') == 1)
    arbConfig = loadArbConfig();
    rtsConn = ((~isfield(arbConfig, 'isScopeConnected') || arbConfig.isScopeConnected ~= 0) && isfield(arbConfig, 'visaAddrScope'));
    if (rtsConn)
        % if DCA was previously selected , save the channel assignment
        if (get(handles.radiobuttonDCA, 'Value'))
            handles.oldDCA_Chan = [ ...
                get(handles.popupmenuIScope, 'Value') ...
                get(handles.popupmenuQScope, 'Value') ...
                get(handles.popupmenuTrigScope, 'Value')];
            guidata(handles.output, handles);
        end
        % flip the radio buttons
        set(handles.radiobuttonRTScope, 'Value', 1);
        set(handles.radiobuttonDCA, 'Value', 0);
        % set the channel selection
        set(handles.popupmenuIScope, 'String', {'1', '2', '3', '4', 'DIFF1', 'DIFF2', 'REdge1', 'REdge3', 'DIFFREdge'});
        set(handles.popupmenuQScope, 'String', {'1', '2', '3', '4', 'DIFF1', 'DIFF2', 'REdge1', 'REdge3', 'unused'});
        set(handles.popupmenuTrigScope, 'String', {'1', '2', '3', '4', 'REdge1', 'REdge3', 'AUX', 'unused'});
        if (isfield(handles, 'oldRTS_Chan'))
            chan = handles.oldRTS_Chan;
        else
            chan = [1 3 4];
        end
        set(handles.popupmenuIScope, 'Value', chan(1));
        set(handles.popupmenuQScope, 'Value', chan(2));
        set(handles.popupmenuTrigScope, 'Value', chan(3));
    else
        set(handles.radiobuttonRTScope, 'Value', 0);
        errordlg('You must set the VISA address of the real-time scope in "Configure Instrument"');
    end
end
checkChannels(handles);


% --- Executes on button press in radiobuttonDCA.
function radiobuttonDCA_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonDCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.radiobuttonDCA, 'Value') == 1)
    arbConfig = loadArbConfig();
    if (isfield(arbConfig, 'isDCAConnected') && arbConfig.isDCAConnected)
        % if RTScope was previously selected , save the channel assignment
        if (get(handles.radiobuttonRTScope, 'Value'))
            handles.oldRTS_Chan = [ ...
                get(handles.popupmenuIScope, 'Value') ...
                get(handles.popupmenuQScope, 'Value') ...
                get(handles.popupmenuTrigScope, 'Value')];
            guidata(handles.output, handles);
        end
        set(handles.radiobuttonDCA, 'Value', 1);
        set(handles.radiobuttonRTScope, 'Value', 0);
        set(handles.popupmenuIScope, 'String', {'1A', '1B', 'DIFF1A', '1C', '1D', 'DIFF1C', '2A', '2B', 'DIFF2A', '2C', '2D', 'DIFF2C', '3A', '3B', 'DIFF3A', '3C', '3D', 'DIFF3C', '4A', '4B', 'DIFF4A', '4C', '4D', 'DIFF4C', '5A', '5B', 'DIFF5A', '5C', '5D', 'DIFF5C'});
        set(handles.popupmenuQScope, 'String', {'1A', '1B', 'DIFF1A', '1C', '1D', 'DIFF1C', '2A', '2B', 'DIFF2A', '2C', '2D', 'DIFF2C', '3A', '3B', 'DIFF3A', '3C', '3D', 'DIFF3C', '4A', '4B', 'DIFF4A', '4C', '4D', 'DIFF4C', '5A', '5B', 'DIFF5A', '5C', '5D', 'DIFF5C', 'unused'});
        set(handles.popupmenuTrigScope, 'String', {'Front Panel' 'PTB+FP'});
        if (isfield(handles, 'oldDCA_Chan'))
            chan = handles.oldDCA_Chan;
        else
            chan = [1 2 2];
            if (get(handles.popupmenuQAWG, 'Value') == 5)
                chan(2) = length(get(handles.popupmenuQScope, 'String'));
            end
        end
        set(handles.popupmenuTrigScope, 'Value', chan(3));
        set(handles.popupmenuIScope, 'Value', chan(1));
        set(handles.popupmenuQScope, 'Value', chan(2));
    else
        set(handles.radiobuttonDCA, 'Value', 0);
        errordlg('You must set the VISA address of the DCA in "Configure Instrument" if you want to use a DCA for calibration');
    end
end
checkChannels(handles);


function editMaxFreq_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = [];
try
    val = evalin('base', ['[' get(hObject, 'String') ']']);
    fs = evalin('base', ['[' get(handles.editSampleRate, 'String'), ']']);
    if (val > fs/2)
        val = [];
    end
catch ex
end
if (isempty(val))
    set(hObject, 'Background', 'red');
else
    set(hObject, 'Background', 'white');
end



% --- Executes during object creation, after setting all properties.
function editMaxFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNumTones_Callback(hObject, eventdata, handles)
% hObject    handle to editNumTones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = [];
try
    val = evalin('base', ['[' get(hObject, 'String') ']']);
catch ex
end
if (isempty(val))
    set(hObject, 'Background', 'red');
else
    set(hObject, 'Background', 'white');
end


% --- Executes during object creation, after setting all properties.
function editNumTones_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumTones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuIAWG.
function popupmenuIAWG_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuIAWG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checkChannels(handles);


% --- Executes during object creation, after setting all properties.
function popupmenuIAWG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuIAWG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuIScope.
function popupmenuIScope_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuIScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valList = get(handles.popupmenuIScope, 'String');
val = valList{get(handles.popupmenuIScope, 'Value')};
if (strncmpi(val, 'REdge1', 6))
    set(handles.popupmenuQScope, 'Value', 8);    % set Q to REdge3
    set(handles.popupmenuTrigScope, 'Value', 5); % set Trigger to AUX
end
if (strncmpi(val, 'DIFFREdge', 9))
    set(handles.popupmenuQAWG, 'Value', 5);      % set QAWG to unused
    set(handles.popupmenuQScope, 'Value', 9);    % set QScope to unused
    set(handles.popupmenuTrigScope, 'Value', 5); % set Trigger to AUX
end
checkChannels(handles);

% --- Executes during object creation, after setting all properties.
function popupmenuIScope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuIScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuQAWG.
function popupmenuQAWG_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuQAWG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.popupmenuQAWG, 'Value') == 5)
    list = get(handles.popupmenuQScope, 'String');
    set(handles.popupmenuQScope, 'Value', length(list));
end
checkChannels(handles);


% --- Executes during object creation, after setting all properties.
function popupmenuQAWG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuQAWG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuQScope.
function popupmenuQScope_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuQScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = get(handles.popupmenuQScope, 'String');
if (strcmp(list{get(handles.popupmenuQScope, 'Value')}, 'unused'))
    set(handles.popupmenuQAWG, 'Value', 5);
end
checkChannels(handles);


% --- Executes during object creation, after setting all properties.
function popupmenuQScope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuQScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuTrigAWG.
function popupmenuTrigAWG_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuTrigAWG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = get(handles.popupmenuTrigAWG, 'String');
if (strcmp(list{get(handles.popupmenuTrigAWG, 'Value')}, 'unused'))
    list = get(handles.popupmenuTrigScope, 'String');
    p = find(strcmp(list, 'unused'), 1);
    if (~isempty(p))
        set(handles.popupmenuTrigScope, 'Value', p);
    end
end
checkChannels(handles);


% --- Executes during object creation, after setting all properties.
function popupmenuTrigAWG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuTrigAWG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkChannels(handles)
h = [handles.popupmenuIAWG, handles.popupmenuQAWG, handles.popupmenuTrigAWG, ...
     handles.popupmenuIScope, handles.popupmenuQScope, handles.popupmenuTrigScope];
hx = zeros(1, 6);       % flag for error
hv = get(h, 'Value');   % values
hs = cell(1, 6);        % strings
for i=1:6
    list = get(h(i), 'String');
    hs{i} = list{hv{i}};
end
% check for double use channels
if (hv{1} == hv{2}); hx(1) = 1; hx(2) = 1; end
% check for same channel with trigger
if (hv{3} < 5)
    if (hv{1} == hv{3}); hx(1) = 1; hx(3) = 1; end
    if (hv{2} == hv{3}); hx(2) = 1; hx(3) = 1; end
end
if (hv{4} == hv{5} && ~strcmp(hs{5}, 'unused')); hx(4) = 1; hx(5) = 1; end
if (~strcmp(hs{6}, 'Front Panel') && ~strcmp(hs{6}, 'PTB+FP') && ~strcmp(hs{6}, 'AUX'))
    if (hv{4} == hv{6}); hx(4) = 1; hx(6) = 1; end
    if (hv{5} == hv{6}); hx(5) = 1; hx(6) = 1; end
end
% check for unused connected to not unused
if (strcmp(hs{2}, 'unused') && ~strcmp(hs{5}, 'unused'))
    hx(2) = 1;
end
if (~strcmp(hs{2}, 'unused') && strcmp(hs{5}, 'unused'))
    hx(5) = 1;
end
% check for unused trigger connected to not unused trigger
if (strcmp(hs{3}, 'unused') && ~strcmp(hs{6}, 'unused'))
    hx(3) = 1;
end
if (~strcmp(hs{3}, 'unused') && strcmp(hs{6}, 'unused'))
    hx(6) = 1;
end
% if one channel is real edge, both of them have to be
if (strncmpi(hs{4}, 'REdge', 5) && ~(strncmpi(hs{5}, 'REdge', 5) || strcmp(hs{5}, 'unused')))
    hx(5) = 1;
end
if (strncmpi(hs{5}, 'REdge', 5) && ~strncmpi(hs{4}, 'REdge', 5))
    hx(4) = 1;
end
% if using real edge, the trigger has to be AUX
if ((strncmpi(hs{4}, 'REdge', 5) || strncmpi(hs{5}, 'REdge', 5)) && ...
        ~(strcmp(hs{6}, 'AUX') || strncmpi(hs{6}, 'REdge', 5)))
    hx(6) = 1;
end
arbConfig = loadArbConfig();
switch arbConfig.model
    case {'M8195A_1ch' 'M8195A_1ch_mrk'}
        if (hv{1} > 1 && ~strcmp(hs{1}, 'unused')); hx(1) = 1; end
        if (hv{2} > 1 && ~strcmp(hs{2}, 'unused')); hx(2) = 1; end
        if (~strcmp(hs{3}, 'Marker') && ~strcmp(hs{3}, 'unused')); hx(3) = 1; end
    case {'M8195A_2ch' }
        if ((hv{1} ~= 1 && hv{1} ~= 4) && ~strcmp(hs{1}, 'unused')); hx(1) = 1; end
        if ((hv{2} ~= 1 && hv{2} ~= 4) && ~strcmp(hs{2}, 'unused')); hx(2) = 1; end
        if (~strcmp(hs{3}, 'Marker') && ~strcmp(hs{3}, 'unused') && hv{3} ~= 1 && hv{3} ~= 4); hx(3) = 1; end
    case {'M8195A_2ch_mrk' }
        if ((hv{1} ~= 1 && hv{1} ~= 2) && ~strcmp(hs{1}, 'unused')); hx(1) = 1; end
        if ((hv{2} ~= 1 && hv{2} ~= 2) && ~strcmp(hs{2}, 'unused')); hx(2) = 1; end
        if (~strcmp(hs{3}, 'Marker') && ~strcmp(hs{3}, 'unused') && hv{3} ~= 1 && hv{3} ~= 2); hx(3) = 1; end
end
% turn the background to red for those that violate a rule
for i = 1:6
    if (hx(i))
        set(h(i), 'Background', 'red');
    else
        set(h(i), 'Background', 'white');
    end
end

% --- Executes on selection change in popupmenuTrigScope.
function popupmenuTrigScope_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuTrigScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list = get(handles.popupmenuTrigScope, 'String');
if (strcmp(list{get(handles.popupmenuTrigScope, 'Value')}, 'unused'))
    list = get(handles.popupmenuTrigAWG, 'String');
    p = find(strcmp(list, 'unused'), 1);
    if (~isempty(p))
        set(handles.popupmenuTrigAWG, 'Value', p);
    end
end
checkChannels(handles);


% --- Executes during object creation, after setting all properties.
function popupmenuTrigScope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuTrigScope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAmplitude_Callback(hObject, eventdata, handles)
% hObject    handle to editAmplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = [];
try
    val = evalin('base', ['[' get(hObject, 'String') ']']);
catch ex
end
if (isempty(val) || ~isscalar(val) || val < 0)
    set(hObject, 'Background', 'red');
else
    set(hObject, 'Background', 'white');
end


% --- Executes during object creation, after setting all properties.
function editAmplitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAmplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSimulation.
function popupmenuSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSimulation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSimulation


% --- Executes during object creation, after setting all properties.
function popupmenuSimulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuDebugLevel.
function popupmenuDebugLevel_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuDebugLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuDebugLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuDebugLevel


% --- Executes during object creation, after setting all properties.
function popupmenuDebugLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuDebugLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxSkewIncluded.
function checkboxSkewIncluded_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSkewIncluded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSkewIncluded


% --- Executes on button press in checkboxScopeRST.
function checkboxScopeRST_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxScopeRST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxScopeRST


% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles, 'result') && ~isempty(handles.result))
    Cal = handles.result;
    freq = Cal.Frequency_MT * 1e9;
    mag = Cal.AmplitudeResponse_MT;
    phase = Cal.AbsPhaseResponse_MT;
    cplxCorr = (10 .^ (mag/20)) .* exp(1i * phase/180*pi);
    % set up perChannelCorr structure
    clear perChannelCorr;
    perChannelCorr(:,1) = freq(1:end);
    perChannelCorr(:,2:size(cplxCorr,2)+1) = 1 ./ cplxCorr;
    savePerChannelCorr(perChannelCorr);
else
    msgbox('no valid measurement available');
end
    

function savePerChannelCorr(perChannelCorr)
% prompt user for a filename and save frequency response in desired format
% note: same function as in iqcorrmgmt.m --> should be unified
numChan = size(perChannelCorr, 2) - 1;
sp1 = sprintf('.s%dp', 2*numChan);
sp2 = sprintf('Touchstone %d-port file (*.s%dp)', 2*numChan, 2*numChan);
[filename, pathname, filterindex] = uiputfile({...
    sp1, sp2; ...
    '.mat', 'MATLAB file (*.mat)'; ...
    '.csv', 'CSV file (*.csv)'; ...
    '.csv', 'CSV (VSA style) (*.csv)'}, ...
    'Save Frequency Response As...');
if (filename ~= 0)
    switch filterindex
        case 2 % .mat
            try
                clear Cal;
                Cal.Frequency_MT = perChannelCorr(:,1) / 1e9;
                Cal.AmplitudeResponse_MT = -20 * log10(abs(perChannelCorr(:,2:end)));
                Cal.AbsPhaseResponse_MT = unwrap(angle(perChannelCorr(:,2:end))) * -180 / pi;
                save(fullfile(pathname, filename), 'Cal');
            catch ex
                errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
            end
        case 3 % .csv
            cal = zeros(size(perChannelCorr,1), 2*(size(perChannelCorr,2)-1)+1);
            cal(:,1) = perChannelCorr(:,1);
            for i = 1:numChan
               cal(:,2*i) = 20 * log10(abs(perChannelCorr(:,i+1)));
               cal(:,2*i+1) = unwrap(angle(perChannelCorr(:,i+1))) * 180 / pi;
            end
            csvwrite(fullfile(pathname, filename), cal);
        case 4 % .csv (VSA style)
            try
                ch = 1;
                if (size(perChannelCorr, 2) > 2)
                    list = {'Primary / I', 'Secondary / Q', '3rd', '4th'};
                    [ch,~] = listdlg('PromptString', 'Select Channel', 'SelectionMode', 'single', 'ListString', list(1:size(perChannelCorr,2)-1), 'ListSize', [100 60]);
                end
                if (~isempty(ch))
                    f = fopen(fullfile(pathname, filename), 'wt');
                    % if positive frequencies only, mirror to negative side
                    nPts = size(perChannelCorr, 1);
                    pf = polyfit((0:nPts-1)', perChannelCorr(:,1), 1);
                    fprintf(f, sprintf('FileFormat UserCal-1.0\n'));    % new tag - Nizar Messaoudi
                    fprintf(f, sprintf('Trace Data\n'));                % new tag - Nizar Messaoudi
                    fprintf(f, sprintf('YComplex1\n'));                 % new tag - Nizar Messaoudi
                    fprintf(f, sprintf('YFormat RI\n'));                % new tag - Nizar Messaoudi
                    fprintf(f, sprintf('InputBlockSize, %d\n', nPts));
                    fprintf(f, sprintf('XStart, %g\n', pf(2)));
                    fprintf(f, sprintf('XDelta, %g\n', pf(1)));
                    %fprintf(f, sprintf('YUnit, lin\n'));               % removed tag - Nizar Messaoudi
                    fprintf(f, sprintf('Y\n'));
                    for i = 1:nPts
                        fprintf(f, sprintf('%g,%g\n', real(1/perChannelCorr(i,ch+1)), imag(1/perChannelCorr(i,ch+1))));
                        %fprintf(f, sprintf('%g,%g\n', abs(1/perChannelCorr(i,ch+1)), -angle(perChannelCorr(i,ch+1))));
                        %fprintf(f, sprintf('%g,%g\n', -20*log10(abs(perChannelCorr(i,ch+1))), unwrap(angle(perChannelCorr(i,ch+1))) * -180 / pi));
                    end
                    fclose(f);
                end
            catch ex
                errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
            end
        case 1 % .sNp
            try
                freq = perChannelCorr(:,1);
                sparam = zeros(2*numChan, 2*numChan, size(freq,1));
                for i = 1:numChan
                    tmp = 1./perChannelCorr(:,i+1);
                    sparam(2*i-1,2*i,:) = tmp;
                    sparam(2*i,2*i-1,:) = tmp;
                end
                sp = rfdata.data('Freq', freq, 'S_Parameters', sparam);
                sp.write(fullfile(pathname, filename));
            catch ex
                errordlg({ex.message, [ex.stack(1).name ', line ' num2str(ex.stack(1).line)]});
            end
    end
end


% --- Executes on button press in pushbuttonUseAsDefault.
function pushbuttonUseAsDefault_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonUseAsDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles, 'result') && ~isempty(handles.result))
    recalibrate = get(handles.checkboxReCalibrate, 'Value');
    result = handles.result;
    updatePerChannelCorr(hObject, handles, result.Frequency_MT * 1e9, result.AmplitudeResponse_MT, result.AbsPhaseResponse_MT, recalibrate);
    % if the corr mgmt window is open, update the graphs
    updateCorrWindow();
    % adjust DC offset in AWG if we are not using a differential channel
    iList = get(handles.popupmenuIScope, 'String');
    if (~strncmpi(iList{get(handles.popupmenuIScope, 'Value')}, 'DIFF', 4))
        try
            f = iqopen();
            for ch = 1:length(result.AWGChannels)
                off = str2double(query(f, sprintf(':VOLTage%d:OFFSet?', result.AWGChannels(ch))));
                off = off - result.DCOffset(ch);
                fprintf(f, sprintf(':VOLTage%d:OFFSet %g', result.AWGChannels(ch), off));
            end
            fclose(f);
        catch
        end
    end
else
    msgbox('no valid measurement available');
end


function updateCorrWindow()
% If Correction Mgmt Window is open, refresh it
try
    TempHide = get(0, 'ShowHiddenHandles');
    set(0, 'ShowHiddenHandles', 'on');
    figs = findobj(0, 'Type', 'figure', 'Name', 'Correction Management');
    set(0, 'ShowHiddenHandles', TempHide);
    if (~isempty(figs))
        iqcorrmgmt();
    end
catch
end



function updatePerChannelCorr(hObject, handles, freq, mag, phase, recalibrate)
% update the PerChannel correction file
cplxCorr = (10 .^ (mag/20)) .* exp(1i * phase/180*pi);
% set up perChannelCorr structure
clear perChannelCorr;
perChannelCorr(:,1) = freq(1:end);
perChannelCorr(:,2:size(cplxCorr,2)+1) = 1 ./ cplxCorr;
% get the filename
ampCorrFile = iqampCorrFilename();
clear acs;
if (recalibrate)
    % try to load ampCorr file - be graceful if it does not exist
    try
        acs = load(ampCorrFile);
    catch
        errordlg('existing correction file can not be loaded');
        return;
    end
    % make sure we have the same frequency points and same number of channels
    if (~isequal(perChannelCorr(:,1), acs.perChannelCorr(:,1)) || size(perChannelCorr,2) ~= size(acs.perChannelCorr, 2))
        errordlg('Number of frequency points or number of channels does not match with original calibration');
        return;
    end
    % new correction is the product of old and new
    acs.perChannelCorr(:,2:end) = acs.perChannelCorr(:,2:end) .* perChannelCorr(:,2:end);
    % once additive correction has been applied it must not be added again!
    set(handles.pushbuttonSave, 'Enable', 'off');
    set(handles.pushbuttonUseAsDefault, 'Enable', 'off');
    handles.result = [];
    guidata(hObject, handles);
else
    acs.perChannelCorr = perChannelCorr;
end
% and save
try
    save(ampCorrFile, '-struct', 'acs');
catch ex
    errordlg(sprintf('Can''t save correction file: %s. Please check if it write-protected.', ex.message));
end


% --- Executes on selection change in popupmenuMemory.
function popupmenuMemory_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuMemory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuMemory contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuMemory


% --- Executes during object creation, after setting all properties.
function popupmenuMemory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuMemory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuToneDev.
function popupmenuToneDev_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuToneDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuToneDev contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuToneDev


% --- Executes during object creation, after setting all properties.
function popupmenuToneDev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuToneDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxAWGRST.
function checkboxAWGRST_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAWGRST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAWGRST


% --- Executes on button press in checkboxAutoScopeAmplitude.
function checkboxAutoScopeAmplitude_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAutoScopeAmplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject, 'Value');
if (val)
    set(handles.editAmplitude, 'Enable', 'off');
else
    set(handles.editAmplitude, 'Enable', 'on');
end
% Hint: get(hObject,'Value') returns toggle state of checkboxAutoScopeAmplitude



function editSampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to editSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checkfields(hObject, 0, handles);


% --- Executes during object creation, after setting all properties.
function editSampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxReCalibrate.
function checkboxReCalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxReCalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbuttonSave, 'Enable', 'off');
set(handles.pushbuttonUseAsDefault, 'Enable', 'off');
handles.result = [];
guidata(hObject, handles);


% --- Executes on button press in checkboxRemoveSinc.
function checkboxRemoveSinc_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRemoveSinc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuLoadSettings_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iqloadsettings(handles);


% --------------------------------------------------------------------
function menuSaveSettings_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
iqsavesettings(handles);


% --------------------------------------------------------------------
function menuGenerateCode_Callback(hObject, eventdata, handles)
% hObject    handle to menuGenerateCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
doCalibrate(hObject, handles, 1);
