
%% Set Transmitter/Receiver Parameters
PXAAdd                = 18;     % The GPIB address of the PXA
PXA_Atten             = 10;     % The mechanical attenuation in dB for the PXA when dowloading the signal. From 6 to 24 with steps of 2 dB
ESGAdd                = 19;     % The GPIB address of the ESG
DCSource_Add          = 5;      % GPIB address for the DC power source - N6705B
PowerMeter_Add        = 13;     % GPIB address for the power meter
E4438C_VisaAddress    = ['GPIB0::' num2str(ESGAdd) '::INSTR'];    % Creates the Visa address of the ESG - 'GPIB0::19::INSTR'
WaveformName          = 'WCDMA4C';     % The waveform name - Only used when uploading signal to ESG

DAC_SamplingRate            = 8e9;      % The sampling rate of the AWG - The input I/Q files with sampling rate of FsampleTx will be upsampled to this number. DAC_SamplingRate has to be an integer multiple of FsampleTx
% DAC_SamplingRate            = 7.5e9;
DDC_SamplingFrequency       = 250e6;    % The sampling rate of the Digitzer when in downconversion mode
UXA_Address                 = '0x2A8D::0x1D0B::MY56080250::0'; % UXA USB Address
UXA_Atten                   = 0;        % UXA mechanical attenuator setting in dB
UXA_ClockRefSource          = 'INTernal'; % Utilize the internal / external reference of the UXA
UXA_IFAnalysisBandwidth     = 160e6;

% Scope Parameters
Scope_Driver = [];
MSO_Address = 'USB0::0x0957::0x9001::MY48240314::0::INSTR';
scopeRefClock = 'OFF';
%MSO_SamplingFrequency = 1.998e9;
MSO_SamplingFrequency = 2e9;

if (IQmod_flag)
    RF_channel                  = [];       % AWG channel 1 set to I and AWG channel 2 is set to Q
else
    RF_channel                  = 1;        % AWG channel used for sending RF signal - Not used in 'ESG' mode    
end
VFS                         = 0.7;      % Full scale voltage of the AWG. 0.1 < VFS < 0.7;
Fs                          = FsampleRx;

external_clock_enable       = 0;        % 1 if the ADC is driven by an external sampling clock.


if Measure_Pout_Eff
    % ATN             = Attenuator('Atten300W_Coupler.s2p');
    ATN             = Attenuator('Atten300W_Coupler_0r5to10GHz_Apr2015.s2p');
    PM_obj          = PowerMeter_N1911A(PowerMeter_Add);
    PM_obj.connect;
    PM_obj.frequency(Fcarrier);
    PM_obj.offset(ATN.attenuation(Fcarrier));
    fprintf('Attenuation at %g Hz is %g dB\n', Fcarrier, ATN.attenuation(Fcarrier));
    if DoCalibration
        PM_obj.zero_and_cal;
    end
end
if strcmp(Transmitter_type,'AWG')
    [DownSampleTx, UpSampleTx] = rat(FsampleTx/FsampleRx/SubRate);
    %[DownSampleTx, UpSampleTx] = rat(FsampleTx/FsampleRx);
    if (IQmod_flag)
        I_Offset = 0;
        Q_Offset = 0;
    end
elseif strcmp(Transmitter_type,'ESG')
    if FsampleTx > 100e6
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        disp(' Warning... ESG maximum sampling rate is 100 MHz. Value of 100 MHz will be used for the measurements');
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        FsampleTx = 100e6;
    end
    [DownSampleTx, UpSampleTx] = rat(FsampleTx/FsampleTx);
end
if strcmp(Receiver_type,'Digitizer')
%     [DownSampleRx, UpSampleRx] = rat(FsampleRx/DDC_SamplingFrequency);
%     [DownSampleDigitizer, UpSampleDigitizer] = rat(FsampleRx/(Digitizer_SamplingFrequency)); % the factor of 2 is added since the digitizer sampling frequensy is real sampling not complex
elseif strcmp(Receiver_type,'PXA')
    if FsampleRx > 160e6
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        disp(' Warning... PXA maximum sampling rate is 160 MHz. Value of 160 MHz will be used for the measurements');
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        FsampleRx = 160e6;
    end
    [DownSampleRx, UpSampleRx] = rat(FsampleRx/FsampleRx);
