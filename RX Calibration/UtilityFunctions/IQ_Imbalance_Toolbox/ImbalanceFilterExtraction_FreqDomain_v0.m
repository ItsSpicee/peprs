function [ tones_22, G ] = ImbalanceFilterExtraction_FreqDomain( In_D, Out_D, FsampleTx )
%     tones1  = 10e06:20e06:2100e06;
%     tones2 = 20e06:20e06:2100e06;
    tones1 = 10e06:20e06:380e06;
    tones2 = 20e06:20e06:380e06;

    tones_11 = [-flip(tones1) tones1];
    tones_22 = [-flip(tones2) tones2];

    H11 = Extract_filter( real(In_D),real(Out_D),tones_11, FsampleTx );
    H12 = Extract_filter( imag(In_D),real(Out_D),tones_22, FsampleTx );
    H21 = Extract_filter( real(In_D),imag(Out_D),tones_11, FsampleTx );
    H22 = Extract_filter( imag(In_D),imag(Out_D),tones_22, FsampleTx );

    figure;
    plot( angle(H11)/pi*180 , '-*b');
    hold on; grid on;
    plot( angle(H22)/pi*180 , '-*g');
    plot( angle(H12)/pi*180 , '-*r');
    plot( angle(H21)/pi*180 , '-*m');
    legend('H11','H22','H12','H21');
    title( ' Phase of the filter of the forward model'); 

    figure;
    plot( 20*log10(abs(H11)) , '-*b');
    hold on; grid on;
    plot( 20*log10(abs(H22)) , '-*g');
    plot( 20*log10(abs(H12)) , '-*r');
    plot( 20*log10(abs(H21)) , '-*m');
    legend('H11','H22','H12','H21');
    title( ' MAG of the filter of the forward model'); 

% Construct the G filters
    [H_11_interp] = interp1(tones_11, H11, tones_22, 'spline').';  
    [H_21_interp] = interp1(tones_11, H21, tones_22, 'spline').';  
    
    [G11, G12, G21, G22]  = compute_inverseFilters(H_11_interp, H12, H_21_interp, H22);
    G = struct('G11', G11, 'G12', G12, 'G21', G21, 'G22', G22);
%     [G11, G12, G21, G22]  = compute_inverseFilters(H11, H12, H21, H22);

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

