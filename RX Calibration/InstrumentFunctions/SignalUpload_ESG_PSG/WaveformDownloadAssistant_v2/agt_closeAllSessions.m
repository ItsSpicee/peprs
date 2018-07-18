function agt_closeAllSessions
% PSG/ESG Download Assistant, Version 2.0
% Copyright (C) 2005 Agilent Technologies, Inc.
%
% function agt_closeAllSessions
% The function closes all open instrument IO sessions.
%
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end