elseif strcmp(Receiver_type,'Scope')
   [DownSampleRx, UpSampleRx] = rat(FsampleRx/MSO_SamplingFrequency);
   [DownSampleDigitizer, UpSampleDigitizer] = rat(FsampleRx/(Digitizer_SamplingFrequency)); % the factor of 2 is added since the digitizer sampling frequensy is real sampling not complex
elseif strcmp(Receiver_type,'UXA')
%    [DownSampleUXA, UpSampleUXA] = rat(FsampleRx/(UXA_IFAnalysisBandwidth));
end
% if ( strcmp(Receiver_type,'Digitizer') || strcmp(Transmitter_type,'AWG') )
%     % Digitizer Parameters Definition
%     M9703A_VisaAddress='PXI0::10-0.0::INSTR';
%     ReferenceSource='AgMD1ReferenceOscillatorSourceAXI';
%     %     ReferenceSource='AgMD1ReferenceOscillatorSourceExternal';
%     TriggerSource='External1';
%     TriggerLevel=0.2;
%     Channel1='Channel3';
%     Channel2='Channel4';        % only used in the interleaivng mode.
%     DownconversionEnabled =0;   % choose between 0 (Digitizer) and 1 (DDC)
%     DownconversionMode    =0;   % choose between 0 (no Downconversion), 1 (Single DownConversion) and 2 (Dual DownConversion)
%     PointsPerRecord=floor(FramTime*Digitizer_SamplingFrequency) + 1; %189888;
%     FullScaleRange=2;
%     ACDCCoupling=1;
%     % Amplifier Parameters Definition
%     M9352A_VisaAddress      ='PXI0::27-10.0::INSTR';
%     AmpChannel='Channel3';
%     load FIR_filter_fs_1r0GHz_fpass_0r247GHz_Order2037
    load FIR_filter_fs_2r0GHzfpass_0r495GHz_Order2037
%     load FIR_filter_fs_0r5GHz_fpass_0r123GHz_Order1358
    FIR_filter_num = Num;
%     M9352A_Gain_value = 16; % Max: 39.5, Min: 8
% end
% if strcmp(Receiver_type,'Digitizer')
%     % LO Generator Parameters Definition
%     % E4438C_VisaAddress='GPIB0::19::INSTR'; %'GPIB0::19::INSTR'
%     E4433B_Add = 17;
%     E4433B_VisaAddress=['GPIB0::' num2str(E4433B_Add) '::INSTR']; %'GPIB0::17::INSTR'
%     % 380e6 for 850MHz, 390e6 for 750MHz
%     %IF_Frequency=250.0e6; %250e6;
%     IF2_Frequency=2.0e9; %250e6;
%     % LO_Frequency2=Fcarrier2-IF_Frequency;
%     if (DownconversionMode == 2)
%         LO_Frequency1=IF2_Frequency-IF_Frequency;
%         LO_Frequency2=Fcarrier+IF2_Frequency;
%     elseif (DownconversionMode == 1)
%         LO_Frequency1=Fcarrier+IF_Frequency;
%     elseif (DownconversionMode == 0)
%         % Do nothing
%     end
% end
% if strcmp(Receiver_type,'Digitizer')
%     [M9703A_Obj] = M9703A_Configuration_bel(M9703A_VisaAddress, ReferenceSource, TriggerSource, TriggerLevel, DoCalibration,...
%         external_clock_enable, Digitizer_SamplingFrequency);
%     % caibrate the ADC channels
%     if DoCalibration == 1
%         M9703A_DDC_Configuration(M9703A_Obj, Channel1, 0, 0);
%         M9703A_DDC_Configuration(M9703A_Obj, Channel2, 0, 0);
%     end
%     [M9352A_Obj] = M9352A_Configuration(M9352A_VisaAddress);
% elseif strcmp(Receiver_type,'Scope')
% %     Connect_to_Scope
% end

% If the UXA is used as a downconverter for the scope, then setup the UXA
if (UXA_Downconversion_flag)
    UXA_Downconversion_Mode_Setup (UXA_Downcversion_RF_Freq, UXA_IFAnalysisBandwidth, ...
        FramTime, UXA_Address, UXA_Atten, UXA_ClockRefSource)
end