ACPR_L_old = 0; 
ACPR_U_old = 0;

switch DPD.Type
    case {'SquareRootBasis', 'DirectLearning_MagAPD'}
        DL_APD_modelParam.g1 = PrintDPDArchitectureSummary(DPD, DL_APD_modelParam.g1, MStep);
        DL_APD_modelParam.g2 = PrintDPDArchitectureSummary(DPD, DL_APD_modelParam.g2, MStep);
    otherwise
        M = DL_APD_modelParam.M;
        N = DL_APD_modelParam.N;
        MNL = DL_APD_modelParam.MNL;
        ML = DL_APD_modelParam.ML;
        DL_APD_modelParam.Mstep = MStep;
        engine = DL_APD_modelParam.engine;
        polyorder = DL_APD_modelParam.polyorder;
        
        [XM, Basis, ~] = Generate_MemPoly_Matrix(zeros(10*M, 1), M, N, engine, polyorder,DL_APD_modelParam.Mstep, MNL, ML);
        %% Test BB DPD
        % DL_APD_modelParam.M = 1;
        % basisOpt.linearMemoryDepth = 1;
        % basisOpt.dynamicFlag = 0;
        % basisOpt.linearAugFlag = 1;
        % basisOpt.evenOddAugFlag = 1;
        % DL_APD_modelParam.MaxM = max(basisOpt.linearMemoryDepth, DL_APD_modelParam.M);
        % %         bbeM = [DL_APD_modelParam.M, DL_APD_modelParam.M, 0, 0, 0]
        % [Basis] = GenerateBBEVBasis(DL_APD_modelParam.N,DL_APD_modelParam.M,basisOpt);
        % XM = ProcessBasis(zeros(10*M, 1), Basis, DL_APD_modelParam.MaxM);

        %%
        nb_coef=size(XM,2);
        DL_APD_modelParam.coef    = zeros(nb_coef,1);
        DL_APD_modelParam.coef(1) = 1;
        DL_APD_modelParam.Init    =     true;

        %SetDPDParameters
        %Copying_Coeff
        % Get basis information
        % a = zeros(length(Basis), 3);
        % for basisIdx = 1:length(Basis)
        %     a(basisIdx, 1) = Basis(basisIdx).P.M;
        %     a(basisIdx, 2) = Basis(basisIdx).P.N;
        %     a(basisIdx, 3) = Basis(basisIdx).P.K;
        % end

        clear XM

        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        disp(' DPD Model Summary ');
        disp(['    - Model Type               = ', engine]);
        disp(['    - Polynomial Order         = ', polyorder]);
        disp(['    - Memory Depth             = ' num2str(M)]);
        disp(['    - Memory Step              = ' num2str(MStep)]);
        disp(['    - Nonlinearity Order       = ' num2str(N)]);
        disp(['    - Nonlinear Memory Depth   = ' num2str(MNL)]);
        disp(['    - Number of Coefficients   = ' num2str(nb_coef)]);
        disp(['    - DPD Training Signal Size = ' num2str(DPD.NofDPDPoints)]);
        disp(['    - Adaptive Algorithm       = ' DL_APD_modelParam.method]);
        disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end