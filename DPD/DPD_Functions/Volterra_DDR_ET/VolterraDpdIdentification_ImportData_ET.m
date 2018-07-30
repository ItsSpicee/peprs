function [In, Out, Vdd_import] = VolterraDpdIdentification_ImportData_ET(Input, Output, Vdd, PS, CDTRFTB)

% align the length
in = Input; out = Output;
L = min([length(in), length(out)]);
in = in(CDTRFTB:L);
out = out(CDTRFTB:L);

% peak power = 0 dBm
ampY = abs(out);
MaxPowerY = max(ampY .^ 2);
MaxPowerdBX = 10 * log10(MaxPowerY / 100) + 30;
Offset_Out  = 10 ^ (-MaxPowerdBX / 20);
out = out * Offset_Out ;

% set SSG = 0 dB
PowerAvgin  = mean(abs(in).^2);
PowerAvgdBin  = 10 * log10(PowerAvgin / 100) + 30;
PowerAvgout = mean(abs(out).^2);
PowerAvgdBout = 10 * log10(PowerAvgout / 100) + 30;
Offset_In = PowerAvgdBout - PowerAvgdBin;
Offset_In = 10 ^ ( Offset_In / 20 );
In  = in * Offset_In;
Out = out;

% set the avg phase distortion to 0 degree
PhaseOut = angle(Out);
PhaseIn  = angle(In);
PhaseDistortion = (PhaseOut - PhaseIn);
Ind = PhaseDistortion >   pi;
PhaseDistortion = PhaseDistortion - 2 * Ind * pi;
Ind = PhaseDistortion < - pi;
PhaseDistortion = PhaseDistortion + 2 * Ind * pi;
avgPhaseDistortion = mean(PhaseDistortion);
Out = Out * exp(-1i*avgPhaseDistortion);

ampY = abs(Out);
L = length(ampY);
PS0 = find(ampY==max(ampY));

if PS0-PS/2 < 1
    PS    = min(PS,L);
    Range = 1 : PS;
elseif PS0+PS/2 > L
    PS    = max(1,L-PS);
    Range = PS : L;
else
    PS    = round(PS/2);
    Range = PS0-PS : PS0+PS;
end
In  =  In(Range);
Out = Out(Range);
Vdd_import = Vdd(Range);
