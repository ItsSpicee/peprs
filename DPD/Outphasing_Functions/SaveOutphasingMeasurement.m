EVM_perc_withOutphasing = EVM_perc;
ACLR_L_withOutphasing = ACLR_L;
ACLR_U_withOutphasing = ACLR_U;
ACPR_L_withOutphasing = ACPR_L;
ACPR_U_withOutphasing = ACPR_U;
[~, ~, PAPRin_withOutphasing] = CheckPower(In_ori,0);
[~, ~, PAPRout_withOutphasing] = CheckPower(Rec,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Making measurement directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DPD.MeasurementResultsDir = 'Outphasing_Measurements';
if (~exist(DPD.MeasurementResultsDir,'dir'))
    mkdir(DPD.MeasurementResultsDir);
    addpath(genpath(DPD.MeasurementResultsDir));
end
cd(DPD.MeasurementResultsDir);
time_now = clock;
dir_name = strcat('Measurement',date,'_',int2str(time_now(4)),'_',int2str(time_now(5)),'_',int2str(time_now(6)));
mkdir(dir_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Writing files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(dir_name)
try 
    %%%% Input signal before DPD
    fidIEH = fopen(['I_Input_NoDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(In_ori_EVM));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Input_NoDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(In_ori_EVM));
    fclose(fidIEH);
    %%%% Output with DPD
    fidIEH = fopen(['I_Output_WithOutphasing_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(Rec));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Output_WithOutphasing_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(Rec));
catch  ME
    disp(ME);
end
fclose(fidIEH);
cd ..
cd ..