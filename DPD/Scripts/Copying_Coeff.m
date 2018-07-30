DL_APD_modelParam_old = DL_APD_modelParam;
SetDPDParameters;

ACPR_L_old = 0;
ACPR_U_old = 0;
M = DL_APD_modelParam.M;
N = DL_APD_modelParam.N;
ML = DL_APD_modelParam.ML;
engine = DL_APD_modelParam.engine;
polyorder = DL_APD_modelParam.polyorder;
[XM, ~] = Generate_MemPoly_Matrix(zeros(10*M, 1), M, N, engine, polyorder,DL_APD_modelParam.Mstep, MNL, ML);
nb_coef=size(XM,2);
DL_APD_modelParam.coef = zeros(nb_coef,1);
DL_APD_modelParam.coef(1) = 1;
DL_APD_modelParam.Init =     true;


DL_APD_modelParam_old
M = DL_APD_modelParam_old.M;
N = DL_APD_modelParam_old.N;
ML = DL_APD_modelParam_old.ML;
MNL = DL_APD_modelParam_old.MNL;
model = DL_APD_modelParam_old.engine;
polyorder = DL_APD_modelParam_old.polyorder;
coef_sou = DL_APD_modelParam_old.coef;
[basis_sou, MaxM] = Generate_Basis(M, N, engine, polyorder, DL_APD_modelParam.Mstep, MNL, ML);

M = DL_APD_modelParam.M;
N = DL_APD_modelParam.N;
ML = DL_APD_modelParam.ML;
MNL = DL_APD_modelParam.MNL;
model = DL_APD_modelParam.engine;
polyorder = DL_APD_modelParam.polyorder;
[basis_des, MaxM] = Generate_Basis(M, N, model, polyorder, DL_APD_modelParam.Mstep, MNL, ML);
coef_des = zeros(1, length(basis_des));





[ coef_des ] = copy_coefficients( basis_des, basis_sou, coef_sou );


DL_APD_modelParam.coef = coef_des.';
DL_APD_modelParam