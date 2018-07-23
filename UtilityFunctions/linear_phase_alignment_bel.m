function [ X_I_4, X_Q_4, Y_I_4, Y_Q_4 ] = linear_phase_alignmnet(X_I_3, X_Q_3, Y_I_3, Y_Q_3,fs )
%LINEAR_PHASE_ALIGNMNET Summary of this function goes here

    t           = (0 : 1/fs : (length(X_I_3)-1)/fs)';
    angle_In    = unwrap(angle(complex(X_I_3, X_Q_3)));
    angle_Out   = unwrap(angle(complex(Y_I_3, Y_Q_3)));
    angle_diff  = angle_Out - angle_In; 
    figure ; plot(t, angle_In, 'k', 'linewidth', 2);
    hold on; plot(t, angle_Out, 'b', 'linewidth', 2); grid on;
    legend('In','Out')
    
% Interpolation of the difference betwen the two angles    
    p_fit_mag   = polyfit(t, angle_diff, 1);
    angle_fitted= polyval(p_fit_mag,t);
    figure ; plot(t, angle_fitted, 'k', 'linewidth', 2);
    hold on; plot(t, angle_diff, 'b', 'linewidth', 2); grid on;
    legend('Fitted','Diff')
% Shifting the phase of one of the signals by the linear difference
    angle_fitted_IQ     = exp(-1j*angle_fitted);
    % out <= out - phase_difference
    signal_out          = complex(Y_I_3, Y_Q_3) .* angle_fitted_IQ;
% To Validate
    angel_mod   = unwrap(angle(signal_out));
    figure ; plot(t, angel_mod   , 'k', 'linewidth', 2);
    %hold on; plot(t, angle_In, 'b', 'linewidth', 2); grid on;
    hold on; plot(t, angle_Out, 'm', 'linewidth', 2); grid on;
    legend('Mod','In')
    
    
    

end

