function init(obj)
% This function is called after the object is connected.
% OBJ is the device object.
% End of function definition - DO NOT EDIT

% NOTE: This code is required to support driver interfaces that are collections.
%       Deleting or altering this code may prevent device objects using this
%       driver from operating correctly.

comobj = get(obj, 'Interface');

warning off backtrace
try
	collection = comobj;
	collection = get(collection, 'Channels2');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Channels2');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2filter');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2measurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2multirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2digitaldownconversion');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2counter');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2filter');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2measurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2multirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2digitaldownconversion');

try
	collection = comobj;
	collection = get(collection, 'Channels');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Channels');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channelfilter');

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channelmeasurement');

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channelmultirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channeldigitaldownconversion');

try
	collection = comobj;
	collection = get(collection, 'Channels3');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Channels3');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3counter');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3filter');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3measurement');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3multirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3digitaldownconversion');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3downconversion');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3counter');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3filter');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3measurement');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3multirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels3' , 'Channel3digitaldownconversion');

try
	collection = comobj;
	collection = get(collection, 'LogicDevices');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Logicdevices');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

try
	collection = comobj;
	collection = get(collection, 'Channels2');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Channels2');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2filter');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2measurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2multirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2digitaldownconversion');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2counter');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2filter');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2measurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2multirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels2' , 'Channel2digitaldownconversion');

try
	collection = comobj;
	collection = get(collection, 'Channels');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Channels');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channelfilter');

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channelmeasurement');

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channelmultirecordmeasurement');

collection = comobj;
collection = get(collection, 'Channels');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Channels' , 'Channeldigitaldownconversion');

try
	collection = comobj;
	collection = get(collection, 'Trigger2');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger2sources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourceedge');

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourcetv');

try
	collection = comobj;
	collection = get(collection, 'Trigger2');
	collection = get(collection, 'Sources2');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger2sources2');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2edge');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2tv');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2magnitude');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2edge');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2tv');

try
	collection = comobj;
	collection = get(collection, 'Trigger2');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger2sources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourceedge');

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourcetv');

try
	collection = comobj;
	collection = get(collection, 'Trigger');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Triggersources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'TriggerSources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'TriggerSources' , 'TriggerSourceedge');

collection = comobj;
collection = get(collection, 'TriggerSources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'TriggerSources' , 'TriggerSourcetv');

try
	collection = comobj;
	collection = get(collection, 'Trigger3');
	collection = get(collection, 'Sources2');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger3sources2');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2edge');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2tv');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2magnitude');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2edge');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2tv');

try
	collection = comobj;
	collection = get(collection, 'Trigger3');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger3sources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger3Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources' , 'Trigger3Sourceedge');

collection = comobj;
collection = get(collection, 'Trigger3Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources' , 'Trigger3Sourcetv');

try
	collection = comobj;
	collection = get(collection, 'Trigger3');
	collection = get(collection, 'Sources3');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger3sources3');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger3Sources3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources3' , 'Trigger3Source3magnitude');

collection = comobj;
collection = get(collection, 'Trigger3Sources3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources3' , 'Trigger3Source3edge');

collection = comobj;
collection = get(collection, 'Trigger3Sources3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources3' , 'Trigger3Source3tv');

collection = comobj;
collection = get(collection, 'Trigger3Sources3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources3' , 'Trigger3Source3magnitude2');

collection = comobj;
collection = get(collection, 'Trigger3Sources3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources3' , 'Trigger3Source3magnitude');

collection = comobj;
collection = get(collection, 'Trigger3Sources3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources3' , 'Trigger3Source3edge');

collection = comobj;
collection = get(collection, 'Trigger3Sources3');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources3' , 'Trigger3Source3tv');

try
	collection = comobj;
	collection = get(collection, 'Trigger3');
	collection = get(collection, 'Sources2');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger3sources2');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2edge');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2tv');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2magnitude');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2edge');

collection = comobj;
collection = get(collection, 'Trigger3Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources2' , 'Trigger3Source2tv');

try
	collection = comobj;
	collection = get(collection, 'Trigger3');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger3sources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger3Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources' , 'Trigger3Sourceedge');

collection = comobj;
collection = get(collection, 'Trigger3Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger3Sources' , 'Trigger3Sourcetv');

try
	collection = comobj;
	collection = get(collection, 'Calibration2');
	collection = get(collection, 'DelayControls');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Calibration2delaycontrols');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

try
	collection = comobj;
	collection = get(collection, 'Trigger2');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger2sources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourceedge');

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourcetv');

try
	collection = comobj;
	collection = get(collection, 'Trigger2');
	collection = get(collection, 'Sources2');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger2sources2');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2edge');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2tv');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2magnitude');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2edge');

collection = comobj;
collection = get(collection, 'Trigger2Sources2');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources2' , 'Trigger2Source2tv');

try
	collection = comobj;
	collection = get(collection, 'Trigger2');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Trigger2sources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourceedge');

collection = comobj;
collection = get(collection, 'Trigger2Sources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'Trigger2Sources' , 'Trigger2Sourcetv');

try
	collection = comobj;
	collection = get(collection, 'Trigger');
	collection = get(collection, 'Sources');
	instrgate('privateIviComDriverHelper', 'group', obj, collection, 'Triggersources');
catch e
	errorMsg = instrgate('privateCOMGetErrorInfo');
	warning('%s',errorMsg.Description);
end

collection = comobj;
collection = get(collection, 'TriggerSources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'TriggerSources' , 'TriggerSourceedge');

collection = comobj;
collection = get(collection, 'TriggerSources');
instrgate('privateIviComDriverHelper', 'nestedgroup', obj, collection, 'TriggerSources' , 'TriggerSourcetv');

warning on backtrace
