%% Apply DPD
switch DPD.Type
    case 'Volterra_DDR'
        Pr = VolterraDpdApply_ET(In_ori_EVM_rx_calibrated, abs(In_ori_EVM), VolterraETParameters, VolterraCoeff);
    case 'APD'
        Pr = APD_Apply(In_ori_EVM_rx_calibrated, APD_modelParam, APD_coef);
    case 'FIR_APD'
        Pr = FIR_APD_Apply(In_ori_EVM_rx_calibrated, FIR_APD_modelParam, FIR_APD_coef);
    case 'DirectLearning_Volterra'
        Pr = VolterraDpdApply_ET(In_ori_EVM_rx_calibrated, abs(In_ori_EVM), DL_VolterraParameters, DL_Volterra_coef);
    case {'DirectLearning_APD', 'DirectLearning_APD_FW'}
        if (DPD.CascadeDPDFlag)
            In_ori = APD_Apply(finalPr, DL_APD_modelParam);
        else
            In_ori = APD_Apply(In_ori_EVM_rx_calibrated, DL_APD_modelParam);
        end
        memTrunc = length(In_ori_EVM_rx_calibrated) - length(In_ori);
        In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];
    case 'DirectLearning_MagAPD'
        if IterationCount >= DL_APD_modelParam.g2.ActivateIter
            In_ori = APD_Apply(In_ori_EVM_rx_calibrated, DL_APD_modelParam.g2);
            memTrunc = length(In_ori_EVM_rx_calibrated) - length(In_ori);
        	In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];
        else
            In_ori = In_ori_EVM_rx_calibrated;
        end
        In_ori = APD_Apply(In_ori, DL_APD_modelParam.g1);
        memTrunc = length(In_ori_EVM_rx_calibrated) - length(In_ori);
        In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];
    case 'SquareRootBasis'
        if IterationCount >= DL_APD_modelParam.g2.ActivateIter
            if (DL_APD_modelParam.FilterBasisFlag)
                In_ori = APD_Apply(In_ori_EVM_rx_calibrated, DL_APD_modelParam.g2, DL_APD_modelParam.Num);
            else
                In_ori = APD_Apply(In_ori_EVM_rx_calibrated, DL_APD_modelParam.g2);
            end
            memTrunc = length(In_ori_EVM_rx_calibrated) - length(In_ori);
        	In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];
        else
            In_ori = In_ori_EVM_rx_calibrated;
        end
        In_ori = SetMeanPower(In_ori,0);
       
        if (DL_APD_modelParam.FilterBasisFlag)
            In_ori = APD_Apply(abs(In_ori).^(1/DL_APD_modelParam.g1.RootOrder) .* exp(1i * unwrap(angle(In_ori), pi) ./ DL_APD_modelParam.g1.RootOrder), DL_APD_modelParam.g1, DL_APD_modelParam.Num);
        else
            In_ori = APD_Apply(abs(In_ori).^(1/DL_APD_modelParam.g1.RootOrder) .* exp(1i * unwrap(angle(In_ori), pi) ./ DL_APD_modelParam.g1.RootOrder), DL_APD_modelParam.g1);
        end
        memTrunc = length(In_ori_EVM_rx_calibrated) - length(In_ori);
        In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];
    case {'test'}
        In_ori = APD_Apply(In_ori_EVM_rx_calibrated, DL_APD_modelParam.g1);
        CheckPower(In_ori,1);
        %% g2
        if DL_APD_modelParam.activateG2
            p = 1;
            u2 = APD_Apply(In_ori_EVM_rx_calibrated, DL_APD_modelParam.g2);
            if (length(u2) > length(In_ori))
                memTrunc = length(u2) - length(In_ori);
                In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];
            else
                memTrunc = length(In_ori) - length(u2);
                u2 = [u2((end-(memTrunc-1)):end,1); u2];
            end
        else
            p = 0;
            u2 = 0;
        end
%         In_ori = SetMeanPower
        In_ori_mag = abs(In_ori).^(1/TX.FreqMultiplier.Factor);
        In_ori_phase = unwrap(angle(In_ori))/TX.FreqMultiplier.Factor;
        In_ori = In_ori_mag .* exp(1i*In_ori_phase);
        In_ori = In_ori + u2;
%%
        
%         In_ori = APD_Apply(In_ori_EVM_rx_calibrated, DL_APD_modelParam,DL_APD_modelParam.Num);
%         [ In_ori ] = ApplyBBEVDModel( In_ori_EVM_rx_calibrated, Basis, DL_APD_modelParam, DL_APD_modelParam.MaxM);
end

% if DPD.CheckModelFlag
%     switch DPD.Type
%         case 'SquareRootBasis'
%             [Out_model] = APD_Apply(In_D_EVM,DL_APD_modelParam.g2);
%             [Out_model] = APD_Apply(abs(Out_model).^(1/2) .* exp(1i * unwrap(angle(Out_model), pi) ./ 2),DL_APD_modelParam.g1);
%         %     [Out_model] = APD_Apply(In_D_EVM,DL_APD_modelParam,DL_APD_modelParam.Num);
%             [~]      = ModelCheck(In_D_EVM(memTrunc+1:end), Out_D_EVM(memTrunc+1:end), Out_model);
% 
%         otherwise
%             [Out_model] = APD_Apply(In_D_EVM,DL_APD_modelParam);
%             [~]      = ModelCheck(In_D_EVM(memTrunc+1:end), Out_D_EVM(memTrunc+1:end), Out_model);
%     end
% end

memTrunc = length(In_ori_EVM_rx_calibrated) - length(In_ori);
In_ori = resample(In_ori,Signal.DownsampleRX,Signal.UpsampleRX);

% In_ori = [In_ori((end-(memTrunc-1)):end,1); In_ori];
% In_ori_mag = abs(In_ori_EVM).^(1/TX.FreqMultiplier.Factor);
% In_ori_phase = unwrap(angle(In_ori_EVM))/TX.FreqMultiplier.Factor;
% In_ori = In_ori + In_ori_mag .* exp(1i*In_ori_phase);

disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Predistorted Signal']);
CheckPower(In_ori, 1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%%

clear In_D_EVM Out_D_EVM Out_model