function [  ] = pt( X_I,  Y_I, length)
switch nargin
    case 2
        length= 5000;
    otherwise

end
%PT_BEL Summary of this function goes here
%   Detailed explanation goes here

% temp1 = complex(X_I_2(1:lenght), X_Q_2(1:lenght));
% temp2 = complex(Y_I_2(1:lenght), Y_Q_2(1:lenght));



temp1 = X_I; 
temp2 = Y_I; 

figure
%lenght = 100;
subplot(2,1,1); 
plot(real(temp1(1:length)), 'k.-')
hold on
plot(real(temp2(1:length)), 'b.-')
ylabel('[V]')
xlabel('Sample Number')
title('Real')
grid on; 
legend('1','2')

subplot(2,1,2); 
plot(imag(temp1(1:length)), 'k.-')
hold on
plot(imag(temp2(1:length)), 'b.-')
ylabel('[V]')
xlabel('Sample Number')
title('Imag')
grid on; 
legend('1','2')

% figure
% subplot(2,1,1)
% plot(real(temp1(1:length)), 'k.-')
% grid on; 
% subplot(2,1,2)
% plot(real(temp2(1:length)), 'k.-')
% grid on; 

figure
subplot(2,1,1); 
plot(abs(temp1(1:length)), 'k.-')
hold on
plot(abs(temp2(1:length)), 'b.-')
ylabel('[V]')
xlabel('Sample Number')
title('RF Envelope')
grid on; 
legend('1','2')

subplot(2,1,2); 
plot((180/pi*((angle(temp1(1:length))))), 'k.-')
hold on
plot((180/pi*((angle(temp2(1:length))))), 'b.-')
ylabel('[Degrees]')
xlabel('Sample Number')
title('Angle')
grid on; 
legend('1','2')

end

