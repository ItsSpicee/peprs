if despurFlag == 1
    scopeSpurStart = -0.5e9;
    scopeSpurSpacing = 250e6;
    scopeSpurEnd = 0.5e9;
    [Rec]  = RemoveScopeSpurs(Rec, Signal.Fsample, scopeSpurStart, scopeSpurEnd, scopeSpurSpacing, 2);           
    scopeSpurStart = -0.374e9;
    scopeSpurSpacing = 250e6;
    scopeSpurEnd = 0.376e9;
    [Rec]  = RemoveScopeSpurs(Rec, Signal.Fsample, scopeSpurStart, scopeSpurEnd, scopeSpurSpacing, 2);           
end