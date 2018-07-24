function [G11, G12, G21, G22]  = CalculateInverseImbalanceFilters(H11, H12, H21, H22)
    G11= zeros(size(H11));
    G12= zeros(size(H12));
    G22= zeros(size(H22));
    G21= zeros(size(H21));
    
    for i = 1:length(G11)
        a = pinv ([H11(i) H12(i) ; H21(i) H22(i)]);
        G11(i) = a(1,1);
        G12(i) = a(1,2);
        G21(i) = a(2,1);
        G22(i) = a(2,2);
    end
    
%     % ~MBR :  zero the cross-corolation filters
%     for i = 1:length(G11)
%         a = pinv ([H11(i) H12(i) ; H21(i) H22(i)]);
%         G11(i) = a(1,1);
%         G12(i) = a(1,2)*0;
%         G21(i) = a(2,1)*0;
%         G22(i) = a(2,2);
%     end
    
end

