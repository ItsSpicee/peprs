function [ model_EMP] = ConvertToEMP( model_MP )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~strcmp(model_MP.engine, 'MP')
    error('Not an MP');
end
M = model_MP.M;
N = model_MP.N;
coef_MP = model_MP.coef;

coefs = zeros(1+M*N,1);
idx = 1;
for i = 1:(M*(N+1))
    first_coef = 0;
    if mod(i,N+1) == 1
        first_coef = first_coef + coef_MP(i);
    else
        idx = idx + 1;
        coefs(idx) = coef_MP(i);
    end
end
coefs(1) = first_coef;

model_EMP = model_MP;
model_EMP.engine = 'H_EMP';
model_EMP.coef = coefs;

end
