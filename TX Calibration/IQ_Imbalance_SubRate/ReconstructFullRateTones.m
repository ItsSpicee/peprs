function [FullRateEstimate_s2, FullRateEstimate_s4, FullRateEstimate_s8] = ReconstructFullRateTones(Received_train, tones_freq, fs)
%     tones_freq   = [2:10:492, 503:10:993, 1004:10:1494, 1501:10:1981] * 1e6;
    Received_train = Received_train(1:800e3);
    tones_freq = [-fliplr(tones_freq), tones_freq];
    [~, Recceived_FullRate] = GetFullRateTones(Received_train, tones_freq, fs);

    % fish the tones for fs = 2e9
    subrate = 4;
    Received_train_SubRate2 = Received_train(1:subrate:end);
%     ps_bel(Received_train_SubRate2,fs/subrate,0);
    tones_inband = [-993:10:-503, -492:10:-2, 2:10:492, 503:10:993] * 1e6;
    tones_alias_leftband = [19:10:499, 506:10:996] * 1e6;
    tones_alias_rightband = [-996:10:-506, -499:10:-19] * 1e6;
    [~, Recceived_Inband] = GetFullRateTones(Received_train_SubRate2, tones_inband, fs/subrate);
    [~, Recceived_AliasLeftBand] = GetFullRateTones(Received_train_SubRate2, [tones_alias_leftband], fs/subrate);
    [~, Recceived_AliasRightBand] = GetFullRateTones(Received_train_SubRate2, [tones_alias_rightband], fs/subrate);
    % align the tones
    tones_received_subrate2 = [Recceived_AliasLeftBand, Recceived_Inband, Recceived_AliasRightBand];

    % fish the tones for fs = 1e9
    subrate = 8;
    Received_train_SubRate4 = Received_train(1:subrate:end);
%     ps_bel(Received_train_SubRate4,fs/subrate,0);
    tones_inband = [-492:10:-2, 2:10:492] * 1e6;
    tones_alias_leftband_1 = [19:10:499] * 1e6;
    tones_alias_leftband_2 = [-494:10:-4] * 1e6;
    tones_alias_leftband_3 = [7:10:497] * 1e6;
    tones_alias_rightband_1 = [-497:10:-7] * 1e6;
    tones_alias_rightband_2 = [4:10:494] * 1e6;
    tones_alias_rightband_3 = [-499:10:-19] * 1e6;
    [~, Recceived_Inband] = GetFullRateTones(Received_train_SubRate4, tones_inband, fs/subrate);
    [~, Recceived_AliasLeftBand_1] = GetFullRateTones(Received_train_SubRate4, [tones_alias_leftband_1], fs/subrate);
    [~, Recceived_AliasLeftBand_2] = GetFullRateTones(Received_train_SubRate4, [tones_alias_leftband_2], fs/subrate);
    [~, Recceived_AliasLeftBand_3] = GetFullRateTones(Received_train_SubRate4, [tones_alias_leftband_3], fs/subrate);
    [~, Recceived_AliasRightBand_1] = GetFullRateTones(Received_train_SubRate4, [tones_alias_rightband_1], fs/subrate);
    [~, Recceived_AliasRightBand_2] = GetFullRateTones(Received_train_SubRate4, [tones_alias_rightband_2], fs/subrate);
    [~, Recceived_AliasRightBand_3] = GetFullRateTones(Received_train_SubRate4, [tones_alias_rightband_3], fs/subrate);
    % align the tones
    tones_received_subrate4 = [Recceived_AliasLeftBand_1, Recceived_AliasLeftBand_2, Recceived_AliasLeftBand_3, Recceived_Inband, Recceived_AliasRightBand_1, Recceived_AliasRightBand_2, Recceived_AliasRightBand_3];


    % fish the tones for fs = 0.5e9
    subrate = 16;
    Received_train_SubRate8 = Received_train(1:subrate:end); 
