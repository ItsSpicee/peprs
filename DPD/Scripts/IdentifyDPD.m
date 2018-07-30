% DPD Identification and Validation
switch DPD.Type
    case 'Volterra_DDR'
        VolterraParameters.NSupply = 1 ;
        DelayAdjusted_Vdd = abs(In_D);
        [VolterraETParameters,VolterraCoeff,VolterraOutput,StaticOutput,NMSE] = VolterraDpdIdentification_ET(In_D,Out_D,circshift(DelayAdjusted_Vdd,0),VolterraParameters,DPD.NofDPDPoints,true);
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(VolterraCoeff);
        num_of_coeff = size(VolterraCoeff,1);
    case 'APD'
        [APD_coef, NMSE] = APD_Identify(APD_modelParam,In_D,Out_D,DPD.NofDPDPoints);
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(APD_coef);
    case 'FIR_APD'
        [FIR_APD_coef, NMSE] = FIR_APD_Identify(FIR_APD_modelParam,In_D,Out_D,DPD.NofDPDPoints);
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(FIR_APD_coef);
        if FIR_APD_modelParam.use_NL == 1
            NonlinearID_In = In_D;
            NonlinearID_Out = Out_D;
        end
    case 'DirectLearning_Volterra'
		[DL_VolterraParameters, NMSE] = DL_Volterra_Identify(DL_VolterraParameters,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate);
		DL_Volterra_coef = DL_VolterraParameters.coef;
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_Volterra_coef);
        num_of_coeff = size(DL_Volterra_coef,1);
	case 'DirectLearning_APD'
        [DL_APD_modelParam, NMSE] = DL_APD_Identify(DL_APD_modelParam,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate);
%         [DL_APD_modelParam, NMSE] = DL_APD_Identify(DL_APD_modelParam,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate, DL_APD_modelParam.Num);
%         [ DL_APD_modelParam ] = IdentifyBBEVDCoeff(DL_APD_modelParam, In_D_EVM,Out_D_EVM, Basis,DPD.NofDPDPoints);
        DL_APD_coef = DL_APD_modelParam.coef;
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef);
    case 'DirectLearning_MagAPD'
        if IterationCount < DL_APD_modelParam.g2.ActivateIter
            [DL_APD_modelParam.g1, NMSE] = DL_APD_Identify(DL_APD_modelParam.g1,abs(In_D_EVM),abs(Out_D_EVM),DPD.NofDPDPoints,RX.SubRate);
%         [DL_APD_modelParam, NMSE] = DL_APD_Identify(DL_APD_modelParam,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate, DL_APD_modelParam.Num);
%         [ DL_APD_modelParam ] = IdentifyBBEVDCoeff(DL_APD_modelParam, In_D_EVM,Out_D_EVM, Basis,DPD.NofDPDPoints);
            DL_APD_coef = DL_APD_modelParam.g1.coef;
            [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef);
        else
           [DL_APD_modelParam.g2, NMSE] = DL_APD_Identify(DL_APD_modelParam.g2,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate);
           DL_APD_coef = DL_APD_modelParam.g2.coef;
        end
    case 'DirectLearning_APD_FW'
        [DL_APD_modelParam, NMSE] = DL_APD_Identify_FW(DL_APD_modelParam,In_D,Out_D,DPD.NofDPDPoints,RX.SubRate);
		DL_APD_coef = DL_APD_modelParam.coef;
        [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef);
    case 'test'
        [DL_APD_modelParam, NMSE] = DL_APD_Identify_test(DL_APD_modelParam,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate);
% 		DL_APD_coef = DL_APD_modelParam.coef;
%         [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef);
    case 'SquareRootBasis'        
        if IterationCount < DL_APD_modelParam.g2.ActivateIter
            if DL_APD_modelParam.FilterBasisFlag
                [DL_APD_modelParam.g1, NMSE] = DL_APD_Identify_SqrtBasis(DL_APD_modelParam.g1,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate,IterationCount,DL_APD_modelParam.Num);
            else
                [DL_APD_modelParam.g1, NMSE] = DL_APD_Identify_SqrtBasis(DL_APD_modelParam.g1,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate,IterationCount);
            end 
            DL_APD_coef.g1 = DL_APD_modelParam.g1.coef;
            [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef.g1);
        else
            if IterationCount ~= DL_APD_modelParam.g1.retrainIteration
                if DL_APD_modelParam.FilterBasisFlag
                    [DL_APD_modelParam.g2, NMSE] = DL_APD_Identify_SqrtBasis(DL_APD_modelParam.g2,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate,IterationCount,DL_APD_modelParam.Num);
                else
                    [DL_APD_modelParam.g2, NMSE] = DL_APD_Identify_SqrtBasis(DL_APD_modelParam.g2,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate,IterationCount);
                end
                DL_APD_coef.g2 = DL_APD_modelParam.g2.coef;
                [Coeff_DR, Coeff_DR_real, Coeff_DR_imag] = CheckDR(DL_APD_coef.g2);
            else
                if DL_APD_modelParam.FilterBasisFlag
                    [DL_APD_modelParam.g1, NMSE] = DL_APD_Identify_SqrtBasis(DL_APD_modelParam.g1,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate,IterationCount,DL_APD_modelParam.Num);
                else
                    [DL_APD_modelParam.g1, NMSE] = DL_APD_Identify_SqrtBasis(DL_APD_modelParam.g1,In_D_EVM,Out_D_EVM,DPD.NofDPDPoints,RX.SubRate,IterationCount);
                end
                DL_APD_coef.g1 = DL_APD_modelParam.g1.coef;
            end
        end
            
end