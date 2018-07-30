function [ coef_des ] = copy_coefficients( basis_des, basis_sou, coef_sou )
%COPY_COEFFICIENTS This fucntions copies the coefficient from one of the
%source to destination taking in considertaion the basis structure


coef_des = zeros(1, length(basis_des));

%copy the ceof number i from the source
for i = 1 :length(coef_sou)
    field_names = fieldnames(basis_sou(i).P);
    % find that coef place in the des matrix
    for j = 1 : length(coef_des)
       l = 1;
       found_flag = 1;
       while (l<=length(field_names))
            if isfield(basis_des(j).P, field_names(l))
                if getfield(basis_des(j).P, char(field_names(l)))  == getfield(basis_sou(i).P, char(field_names(l))) 
                else
                     found_flag = 0;
                end
            else
                found_flag = 0;
            end
            l = l + 1;
       end
       if found_flag == 1 
            coef_des(j) = coef_sou(i);
       end
    end 
end
end

