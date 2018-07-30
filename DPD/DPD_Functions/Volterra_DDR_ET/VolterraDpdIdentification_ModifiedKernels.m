function [ kernel , NbCoeff ] = VolterraDpdIdentification_ModifiedKernels( VolterraParameters )
    VolterraParameters    
    kernel = textread( VolterraParameters.ModifiedFile , '%s' , 'delimiter' , '\n' , 'whitespace' , '' ) ;
    kernel = str2mat( kernel ) ;
    
    K = cell( 11 , 1 ) ;
    [ L , auxaux ] = size( kernel ) ;
    j = 0 ;
    NbCoeff = 0 ;
    
    for i = 1 : L
        if strcmp( kernel( i , 1 : 7 ) , 'kernel ' )
            j = j + 1 ;
        elseif ~isempty( str2num( kernel( i ,  : ) ) ) 
            NbCoeff = NbCoeff + 1 ;
            K{ j , 1 } = [ K{ j , 1 } ; str2num( kernel( i , : ) ) ] ;
        end
    end
    
    kernel = K ;