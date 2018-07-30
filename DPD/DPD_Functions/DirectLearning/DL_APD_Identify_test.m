function [modelParam, NMSE] = DL_APD_Identify_test(modelParam, In_Ori, PA_out, NofDPDPoints, SubRate, Num)
% Impletement APD identification using direct learning
% NofDPDPoints = length(In_Ori);
[x_dltr, yp_dltr, ~, ~] = Extract_Signal_Peak(In_Ori, PA_out, NofDPDPoints, SubRate);
if ~modelParam.activateG2
    method = modelParam.g1.method;
    M = modelParam.g1.M;
    N = modelParam.g1.N;
    % nonlinear memory depth
    MNL = modelParam.g1.MNL;
    ML = modelParam.g1.ML;
    engine = modelParam.g1.engine;
    polyorder = modelParam.g1.polyorder;
    Mstep = modelParam.g1.Mstep;
    g = 1; % update weight factor
    [XM, ~, MaxM] = Generate_MemPoly_Matrix(x_dltr, M, N, engine, polyorder, Mstep, MNL, ML);
    switch nargin
        case 5
            % do nothing
        case 6
            % This part is for basis filtering.
            % the resulted basis matrix is filtered col by col using the same
            % lpf
    %         XM_old  = XM;
    %         XM = filter(Num, [1 0], XM, [], 1);
            XM_old  = XM;
            XM = filter(Num, 1, XM, [], 2);
            for i = 1:size(XM,2)
                [basisPower, ~, ~] = CheckPower(XM_old(:,i),0);
                XM(:,i) = SetMeanPower(XM(:,i),basisPower);
            end
    end
    o_s = max(ceil(MaxM / SubRate),1);
    % o_s = max(floor(MaxM / SubRate),1);
    if ~modelParam.g1.Init
        % Just set coefficients to [1 0 0 0 ... ]
        nb_coef=size(XM,2);
        modelParam.g1.coef = zeros(nb_coef,1);
        modelParam.g1.coef(1) = 1;
        modelParam.g1.Init = true;
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
            if nargin < 6
                delta = pinv(XT*XM + lambda * ones(size(XM,2),size(XM,2)))*(XT*(yp_dltr-x_dltr));
            else
                error = filter(Num, 1, yp_dltr-x_dltr);
                [basisPower, ~, ~] = CheckPower(yp_dltr-x_dltr, 0);
                error = SetMeanPower(error,basisPower);

                delta = pinv(XT*XM + lambda * ones(size(XM,2),size(XM,2)))*(XT*(error));
            end
            modelParam.g1.coef = modelParam.g1.coef - g * delta;
        case 'RLS'
            lam = 1;
            lam = 1/lam;
            P = 1e8 * eye(length(modelParam.g1.coef));
            delta = zeros(length(modelParam.g1.coef), 1);

            pt_bel(yp_dltr,x_dltr,1000);
            for n = o_s:length(yp_dltr)-1
                UM = XM(n*SubRate-MaxM+2,:);
                Num = lam * P * UM';
                Den = 1 + lam * UM * P * UM';
                P = lam * ((eye(length(modelParam.g1.coef)) - Num / Den * UM) * P);
                e = yp_dltr(n+1) - x_dltr(n*SubRate+1);
                delta = delta + Num / Den * (e - UM * delta);
            end
    %       max(abs(delta))
            modelParam.g1.coef = modelParam.g1.coef - g * delta;
        otherwise
            error('Method not recognized');
    end

    NMSE = 0;

%     modelParamError = modelParam.g1;
%     modelParamError.coef = delta;
%     e_modeltr = Apply_APD(yp_dltr-x_dltr, modelParamError);
%     e_modelval = Apply_APD(PA_out-In_Ori, modelParamError);
%     % [e_tr, e_modeltr] = AdjustPowerAndPhase(yp_dltr-x_dltr,e_modeltr,0);
%     % [e_val, e_modelval] = AdjustPowerAndPhase(PA_out-In_Ori,e_modelval,0);
%     % [e_tr, e_modeltr] = AdjustDelay(e_tr, e_modeltr, 100);
%     % [e_val, e_modelval] = AdjustDelay(e_tr, e_modeltr, 100);
%     PlotSpectrum(yp_dltr-x_dltr,e_modeltr,2e9)
    % CalculateNMSE(yp_dltr-x_dltr,e_modeltr)
    % CalculateNMSE(PA_out-In_Ori,e_modelval)
    % PlotAMAM(e_tr, e_modeltr);
    % PlotAMPM(e_tr, e_modeltr);
    % pt_bel(e_tr,e_modeltr,5000)
else
    method = modelParam.g2.method;
    
    %% generate u2
    % generate ux
    ux = APD_Apply(x_dltr, modelParam.g1);
    memTrunc = abs(length(ux) - length(x_dltr));
    ux = [ux((end-(memTrunc-1)):end,1); ux];
    %sqrt
    ux_mag = abs(ux).^(1/2);
