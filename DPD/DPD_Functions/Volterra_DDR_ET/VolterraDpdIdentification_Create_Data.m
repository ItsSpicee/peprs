function data = VolterraDpdIdentification_Create_Data(In_I,In_Q,Out_I,Out_Q)
    % Input and Output Waveforms
        data.In_I = In_I; data.Out_I = Out_I;
        data.In_Q = In_Q; data.Out_Q = Out_Q;
    % Complex signal
        data.Vin  = complex(In_I ,In_Q );
        data.Vout = complex(Out_I,Out_Q);
    % Amplitude
        data.Rin  = abs(data.Vin );
        data.Rout = abs(data.Vout);
    % Phase
        data.Phin  = angle(data.Vin );
        data.Phout = angle(data.Vout);
    % Power
        data.Pin  = 10*log10(data.Rin.^2 /100)+30;
        data.Pout = 10*log10(data.Rout.^2/100)+30;
    % Aveage power
        data.AvgPin  = mean(data.Pin);
        data.AvgPout = mean(data.Pout);
    % Normalize the data
        data.Offset = data.AvgPout - data.AvgPin;
