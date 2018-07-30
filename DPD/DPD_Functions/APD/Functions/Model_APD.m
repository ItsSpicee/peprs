function [APD_coef, Basis] = Model_APD(APD_in, APD_out, model)
% Model the input and output signals

% Synchronize the phase of the input and output
% [APD_in, APD_out] = AdjustPhase(APD_in, APD_out);

global DEBUG

x_pd = APD_in;
y_pd = APD_out;
if strcmp(model.polyorder,'odd')
    po = (floor(model.N/2)+1);
elseif strcmp(model.polyorder,'odd_even')
    po = (model.N+1);
elseif strcmp(model.polyorder,'odd_aug')
    if model.N > 0
        po = (floor(model.N/2)+1) + 1;
    else
        po = (floor(model.N/2)+1);
    end
end
if strcmp(model.architecture, 'multiply')
    add_flag = 0;
elseif strcmp(model.architecture,'add')
    add_flag = 1;
end
if model.two_step == 0
    if length(model.engine) > 4 && strcmp(model.engine(1:4), 'Mod_')
        [A, Basis, MaxM] = Generate_MemPoly_Matrix(x_pd, model.M, model.N, model.engine, model.polyorder, model.Mstep, model.FIR_M);
        m_shift = max(model.M, model.FIR_M, MaxM);
    else
        [A, Basis, MaxM] = Generate_MemPoly_Matrix(x_pd, model.M, model.N, model.engine, model.polyorder, model.Mstep);
        m_shift = (model.M, MaxM);
    end
    x_pd = x_pd(m_shift:end);
    y_pd = y_pd(m_shift:end);
    
    APD_coef = pinv(A, eps) * (y_pd - add_flag * x_pd);
    
    if DEBUG == 1
        S = A(:, 1:po);
        static_coef = APD_coef(1:po);
        static_inverse_out = S*static_coef+x_pd * add_flag;
        NMSE_dB = ModelCheck(x_pd, y_pd, static_inverse_out, 'Inverse APD Static Test');
        display(['NMSE of inverse static APD modelling = ', num2str(NMSE_dB)]);
        APD_inverse_out = A*APD_coef+x_pd * add_flag;
        NMSE_dB = ModelCheck(x_pd, y_pd, APD_inverse_out, 'Inverse APD Test');
        display(['NMSE of inverse APD modelling = ', num2str(NMSE_dB)]);
    end
else
    % static non-linearity first
    if length(model.engine)>=4 && strcmp(model.engine(1:4), 'Mod_')
        [A, Basis, MaxM] = Generate_MemPoly_Matrix(x_pd, model.M, model.N, model.engine, model.polyorder, model.Mstep, model.FIR_M);
        m_shift = max(model.M, model.FIR_M, MaxM);
    else
        [A, Basis, MaxM] = Generate_MemPoly_Matrix(x_pd, model.M, model.N, model.engine, model.polyorder, model.Mstep);
        m_shift = max(model.M, MaxM);
    end
    S = A(:,1:po);
    D = A(:, po+1:end);
    
    x_pd = x_pd(m_shift:end);
    y_pd = y_pd(m_shift:end);
    
    static_coef = pinv(S, eps) * (y_pd - add_flag * x_pd);
    % dynamic part
    static_inverse_out = S*static_coef+x_pd * add_flag;
    dynamic_coef = pinv(D, eps) * (y_pd - static_inverse_out);
    
    APD_coef = [static_coef; dynamic_coef];
    
    if DEBUG == 1
        NMSE_dB = ModelCheck(x_pd, y_pd, static_inverse_out, 'Inverse APD Static Test');
        display(['NMSE of inverse static APD modelling = ', num2str(NMSE_dB)]);
        APD_inverse_out = A*APD_coef+x_pd * add_flag;
        NMSE_dB = ModelCheck(x_pd, y_pd, APD_inverse_out, 'Inverse APD Test');
        display(['NMSE of inverse APD modelling = ', num2str(NMSE_dB)]);
    end
end

end
