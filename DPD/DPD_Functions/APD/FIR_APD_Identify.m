function [coefficients, NMSE] = FIR_APD_Identify(modelParam, PA_in, PA_out, NofDPDPoints)

% Hotfix for Static Engine Type
if(strcmp(modelParam.engine, 'Static'))
    modelParam.engine = 'MP';
    modelParam.APD_M = 1;
end

model_APD.N = modelParam.APD_N;
model_APD.M = modelParam.APD_M;
model_APD.architecture = modelParam.architecture;
model_APD.engine = modelParam.engine;
model_APD.polyorder = modelParam.polyorder;
model_APD.two_step = modelParam.two_step;
model_APD.FIR_M = modelParam.FIR_M;
% FIR is just a N = 0 DPD
model_FIR.M = modelParam.FIR_M;
model_FIR.N = 0;
model_FIR.architecture = 'multiply';
model_FIR.engine = 'MP';
model_FIR.polyorder = modelParam.polyorder;
model_FIR.two_step = modelParam.two_step;

% Interchange input and output to model reverse PA
y_ori = PA_in;
x_ori = PA_out;

[x, y] = Extract_Signal_Peak(x_ori, y_ori, NofDPDPoints);

% Do sth fancy here
if modelParam.use_parallel_FIR
	model_APD.engine = strcat('Mod_',modelParam.engine);
	model_invAPD = model_APD;
	[model_APD.coef] = Model_APD(x, y, model_APD);
	[model_invAPD.coef] = Model_APD(y, x, model_invAPD);
	model_APD.engine = modelParam.engine;
	model_APD.coef = model_APD.coef(1:end-modelParam.FIR_M+1);
	model_invAPD.engine = modelParam.engine;
	model_invAPD.coef = model_invAPD.coef(1:end-modelParam.FIR_M+1);
else
    model_invAPD = model_APD;
	[model_APD.coef] = Model_APD(x, y, model_APD);
	[model_invAPD.coef] = Model_APD(y, x, model_invAPD);
end
[u_out, u_offset] = Apply_APD(y, model_invAPD);
x_in=x(u_offset:end);
[model_FIR.coef] = Model_DPD(x_in, u_out, model_FIR);

coefficients = [model_FIR.coef; model_APD.coef];

% Verification
[output_FIR, offset_FIR] = Apply_DPD(x_ori, model_FIR);
[output_APD, offset_APD] = Apply_APD(output_FIR, model_APD);
x_dis = x_ori(offset_FIR+offset_APD-1:end);
y_dis = y_ori(offset_FIR+offset_APD-1:end);
NMSE = ModelCheck(x_dis, y_dis, output_APD);

disp([' *************************  ']);
disp([' NMSE = ', num2str(NMSE), ' dB' ]);
disp([' *************************  ']);

disp([' *************************  ']);
disp([' No. of coefficients ', num2str(size(coefficients,1)) ]);
disp([' *************************  ']);

end
