%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Making measurement directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DPD.MeasurementResultsDir = 'Measurements';
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
    %%%% PreDistorted Input
    fidIEH = fopen(['I_Input_PreDist_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(In_ori));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Input_PreDist_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(In_ori));
    fclose(fidIEH);
    %%%% Output with DPD
    fidIEH = fopen(['I_Output_WithDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',real(Rec));
    fclose(fidIEH);
    fidIEH = fopen(['Q_Output_WithDPD_1.txt'],'wt');
    fprintf(fidIEH,'%12.20f\n',imag(Rec));

    savevsarecording('VSA_Rec_WithDPD.mat', Rec, Signal.Fsample, 0);
	savevsarecording('VSA_In_ori_EVM.mat', In_ori_EVM, Signal.Fsample, 0);
    savevsarecording('VSA_Out_D_EVM_WithDPD.mat', Out_D_EVM, Signal.Fsample, 0);
catch  ME
    disp(ME);
end
fclose(fidIEH);
cd ..

switch DPD.Type
    case 'SquareRootBasis'
        movefile('../g1_FinalStatistics.mat',dir_name)
end

cd ..