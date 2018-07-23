function [Continue_Flag] = Confirmation_Dialogue(dlg_ques,dlg_title)

Continue_Flag = 0;
while Continue_Flag == 0
    choice_LO_ON = questdlg(dlg_ques, dlg_title, 'Yes','No','Abort','No');
    % Handle response
    switch choice_LO_ON
        case 'Yes'
            disp(['LO turned on. Continuing...'])
            Continue_Flag = 1;                    
        case 'No'
            disp(['Cannot Proceed without LO...'])
            Continue_Flag = 0;
            pause(1)
        case 'Abort'
            disp(['Aborting Operation...'])
            Continue_Flag = -1;
    end
end        

end