function [DPD_coef, Basis] = Model_DPD(DPD_in, DPD_out, model)
% Model the input and output signals

% Synchronize the phase of the input and output
% [DPD_in, DPD_out] = AdjustPhase(DPD_in, DPD_out);
global DEBUG

x_pd = DPD_in;
y_pd = DPD_out;
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
    [A, Basis] = Generate_MemPoly_Matrix(x_pd, model.M, model.N, model.engine, model.polyorder);
    
    x_pd = x_pd(model.M:end);
    y_pd = y_pd(model.M:end);
    
    DPD_coef = pinv(A, eps) * (y_pd - add_flag * x_pd);
    
    if DEBUG == 1
        S = A(:, 1:po);
        static_coef = DPD_coef(1:po);
        static_inverse_out = S*static_coef+x_pd * add_flag;
        NMSE_dB = ModelCheck(x_pd, y_pd, static_inverse_out, 'Inverse DPD Static Test');
        display(['NMSE of inverse static DPD modelling = ', num2str(NMSE_dB)]);
        DPD_inverse_out = A*DPD_coef+x_pd * add_flag;
        NMSE_dB = ModelCheck(x_pd, y_pd, DPD_inverse_out, 'Inverse DPD Test');
        display(['NMSE of inverse DPD modelling = ', num2str(NMSE_dB)]);
    end
else
    % static non-linearity first
    [A, Basis] = Generate_MemPoly_Matrix(x_pd, model.M, model.N, model.engine, model.polyorder);
    S = A(:,1:po);
    D = A(:, po+1:end);
    
    x_pd = x_pd(model.M:end);
    y_pd = y_pd(model.M:end);
    
    static_coef = pinv(S, eps) * (y_pd - add_flag * x_pd);
    % dynamic part
    static_inverse_out = S*static_coef+x_pd * add_flag;
    dynamic_coef = pinv(D, eps) * (y_pd - static_inverse_out);
    
    DPD_coef = [static_coef; dynamic_coef];
    
    if DEBUG == 1
        NMSE_dB = ModelCheck(x_pd, y_pd, static_inverse_out, 'Inverse DPD Static Test');
        display(['NMSE of inverse static DPD modelling = ', num2str(NMSE_dB)]);
        DPD_inverse_out = A*DPD_coef+x_pd * add_flag;
        NMSE_dB = ModelCheck(x_pd, y_pd, DPD_inverse_out, 'Inverse DPD Test');
        display(['NMSE of inverse DPD modelling = ', num2str(NMSE_dB)]);
    end
end

end
