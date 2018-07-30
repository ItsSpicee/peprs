function [output, offset] = Apply_Basis(input, model)

if length(model.engine)>=4 && strcmp(model.engine(1:4), 'Mod_')
	offset = max(model.M, model.FIR_M);
else
	offset = model.M;
end
A = ProcessBasis(input, model.Basis, offset);
if strcmp(model.architecture, 'multiply')
	output = A*model.coef;
elseif strcmp(model.architecture, 'add')
	output = A*model.coef + input(offset:end);
end

end
