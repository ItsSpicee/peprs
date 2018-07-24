function [ G ] = CascadeImbalanceFilters_FreqDomain ( G1, G2 )
    G.G11 = G1.G11 .* G2.G11 + G1.G12 .* G2.G21;
    G.G12 = G1.G11 .* G2.G12 + G1.G12 .* G2.G22;
    G.G21 = G1.G21 .* G2.G11 + G1.G22 .* G2.G21;
    G.G22 = G1.G21 .* G2.G12 + G1.G22 .* G2.G22; 
end