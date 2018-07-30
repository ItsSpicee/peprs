function [modelParam, NMSE] = DL_APD_Identify_FW(modelParam, PA_in, PA_out, NofDPDPoints, SubRate)
% Impletement APD identification using direct learning with forward modelling of
% the PA, then build training data using PA forward model and train APD
[xp_dltr, yp_dltr, ~, ~] = Extract_Signal_Peak(PA_in, PA_out, NofDPDPoints, SubRate);
PA_model = modelParam;
method = PA_model.method;
M = PA_model.M;
N = PA_model.N;
engine = PA_model.engine;
polyorder = PA_model.polyorder;
g = 0.5; % update weight factor

[XM, ~] = Generate_MemPoly_Matrix(xp_dltr, M, N, engine, polyorder);
o_s = max(floor(M / SubRate),1);
% if ~PA_model.Init
    % Just set coefficients to [1 0 0 0 ... ]
    nb_coef=size(XM,2);
    PA_model.coef = zeros(nb_coef,1);
    PA_model.coef(1) = 1;
    PA_model.Init = true;
% end

% Train PA forward model with subrate sample
switch method
    case 'LSE'
        xp_dltr = xp_dltr(o_s*SubRate+1:end);
        yp_dltr = yp_dltr(o_s+1:end);
        if SubRate > 1
            xp_dltr  = xp_dltr(SubRate:SubRate:end);
            XM    = XM(SubRate:SubRate:end,:);
        end
        XT = XM';
        PA_model.coef = pinv(XT*XM)*(XT*yp_dltr);
    case 'RLS'
        P = 1e8 * eye(length(PA_model.coef));
        xp_update = xp_dltr(o_s*SubRate+1);
        for n = o_s:length(yp_dltr)-1
            UM = XM(n*SubRate-M+2,:);
            Num = P * UM';
            Den = 1 + UM * P * UM';
            P = (eye(length(PA_model.coef)) - Num / Den * UM) * P;
            e = yp_dltr(n+1) - xp_update;
            PA_model.coef = PA_model.coef + Num / Den * e * g;
            if n < length(yp_dltr)-2
                xp_update = XM((n+1)*SubRate-M+2,:) * PA_model.coef;
            end
        end
    otherwise
        error('Method not recognized');
end

clear XM XT
% Train DPD coefficient with fullrate output using PA forward model
[PA_out_FR, FR_os] = Apply_APD(xp_dltr, PA_model);
APD_OUT = xp_dltr(FR_os:end);
% modelParam.coef = Model_APD(PA_out_FR, APD_OUT, modelParam);
[XM, ~] = Generate_MemPoly_Matrix(PA_out_FR, M, N, engine, polyorder);
o_s = max(floor(M / SubRate),1);
% if ~PA_model.Init
    % Just set coefficients to [1 0 0 0 ... ]
    nb_coef=size(XM,2);
    modelParam.coef = zeros(nb_coef,1);
    modelParam.coef(1) = 1;
    modelParam.Init = true;
% end
switch method
    case 'LSE'
        PA_out_FR = PA_out_FR(o_s*SubRate+1:end);
        APD_OUT = APD_OUT(o_s+1:end);
        if SubRate > 1
            PA_out_FR  = PA_out_FR(SubRate:SubRate:end);
            XM    = XM(SubRate:SubRate:end,:);
        end
        XT = XM';
        modelParam.coef = pinv(XT*XM)*(XT*APD_OUT);
    case 'RLS'
        P = 1e8 * eye(length(modelParam.coef));
        xp_update = PA_out_FR(o_s*SubRate+1);
        for n = o_s:length(APD_OUT)-1
            UM = XM(n*SubRate-M+2,:);
            Num = P * UM';
            Den = 1 + UM * P * UM';
            P = (eye(length(modelParam.coef)) - Num / Den * UM) * P;
            e = APD_OUT(n+1) - xp_update;
            modelParam.coef = modelParam.coef + Num / Den * e * g;
            if n < length(APD_OUT)-2
                xp_update = XM((n+1)*SubRate-M+2,:) * modelParam.coef;
            end
        end
    otherwise
        error('Method not recognized');
end
clear XM XT

% Verification
[PA_out_FR, FR_os] = Apply_APD(PA_in, PA_model);

% Only work with Full Rate
NMSE = ModelCheck(PA_in(FR_os:end), PA_out(FR_os:end), PA_out_FR);
disp([' NMSE1 = ', num2str(NMSE), ' dB' ]);

[APD_est_o, APD_est_os] = Apply_APD(PA_out_FR, modelParam);
APD_i = PA_out_FR(APD_est_os:end);
APD_o = PA_in(FR_os+APD_est_os-1:end);
NMSE = ModelCheck(APD_i, APD_o, APD_est_o);

disp([' *************************  ']);
disp([' NMSE2 = ', num2str(NMSE), ' dB' ]);
disp([' *************************  ']);

disp([' *************************  ']);
disp([' No. of coefficients ', num2str(size(modelParam.coef,1)) ]);
disp([' *************************  ']);

end
