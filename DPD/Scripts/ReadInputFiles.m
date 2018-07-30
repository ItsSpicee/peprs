%% Reading the input files

% Any modifications to the signal sampling rate from the original signal
% sampling rate
upsamplingFactor = 1;
downsamplingFactor = 1;
if EVM_flag == 0        
switch SignalName %#ok<*NASGU>
    case 'LTE_20' %% LTE 20 MHz
        InI_beforeDPD_path = 'LTE_20MHz_In_I_100r0_PAPR_9r3_16QAM_1ms.txt';
        InQ_beforeDPD_path = 'LTE_20MHz_In_Q_100r0_PAPR_9r3_16QAM_1ms.txt';
        Signal.BW          = 20e6;
        Signal.Fsample   = 100e6;
        Signal.PAPR_limit = 9.3;
    case 'WCDMA_5' %% WCDMA 1C - 5 MHz
        InI_beforeDPD_path = 'WCDMA3G_1C_In_I_100r0_PAPR_7r4_Version1200_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_1C_In_Q_100r0_PAPR_7r4_Version1200_1ms.txt';
        Signal.BW          = 5e6;
        Signal.Fsample   = 100e6;
        Signal.PAPR_limit = 7.4;
    case 'WCDMA_10' %% WCDMA 101 - 10 MHz
        InI_beforeDPD_path = 'WCDMA3G_11_In_I_100r0_PAPR_7r4_Version1200_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_11_In_Q_100r0_PAPR_7r4_Version1200_1ms.txt';
        Signal.BW          = 10e6;
        Signal.Fsample   = 100e6;
        Signal.PAPR_limit  = 7.4;
    case 'WCDMA_15' %% WCDMA 101 - 15 MHz
        InI_beforeDPD_path = 'WCDMA3G_101_In_I_100r0_PAPR_8r3_Version1200_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_101_In_Q_100r0_PAPR_8r3_Version1200_1ms.txt';
        Signal.BW          = 15e6;
        Signal.Fsample   = 100e6;
        Signal.PAPR_limit  = 10;
    case 'WCDMA_1111_20' %% WCDMA 4C - 20 MHz
        InI_beforeDPD_path = 'WCDMA3G_4C_In_I_100r0_PAPR_7r14_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_4C_In_Q_100r0_PAPR_7r14_1ms.txt';
        Signal.BW          = 20e6;
        Signal.Fsample   = 100e6;
        Signal.PAPR_limit = 7.14;
        upsamplingFactor = 4;
    case 'WCDMA_1001_20' %% WCDMA 1001 - 20 MHz
        InI_beforeDPD_path = 'WCDMA3G_4C_1001_In_I_100r0_PAPR_7r11_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_4C_1001_In_Q_100r0_PAPR_7r11_1ms.txt';
        Signal.BW          = 20e6;
        Signal.Fsample   = 100e6;
    case 'WCDMA_30' %% WCDMA 4C - 30 MHz
        InI_beforeDPD_path = 'WCDMA3G_110011_In_I_200r0_PAPR_8r6_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_110011_In_Q_200r0_PAPR_8r6_1ms.txt';
        Signal.BW          = 30e6;
        Signal.Fsample   = 200e6;
    case 'DualBand_40' %% WCDMA 111 / LTE 15 - 40 MHz
        InI_beforeDPD_path = 'WCDMA111_LTE15_40MHz_In_I_200r0_PAPR_8r4_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA111_LTE15_40MHz_In_Q_200r0_PAPR_8r4_1ms.txt';
        Signal.BW          = 40e6;
        Signal.Fsample   = 200e6;
    case 'WCDMA_50' %% WCDMA 10C - 50 MHz
        InI_beforeDPD_path = 'WCDMA3G_10C_In_I_400r0_PAPR_10r0_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_10C_In_Q_400r0_PAPR_10r0_1ms.txt';
        Signal.BW          = 50e6;
        Signal.Fsample   = 400e6;
        Signal.PAPR_limit  = 8.4;
    case 'TriBand_80' %% WCDMA 4C + LTE15 + LTE20 - 80 MHz
        InI_beforeDPD_path = 'WCDMA_4C_LTE15_LTE20_80MHz_In_I_400r0_PAPR_10r9_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA_4C_LTE15_LTE20_80MHz_In_Q_400r0_PAPR_10r9_1ms.txt';
        Signal.BW          = 80e6;
        Signal.Fsample   = 400e6;
    case 'DualBand_80' %% WCDMA 4C + LTE20 - 80 MHz
        InI_beforeDPD_path = 'WCDMA_4C_LTE20_80MHz_In_I_400r0_PAPR_9r6_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA_4C_LTE20_80MHz_In_Q_400r0_PAPR_9r6_1ms.txt';
        Signal.BW          = 80e6;
        Signal.Fsample   = 400e6;
    case 'DualBand_80_New' %% WCDMA 4C + LTE20 - 80 MHz
        InI_beforeDPD_path = 'WCDMA_4C_LTE20_80MHz_In_I_400r0_PAPR_10r4_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA_4C_LTE20_80MHz_In_Q_400r0_PAPR_10r4_1ms.txt';
        Signal.BW          = 80e6;
        Signal.Fsample   = 400e6;
    case 'TriBand_160' %% WCDMA 4C + LTE20 + 1001 - 160 MHz
         InI_beforeDPD_path = 'WCDMA_4C_LTE20_1001_160MHz_In_I_800r0_PAPR_8r9_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA_4C_LTE20_1001_160MHz_In_Q_800r0_PAPR_8r9_1ms.txt';
        factor      = 1;
        Signal.BW          = 160e6  * factor;
        Signal.Fsample   = 800e6  * factor ;
    case 'WCDMA_1001_20_upsampled' %% WCDMA 4C + LTE20 + 1001 - 160 MHz
        InI_beforeDPD_path = 'WCDMA3G_4C_1001_In_I_100r0_PAPR_7r11_1ms.txt';
        InQ_beforeDPD_path = 'WCDMA3G_4C_1001_In_Q_100r0_PAPR_7r11_1ms.txt';
        Signal.BW          = 20 * 10e6;
        Signal.Fsample   = 100 * 10e6;
    case 'LTE_80MHz'
        InI_beforeDPD_path = 'LTE_8x20M_I_fs_1e+09_PAPR_8.4_11.2_QPSK_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_8x20M_Q_fs_1e+09_PAPR_8.4_11.2_QPSK_1ms_4xUPS.txt';
        Signal.PAPR_limit  = 8.5;
        factor      = 2;
        Signal.BW          = 160e6 / factor;
        Signal.Fsample   = 1e9 / factor;
        upsamplingFactor = 4;
    case 'LTE_160MHz'
        InI_beforeDPD_path = 'LTE_16x20M_Q_fs_1e+09_PAPR_8.4_11.5_QPSK_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_16x20M_Q_fs_1e+09_PAPR_8.4_11.5_QPSK_1ms_4xUPS.txt';
        Signal.PAPR_limit  = 8.4;
        factor      = 0.5;
        Signal.BW          = 320e6 * factor;
        Signal.Fsample   = 1e9 * factor;
        upsamplingFactor = 6;
    case 'LTE_320MHz'
        InI_beforeDPD_path = 'LTE_16x20M_Q_fs_1e+09_PAPR_8.4_11.5_QPSK_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_16x20M_Q_fs_1e+09_PAPR_8.4_11.5_QPSK_1ms_4xUPS.txt';
        Signal.PAPR_limit      = 7;
        factor      = 1;
        Signal.BW          = (320e6)/factor;
        Signal.Fsample   = (1e9)/factor;
        upsamplingFactor = 3;
        downsamplingFactor = 1;
    case 'LTE_640MHz_10011001'
        InI_beforeDPD_path = 'LTE_32x20M_I_fs_1e+09_PAPR_8.5_11.2_QPSK_1ms_4xUPS_10011001.txt';
        InQ_beforeDPD_path = 'LTE_32x20M_Q_fs_1e+09_PAPR_8.5_11.2_QPSK_1ms_4xUPS_10011001.txt';
        factor      = 1;
        Signal.PAPR_limit      = 8.5;
        Signal.BW          = (640e6)/factor;
        Signal.Fsample   = (1e9)/factor;
    case 'LTE_640MHz_10000001'
        InI_beforeDPD_path = 'LTE_32x20M_I_fs_1e+09_PAPR_8.4_11.3_QPSK_1ms_4xUPS_10000001.txt';
        InQ_beforeDPD_path = 'LTE_32x20M_Q_fs_1e+09_PAPR_8.4_11.3_QPSK_1ms_4xUPS_10000001.txt';
        factor      = 1;
        Signal.BW          = (640e6)/factor;
        Signal.Fsample   = (1e9)/factor;
    case 'LTE_320MHz_1001'
        InI_beforeDPD_path = 'LTE_16x20M_I_fs_1e+09_PAPR_8.4_11.1_QPSK_1ms_4xUPS_1001.txt';
        InQ_beforeDPD_path = 'LTE_16x20M_Q_fs_1e+09_PAPR_8.4_11.1_QPSK_1ms_4xUPS_1001.txt';
        factor      = 1;
        Signal.PAPR_limit  = 8.4;
        Signal.BW          = (320e6)/factor;
        Signal.Fsample   = (1e9)/factor;
    case 'LTE_40MHz_QPSK'
        InI_beforeDPD_path = 'LTE_8x20M_Q_fs_1e+09_PAPR_8.4_11.2_QPSK_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_8x20M_Q_fs_1e+09_PAPR_8.4_11.2_QPSK_1ms_4xUPS.txt';
        Signal.PAPR_limit      = 8.4;
        factor      = 4;
        Signal.BW          = (160e6)/factor;
        Signal.Fsample   = (1e9)/factor;
        upsamplingFactor = 4;
    case 'LTE_160MHz_QPSK'
        InI_beforeDPD_path = 'LTE_8x20M_Q_fs_1e+09_PAPR_8.4_11.2_QPSK_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_8x20M_Q_fs_1e+09_PAPR_8.4_11.2_QPSK_1ms_4xUPS.txt';
        Signal.PAPR_limit      = 8.4;
        factor      = 1;
        Signal.BW          = (160e6)/factor;
        Signal.Fsample   = (1e9)/factor;
        upsamplingFactor = 1;
	case 'LTE_640MHz_16QAM'
        InI_beforeDPD_path = 'LTE_32x20M_I_fs_1e+09_PAPR_8.4_12.3_QPSK_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_32x20M_Q_fs_1e+09_PAPR_8.4_12.3_QPSK_1ms_4xUPS.txt';
        Signal.PAPR_limit      = 8.4;
        factor      = 1;
        Signal.BW          = (640e6)/factor;
        Signal.Fsample   = (1e9)/factor;
        upsamplingFactor = 3;
        downsamplingFactor = 1;
    case '16QAM_200MHz'
        InI_beforeDPD_path  = 'I.txt';
        InQ_beforeDPD_path  = 'Q.txt';
        Signal.PAPR_limit      = 6.04;
        factor      = 1;
        Signal.BW          = (200e6)/factor;
        Signal.Fsample   = (1e9)/factor;  
    case '16QAM_300MHz'
        InI_beforeDPD_path = 'I_300mhz_16QAM_1gsps.txt'
        InQ_beforeDPD_path = 'Q_300mhz_16QAM_1gsps.txt'
        Signal.PAPR_limit  = 6.04;
        factor      = 1;
        Signal.BW          = (350e6)/factor;
        Signal.Fsample   = (1e9)/factor;
        upsamplingFactor = 1;
        downsamplingFactor = 1;
    case 'LTE_200MHz'
        InI_beforeDPD_path = 'LTE_8x20M_I_fs_1e+09_PAPR_8.4_11.0_16QAM_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_8x20M_Q_fs_1e+09_PAPR_8.4_11.0_16QAM_1ms_4xUPS.txt';
        Signal.PAPR_limit  = 8.4;
        factor      = 0.8;
        Signal.BW          = (160e6)/factor;
        Signal.Fsample   = (1e9)/factor;  
        upsamplingFactor =  8;
        downsamplingFactor = 5;
    case 'LTE_320MHz_16QAM'
        InI_beforeDPD_path = 'LTE_16x20M_I_fs_1e+09_PAPR_8.4_11.9_16QAM_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'LTE_16x20M_Q_fs_1e+09_PAPR_8.4_11.9_16QAM_1ms_4xUPS.txt';
        Signal.PAPR_limit  = 8.4;
        factor      = 1;
        Signal.BW          = (320e6)/factor;
        Signal.Fsample   = (1e9)/factor;  
    case 'LTE_800MHz_16QAM'
        InI_beforeDPD_path = 'LTE_800M_I_fs_1e+09_PAPR_8.5_11.6_16QAM_1ms_5xUPS.txt';
        InQ_beforeDPD_path = 'LTE_800M_Q_fs_1e+09_PAPR_8.5_11.6_16QAM_1ms_5xUPS.txt';
        Signal.PAPR_limit  = 8.4;
        factor      = 1;
        Signal.BW          = (800e6)/factor;
        Signal.Fsample   = (1e9)/factor;
        upsamplingFactor = 2;
    case '16QAM_320MHz'
        InI_beforeDPD_path = 'SC_320M_I_fs_1e+09_PAPR_7.0_8.2_16QAM_1ms_4xUPS.txt';
        InQ_beforeDPD_path = 'SC_320M_Q_fs_1e+09_PAPR_7.0_8.2_16QAM_1ms_4xUPS.txt';
        Signal.PAPR_limit  = 7.5;
        factor      = 1;
        Signal.BW          = (320e6)/factor;
        Signal.Fsample   = (1e9)/factor;
    case '16QAM_640MHz'
        InI_beforeDPD_path = 'SC_640M_I_fs_1e+09_PAPR_7.6_8.2_16QAM_1ms_2xUPS.txt';
        InQ_beforeDPD_path = 'SC_640M_Q_fs_1e+09_PAPR_7.6_8.2_16QAM_1ms_2xUPS.txt';
        Signal.PAPR_limit  = 7.6;
        factor      = 1;
        Signal.BW          = (640e6)/factor;
        Signal.Fsample   = (1e9)/factor;   
    case '16QAM_2GHz'
        InI_beforeDPD_path = 'SC_2G_I_fs_4e+09_PAPR_6.1_8.2_16QAM_0.25ms_2xUPS.txt';
        InQ_beforeDPD_path = 'SC_2G_I_fs_4e+09_PAPR_6.1_8.2_16QAM_0.25ms_2xUPS.txt';
        Signal.PAPR_limit  = 8;
        factor      = 1;
        Signal.BW          = (2e9)/factor;
        Signal.Fsample   = (4e9)/factor;
        upsamplingFactor = 2;
    case '256QAM_2GHz'
        InI_beforeDPD_path = 'SC_2G_I_fs_4e+09_PAPR_7.1_9.3_256QAM_0.25ms_2xUPS.txt';
        InQ_beforeDPD_path = 'SC_2G_Q_fs_4e+09_PAPR_7.1_9.3_256QAM_0.25ms_2xUPS.txt';
        Signal.PAPR_limit  = 8.4;
        factor      = 1;
        Signal.BW          = (2e9)/factor;
        Signal.Fsample   = (4e9)/factor;
    case 'WhiteNoise_2GHz'
        InI_beforeDPD_path = 'WhiteNoise_2GHz_I_fs_4e9_0.5ms.txt';
        InQ_beforeDPD_path = 'WhiteNoise_2GHz_Q_fs_4e9_0.5ms.txt';
        Signal.PAPR_limit  = 8.4;
        factor      = 1;
        Signal.BW          = (1.9e9)/factor;
        Signal.Fsample   = (4e9)/factor; 
    case 'MultiTone_2GHz'
        InI_beforeDPD_path = 'multi_tone_2GHz_I_fs_4e9_0.5ms.txt';
        InQ_beforeDPD_path = 'multi_tone_2GHz_Q_fs_4e9_0.5ms.txt';
        Signal.PAPR_limit  = 6.96;
        factor      = 1;
        Signal.BW          = (2e9)/factor;
        Signal.Fsample   = (4e9)/factor;
        upsamplingFactor = 1;
    case 'MultiTone_20MHz'
        InI_beforeDPD_path = 'multi_tone_20MHz_I_fs_1e8_0.5ms.txt';
        InQ_beforeDPD_path = 'multi_tone_20MHz_Q_fs_1e8_0.5ms.txt';
        Signal.PAPR_limit  = 4.72;
        factor      = 1;
        Signal.BW          = (20e6)/factor;
        Signal.Fsample   = (1e8)/factor;
    case 'MultiTone_3GHz'
        InI_beforeDPD_path = 'Multi_Tone_3GHz_I_fs_8e9_0.25ms.txt';
        InQ_beforeDPD_path = 'Multi_Tone_3GHz_Q_fs_8e9_0.25ms.txt';
        Signal.PAPR_limit  = 7.1;
        factor      = 1;
        Signal.BW          = (3e9)/factor;
        Signal.Fsample   = (8e9)/factor;
        upsamplingFactor = 1;
    case 'MultiTone_6GHz'
        InI_beforeDPD_path = 'Multi_Tone_6GHz_I_fs_8e9_0.25ms.txt';
        InQ_beforeDPD_path = 'Multi_Tone_6GHz_Q_fs_8e9_0.25ms.txt';
        Signal.PAPR_limit  = 7.1;
        factor      = 1;
        Signal.BW          = (6e9)/factor;
        Signal.Fsample   = (8e9)/factor;
    case 'MultiTone_3r4GHz'
        InI_beforeDPD_path = 'Multi_Tone_3r4GHz_I_fs_8e9_0.25ms.txt';
        InQ_beforeDPD_path = 'Multi_Tone_3r4GHz_Q_fs_8e9_0.25ms.txt';
        Signal.PAPR_limit  = 12.35;
        factor      = 1;
        Signal.BW          = (3.4e9)/factor;
        Signal.Fsample   = (8e9)/factor;
        upsamplingFactor = 1;
    case 'MultiTone_4r4GHz'
        InI_beforeDPD_path = 'Multi_Tone_4r4GHz_I_fs_8e9_0.25ms.txt';
        InQ_beforeDPD_path = 'Multi_Tone_4r4GHz_Q_fs_8e9_0.25ms.txt';
        Signal.PAPR_limit  = 11.58;
        factor      = 1;
        Signal.BW          = (4.3e9)/factor;
        Signal.Fsample   = (8e9)/factor;
        upsamplingFactor = 1;
     case 'MultiTone_4r4GHz_20MHz'
        InI_beforeDPD_path = 'Multi_Tone_4r4GHz_I_fs_8e9_0.25ms_11dB_20MHz_Spacing.txt';
        InQ_beforeDPD_path = 'Multi_Tone_4r4GHz_Q_fs_8e9_0.25ms_11dB_20MHz_Spacing.txt';
        Signal.PAPR_limit  = 11;
        factor      = 1;
        Signal.BW          = (4.3e9)/factor;
        Signal.Fsample   = (8e9)/factor;
        upsamplingFactor = 1;
    case 'Real_MultiTone_4r2GHz'
        InI_beforeDPD_path = 'Real_Multi_Tone_4r4GHz_I_fs_8e9_0.25ms_10r65dB.txt';
        InQ_beforeDPD_path = 'Real_Multi_Tone_4r4GHz_Q_fs_8e9_0.25ms_10r65dB.txt';
        Signal.PAPR_limit  = 10.65;
        factor      = 1;
        Signal.BW          = (4.2e9)/factor;
        Signal.Fsample   = (8e9)/factor;
        upsamplingFactor = 1;
    case 'MultiTone_4r4GHz_LowPAPR'
        InI_beforeDPD_path = 'Multi_Tone_4r4GHz_I_fs_8e9_0.25ms_2r58dB.txt';
        InQ_beforeDPD_path = 'Multi_Tone_4r4GHz_Q_fs_8e9_0.25ms_2r58dB.txt';
        Signal.PAPR_limit  = 2.58;
        factor      = 1;
        Signal.BW          = (4.3e9)/factor;
        Signal.Fsample   = (8e9)/factor;
        upsamplingFactor = 1;
    case 'Real_MultiTone_1r0GHz'
        InI_beforeDPD_path = 'Real_Multi_Tone_0r5GHz_I_fs_8e9_0.25ms_10r47dB.txt';
        InQ_beforeDPD_path = 'Real_Multi_Tone_0r5GHz_Q_fs_8e9_0.25ms_10r42dB.txt';
        Signal.PAPR_limit  = 10.4;
        factor      = 1;
        Signal.BW          = (0.96e9)/factor;
        Signal.Fsample   = (8e9)/factor;
        upsamplingFactor = 1;
        downsamplingFactor = 1;
    case 'MultiToneSignal_s1_200MHz'
        InI_beforeDPD_path = 'MultiToneSignal_s1_200MHz_I_fs_400e6_0r6ms.txt';
        InQ_beforeDPD_path = 'MultiToneSignal_s1_200MHz_Q_fs_400e6_0r6ms.txt';
        Signal.PAPR_limit  = 2.2;
        factor             = 1;
        Signal.BW          = (0.2e9)/factor;
        Signal.Fsample     = (0.4e9)/factor;
        upsamplingFactor   = 1;
        downsamplingFactor = 1;
    case 'MultiToneSignal_s2_200MHz'
        InI_beforeDPD_path = 'MultiToneSignal_s2_200MHz_I_fs_400e6_0r6ms.txt';
        InQ_beforeDPD_path = 'MultiToneSignal_s2_200MHz_Q_fs_400e6_0r6ms.txt';
        Signal.PAPR_limit  = 2.2;
        factor             = 1;
        Signal.BW          = (0.2e9)/factor;
        Signal.Fsample     = (0.4e9)/factor;
        upsamplingFactor   = 1;
        downsamplingFactor = 1;
    case 'MultiToneSignal_s1_0r64GHz'
        InI_beforeDPD_path = 'MultiToneSignal_s1_0r64GHz_I_fs_2e9_PAPR_5r53dB_0.12ms.txt';
        InQ_beforeDPD_path = 'MultiToneSignal_s1_0r64GHz_Q_fs_2e9_PAPR_5r53dB_0.12ms.txt';
        Signal.PAPR_limit  = 2.52;
        factor             = 1;
        Signal.BW          = (0.64e9)/factor;
        Signal.Fsample     = (2e9)/factor;
        upsamplingFactor   = 1;
        downsamplingFactor = 1;
    case 'MultiToneSignal_s1_1r2GHz'
        InI_beforeDPD_path = 'MultiToneSignal_s1_1r2GHz_I_fs_3e9_PAPR_2r59_0r12ms.txt';
        InQ_beforeDPD_path = 'MultiToneSignal_s1_1r2GHz_Q_fs_3e9_PAPR_2r59_0r12ms.txt';
        Signal.PAPR_limit  = 2.59;
        factor             = 1;
        Signal.BW          = (1.2e9)/factor;
        Signal.Fsample     = (3e9)/factor;
        upsamplingFactor   = 1;
        downsamplingFactor = 1;
    case 'SC_QAM64_100MHz'
        InI_beforeDPD_path = 'SC_64QAM_100MHz_I_fs_1e9_PAPR_6r9dB_Filt_RC_alpha_0r05_1ms.txt';
        InQ_beforeDPD_path = 'SC_64QAM_100MHz_Q_fs_1e9_PAPR_6r9dB_Filt_RC_alpha_0r05_1ms.txt';
        Signal.PAPR_limit  = 9;
        factor      = 1;
        alpha = 0.1;
        Signal.BW          =  100e6*(1+alpha); 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 1;
    case 'SC_QAM64_400MHz'
        InI_beforeDPD_path = 'SC_64QAM_400M_I_fs_2e9_PAPR_6r9dB_Filt_RC_alpha_0r05_1ms.txt';
        InQ_beforeDPD_path = 'SC_64QAM_400M_Q_fs_2e9_PAPR_6r9dB_Filt_RC_alpha_0r05_1ms.txt';
        Signal.PAPR_limit  = 9;
        factor      = 1;
        alpha = 0.1;
        Signal.BW          =  400e6*(1+alpha); 
        Signal.Fsample     = 2e09;  
        upsamplingFactor   = 1;
    case 'SC_QAM64_800MHz'
        InI_beforeDPD_path = 'SC_64QAM_800M_I_fs_2e9_PAPR_8r7dB_Filt_RC_alpha_0r05_0r5ms.txt';
        InQ_beforeDPD_path = 'SC_64QAM_800M_Q_fs_2e9_PAPR_8r7dB_Filt_RC_alpha_0r05_0r5ms.txt';
        Signal.PAPR_limit  = 9;
        factor      = 1;
        alpha = 0.1;
        Signal.BW          =  800e6*(1+alpha); 
        Signal.Fsample     = 2e09;  
        upsamplingFactor   = 2;
    case '5G_NR_OFDM_50MHz'
        InI_beforeDPD_path = '5G_signal_I_64QAM_50MHz_1e9GSaps.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_50MHz_1e9GSaps.txt';
        Signal.PAPR_limit  = 10.6;
        factor      = 1;
        Signal.BW          = 50e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 1;
    case '5G_NR_OFDM_200MHz'
        InI_beforeDPD_path = '5G_signal_I_64QAM_200MHz_1e9GSaps.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_200MHz_1e9GSaps.txt';
        Signal.PAPR_limit  = 11;
        factor      = 1;
        Signal.BW          = 200e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 3;
    case '5G_NR_OFDM_100MHz'
        InI_beforeDPD_path = '5G_signal_I_64QAM_100MHz_1e9GSaps.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_100MHz_1e9GSaps.txt';
        Signal.PAPR_limit  = 11;
        factor      = 1;
        Signal.BW          = 100e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 2;
    case '5G_NR_OFDM_400MHz'
        InI_beforeDPD_path = '5G_signal_I_64QAM_400MHz_1e9GSaps.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_400MHz_1e9GSaps.txt';
        Signal.PAPR_limit  = 11;
        factor      = 1;
        Signal.BW          = 400e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 3;
    case '5G_NR_OFDM_50MHz_64QAM_Pilots'
        InI_beforeDPD_path = '5G_signal_I_64QAM_50MHz_1e9GSaps_With_Pilots.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_50MHz_1e9GSaps_With_Pilots.txt';
        Signal.PAPR_limit  = 9.5;
        factor      = 1;
        Signal.BW          = 400e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 1;
    case '5G_NR_OFDM_200MHz_64QAM_Pilots'
        InI_beforeDPD_path = '5G_signal_I_64QAM_200MHz_1e9GSaps_With_Pilots.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_200MHz_1e9GSaps_With_Pilots.txt';
        Signal.PAPR_limit  = 9.5;
        factor      = 1;
        Signal.BW          = 200e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 3;
    case '5G_NR_OFDM_200MHz_256QAM_Pilots'
        InI_beforeDPD_path = '5G_signal_I_256QAM_400MHz_1e9GSaps_With_Pilots.txt';
        InQ_beforeDPD_path = '5G_signal_Q_256QAM_400MHz_1e9GSaps_With_Pilots.txt';
        Signal.PAPR_limit  = 9.5;
        factor      = 1;
        Signal.BW          = 200e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 3;
    case '5G_NR_OFDM_400MHz_64QAM_Pilots'
        InI_beforeDPD_path = '5G_signal_I_64QAM_400MHz_1e9GSaps_With_Pilots.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_400MHz_1e9GSaps_With_Pilots.txt';
        Signal.PAPR_limit  = 9.5;
        factor      = 1;
        Signal.BW          = 400e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 3;
    case '5G_NR_OFDM_400MHz_256QAM_Pilots'
        InI_beforeDPD_path = '5G_signal_I_256QAM_400MHz_1e9GSaps_With_Pilots.txt';
        InQ_beforeDPD_path = '5G_signal_Q_256QAM_400MHz_1e9GSaps_With_Pilots.txt';
        Signal.PAPR_limit  = 9.5;
        factor      = 1;
        Signal.BW          = 400e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 3;
    case '5G_NR_OFDM_800MHz_64QAM_Pilots'
        InI_beforeDPD_path = '5G_signal_I_64QAM_800MHz_1e9GSaps_With_Pilots.txt';
        InQ_beforeDPD_path = '5G_signal_Q_64QAM_800MHz_1e9GSaps_With_Pilots.txt';
        Signal.PAPR_limit  = 9.5;
        factor      = 1;
        Signal.BW          = 800e6; 
        Signal.Fsample     = 1e09;  
        upsamplingFactor   = 3;
    case '5G_NR_OFDM_800MHz_256QAM_Pilots'
        InI_beforeDPD_path = '5G_signal_I_256QAM_800MHz_2e9GSaps_With_Pilots_1.txt';
        InQ_beforeDPD_path = '5G_signal_Q_256QAM_800MHz_2e9GSaps_With_Pilots_1.txt';
        Signal.PAPR_limit  = 9.5;
        factor      = 1;
        Signal.BW          = 800e6; 
        Signal.Fsample     = 2e09;  
        upsamplingFactor   = 3;
        downsamplingFactor = 2;
    otherwise   
        error('Unknown Signal Name');
