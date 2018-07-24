function [ Pr ] = Generate_XdB_Expansion ( In , GainExpansion , InflectionPoint)
% Create Artificial gain expansion

    NoOfEntries     = length ( In ) ;
    LinearGain      = sqrt ( 2 ) / 2 - InflectionPoint ^ 2 * GainExpansion ;
    GainExpansion   = 1 / sqrt( 2 ) * 10 ^ ( GainExpansion / 20 ) ;
    InflectionPoint = floor ( InflectionPoint * NoOfEntries ) ;
    
    
    norm = max ( sqrt ( real(In) .^ 2 + imag(In) .^ 2 ) ) ;
    In = In / norm ;    
    
    IQ_addr  = In .* conj(In);
    LUT_addr = floor ( IQ_addr * ( NoOfEntries - 1 ) ) + 1 ;	
	
    %Generate Ic and Qc
    Coeff = zeros( NoOfEntries , 1 ) ;

    % 0 Gain
    Coeff ( 1 : InflectionPoint ) = LinearGain ;
    
    % Gain Expansion
    x  = [ 1          InflectionPoint:(NoOfEntries-InflectionPoint)/2:NoOfEntries ] ;
    y  = [ LinearGain LinearGain (GainExpansion+LinearGain)/2 GainExpansion ] ;
    
    p = polyfit( x , y , 3 ) ;
    X = zeros(4,NoOfEntries);
    for  k = 0 : 3
        X(4-k,:) = ( 1 : NoOfEntries ) .^ k  ;
    end  
    
	Coeff ( 1 : NoOfEntries ) = p * X ;
    
    c = transpose ( Coeff( LUT_addr ) ).' ;
          
    Pr = In .* complex(c, c) ;
