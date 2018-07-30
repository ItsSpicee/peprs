EVM_perc_withoutOutphasing = EVM_perc;
ACLR_L_withoutOutphasing = ACLR_L;
ACLR_U_withoutOutphasing = ACLR_U;
ACPR_L_withoutOutphasing = ACPR_L;
ACPR_U_withoutOutphasing = ACPR_U;
[~, ~, PAPRin_withoutOutphasing] = CheckPower(In_ori,0);
[~, ~, PAPRout_withoutOutphasing] = CheckPower(Rec,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Making measurement directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('Outphasing_Measurements')
cd(dir_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Writing files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try 
    fidIEH = fopen(['Summary.txt'],'wt');
    fprintf(fidIEH,'\nWith Outphasing Cal Results \n ');
    fprintf(fidIEH,'EVM (%%) = %4.3f \n ',EVM_perc_withOutphasing);
    fprintf(fidIEH,'ACLR_L/ACLR_U = %4.3f / %4.3f \n ',ACLR_L_withOutphasing,ACLR_U_withOutphasing);
    fprintf(fidIEH,'ACPR_L/ACPR_U = %4.3f / %4.3f \n ',ACPR_L_withOutphasing,ACPR_U_withOutphasing);
    fprintf(fidIEH,'PAPRin = %4.3f \n ',PAPRin_withOutphasing);
    fprintf(fidIEH,'PAPRout = %4.3f \n ',PAPRout_withOutphasing);

    fprintf(fidIEH,'\nWithout Outphasing Cal Results \n ');
    fprintf(fidIEH,'EVM (%%) = %4.3f \n ',EVM_perc_withoutOutphasing);
    fprintf(fidIEH,'ACLR_L/ACLR_U = %4.3f / %4.3f \n ',ACLR_L_withoutOutphasing,ACLR_U_withoutOutphasing);
    fprintf(fidIEH,'ACPR_L/ACPR_U = %4.3f / %4.3f \n ',ACPR_L_withoutOutphasing,ACPR_U_withoutOutphasing);
    fprintf(fidIEH,'PAPRin = %4.3f \n ',PAPRin_withoutOutphasing);
    fprintf(fidIEH,'PAPRout = %4.3f \n ',PAPRout_withoutOutphasing);
    fclose(fidIEH);

    %%%% Output without Outphasing Cal
    fidIEH = fopen(['I_Output_WithoutOutphasing_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(Rec));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Output_WithoutOutphasing_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(Rec));
    fclose(fidIEH);
catch  ME
    disp(ME);
end

cd ..
cd ..