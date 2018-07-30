function [modelParam, NMSE] = DL_APD_Identify_SqrtBasis(modelParam, In_Ori, PA_out, NofDPDPoints, SubRate, IterationCount, Num)
% Impletement APD identification using direct learning
% NofDPDPoints = length(In_Ori);
[x_dltr, yp_dltr, ~, ~] = Extract_Signal_Peak(In_Ori, PA_out, NofDPDPoints, SubRate);
method = modelParam.method;
M = modelParam.M;
N = modelParam.N;
% nonlinear memory depth
MNL = modelParam.MNL;
ML = modelParam.ML;
engine = modelParam.engine;
polyorder = modelParam.polyorder;
Mstep = modelParam.Mstep;
g = modelParam.learningParameter; % update weight factor
if ~modelParam.sqrtFlag
    [XM, ~, MaxM] = Generate_MemPoly_Matrix(x_dltr, M, N, engine, polyorder, Mstep, MNL, ML);
else
    [XM, ~, MaxM] = Generate_MemPoly_Matrix(abs(x_dltr).^(1/modelParam.RootOrder) .* exp(1i * unwrap(angle(x_dltr), pi)./modelParam.RootOrder), M, N, engine, polyorder, Mstep, MNL, ML);
end
switch nargin
    case 5
        % do nothing
    case 7
        % This part is for basis filtering.
        % the resulted basis matrix is filtered col by col using the same
        % lpf
%         XM_old  = XM;
%         XM = filter(Num, [1 0], XM, [], 1);
        XM_old  = XM;
        XM = filter(Num, 1, XM, [], 1);
        for i = 1:size(XM,2)
            [basisPower, ~, ~] = CheckPower(XM_old(:,i),0);
            XM(:,i) = SetMeanPower(XM(:,i),basisPower);
        end
end
o_s = max(ceil(MaxM / SubRate),1);
% o_s = max(floor(MaxM / SubRate),1);
if ~modelParam.Init
    % Just set coefficients to [1 0 0 0 ... ]
    nb_coef=size(XM,2);
    modelParam.coef = zeros(nb_coef,1);
    modelParam.coef(1) = 1;
    modelParam.Init = true;
end
% PlotGain(x_dltr, yp_dltr);
% PlotAMPM(x_dltr, yp_dltr);
% PlotAMAM(x_dltr, yp_dltr);




switch method
    case 'LSE'
        lambda = 0.01;
        x_dltr = x_dltr(o_s*SubRate:end);
        yp_dltr = yp_dltr(o_s:end);
        if SubRate > 1
            x_dltr  = x_dltr(SubRate:SubRate:end);
            % yp_dltr = yp_dltr(SubRate:SubRate:end);
            XM    = XM(SubRate:SubRate:end,:);
        end
        XT = XM';
        if nargin < 7
            if (~modelParam.sqrtFlag && IterationCount > 1)
                delta = pinv(XT*XM + lambda * ones(size(XM,2),size(XM,2)))*(XT*(yp_dltr-x_dltr));
            else
                delta = pinv(XT*XM + lambda * ones(size(XM,2),size(XM,2)))*(XT*(yp_dltr-x_dltr.^modelParam.RootOrder));
            end
        else
            error = filter(Num, 1, yp_dltr-x_dltr);
            [basisPower, ~, ~] = CheckPower(yp_dltr-x_dltr, 0);
            error = SetMeanPower(error,basisPower);

            delta = pinv(XT*XM + lambda * ones(size(XM,2),size(XM,2)))*(XT*(error));
        end
        modelParam.coef = modelParam.coef - g * delta;
    case 'RLS'
        lam = 1;
        lam = 1/lam;
        P = 1e8 * eye(length(modelParam.coef));
        delta = zeros(length(modelParam.coef), 1);
                
        pt(yp_dltr,x_dltr,1000);
        if nargin == 7
           [basisPower, ~, ~] = CheckPower(yp_dltr, 0);
           yp_dltr = filter(Num, 1,yp_dltr);
           yp_dltr = SetMeanPower(yp_dltr,basisPower);
           [basisPower, ~, ~] = CheckPower(x_dltr, 0);
           x_dltr = filter(Num, 1,x_dltr);
           x_dltr = SetMeanPower(x_dltr,basisPower);
           pt(yp_dltr,x_dltr,1000);
        end
        for n = o_s:length(yp_dltr)-1
            UM = XM(n*SubRate-MaxM+2,:);
            Num = lam * P * UM';
            Den = 1 + lam * UM * P * UM';
            P = lam * ((eye(length(modelParam.coef)) - Num / Den * UM) * P);
            if (~modelParam.sqrtFlag && IterationCount > 1)
                e = yp_dltr(n+1) - x_dltr(n*SubRate+1);
            else
                e = yp_dltr(n+1) - x_dltr(n*SubRate+1).^modelParam.RootOrder;
            end
            delta = delta + Num / Den * (e - UM * delta);
        end
%       max(abs(delta))
        modelParam.coef = modelParam.coef - g * delta;
    otherwise
        error('Method not recognized');
end

NMSE = 0;

% modelParamError = modelParam;
% modelParamError.coef = delta;
% e_modeltr = Apply_APD(yp_dltr-x_dltr, modelParamError);
% e_modelval = Apply_APD(PA_out-In_Ori, modelParamError);
% [e_tr, e_modeltr] = AdjustPowerAndPhase(yp_dltr-x_dltr,e_modeltr,0);
% [e_val, e_modelval] = AdjustPowerAndPhase(PA_out-In_Ori,e_modelval,0);
% [e_tr, e_modeltr] = AdjustDelay(e_tr, e_modeltr, 100);
% [e_val, e_modelval] = AdjustDelay(e_tr, e_modeltr, 100);
% PlotSpectrum(yp_dltr-x_dltr,e_modeltr,2e9)
% CalculateNMSE(yp_dltr-x_dltr,e_modeltr)
% CalculateNMSE(PA_out-In_Ori,e_modelval)
% PlotAMAM(e_tr, e_modeltr);
% PlotAMPM(e_tr, e_modeltr);
% pt_bel(e_tr,e_modeltr,5000)

% % Verification
% [PA_out_FR, FR_os] = Apply_APD(PA_in, PA_model);
% 
% % Only work with Full Rate
% NMSE = ModelCheck(PA_in(FR_os:end), PA_out(FR_os:end), PA_out_FR);
% disp([' NMSE1 = ', num2str(NMSE), ' dB' ]);
% 
% [APD_est_o, APD_est_os] = Apply_APD(PA_out_FR, modelParam);
% APD_i = PA_out_FR(APD_est_os:end);
% APD_o = PA_in(FR_os+APD_est_os-1:end);
% NMSE = ModelCheck(APD_i, APD_o, APD_est_o);
% 
% disp([' *************************  ']);
% disp([' NMSE2 = ', num2str(NMSE), ' dB' ]);
% disp([' *************************  ']);
% 
% disp([' *************************  ']);
% disp([' No. of coefficients ', num2str(size(modelParam.coef,1)) ]);
% disp([' *************************  ']);
% 


end
