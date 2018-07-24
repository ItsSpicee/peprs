function [Gain]=M9352A_Gain(InstrumentObj, Channel, varargin)
% Configure the Amplifier Gain
% - Channel - String value to specify the channel for the downconversion 
% configuration. Possible values are Channel1, ...,Channel<n>  where <n> is 
% the number of channel input.
% - Gain - The value of the gain. Between 8 and 39.5 in dB.

if length(varargin)==1
     if varargin{1} < 8 || varargin{1} > 39.5
        msgbox('The Gain should be between 8 and 39.5 dB', 'Error');
     else 
        InstrumentObj.DeviceSpecific.Modules.M9352.Channels.Item(Channel).Gain=varargin{1};
     end
end
Gain=InstrumentObj.DeviceSpecific.Modules.M9352.Channels.Item(Channel).Gain;