%     ux_phase = unwrap(angle(ux))/2;
    ux_phase = angle(ux)/2;
    ux = ux_mag .* exp(1i*ux_phase);

    % generate uy
    uy = APD_Apply(yp_dltr, modelParam.g1);
    memTrunc = abs(length(uy) - length(yp_dltr));
    uy = [uy((end-(memTrunc-1)):end,1); uy];
    %sqrt
    uy_mag = abs(uy).^(1/2);
%     uy_phase = unwrap(angle(uy))/2;
    uy_phase = angle(uy)/2;
    uy = uy_mag .* exp(1i*uy_phase);
%     uy = -uy;
    
%     [ux,uy] = AdjustPhase(ux,uy);
    pt_bel(ux,uy,1000);
    u2 = ux - uy;
    PlotGain(yp_dltr,u2);
    PlotAMAM(yp_dltr,u2);
    PlotAMPM(yp_dltr,u2);

    M = modelParam.g2.M;
    N = modelParam.g2.N;
    % nonlinear memory depth
    MNL = modelParam.g2.MNL;
    ML = modelParam.g2.ML;
    engine = modelParam.g2.engine;
    polyorder = modelParam.g2.polyorder;
    Mstep = modelParam.g2.Mstep;
    [YM, ~, MaxM] = Generate_MemPoly_Matrix(yp_dltr, M, N, engine, polyorder, Mstep, MNL, ML);
    switch nargin
        case 5
            % do nothing
        case 6
            % This part is for basis filtering.
            % the resulted basis matrix is filtered col by col using the same
            % lpf
    %         XM_old  = XM;
    %         XM = filter(Num, [1 0], XM, [], 1);
            YM_old  = YM;
            YM = filter(Num, 1, YM, [], 2);
            for i = 1:size(YM,2)
                [basisPower, ~, ~] = CheckPower(YM_old(:,i),0);
                YM(:,i) = SetMeanPower(YM(:,i),basisPower);
            end
    end
    o_s = max(ceil(MaxM / SubRate),1);
    % o_s = max(floor(MaxM / SubRate),1);
    if ~modelParam.g2.Init
        % Just set coefficients to [1 0 0 0 ... ]
        nb_coef=size(YM,2);
        modelParam.g2.coef = zeros(nb_coef,1);
        modelParam.g2.coef(1) = 1;
        modelParam.g2.Init = true;
    end
    % PlotGain(x_dltr, yp_dltr);
    % PlotAMPM(x_dltr, yp_dltr);
    % PlotAMAM(x_dltr, yp_dltr);

    switch method
        case 'LSE'
            lambda = 0.01;
            u2 = u2(o_s*SubRate:end);
%             yp_dltr = yp_dltr(o_s:end);
%             if SubRate > 1
%                 x_dltr  = x_dltr(SubRate:SubRate:end);
                % yp_dltr = yp_dltr(SubRate:SubRate:end);
%                 YM    = YM(SubRate:SubRate:end,:);
%             end
            YT = YM';
            if nargin < 6
                delta = pinv(YT*YM + lambda * ones(size(YM,2),size(YM,2)))*(YT*(u2));
            else
                error = filter(Num, 1, u2);
                [basisPower, ~, ~] = CheckPower(u2, 0);
                error = SetMeanPower(error,basisPower);

                delta = pinv(YT*YM + lambda * ones(size(YM,2),size(YM,2)))*(YT*(u2));
            end
            modelParam.g2.coef = delta;
        case 'RLS'
            lam = 1;
            lam = 1/lam;
            P = 1e8 * eye(length(modelParam.g2.coef));
            delta = zeros(length(modelParam.g2.coef), 1);

            pt_bel(yp_dltr,x_dltr,1000);
            for n = o_s:length(yp_dltr)-1
                UM = YM(n*SubRate-MaxM+2,:);
                Num = lam * P * UM';
                Den = 1 + lam * UM * P * UM';
                P = lam * ((eye(length(modelParam.g2.coef)) - Num / Den * UM) * P);
%                 e = yp_dltr(n+1) - x_dltr(n*SubRate+1);
                e = u2;
                delta = delta + Num / Den * (e - UM * delta);
            end
    %       max(abs(delta))
%             modelParam.g1.coef = modelParam.g1.coef - g * delta;
            modelParam.g2.coef = delta;
        otherwise
            error('Method not recognized');
    end
    pd1 = Apply_APD(x_dltr, modelParam.g1);
    pd1 = abs(pd1).^(1/2) .* exp(1i * unwrap(angle(pd1))/2);
    pd2 = Apply_APD(x_dltr, modelParam.g2);
    uest = [pd2(end-o_s+2:end); pd2] + pd1;
    PlotAMAM(x_dltr,uest);
    PlotAMPM(x_dltr,uest);
end

    NMSE = 0;        
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
