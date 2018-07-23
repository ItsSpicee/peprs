function MultiRresult=CoCrossDifferenceMultiplier(x1, x2, Xvector)
%caculate the multiplication of cross difference of sequence
N=length(Xvector);
MultiRresult=1;
for k=1:N
    if (x1~=Xvector(k))
        MultiRresult=MultiRresult*(x2-Xvector(k));
    end
end

end
