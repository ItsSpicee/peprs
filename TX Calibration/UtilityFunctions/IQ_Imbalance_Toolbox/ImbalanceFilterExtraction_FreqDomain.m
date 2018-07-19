function [ tonesFreq, G ] = ImbalanceFilterExtraction_FreqDomain( In_D, Out_D, Cal )
%     tones1  = 10e06:20e06:2100e06;
%     tones2 = 20e06:20e06:2100e06;
    if (~Cal.Signal.UniformSpacing)
        tones_I = Cal.Signal.ToneFrequenciesI;
        tones_Q = Cal.Signal.ToneFrequenciesQ;
    else
        tones_I = Cal.Signal.StartingToneFreq_I:Cal.Signal.ToneSpacing:Cal.Signal.EndingToneFreq_I;
        tones_Q = Cal.Signal.StartingToneFreq_Q:Cal.Signal.ToneSpacing:Cal.Signal.EndingToneFreq_Q;
    end
    tonesBaseband_I = [-flip(tones_I) tones_I];
    tonesBaseband_Q = [-flip(tones_Q) tones_Q];
    
    H11 = CalculateForwardResponseModel( real(In_D),real(Out_D), tonesBaseband_I, Cal.Signal.Fsample );
    H12 = CalculateForwardResponseModel( imag(In_D),real(Out_D), tonesBaseband_Q, Cal.Signal.Fsample );
    H21 = CalculateForwardResponseModel( real(In_D),imag(Out_D), tonesBaseband_I, Cal.Signal.Fsample );
    H22 = CalculateForwardResponseModel( imag(In_D),imag(Out_D), tonesBaseband_Q, Cal.Signal.Fsample );

%     figure;
%     plot( angle(H11)/pi*180 , '-*b');
%     hold on; grid on;
%     plot( angle(H22)/pi*180 , '-*g');
%     plot( angle(H12)/pi*180 , '-*r');
%     plot( angle(H21)/pi*180 , '-*m');
%     legend('H11','H22','H12','H21');
%     title( ' Phase of the filter of the forward model'); 

%     figure;
%     plot( 20*log10(abs(H11)) , '-*b');
%     hold on; grid on;
%     plot( 20*log10(abs(H22)) , '-*g');
%     plot( 20*log10(abs(H12)) , '-*r');
%     plot( 20*log10(abs(H21)) , '-*m');
%     legend('H11','H22','H12','H21');
%     title( ' MAG of the filter of the forward model'); 
    
    % Place the filters on to the same frequency grid and construct the G 
    % filters
%     
%     H_11_interp = H11;
%     H_21_interp = H21;
%     H_22_interp = H22;
%     H_12_interp = H12;
    if (Cal.Signal.EndingToneFreq_Q >= Cal.Signal.EndingToneFreq_I)
        [H_11_interp] = interp1(tonesBaseband_I, H11, tonesBaseband_Q, 'spline').';  
        [H_21_interp] = interp1(tonesBaseband_I, H21, tonesBaseband_Q, 'spline').';
        [G11, G12, G21, G22]  = CalculateInverseImbalanceFilters(H_11_interp, H12, H_21_interp, H22);
        tonesFreq = tonesBaseband_Q;
    else
        [H_22_interp] = interp1(tonesBaseband_Q, H22, tonesBaseband_I, 'spline').';  
        [H_12_interp] = interp1(tonesBaseband_Q, H12, tonesBaseband_I, 'spline').';  
        [G11, G12, G21, G22]  = CalculateInverseImbalanceFilters(H11, H_12_interp, H21, H_22_interp);
        tonesFreq = tonesBaseband_I;
    end
    
    G = struct('G11', G11, 'G12', G12, 'G21', G21, 'G22', G22);

    figure;
    plot( angle(G11)/pi*180 , '-*b');
    hold on; grid on;
    plot( angle(G22)/pi*180 , '-*g');
    plot( angle(G12)/pi*180 , '-*r');
    plot( angle(G21)/pi*180 , '-*m');
    legend('G11','G22','G12','G21');
    title( 'Phase Filter of the inverse model'); 

    figure;
    plot( 20*log10(abs(G11)) , '-*b');
    hold on; grid on;
    plot( 20*log10(abs(G22)) , '-*g');
    plot( 20*log10(abs(G12)) , '-*r');
    plot( 20*log10(abs(G21)) , '-*m');
    legend('G11','G22','G12','G21');
    title( 'Mag Filter of the inverse model');  
end

