function [ WaveformArray ] = Phase_Power_Alignmnet_bel( WaveformArray )
%PHASE_POWER_ALIGNMNET_BEL Summary of this function goes here
%   Detailed explanation goes here
    [N, L] = size(WaveformArray);
    ref_norm                    = SetMeanPower(WaveformArray(1,:), 0);
    %ref_norm                    = complex(ref_norm_I, ref_norm_Q);
    WaveformArray(1, :)         = ref_norm;
    %checkPower(ref_norm_I, ref_norm_Q,1);
    for i = 2:N
        temp = WaveformArray(i,:);
        [~, WaveformArray(i, :), ~, ~] = AdjustPowerAndPhase(ref_norm, temp,0);
    end
end

