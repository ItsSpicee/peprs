function [modelParam, NMSE] = DL_Volterra_Identify(modelParam, In_Ori, PA_out, NofDPDPoints, SubRate)
% Impletement Volterra_DDR identification using direct learning
[x_dltr, yp_dltr, ~, ~] = Extract_Signal_Peak(In_Ori, PA_out, NofDPDPoints,SubRate);
method = modelParam.method;
M = max(modelParam.Order) + 1;
g = 1; % update weight factor

[XM, modelParam] = VolterraDpd_GenerateMatrix(x_dltr, abs(x_dltr), modelParam);
o_s = floor(M / SubRate);
if ~modelParam.Init
    % Just set coefficients to [1 0 0 0 ... ]
    nb_coef=size(XM,2);
    modelParam.coef = zeros(nb_coef,1);
    modelParam.coef(1) = 1;
    modelParam.Init = true;
end
switch method
    case 'LSE'
        x_dltr = x_dltr(o_s*SubRate+1:end);
        yp_dltr = yp_dltr(o_s+1:end);
        if SubRate > 1
            x_dltr  = x_dltr(SubRate:SubRate:end);
            % yp_dltr = yp_dltr(SubRate:SubRate:end);
            XM    = XM(SubRate:SubRate:end,:);
        end
        XT = XM';
        delta = pinv(XT*XM)*(XT*(yp_dltr-x_dltr));
        modelParam.coef = modelParam.coef - g * delta;
    case 'RLS'
        P = 1e8 * eye(length(modelParam.coef));
        delta = zeros(length(modelParam.coef), 1);
        
        for n = o_s:length(yp_dltr)-1
            UM = XM(n*SubRate+1,:);
            Num = P * UM';
            Den = 1 + UM * P * UM';
            P = (eye(length(modelParam.coef)) - Num / Den * UM) * P;
            e = yp_dltr(n+1) - x_dltr(n*SubRate+1);
            delta = delta + Num / Den * (e - UM * delta);
        end
        modelParam.coef = modelParam.coef - g * delta;
    otherwise
        error('Method not recognized');
end

NMSE = 0;

end

