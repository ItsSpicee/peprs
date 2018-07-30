function [output, Basis, MaxM] = Generate_MemPoly_Matrix(input, M, N, model, polyorder, Mstep, MNL, ML, varargin)

% Supported Mode MP, H_EMP, Mod_H_EMP, CRV, ECRV, ECRV_Pruned
% Currently not supported UB_MP, NB_EMP, Mod_NB_EMP, Deriv_MP
[Basis, MaxM] = Generate_Basis(M, N, model, polyorder, Mstep, MNL, ML, varargin);

A = ProcessBasis(input, Basis, MaxM);

output = A;

end
