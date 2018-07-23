function [WaveformArray] = ADC_capture_bel(repeat,M9703A_Obj, Channel1, PointsPerRecord, FullScaleRange, ACDCCoupling, interleaving_flag, Fs_adc)
    
%     if interleaving_flag == 1
%         Fs_adc = 2e9;
%     else
%         Fs_adc = 1e9;
%     end

    %Fs_adc = 
    
%     res = Fs_adc/PointsPerRecord;    disp(['ADC Frequency Resolution: ' num2str(res)]);
    
    %data_discard  = 100000; % get rid of the first quarter to avoide system intialization errors.
    %WaveformArray = zeros(repeat ,PointsPerRecord - data_discard + 1);
    WaveformArray = zeros(repeat ,PointsPerRecord);
    %display('Start of ADC Measurment');
    tic
    for i = 1: repeat 
        display(['    ' 'Measurment' num2str(i) '/' num2str(repeat)])
        WaveformArray(i, :) = M9703A_Acquisition_bel(M9703A_Obj, Channel1, ...
            PointsPerRecord, Fs_adc, FullScaleRange, ACDCCoupling, interleaving_flag);
%         if i == 1
%             ps_bel(WaveformArray(1, :), Fs_adc, 0);
%         end
    end
%     time = toc;
%     display(['End of ADC Measurment. Time: ' num2str(time) ' S']);
    % Saving the data
%     d = date;
%     c = clock;
%     name_file = [d(4:6) d(1:2) '_' num2str(c(4)) num2str(c(5)) string_save '_ADC_raw_data'];
%     save(name_file, 'WaveformArray', 'Fs_adc');
%     %
%     display(['File ' name_file ' saved!'])
end

