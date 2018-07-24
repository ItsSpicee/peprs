function [] = pp_bel( X_I_3, X_Q_3, Y_I_3, Y_Q_3,fs_uxa)
%Plot the phase difference between two signals. 

    figure;
    plot(180/pi*(unwrap(angle(complex(X_I_3, X_Q_3))) - unwrap(angle(complex(Y_I_3, Y_Q_3)))))
    t = 0:1/fs_uxa:(length(X_I_3)-1)/fs_uxa;
    plot(t, 180/pi*unwrap((angle(complex(X_I_3, X_Q_3))) - (angle(complex(Y_I_3, Y_Q_3)))))
    xlabel('time'); ylabel('phase difference [degrees]'); grid on; 
    title('Angle difference between the UXA and AWG signal');
end

