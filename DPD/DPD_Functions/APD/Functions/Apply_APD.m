function [output, offset] = Apply_APD(input, model, Num)

if length(model.engine)>=4 && strcmp(model.engine(1:4), 'Mod_')
	A = Generate_MemPoly_Matrix(input, model.M, model.N, model.engine, model.polyorder, model.Mstep, model.FIR_M);
	offset = max(model.M, model.FIR_M);
else
	A = Generate_MemPoly_Matrix(input, model.M, model.N, model.engine, model.polyorder, model.Mstep, model.MNL, model.ML);
	offset = model.M;
end

if nargin == 3 
%     A = filter(Num, [1 0], A, [], 1);
    basisPower = zeros(size(A,2));
    for i = 1:size(A,2)
        [basisPower(i), ~, ~] = CheckPower(A(:,i),0);
    end
    A = filter(Num, 1, A, [], 1);
    for i = 1:size(A,2)
        A(:,i) = SetMeanPower(A(:,i),basisPower(i));
    end
end

if strcmp(model.architecture, 'multiply')
	output = A*model.coef;
elseif strcmp(model.architecture, 'add')
	output = A*model.coef + input(offset:end);
end

end
