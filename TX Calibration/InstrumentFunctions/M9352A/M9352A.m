VisaAddressAmp='PXI32::10::0::INSTR';
AmpChannel='Channel1';
GainValue=8;

[InstrumentObj] = M9352A_Configuration(VisaAddressAmp);
[Gain]=M9352A_Gain(InstrumentObj, AmpChannel)


driver.Close