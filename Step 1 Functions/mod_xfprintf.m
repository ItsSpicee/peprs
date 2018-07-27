function error = mod_xfprintf(f, s, ignoreError)
% Send the string s to the instrument object f
% and check the error status
% if ignoreError is set, the result of :syst:err is ignored
% returns 0 for success, -1 for errors

    error = "";
    % set debugScpi=1 in MATLAB workspace to log SCPI commands
    if (evalin('base', 'exist(''debugScpi'', ''var'')'))
        fprintf('cmd = %s\n', s);
    end
    fprintf(f, s);
    result = query(f, ':syst:err?');
    if (isempty(result))
        fclose(f);
        error = 'The M8190A firmware did not respond to a :SYST:ERRor query. Please check that the firmware is running and responding to commands.';
        return;
    end
    if (~exist('ignoreError', 'var') || ignoreError == 0)
        while (~strncmp(result, '0,No error', 10) && ~strncmp(result, '0,"No error"', 12))
            error = sprintf('M8190A firmware returns an error on command: %s\n\n Error Message:%s',s,result);
            result = query(f, ':syst:err?');
        end
    end