%     ps_bel(Received_train_SubRate8,fs/subrate,0);
    tones_inband = [-242:10:-2, 2:10:242] * 1e6;
    tones_alias_leftband_1 = [19:10:249] * 1e6;
    tones_alias_leftband_2 = [-241:10:-1] * 1e6;
    tones_alias_leftband_3 = [6:10:246] * 1e6;
    tones_alias_leftband_4 = [-244:10:-4] * 1e6;
    tones_alias_leftband_5 = [7:10:247] * 1e6;
    tones_alias_leftband_6 = [-243:10:-3] * 1e6;
    tones_alias_leftband_7 = [8:10:248] * 1e6;
    tones_alias_rightband_1 = [-248:10:-8] * 1e6;
    tones_alias_rightband_2 = [3:10:243] * 1e6;
    tones_alias_rightband_3 = [-247:10:-7] * 1e6;
    tones_alias_rightband_4 = [4:10:244] * 1e6;
    tones_alias_rightband_5 = [-246:10:-6] * 1e6;
    tones_alias_rightband_6 = [1:10:241] * 1e6;
    tones_alias_rightband_7 = [-249:10:-19] * 1e6;
    [~, Recceived_Inband] = GetFullRateTones(Received_train_SubRate8, tones_inband, fs/subrate);
    [~, Recceived_AliasLeftBand_1] = GetFullRateTones(Received_train_SubRate8, [tones_alias_leftband_1], fs/subrate);
    [~, Recceived_AliasLeftBand_2] = GetFullRateTones(Received_train_SubRate8, [tones_alias_leftband_2], fs/subrate);
    [~, Recceived_AliasLeftBand_3] = GetFullRateTones(Received_train_SubRate8, [tones_alias_leftband_3], fs/subrate);
    [~, Recceived_AliasLeftBand_4] = GetFullRateTones(Received_train_SubRate8, [tones_alias_leftband_4], fs/subrate);
    [~, Recceived_AliasLeftBand_5] = GetFullRateTones(Received_train_SubRate8, [tones_alias_leftband_5], fs/subrate);
    [~, Recceived_AliasLeftBand_6] = GetFullRateTones(Received_train_SubRate8, [tones_alias_leftband_6], fs/subrate);
    [~, Recceived_AliasLeftBand_7] = GetFullRateTones(Received_train_SubRate8, [tones_alias_leftband_7], fs/subrate);
    [~, Recceived_AliasRightBand_1] = GetFullRateTones(Received_train_SubRate8, [tones_alias_rightband_1], fs/subrate);
    [~, Recceived_AliasRightBand_2] = GetFullRateTones(Received_train_SubRate8, [tones_alias_rightband_2], fs/subrate);
    [~, Recceived_AliasRightBand_3] = GetFullRateTones(Received_train_SubRate8, [tones_alias_rightband_3], fs/subrate);
    [~, Recceived_AliasRightBand_4] = GetFullRateTones(Received_train_SubRate8, [tones_alias_rightband_4], fs/subrate);
    [~, Recceived_AliasRightBand_5] = GetFullRateTones(Received_train_SubRate8, [tones_alias_rightband_5], fs/subrate);
    [~, Recceived_AliasRightBand_6] = GetFullRateTones(Received_train_SubRate8, [tones_alias_rightband_6], fs/subrate);
    [~, Recceived_AliasRightBand_7] = GetFullRateTones(Received_train_SubRate8, [tones_alias_rightband_7], fs/subrate);
    % align the tones
    tones_received_subrate8 = [Recceived_AliasLeftBand_1, Recceived_AliasLeftBand_2, Recceived_AliasLeftBand_3, Recceived_AliasLeftBand_4, Recceived_AliasLeftBand_5, Recceived_AliasLeftBand_6, Recceived_AliasLeftBand_7, ...
        Recceived_Inband, Recceived_AliasRightBand_1, Recceived_AliasRightBand_2, Recceived_AliasRightBand_3, Recceived_AliasRightBand_4, Recceived_AliasRightBand_5, Recceived_AliasRightBand_6, Recceived_AliasRightBand_7];

    figure
    subplot(2,1,1);
    hold on
    plot(tones_freq, 20*log10(abs(tones_received_subrate2))+10, '.-g');
    plot(tones_freq, 20*log10(abs(tones_received_subrate4))+10, '.-m');
    plot(tones_freq, 20*log10(abs(tones_received_subrate8))+10, '.-b');
    plot(tones_freq, 20*log10(abs(Recceived_FullRate))+10, '.-r');
    legend('Subrate = 2; Fs = 2 GSa/s', 'Subrate = 4; Fs = 1 GSa/s', 'Subrate = 8; Fs = 0.5 GSa/s', 'Fullrate Fs = 8 GSa/s');
    ylabel('Magnitude (dBW/Hz)', 'FontSize', 20, 'FontWeight', 'Bold');
    xlabel('Frequency (Hz)', 'FontSize', 20, 'FontWeight', 'Bold');
    set(gca,'FontSize', 20, 'FontWeight','Bold');

    subplot(2,1,2);
    hold on
    plot(tones_freq, (angle(tones_received_subrate2))*180/pi, '.-g');
    plot(tones_freq, (angle(tones_received_subrate4))*180/pi, '.-m');
    plot(tones_freq, (angle(tones_received_subrate8))*180/pi, '.-b');
    plot(tones_freq, (angle(Recceived_FullRate))*180/pi, '.-r');
    legend('Subrate = 2; Fs = 2 GSa/s', 'Subrate = 4; Fs = 1 GSa/s', 'Subrate = 8; Fs = 0.5 GSa/s', 'Fullrate Fs = 8 GSa/s');
    ylabel('Phase (degrees)', 'FontSize', 20, 'FontWeight', 'Bold');
    xlabel('Frequency (Hz)', 'FontSize', 20, 'FontWeight', 'Bold');
    set(gca,'FontSize', 20, 'FontWeight','Bold');

    % compare to full-rate
    NMSE_subrate2 = CalculateNMSE(Recceived_FullRate, tones_received_subrate2, 1);
    NMSE_subrate4 = CalculateNMSE(Recceived_FullRate, tones_received_subrate4, 1);
    NMSE_subrate8 = CalculateNMSE(Recceived_FullRate, tones_received_subrate8, 1);

    FullRateEstimate_s2 = tones_received_subrate2;
    FullRateEstimate_s4 = tones_received_subrate4;
    FullRateEstimate_s8 = tones_received_subrate8;
end

