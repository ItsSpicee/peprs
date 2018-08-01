function Preview_Signal()   
    load(".\DPD Data\Signal Generation Parameters\Signal.mat")
    load('.\DPD Data\Signal Generation Parameters\TX.mat')
    EVM_flag = 0;
    SignalName = Signal.Name;
    ReadInputFiles
    for i = 1:10
        Y = LimitPAPR(In_ori, Signal.PAPR_limit);
        %CheckPower(Y, 1);
        Y_filtered= digital_lpf(Y, Signal.Fsample, Signal.BW/2);
        %CheckPower(Y_filtered, 1);
        In_ori = Y_filtered;
    end
    
    Plot_Prechar_Spectrum(In_ori, In_ori, Signal.Fsample);
    clear Y_filtered Y
end