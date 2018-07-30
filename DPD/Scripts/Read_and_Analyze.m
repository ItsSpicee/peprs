SubRate     = 1;
file_name    = 'Measurement25-Nov-2016_8_24_12';
dir_name     = ['./Measurements/' file_name];
string_name = 'half_final';
cd (dir_name);


I_in_no     =  load('I_Input_NoDPD_1.txt');
Q_in_no     =  load('Q_Input_NoDPD_1.txt');
% I_out_no    =  load('I_Output_WithoutDPD.txt');
% Q_out_no    =  load('Q_Output_WithoutDPD.txt');

I_in_with   =  load('I_Input_PreDist_1.txt');
Q_in_with   =  load('Q_Input_PreDist_1.txt');
I_out_with  =  load('I_Output_WithDPD_1.txt');
Q_out_with  =  load('Q_Output_WithDPD_1.txt');

In_no       = complex(I_in_no, Q_in_no);
% Out_no      = complex(I_out_no, Q_out_no);
In_with     = complex(I_in_with, Q_in_with);
Out_with    = complex(I_out_with, Q_out_with); 

%% With No Predistortion
In = In_with;
Rec = Out_with;
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Input Signal']);
CheckPower(In,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Output Signal']);
CheckPower(Rec,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
[In, Out]    = UnifyLength(In, Rec, SubRate);
[In_D,Out_D] = AdjustDelayFrac(In, Out, 53, false, SubRate);
% TODO: Sometimes two AdjustPhase is needed
[In_D,Out_D] = AdjustPhase(In_D,Out_D,false,SubRate);
PlotGain(In_D(1:SubRate:end), Out_D, [string_name 'amam_nodpd']);
PlotAMPM(In_D(1:SubRate:end), Out_D, [string_name 'amap_nodpd']);
% PlotSpectrum(In_D(1:SubRate:end), Out_D, Fs);
% [freq, spectrum]   = CalculatedSpectrum(Out_D,Fs);
% [ACLR_L, ACLR_U]   = CalculateACLR(freq, spectrum, 0, BW, fG);
% [ACPR_L, ACPR_U]   = CalculateACPR(freq, spectrum, 0, BW, fG);
%% With Predistortion
In = In_no;
Rec = Out_with;
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Input Signal']);
CheckPower(In,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp([' Output Signal']);
CheckPower(Rec,1);
disp(' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
[In, Out]    = UnifyLength(In, Rec, SubRate);
[In_D,Out_D] = AdjustDelayFrac(In, Out, 53, false, SubRate);
% TODO: Sometimes two AdjustPhase is needed
[In_D,Out_D] = AdjustPhase(In_D,Out_D,false,SubRate);
start_indx = 20;
PlotGain(In_D((start_indx- 1) * SubRate + 1 :SubRate:end), Out_D(start_indx:end), [string_name 'amam_withdpd']);
PlotAMPM(In_D((start_indx- 1) * SubRate + 1 :SubRate:end), Out_D(start_indx:end), [string_name 'amap_withdpd'] );
% PlotSpectrum(In_D(1:SubRate:end), Out_D, Fs);
% [freq, spectrum]   = CalculatedSpectrum(Out_D,Fs);
% [ACLR_L, ACLR_U]   = CalculateACLR(freq, spectrum, 0, BW, fG);
% [ACPR_L, ACPR_U]   = CalculateACPR(freq, spectrum, 0, BW, fG);

cd ../../
