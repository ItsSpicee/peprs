        if TX.AWG.Position  == 1
            [s2_D] = ApplyDelay(s2,Signal.Fsample,1000,3,25,12 / 1e6);
            if length(Out_D_EVM) > length(s2_D);
                s1_D = Out_D_EVM(1:length(s2_D));
            else
                s2_D = s2_D(1:length(Out_D_EVM));
                s1_D = Out_D_EVM;
            end
            sin = In_ori_EVM+s2;
        else
            [s1_D] = ApplyDelay(s1,Signal.Fsample,1000,3,25,12 / 1e6);
            s2_D = Out_D_EVM(1:length(s1_D));
            sin = In_ori_EVM+s1;
        end

        sout = s1_D+s2_D;
        [sin, sout] = AdjustDelay(sin,sout,Signal.Fsample,5000);
        [sin, sout] = AdjustPowerAndPhase(sin,sout,0); 
        [sin, sout] = AdjustPowerAndPhase(sin,sout,0); 
        PlotSpectrum(sin,sout,Signal.Fsample)
        PlotGain(sin,sout);
        PlotAMPM(sin,sout);
        [combinedEVMdB, combinedEVMperc] = CalculateEVM(sin,sout)
        
        PlotGain(In_D_EVM.^2,Out_D_EVM);
        PlotAMAM(In_D_EVM,Out_D_EVM);
        PlotAMPM(In_D_EVM.^2,Out_D_EVM);
        PlotDFT(In_D_EVM,Out_D_EVM,1e9)