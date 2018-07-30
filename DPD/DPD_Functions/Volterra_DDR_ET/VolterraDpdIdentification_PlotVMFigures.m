function [ meanInput , maxInput, NMSE ]= VolterraDpdIdentification_PlotVMFigures(Vin,Vout,Volterra,Coefficient,Static)
    Measured = VolterraDpdIdentification_Create_Data(real(Vin),imag(Vin),real(Vout),imag(Vout));
    Volterra = VolterraDpdIdentification_Create_Data(real(Vin),imag(Vin),real(Volterra),imag(Volterra));
    Static   = VolterraDpdIdentification_Create_Data(real(Vin),imag(Vin),real(Static),imag(Static));
    maxInput = max(Volterra.Pin) ;
    meanInput = mean(Volterra.Pin) ;
    
%% I
    figure()
        title('I Component','fontSize',20);
        xlabel('time','FontSize',15);
        ylabel('Voltage','FontSize',15);
        hold on
            plot(Measured.Out_I(1:100));
            plot(Volterra.Out_I(1:100),'ro');
            plot(Static.Out_I(1:100),'gx');
            legend('Measured I','Volterra I','Static I',2);
        hold off
%% Q
    figure()
        title('Q Component','fontSize',20);
        xlabel('time','FontSize',15);
        ylabel('Voltage','FontSize',15);
        hold on
            plot(Measured.Out_Q(1:100));
            plot(Volterra.Out_Q(1:100),'ro');
            plot(Static.Out_Q(1:100),'greenx');
            legend('Measured Q','Volterra Q','Static Q',2);
        hold off
%% AM/AM
    figure()
        title('AM/AM Distortion','FontSize',20);
        xlabel('Pin (dBm)','FontSize',15);
        ylabel('Pout./Pin (dB)','FontSize',15);
        hold on
            plot(Measured.Pin,Measured.Pout-Measured.Pin,'.' );
            plot(Volterra.Pin,Volterra.Pout-Volterra.Pin,'ro' );
            plot(Static.Pin,Static.Pout-Static.Pin,'gx' );
            legend('Measured AMAM','Volterra AMAM','Static AMAM',2);
        hold off  
%% AM/PM
    figure()
        hold on
            title('AM/PM Distortion','FontSize',20);
            xlabel('Pin (dBm)','FontSize',15);
            ylabel('Phase distortion (degree)','FontSize',15);
        
            angle_distortion = Measured.Phout - Measured.Phin;
            aux = angle_distortion > pi;
                angle_distortion = angle_distortion - 2*aux*pi;
            aux = angle_distortion < -pi;
                angle_distortion = angle_distortion + 2*aux*pi;
            plot(Measured.Pin,angle_distortion*180/pi,'.') ;

            angle_distortion = Volterra.Phout - Volterra.Phin;
            aux = angle_distortion > pi;
                angle_distortion = angle_distortion - 2*aux*pi;
            aux = angle_distortion < -pi;
                angle_distortion = angle_distortion + 2*aux*pi;
            plot(Volterra.Pin,angle_distortion*180/pi,'ro') ;

            angle_distortion = Static.Phout - Static.Phin;
            aux = angle_distortion > pi;
                angle_distortion = angle_distortion - 2*aux*pi;
            aux = angle_distortion < -pi;
                angle_distortion = angle_distortion + 2*aux*pi;
            plot(Static.Pin,angle_distortion*180/pi,'gx') ;
            legend('Measured AMPM','Volterra AMPM','Static AMPM',2);
        hold off

%% PSD
    figure()
        Fs = 3.84*10^6;
        h                = spectrum.welch;
        h.OverlapPercent = 40            ;
        h.SegmentLength  = 2048          ;
        h.windowName     = 'Flat Top'    ;
        hold on
            msspectrum(h,Measured.Vout,'centerdc',Fs)           ;
            H = plot(msspectrum(h,Volterra.Vout,'centerdc',Fs));
                set(H,'Color','RED');
            H = plot(msspectrum(h,Static.Vout,'centerdc',Fs));
                set(H,'Color','GREEN');
            H = plot(msspectrum(h,Volterra.Vout-Measured.Vout,'centerdc',Fs));
                set(H,'Color','RED');
            H = plot(msspectrum(h,Static.Vout-Measured.Vout,'centerdc',Fs));
                set(H,'Color','GREEN');
            legend('Measured PSD','Volterra PSD','Static PSD','Volterra Error PSD','Static Error PSD',2);
        hold off    
       
        rms = sqrt(mean(abs(Volterra.Vout-Measured.Vout).^2))/sqrt(mean(abs(Measured.Vout).^2)); 
        NMSE = 10*log10(sum(abs(Volterra.Vout-Measured.Vout).^2)/sum(abs(Measured.Vout).^2));
%         disp(['Pin avg: ', num2str(handles.ampm_data.joe.Pin),' dBm']);
%         disp(['Pout avg: ', num2str(handles.ampm_data.joe.Pout),' dBm']);
%         disp(['Poly coefficients: ']),Coefficient
%         figure(); plot(abs(Coefficient))
%         disp(['RMSE: ',num2str(rms*100),' %']);
        disp(['NMSE: ',num2str(NMSE),' dB']);
%         disp(['Pin avg: ', num2str(handles.ampm_data.joe.Pin),' dBm'])
%         disp(['Pout avg: ', num2str(handles.ampm_data.joe.Pout),' dBm'])
%         disp(['Input Signal CF: ', num2str(10*log10(max(abs( handles.ampm_data.joe.Vin).^2)*10)-10*log10(mean(abs( handles.ampm_data.joe.Vin).^2)*10)), ' dB'])
%         disp(['Output Signal CF: ', num2str(10*log10(max(abs( handles.ampm_data.joe.Vout).^2)*10)-10*log10(mean(abs( handles.ampm_data.joe.Vout).^2)*10)), ' dB'])