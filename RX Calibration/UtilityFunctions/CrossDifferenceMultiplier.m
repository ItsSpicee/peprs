function MultiRresult=CrossDifferenceMultiplier(x, Xvector)
%caculate the multiplication of cross difference of sequence
N=length(Xvector);
MultiRresult=1;
for k=1:N
    if (x~=Xvector(k))
        MultiRresult=MultiRresult*(x-Xvector(k));
    end
end

end
