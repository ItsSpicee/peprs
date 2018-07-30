function [PD_out, offset] = FIR_APD_Apply(in, modelParam, coefficients)

% Hotfix for Static Engine Type
if(strcmp(modelParam.engine, 'Static'))
    modelParam.engine = 'MP';
    modelParam.APD_M = 1;
end

x = in;
FIR_M = modelParam.FIR_M;
model_APD.N = modelParam.APD_N;
model_APD.M = modelParam.APD_M;
model_APD.architecture = modelParam.architecture;
model_APD.engine = modelParam.engine;
model_APD.polyorder = modelParam.polyorder;
model_APD.two_step = modelParam.two_step;
model_APD.coef = coefficients(FIR_M+1:end);
% FIR is just a N = 0 DPD
model_FIR.M = FIR_M;
model_FIR.N = 0;
model_FIR.architecture = 'multiply';
model_FIR.engine = 'MP';
model_FIR.polyorder = modelParam.polyorder;
model_FIR.two_step = modelParam.two_step;
model_FIR.coef = coefficients(1:FIR_M);

[output_FIR, offset_FIR] = Apply_DPD(x, model_FIR);
[output_APD, offset_APD] = Apply_APD(output_FIR, model_APD);

offset = offset_FIR + offset_APD - 1;

PD_out = output_APD;

end
