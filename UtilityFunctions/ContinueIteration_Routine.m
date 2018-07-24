function [next_iteration, KEEP_RF_ON]  = ContinueIteration_Routine

choice = questdlg('Do you want to do another iteration?', ...
    'Another Iteration', ...
    'Yes','No','Yes with RF ON','No');
% Handle response
switch choice
    case 'Yes'
        disp('Continure to Next Iteration')
        next_iteration = 1;
        KEEP_RF_ON = false;
    case 'No'
        disp('Continue to Final DPD Measurements')
        next_iteration = 0;
        KEEP_RF_ON = true;
    case 'Yes with RF ON'
        disp('Continure to Next Iteration')
        next_iteration = 1;
        KEEP_RF_ON = true;
end

end