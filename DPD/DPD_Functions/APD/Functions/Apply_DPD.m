function [output, offset] = Apply_DPD(input, model)

A = Generate_MemPoly_Matrix(input, model.M, model.N, model.engine, model.polyorder);
if strcmp(model.architecture, 'multiply')
    output = A*model.coef;
elseif strcmp(model.architecture, 'add')
    output = A*model.coef + input(model.M:end);
end
offset = model.M;

end
