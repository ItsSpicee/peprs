%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Making measurement directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SigGen.MeasurementResultsDir = 'Signal_Generation_Measurements';
if (~exist(SigGen.MeasurementResultsDir,'dir'))
    mkdir(SigGen.MeasurementResultsDir);
    addpath(genpath(SigGen.MeasurementResultsDir));
end
cd(SigGen.MeasurementResultsDir);
time_now = clock;
dir_name = strcat('Measurement',date,'_',int2str(time_now(4)),'_',int2str(time_now(5)),'_',int2str(time_now(6)));
mkdir(dir_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Writing files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(dir_name)
try 
%     save('SAMeas.mat', 'SAMeas');
    %%%% Input signal
    fidIEH = fopen(['I_Input_NoDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(In_ori));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Input_NoDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(In_ori));
    fclose(fidIEH);
    %%%% Output
    fidIEH = fopen(['I_Output_WithDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(Rec));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Output_WithDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(Rec));
catch  ME
    disp(ME);
end
fclose(fidIEH);
cd ..
cd ..
