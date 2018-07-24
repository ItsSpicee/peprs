function [y] = ApplyTXCorrection(x, H_coeff, M)  
    X_Matrix = zeros(length(x)-M+1,M);
    for n=M:length(x)
        X_Matrix1 = [];
        for t=1:M
            X_Matrix1 = [X_Matrix1 x(n-t+1)];
        end
        X_Matrix(n-M+1,:) = X_Matrix1(:);
    end
%     X_Matrix_reformed = [real(X_Matrix) imag(X_Matrix) ];
    y                 = X_Matrix*H_coeff; 
end