end

In_I_ori = load(['Signals\' InI_beforeDPD_path]); In_I_ori = In_I_ori(:, 1);
In_Q_ori = load(['Signals\' InQ_beforeDPD_path]); In_Q_ori = In_Q_ori(:, 1);

In_ori     = complex(In_I_ori, In_Q_ori );

clear In_I_ori In_Q_ori
else 
    data = load('64QAM_160MHz_1r6GSaps');
    In_ori     = data.In_complex;
    Signal.PAPR_limit  = 7.38;
    factor      = 1;
    Signal.BW          = data.SampleRate/factor;
    Signal.Fsample   = data.Fsample/factor;
    upsamplingFactor = 1;
    downsamplingFactor = 1;
end
% In_I_ori  = resample(In_I_ori, 4, 5);
% In_Q_ori  = resample(In_Q_ori, 4, 5);
% Signal.Fsample = 1e9;
% Perform any Upsampling or Downsampling on the Signal
In_ori         = resample(In_ori, upsamplingFactor, downsamplingFactor, 1000);
Signal.Fsample = Signal.Fsample * upsamplingFactor / downsamplingFactor;
if (Signal.RemoveDCFlag)
    In_ori = In_ori - mean(In_ori);
end
% Total frame time for the modulated signal and ensures that the minimum
% segment length is met
[TX.AWG.Upsample, TX.AWG.Downsample]     = rat(TX.AWG.FsampleDAC / Signal.Fsample);
TX.FrameTime                   = TX.AWG.NumberOfSegments * TX.AWG.MinimumSegmentLength / (Signal.Fsample * TX.AWG.Upsample / TX.AWG.Downsample); 
min_size = length(In_ori);
if min_size > round(TX.FrameTime*Signal.Fsample) + 1
    min_size = round(TX.FrameTime*Signal.Fsample);
end
In_ori  = In_ori(1:min_size);
In_ori= digital_lpf(In_ori, Signal.Fsample, Signal.BW/2);