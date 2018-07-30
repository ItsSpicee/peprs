%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Writing files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('Measurements')
cd(dir_name)
try
    %%%% Output without DPD
    fidIEH = fopen(['I_Output_WithoutDPD.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(Rec));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Output_WithoutDPD.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(Rec));
    fclose(fidIEH);
    
    if (~DPD.CascadeDPDFlag)
    save('finalPredistortedValues', 'finalPr', 'finalMemTrunc', 'finalCoeff');
    else
    save('finalPredistortedValues', 'finalPr', 'finalMemTrunc', 'finalCoeff');
    save('finalPredistortedValues2', 'finalPr2', 'finalMemTrunc2', 'finalCoeff2');
    end
    
    savefig(spectrumFig,'Spectrum')
    save('SpectrumMeasurements','SAMeasResults');
    save('NMSE_vec','NMSE_vec');
    save('EVM_vec','EVMMeasResults');

    savevsarecording('VSA_In_ori.mat', In_ori_EVM, Signal.Fsample, 0);    
    savevsarecording('VSA_Rec_WithoutDPD.mat', Rec, Signal.Fsample, 0);
    savevsarecording('VSA_Out_D_EVM_WithoutDPD.mat', Out_D_EVM, Signal.Fsample, 0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% Wirting Summary file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fidIEH = fopen(['Summary.txt'],'wt');
    fprintf(fidIEH,['DPD type =  ', DPD.Type, '\n ']);
    fprintf(fidIEH,'Carrier Frequency = %4.3f GHz \n ',TX.Fcarrier/1e9);
    fprintf(fidIEH,'Signal BW = %4.3f MHz \n ',Signal.BW/1e6);
    fprintf(fidIEH,['Signal Name (I) = ',InI_beforeDPD_path, '\n ']);
    fprintf(fidIEH,['Signal Name (Q) = ',InQ_beforeDPD_path, '\n ']);
    fprintf(fidIEH,'DPD sampling rate = %4.3f MHz \n ',RX.Fsample/1e6);
    fprintf(fidIEH,'Internal Tx down/upsampling rate = %4.3f / %4.3f \n ',Signal.DownsampleRX,Signal.UpsampleRX);
    fprintf(fidIEH,'DPD Iteration = %4.3f \n ',IterationCount);

    fprintf(fidIEH,'\nWithout DPD Results \n ');
    fprintf(fidIEH,'EVM (%%) = %4.3f \n ',EVM_perc_withoutDPD);
    fprintf(fidIEH,'ACLR_L/ACLR_U = %4.3f / %4.3f \n ',ACLR_L_withoutDPD,ACLR_U_withoutDPD);
    fprintf(fidIEH,'ACPR_L/ACPR_U = %4.3f / %4.3f \n ',ACPR_L_withoutDPD,ACPR_U_withoutDPD);
    fprintf(fidIEH,'PAPRin = %4.3f \n ',PAPRin_withoutDPD);
    fprintf(fidIEH,'PAPRout = %4.3f \n ',PAPRout_withoutDPD);

    fprintf(fidIEH,'\nWith DPD Results \n ');
    fprintf(fidIEH,'EVM (%%) = %4.3f \n ',EVM_perc_withDPD);
    fprintf(fidIEH,'ACLR_L/ACLR_U = %4.3f / %4.3f \n ',ACLR_L_withDPD,ACLR_U_withDPD);
    fprintf(fidIEH,'ACPR_L/ACPR_U = %4.3f / %4.3f \n ',ACPR_L_withDPD,ACPR_U_withDPD);
    fprintf(fidIEH,'PAPRin = %4.3f \n ',PAPRin_withDPD);
    fprintf(fidIEH,'PAPRout = %4.3f \n ',PAPRout_withDPD);

    fprintf(fidIEH,'\nModeling Performance \n ');
    fprintf(fidIEH,'NMSE(dB) = %4.3f \n ',NMSE);

    switch DPD.Type
        case 'Volterra_DDR'
            fprintf(fidIEH,['DPD type =  ', DPD.Type, '\n ']);
            fprintf(fidIEH,'Static NL = %4.3f \n ',VolterraParameters.Static);
            fprintf(fidIEH,'Memory Orders = %4.3f, %4.3f, %4.3f, %4.3f, %4.3f \n ',VolterraParameters.Order(1), VolterraParameters.Order(2), VolterraParameters.Order(3), VolterraParameters.Order(4), VolterraParameters.Order(5));
            fprintf(fidIEH,'Number of coefficients = %4.3f \n ', num_of_coeff);
            fprintf(fidIEH,'Coefficients DR = %4.3f \n ', Coeff_DR);
        case 'DirectLearning_Volterra'
            fprintf(fidIEH,['DPD type =  ', DPD.Type, '\n ']);
            fprintf(fidIEH,'Static NL = %4.3f \n ',DL_VolterraParameters.Static);
            fprintf(fidIEH,'Memory Orders = %4.3f, %4.3f, %4.3f, %4.3f, %4.3f \n ',DL_VolterraParameters.Order(1), DL_VolterraParameters.Order(2), DL_VolterraParameters.Order(3), DL_VolterraParameters.Order(4), DL_VolterraParameters.Order(5));
            fprintf(fidIEH,'Number of coefficients = %4.3f \n ', num_of_coeff);
            fprintf(fidIEH,'Coefficients DR = %4.3f \n ', Coeff_DR);
            fprintf(fidIEH,'SubRate = %4.3f \n ',SubRate_O);
        case 'APD'
            fprintf(fidIEH,['DPD type =  ', DPD.Type, '\n ']);
            fprintf(fidIEH,['Engine = ',APD_modelParam.engine,'\n ']);
            fprintf(fidIEH,'NL = %4.3f \n ',APD_modelParam.N);
            fprintf(fidIEH,'M = %4.3f \n ',APD_modelParam.M);
            fprintf(fidIEH,['Type = ',APD_modelParam.polyorder,'\n ']);
            fprintf(fidIEH,'Use two step identification = %4.3f \n ',APD_modelParam.two_step);
            fprintf(fidIEH,'Number of coefficients = %4.3f \n ', size(APD_coef,1));
            fprintf(fidIEH,'Coefficients DR = %4.3f \n ', Coeff_DR);
        case 'DirectLearning_APD'
            fprintf(fidIEH,['DPD type =  ', DPD.Type, '\n ']);
            fprintf(fidIEH,['Engine = ',DL_APD_modelParam.engine,'\n ']);
            fprintf(fidIEH,'NL = %4.3f \n ',DL_APD_modelParam.N);
            fprintf(fidIEH,'M = %4.3f \n ',DL_APD_modelParam.M);
            fprintf(fidIEH,['Type = ',DL_APD_modelParam.polyorder,'\n ']);
            fprintf(fidIEH,'Use two step identification = %4.3f \n ',DL_APD_modelParam.two_step);
            fprintf(fidIEH,'Number of coefficients = %4.3f \n ', size(DL_APD_coef,1));
            fprintf(fidIEH,'Coefficients DR = %4.3f \n ', Coeff_DR);
            fprintf(fidIEH,'SubRate = %4.3f \n ',SubRate_O);
        case 'FIR_APD'
            fprintf(fidIEH,['DPD type =  ', DPD.Type, '\n ']);
            fprintf(fidIEH,['Engine = ',FIR_APD_modelParam.engine,'\n ']);
            fprintf(fidIEH,'APD_NL = %4.3f \n ',FIR_APD_modelParam.APD_N);
            fprintf(fidIEH,'APD_M = %4.3f \n ',FIR_APD_modelParam.APD_M);
            fprintf(fidIEH,'FIR_M = %4.3f \n ',FIR_APD_modelParam.FIR_M);
            fprintf(fidIEH,['Type = ',FIR_APD_modelParam.polyorder,'\n ']);
            fprintf(fidIEH,'Use two step identification = %4.3f \n ',FIR_APD_modelParam.two_step);
            fprintf(fidIEH,'Number of coefficients = %4.3f \n ', size(FIR_APD_coef,1));
            fprintf(fidIEH,'Coefficients DR = %4.3f \n ', Coeff_DR);
        case 'SquareRootBasis'
            fprintf(fidIEH,['DPD type =  ', DPD.Type, '\n ']);
            fprintf(fidIEH,['G1 Engine = ',DL_APD_modelParam.g1.engine,'\n ']);
            fprintf(fidIEH,'G1 NL = %4.3f \n ',DL_APD_modelParam.g1.N);
            fprintf(fidIEH,'G1 M = %4.3f \n ',DL_APD_modelParam.g1.M);
            fprintf(fidIEH,['G1 Type = ',DL_APD_modelParam.g1.polyorder,'\n ']);
            fprintf(fidIEH,'G1 Use two step identification = %4.3f \n ',DL_APD_modelParam.g1.two_step);
            fprintf(fidIEH,'G1 Number of coefficients = %4.3f \n ', size(DL_APD_modelParam.g1.coef,1));
                       
            fprintf(fidIEH,['G2 Engine = ',DL_APD_modelParam.g2.engine,'\n ']);
            fprintf(fidIEH,'G2 NL = %4.3f \n ',DL_APD_modelParam.g2.N);
            fprintf(fidIEH,'G2 M = %4.3f \n ',DL_APD_modelParam.g2.M);
            fprintf(fidIEH,['G2 Type = ',DL_APD_modelParam.g2.polyorder,'\n ']);
            fprintf(fidIEH,'G2 Use two step identification = %4.3f \n ',DL_APD_modelParam.g2.two_step);
            fprintf(fidIEH,'G2 Number of coefficients = %4.3f \n ', size(DL_APD_modelParam.g2.coef,1));
                        
            fprintf(fidIEH,'G2 Coefficients DR = %4.3f \n ', Coeff_DR);
            fprintf(fidIEH,'SubRate = %4.3f \n ',SubRate_O);
    end
    if Measure_Pout_Eff
        fprintf(fidIEH,'\n');
        fprintf(fidIEH,'With DPD Measurements');
        fprintf(fidIEH,'\nPout  = %4.3f   dBm ', Pout_measured_with_DPD);
        fprintf(fidIEH,'\nVdd   = %4.3f   V', V_m_with_DPD);
        fprintf(fidIEH,'\nIdd   = %4.3f   mA', I_m_with_DPD*1e3);
        fprintf(fidIEH,'\nDE    = %4.3f  %',DE_measured_with_DPD);
        fprintf(fidIEH,'\nPAE   =        %');
        fprintf(fidIEH,'\n');
        fprintf(fidIEH,'Without DPD Measurements');
        fprintf(fidIEH,'\nPout  = %4.3f   dBm ', Pout_measured_without_DPD);
        fprintf(fidIEH,'\nVdd   = % 4.3f   V', V_m_without_DPD);
        fprintf(fidIEH,'\nIdd   = %4.3f   mA', I_m_without_DPD*1e3);
        fprintf(fidIEH,'\nDE    = %4.3f  %',DE_measured_without_DPD);
        fprintf(fidIEH,'\nPAE   =        %');
    else
        fprintf(fidIEH,'\n');
        fprintf(fidIEH,'\nPout   =        dBm');
        fprintf(fidIEH,'\nVdd    = 28     V');
        fprintf(fidIEH,'\nIdd    =        mA');
        fprintf(fidIEH,'\nDE     =        %');
        fprintf(fidIEH,'\nPAE    =        %');
    end
    fclose(fidIEH);
catch ME
    fclose(fidIEH);
    disp(ME);
end
cd ..
cd ..