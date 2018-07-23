function [  ] = pt_bel( X_I_2, X_Q_2, Y_I_2, Y_Q_2 , lenght)
%PT_BEL Summary of this function goes here
%   Detailed explanation goes here

temp1 = complex(X_I_2(1:lenght), X_Q_2(1:lenght));
temp2 = complex(Y_I_2(1:lenght), Y_Q_2(1:lenght));
figure
%lenght = 100;
subplot(2,1,1); 
plot(real(temp1(1:lenght)), 'k.-')
hold on
plot(real(temp2(1:lenght)), 'b.-')
ylabel('[V]')
xlabel('Sample Number')
title('Real')
grid on; 
legend('Orginal','Scope')

subplot(2,1,2); 
plot(imag(temp1(1:lenght)), 'k.-')
hold on
plot(imag(temp2(1:lenght)), 'b.-')
ylabel('[V]')
xlabel('Sample Number')
title('Imag')
grid on; 
legend('Orginal','Scope')
% 
% figure
% subplot(2,1,1)
% plot(real(temp1(1:lenght)), 'k.-')
% grid on; 
% subplot(2,1,2)
% plot(real(temp2(1:lenght)), 'k.-')
% grid on; 

figure
subplot(2,1,1); 
plot(abs(temp1(1:lenght)), 'k.-')
hold on
plot(abs(temp2(1:lenght)), 'b.-')
ylabel('[V]')
xlabel('Sample Number')
title('RF Envelope')
grid on; 
legend('Orginal','Scope')

subplot(2,1,2); 
plot((180/pi*(angle(temp1(1:lenght)))), 'k.-')
hold on
plot((180/pi*(angle(temp2(1:lenght)))), 'b.-')
ylabel('[Degrees]')
xlabel('Sample Number')
title('Angle')
grid on; 
legend('Orginal','Scope')

end

