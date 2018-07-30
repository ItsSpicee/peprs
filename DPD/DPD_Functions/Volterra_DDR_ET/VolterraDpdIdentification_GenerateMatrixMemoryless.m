function U = VolterraDpdIdentification_GenerateMatrixMemoryless( data , MemoryOrder , PolyOrder )

    PolyPower = 0 : ( PolyOrder - 1 ) ;
    
    %abs( data )
    X    = repmat(  data       , 1 , PolyOrder ) ;
    AbsX = repmat( abs( data ) , 1 , PolyOrder ) ;
        
    %Power
    Pp = repmat( PolyPower , length( data ) , 1 ) ; 
    
    X = X .* ( AbsX .^ Pp ) ;
    
    U = zeros( length( data ) , ( MemoryOrder + 1 ) * PolyOrder ) ;
    
    U( : , 1 : PolyOrder ) = X ;

    %-- Shift for memory and fill in zeros for specific locations
    for k = 1 : MemoryOrder
        U( : , ( PolyOrder * k  + 1 ) : ( PolyOrder * ( k + 1 ) ) ) = ...
                            [ zeros( k , PolyOrder) ; X( 1 : (end - k ) , : ) ] ;
    end