% load('IQ_AWG_in.mat')
% Expansion_Margin = 5.4;
% AWG_M8190A_Reference_Clk('Backplane')
% AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower({AWG_In_signal}, ...
%     {svars.fCarrier},{Fsample_signal},svars.fSampleAWG, ...
%     svars.ampCorr,false,[],Expansion_Margin,PAPR_input,PAPR_original,I_offset,Q_offset);
% AWG_M8195A_DAC_Amplitude(1,svars.dacVFS);
% AWG_M8195A_DAC_Amplitude(2,svars.dacVFS);
% % AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
% AWG_M8190A_MKR_Amplitude(2,0.5);       % Set the trigger amplitude to 1.5 V 
% % AWG_M8190A_MKR_Amplitude(2,0);       % Set the trigger amplitude to 1.5 V 

load('IQ_AWG_in.mat')
Expansion_Margin = 3;
% Expansion_Margin = 5;
% AWG_M8190A_Reference_Clk('Backplane')
t = (0:(length(AWG_In_signal)-1)).' ./ Fsample_signal; % Time vector
TX.I_Offset = 0;
TX_Q_Offset = 0;
directConvFlag = 1;
AWG_In_signal = AWG_In_signal + complex(TX.I_Offset,TX.Q_Offset) .* exp(1i * 4 * pi * TX.LO_OffsetFreq * t);
AWG_M8190A_Reference_Clk(TX.AWG.ReferenceClockSource,TX.AWG.ReferenceClock)
AWG_M8190A_IQSignalUpload_ChannelSelect_FixedAvgPower({AWG_In_signal(1:end)}, ...
    {TX.Fcarrier},{Fsample_signal},TX.AWG.FsampleDAC , ...
    0,false,[],Expansion_Margin,PAPR_input,PAPR_original,TX.I_Offset,TX.Q_Offset,1,0,directConvFlag);
AWG_M8195A_DAC_Amplitude(1,TX.AWG.VFS);
AWG_M8195A_DAC_Amplitude(2,TX.AWG.VFS);
AWG_M8190A_MKR_Amplitude(1,1.5);       % Set the trigger amplitude to 1.5 V 
AWG_M8190A_MKR_Amplitude(2,1.5);       % Set the trigger amplitude to 1.5 V 
% AWG_M8190A_MKR_Amplitude(2,0);       % Set the trigger amplitude to 1.5 V 

% load('AWG_in.mat');
% AWG_M8195A_SignalUpload_ChannelSelect_FixedAvgPower({In_ori},{Fcarrier},{FsampleTx},DAC_SamplingRate,Amp_Corr,false,RF_channel,Expansion_Margin,PAPR_input,PAPR_original);
% AWG_M8190A_Reference_Clk('External', 10e6);
% AWG_M8195A_DAC_Amplitude(1,VFS);
% AWG_M8195A_DAC_Amplitude(4,VFS);

% AWG_M8190A_SignalUpload_ChannelSelect_FixedAvgPower({In_ori},{Fcarrier},{FsampleTx},DAC_SamplingRate,Amp_Corr,false,RF_channel,Expansion_Margin,PAPR_input,PAPR_original);
% AWG_M8190A_Reference_Clk('Backplane');
% AWG_M8190A_DAC_Amplitude(RF_channel,VFS);
% % AWG_M8190A_DAC_Amplitude(RF_channel,0.52);
% %     AWG_M8190A_MKR_Amplitude(RF_channel,1.2);
% AWG_M8190A_MKR_Amplitude(RF_channel,1.5);

clear AWG_In_signal iqdata iqtotaldata