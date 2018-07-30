M9352A_VisaAddress      ='PXI0::27-10.0::INSTR';
[M9352A_Obj]            = M9352A_Configuration(M9352A_VisaAddress);
AmpChannel              ='Channel3';
IF_Amp_Gain             = 8;
M9352A_Gain(M9352A_Obj, AmpChannel, IF_Amp_Gain);