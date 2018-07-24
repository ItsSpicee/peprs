function M9703A_DDC_Configuration(InstrumentObj, Channel, DownconversionEnabled, DownconversionFrequency)
% Configure the Downconverter
% - Channel - String value to specify the channel for the downconversion 
% configuration. Possible values are Channel1, ...,Channel<n>  where <n> is 
% the number of channel input.
% - DownconversionEnabled - Logical value for Enabling or Disabling 
% Downconversion. 1 for Enabled and 0 for Disabled.
% - DownconversionFrequency - Numeric Value for the Downconversion 
% Frequency in Hz

    Configure(InstrumentObj.DeviceSpecific.Channels3.Item3(Channel).Downconversion,DownconversionEnabled,DownconversionFrequency);
