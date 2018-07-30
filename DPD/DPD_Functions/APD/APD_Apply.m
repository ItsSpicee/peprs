function [PD_out, offset] = APD_Apply(in, modelParam, Num)

% [norm_xI, norm_xQ] = setMeanPower(in_I, in_Q, 0);
coefficients = modelParam.coef;
x = in;

% Hotfix for Static Engine Type
if(strcmp(modelParam.engine, 'Static'))
    modelParam.engine = 'MP';
    modelParam.M = 1;
end

model = modelParam;
model.coef = coefficients;
switch nargin 
    case 2
        [PD_out, offset] = Apply_APD(x, model);
    case 3
        [PD_out, offset] = Apply_APD(x, model, Num);
end

end
