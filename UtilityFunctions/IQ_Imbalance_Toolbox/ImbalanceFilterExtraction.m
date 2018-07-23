function [H_coeff, NMSE] = ImbalanceFilterExtraction(x, y, M)
    y = y(M:end);
    
    X_Matrix = zeros(length(x)-M+1,M);
    for n=M:length(x)
        X_Matrix1 = [];
        for t=1:M
            X_Matrix1 = [X_Matrix1 x(n-t+1)];
        end
        X_Matrix(n-M+1,:) = X_Matrix1(:);
    end
    X_Matrix_reformed = [real(X_Matrix) imag(X_Matrix)];
    H_coeff           =(pinv(X_Matrix_reformed, eps) * y);
    display(['Condition of Matrix = ' num2str(cond(X_Matrix_reformed))]);
    y_model           = X_Matrix_reformed*H_coeff; 
    PlotSpectrum(y, y_model);
%     NMSE              = 10*log10(mean( abs(y_model - y)).^2./mean(abs(y).^2 ));
    NMSE              = CalculateNMSE(y_model, y,0);
end