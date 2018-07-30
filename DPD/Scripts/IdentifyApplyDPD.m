% DPD Identification and Validation
switch DPD_type
    case 'Volterra_DDR'
        DPD = true ;
        VolterraParameters.NSupply = 1 ;
        DelayAdjusted_Vdd = abs(In_D);
        [VolterraETParameters,VolterraCoeff,VolterraOutput,StaticOutput,NMSE] = VolterraDpdIdentification_ET(In_D,Out_D,circshift(DelayAdjusted_Vdd,0),VolterraParameters,NofDPDPoints,DPD);
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(VolterraCoeff);
        num_of_coeff = size(VolterraCoeff,1);
    case 'APD'
        [APD_coef, NMSE] = APD_Identify(APD_modelParam,In_D,Out_D,NofDPDPoints);
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(APD_coef);
    case 'FIR_APD'
        [FIR_APD_coef, NMSE] = FIR_APD_Identify(FIR_APD_modelParam,In_D,Out_D,NofDPDPoints);
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(FIR_APD_coef);
        if FIR_APD_modelParam.use_NL == 1
            NonlinearID_In = In_D;
            NonlinearID_Out = Out_D;
        end
    case 'DirectLearning_Volterra'
		[DL_VolterraParameters, NMSE] = DL_Volterra_Identify(DL_VolterraParameters,In_D_EVM,Out_D_EVM,NofDPDPoints,SubRate);
		DL_Volterra_coef = DL_VolterraParameters.coef;
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_Volterra_coef);
        num_of_coeff = size(DL_Volterra_coef,1);
	case 'DirectLearning_APD'
		[DL_APD_modelParam, NMSE] = DL_APD_Identify(DL_APD_modelParam,In_D_EVM,Out_D_EVM,NofDPDPoints,SubRate);
        DL_APD_coef = DL_APD_modelParam.coef;
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef);
    case 'DirectLearning_APD_FW'
        [DL_APD_modelParam, NMSE] = DL_APD_Identify_FW(DL_APD_modelParam,In_D,Out_D,NofDPDPoints,SubRate);
		DL_APD_coef = DL_APD_modelParam.coef;
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef);
end
% Apply DPD
switch DPD_type
    case 'Volterra_DDR'
        Pr = VolterraDpdApply_ET(In_ori_EVM, abs(In_ori_EVM), VolterraETParameters, VolterraCoeff);
    case 'APD'
        Pr = APD_Apply(In_ori_EVM, APD_modelParam, APD_coef);
    case 'FIR_APD'
        Pr = FIR_APD_Apply(In_ori_EVM, FIR_APD_modelParam, FIR_APD_coef);
    case 'DirectLearning_Volterra'
        Pr = VolterraDpdApply_ET(In_ori_EVM, abs(In_ori_EVM), DL_VolterraParameters, DL_Volterra_coef);
    case {'DirectLearning_APD', 'DirectLearning_APD_FW'}
        Pr = APD_Apply(In_ori_EVM, DL_APD_modelParam);
end
memTrunc = length(In_ori_EVM) - length(Pr);
Pr = resample(Pr,DownSampleTx,UpSampleTx);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Predistorted Signal']);
CheckPower(Pr, 1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');