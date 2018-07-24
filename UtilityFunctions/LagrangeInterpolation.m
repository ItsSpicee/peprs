function [Xout, Yout] = LagrangeInterpolation(Yin, Granularity, order)
%make Lagrange interpolation, here we supose the points of Xin are equally
%seperated; no expolation, hence there is ratio*(N-1)+1 points after
%interpolation
%Granularity---interpolation Granularity, Granularity is a integer larger than 1
N        = length(Yin);
Xin      = 1:N;%using the discrert integer value
XinStep  = Xin(2)-Xin(1);
XoutStep = XinStep/(Granularity+1);
%points after interpolation
M=(Granularity+1)*(N-1)+1;
%caculate the denominators of the lagrange polynomial
for j=1:(order+1)
    %caculate the denominators of the lagrange polynomial
    Denominator(j)=CrossDifferenceMultiplier(j, Xin(1:(order+1))); %#ok<AGROW>
end
%make lagrange interpolation
counter=1;
out_length = length(1:(Granularity+1):(M-3*Granularity*(order+1)-1)) * (Granularity+1);
Xout = zeros(out_length, 1);
Yout = zeros(out_length, 1);
for i=1:(Granularity+1):(M-3*Granularity*(order+1)-1)
    for k=1:(Granularity+1)
        Xout(i+k-1)=Xin(counter)+(k-1)*XoutStep; %#ok<AGROW>
        Yout(i+k-1)=0; %#ok<AGROW>
        for j=1:(order+1)
            x=Xin(counter)+(j-1);
            Nominator(j)=0; %#ok<AGROW>
            %calculate the nominators of the Lagrange polynomial
            Nominator(j)=CoCrossDifferenceMultiplier(x, Xout(i+k-1), Xin(counter:(counter+order))); %#ok<AGROW>
            %calculate the interpolation value
            if (Denominator(j)~=0)
                Yout(i+k-1)=Yout(i+k-1)+Nominator(j)*Yin(counter+j-1)/Denominator(j); %#ok<AGROW>
            end
        end
    end
    counter=counter+1;
end

end
