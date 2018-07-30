ACPR_L_old = 0; 
ACPR_U_old = 0;

M = DL_APD_modelParam.g1.M;
N = DL_APD_modelParam.g1.N;
MNL = DL_APD_modelParam.g1.MNL;
ML = DL_APD_modelParam.g1.ML;
DL_APD_modelParam.g1.Mstep = MStep;
engine = DL_APD_modelParam.g1.engine;
polyorder = DL_APD_modelParam.g1.polyorder;


[XM, g1.Basis, ~] = Generate_MemPoly_Matrix(zeros(10*M, 1), M, N, engine, polyorder,DL_APD_modelParam.g1.Mstep, MNL, ML);
%%
nb_coef=size(XM,2);
DL_APD_modelParam.g1.coef    = zeros(nb_coef,1);
DL_APD_modelParam.g1.coef(1) = 1;
DL_APD_modelParam.g1.Init    =     true;

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
disp(['    - Adaptive Algorithm       = ' DL_APD_modelParam.g1.method]);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

%% g2
ACPR_L_old = 0; 
ACPR_U_old = 0;

M = DL_APD_modelParam.g2.M;
N = DL_APD_modelParam.g2.N;
MNL = DL_APD_modelParam.g2.MNL;
ML = DL_APD_modelParam.g2.ML;
DL_APD_modelParam.g2.Mstep = MStep;
engine = DL_APD_modelParam.g2.engine;
polyorder = DL_APD_modelParam.g2.polyorder;


[XM, g2.Basis, ~] = Generate_MemPoly_Matrix(zeros(10*M, 1), M, N, engine, polyorder,DL_APD_modelParam.g2.Mstep, MNL, ML);

%%
nb_coef=size(XM,2);
DL_APD_modelParam.g2.coef    = zeros(nb_coef,1);
DL_APD_modelParam.g2.coef(1) = 1;
DL_APD_modelParam.g2.Init    =     true;

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
disp(['    - Adaptive Algorithm       = ' DL_APD_modelParam.g2.method]);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');