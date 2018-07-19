function Envelope_Upload_AWG_M8190A (InI, InQ, Fsample, DAC_SamplingRate,shaping,channel)

Env = abs(InI + 1i*InQ);
Env = Env./max(Env);

if shaping == 8
    a0 = 0.4; a2 = 0.7; a4 = 1-a0-a2;
elseif shaping == 9
    a0 = 0.339; a2 = 0.801; a4 = 1-a0-a2;
elseif shaping == 10
    a0 = 0.25; a2 = 1.1; a4 = 1-a0-a2;
end

Env_shaped = a0 + a2*Env.^2 + a4*Env.^4;

disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'); 
disp([' Peak of the Envelope     = ', num2str(max(Env_shaped))]);
disp([' Average of the Envelope  = ', num2str(mean(Env_shaped))]);
disp([' PAPR of the Envelope     = ', num2str(20*log10(max(Env_shaped)/mean(Env_shaped)))]);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'); 

ComplexSignal{1} = Env_shaped;
Fcarrier_array{1} = 0 ;
FsampleTx_array{1} = Fsample ;

% if channel == 2
AWG_M8190A_SignalUpload_ChannelSelect(ComplexSignal, Fcarrier_array, FsampleTx_array, DAC_SamplingRate, false, false,channel);
% end
% if channel == 1
%     AWG_M8190A_SignalUpload(ComplexSignal, Fcarrier_array, FsampleTx_array, DAC_SamplingRate, false, false);
% end
% if channel == 0 
%     AWG_M8190A_SignalUpload(ComplexSignal, Fcarrier_array, FsampleTx_array, DAC_SamplingRate, false, false);
%     AWG_M8190A_SignalUpload_Channel2(ComplexSignal, Fcarrier_array, FsampleTx_array, DAC_SamplingRate, false, false);
% end

end