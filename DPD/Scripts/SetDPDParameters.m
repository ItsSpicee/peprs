%% Set DPD Parameters
switch DPD.Type
    case {'Volterra_DDR'}
        VolterraParameters.ModifiedKernels = false;
        VolterraParameters.ModifiedFile    = 'kernelsML.txt' ;
        VolterraParameters.DDR             = true ;
        VolterraParameters.DDRorder        = 2 ;
        VolterraParameters.Order           = [7 0 5  0  3  0  0  0  0  0   0   ] ;
        VolterraParameters.Static          = 5 ;
        VolterraParameters.Step            = 2 ;
        VolterraParameters.NSupply         = 1 ;
    case 'APD'
        APD_modelParam.N = 8;
        APD_modelParam.M = 11;
        APD_modelParam.FIR_M = 4;
        APD_modelParam.architecture = 'multiply'; % 'add' or 'multiply';
        % Supported Mode MP, H_EMP, Mod_H_EMP, CRV, CRV_Pruned, ECRV, ECRV_Pruned
        APD_modelParam.engine = 'CRV_Pruned';
        APD_modelParam.polyorder = 'odd_aug'; % 'odd' or 'odd_even' or 'odd_aug'
        APD_modelParam.two_step = 0;
    case 'FIR_APD'
        FIR_APD_modelParam.APD_N = 8;
        FIR_APD_modelParam.APD_M = 11;
        FIR_APD_modelParam.FIR_M = 11;
        FIR_APD_modelParam.architecture = 'multiply'; % 'add' or 'multiply';
        % Supported Mode MP, UB_MP, H_EMP, NB_EMP, Deriv_MP, CRV, ECRV
        FIR_APD_modelParam.engine = 'H_EMP';
        FIR_APD_modelParam.polyorder = 'odd_aug'; % 'odd' or 'odd_even' or 'odd_aug'
        FIR_APD_modelParam.two_step = 0;
        FIR_APD_modelParam.use_parallel_FIR = 1;
        FIR_APD_modelParam.use_NL = 0;
    case {'DirectLearning_Volterra'}
        DL_VolterraParameters.ModifiedKernels = false;
        DL_VolterraParameters.ModifiedFile    = 'kernelsML.txt';
        DL_VolterraParameters.DDR             = true;
        DL_VolterraParameters.DDRorder        = 2;
        DL_VolterraParameters.Order           = [7 0 5 0 3 0 0 0 0 0 0];
        DL_VolterraParameters.Static          = 9;
        DL_VolterraParameters.Step            = 1;
        DL_VolterraParameters.NSupply         = 1;
        DL_VolterraParameters.method          = 'RLS';
        DL_VolterraParameters.Init            = false;
    case {'DirectLearning_APD', 'DirectLearning_APD_FW'}
        MStep = 1;
        DL_APD_modelParam.N = 9;
        DL_APD_modelParam.M = 1;
        %Nonlinear memory depth
        DL_APD_modelParam.MNL = 1;
        %Linear memory depth
        DL_APD_modelParam.ML = 1;
        DL_APD_modelParam.FIR_M = 11;
        DL_APD_modelParam.architecture = 'multiply'; % 'add' or 'multiply';
        % Supported Mode MP, H_EMP, Mod_H_EMP, CRV, CRV_Pruned, ECRV, ECRV_Pruned
        DL_APD_modelParam.engine = 'CRV_Pruned';
        DL_APD_modelParam.polyorder = 'odd_aug'; % 'odd' or 'odd_even' or 'odd_aug'
        DL_APD_modelParam.two_step = 0;
        DL_APD_modelParam.method = 'RLS';
        DL_APD_modelParam.Init = false;
    case {'DirectLearning_MagAPD'}
        MStep = 1;
        DL_APD_modelParam.g1.N = 9;
        DL_APD_modelParam.g1.M = 1;
        %Nonlinear memory depth
        DL_APD_modelParam.g1.MNL = 1;
        %Linear memory depth
        DL_APD_modelParam.g1.ML = 1;
        DL_APD_modelParam.g1.FIR_M = 4;
        DL_APD_modelParam.g1.architecture = 'multiply'; % 'add' or 'multiply';
        % Supported Mode MP, H_EMP, Mod_H_EMP, CRV, CRV_Pruned, ECRV, ECRV_Pruned
        DL_APD_modelParam.g1.engine = 'CRV_Pruned';
        DL_APD_modelParam.g1.polyorder = 'odd_aug'; % 'odd' or 'odd_even' or 'odd_aug'
        DL_APD_modelParam.g1.two_step = 0;
        DL_APD_modelParam.g1.method = 'RLS';
        DL_APD_modelParam.g1.Init = false;
                
        %% g2
        DL_APD_modelParam.g2.ActivateIter = 10;
        DL_APD_modelParam.g2.N = 1;
        DL_APD_modelParam.g2.M = 1;
        %Nonlinear memory depth
        DL_APD_modelParam.g2.MNL = 1;
        %Linear memory depth
        DL_APD_modelParam.g2.ML = 11;
        DL_APD_modelParam.g2.FIR_M = 4;
        DL_APD_modelParam.g2.architecture = 'multiply'; % 'add' or 'multiply';
        % Supported Mode MP, H_EMP, Mod_H_EMP, CRV, CRV_Pruned, ECRV, ECRV_Pruned
        DL_APD_modelParam.g2.engine = 'CRV_Pruned';
        DL_APD_modelParam.g2.polyorder = 'odd'; % 'odd' or 'odd_even' or 'odd_aug'
        DL_APD_modelParam.g2.two_step = 0;
        DL_APD_modelParam.g2.method = 'RLS';
        DL_APD_modelParam.g2.Init = false;
    case {'SquareRootBasis'}
        MStep = 1;
        DL_APD_modelParam.g1.RootOrder = 4;
        DL_APD_modelParam.g1.N = 5;
        DL_APD_modelParam.g1.M = 1;
        %Nonlinear memory depth
        DL_APD_modelParam.g1.MNL = 1;
        %Linear memory depth
        DL_APD_modelParam.g1.ML = 1;
        DL_APD_modelParam.g1.FIR_M = 4;
        DL_APD_modelParam.g1.architecture = 'multiply'; % 'add' or 'multiply';
        % Supported Mode MP, H_EMP, Mod_H_EMP, CRV, CRV_Pruned, ECRV, ECRV_Pruned
        DL_APD_modelParam.g1.engine = 'CRV_Pruned';
        DL_APD_modelParam.g1.polyorder = 'odd'; % 'odd' or 'odd_even' or 'odd_aug'
        DL_APD_modelParam.g1.two_step = 0;
        DL_APD_modelParam.g1.method = 'RLS';
        DL_APD_modelParam.g1.sqrtFlag = 1;
        DL_APD_modelParam.g1.Init = false;
        DL_APD_modelParam.g1.learningParameter = 0.09;
        DL_APD_modelParam.g1.retrainIteration = 20;
        
        %% g2
        MStep = 1;
        DL_APD_modelParam.g2.ActivateIter = 2;
        DL_APD_modelParam.g2.RootOrder = 1;
        DL_APD_modelParam.g2.N = 6;
        %Nonlinear memory depth
        DL_APD_modelParam.g2.MNL = 3;
        %Linear memory depth
        DL_APD_modelParam.g2.ML = 8;
        DL_APD_modelParam.g2.M = max(DL_APD_modelParam.g2.MNL, DL_APD_modelParam.g2.ML);
        DL_APD_modelParam.g2.FIR_M = 4;
        DL_APD_modelParam.g2.architecture = 'multiply'; % 'add' or 'multiply';
        % Supported Mode MP, H_EMP, Mod_H_EMP, CRV, CRV_Pruned, ECRV, ECRV_Pruned
        DL_APD_modelParam.g2.engine = 'CRV_Pruned';
        DL_APD_modelParam.g2.polyorder = 'odd_even'; % 'odd' or 'odd_even' or 'odd_aug'
        DL_APD_modelParam.g2.two_step = 0;
        DL_APD_modelParam.g2.method = 'RLS';
        DL_APD_modelParam.g2.sqrtFlag = 0;
        DL_APD_modelParam.g2.Init = false;
        DL_APD_modelParam.g2.learningParameter = 0.4;
        
%         load('FIR_LPF_fs2e9_fpass_0r8e9_Order116');
        DL_APD_modelParam.FilterBasisFlag = 0;
%         DL_APD_modelParam.Num = Num;
%         clear Num;
end

if (isfield(DPD,'MultiplierChainFlag'))
	if DPD.MultiplierChainFlag
		if isfield(DPD,'MultiplierAFile') 
			DPD.MultiplierAModel = load(DPD.MultiplierAFile,'finalCoeff');
			DPD.MultiplierAModel = DPD.MultiplierAModel.finalCoeff;
		end
	end
end