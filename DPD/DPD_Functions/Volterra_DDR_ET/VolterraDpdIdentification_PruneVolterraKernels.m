function [ kernel , NbCoeff ] = VolterraDpdIdentification_PruneVolterraKernels( VolterraParameters )
    DebugPrint( 'Reduce number of Coefficients using DDR' ) ; 
    R      = VolterraParameters.DDRorder ;
    kernel = VolterraParameters.Kernel   ;
%% 1st Kernel
    if R == 0
        DebugPrint( 'Reduction of kernal #1' ) ;
        %tic
        kernel{ 1 } = [ ] ;
        DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;
    end
%% 3rd Kernel
	K = 0 ;
    if ~isempty( kernel{ 3 } )
        DebugPrint( 'Reduction of kernal #3' ) ;
        %tic
        [ L , auxaux ] = size( kernel{ 3 } );
        for k = 1 : L
            c = 0     ;
            K = K + 1 ;
            % Count the number of delays ( ~= 0 ) higher than R
            for m = 1 : 3
                if kernel{ 3 }(K , m ) ~= 0
                    c = c + 1 ;
                end
            end
            % If the number of delays is higher than R, so eliminate the row
            if c > R
                kernel{ 3 }( K , : ) = [ ] ;
                K = K - 1 ;
            end
        end
        DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;
    end
%% 5th Kernel
    K = 0 ;
    if ~isempty( kernel{ 5 } )
        DebugPrint( 'Reduction of kernal #5' ) ; 
        %tic
        [ L , auxaux ] = size( kernel{ 5 } );
        for k = 1 : L
            c = 0 ;
            K = K + 1 ;
            for m = 1 : 5
                if kernel{ 5 }( K , m ) ~= 0
                    c = c + 1 ;
                end
            end
            if c > R
                kernel{ 5 }( K , : ) = [ ] ;
                K = K - 1 ;
            end
        end
        DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;
    end
%% 7th Kernel
	K = 0 ;
    if ~isempty( kernel{ 7 } )
        DebugPrint( 'Reduction of kernal #7' ) ;
        %tic
        [ L , auxaux ] = size( kernel{ 7 } );
        for k = 1 : L
            c = 0 ;
            K = K + 1 ;
            for m = 1:7
                if kernel{ 7 }( K , m ) ~= 0
                    c = c + 1 ;
                end
            end
            if c > R
                kernel{ 7 }( K , : ) = [ ] ;
                K = K - 1 ;
            end
        end
        DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;        
    end
%% 9th Kernel
	K = 0;
    if ~isempty( kernel{ 9 } )
        DebugPrint( 'Reduction of kernal #9' ) ; 
        %tic
        [ L , auxaux ] = size( kernel{ 9 } );
        for k = 1 : L
            c = 0 ;
            K = K + 1 ;
            for m = 1 : 9
                if kernel{ 9 }( K , m ) ~= 0
                    c = c + 1 ;
                end
            end
            if c > R
                kernel{ 9 }( K , : ) = [ ] ;
                K = K - 1 ;
            end
        end
        DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;
    end
%% 11th Kernel
	K = 0;
    if ~isempty( kernel{ 11 } )
        DebugPrint( 'Reduction of kernal #11' ) ;
        %tic
        [ L , auxaux ] = size( kernel{ 11 } );
        for k = 1:L
        	c = 0 ;
            K = K + 1 ;
            for m = 1 : 11
            	if kernel{ 11 }( K , m ) ~= 0
                    c = c + 1 ;
                end
            end
            if c > R
                kernel{ 11 }( K , : ) = [ ] ;
                K = K - 1 ;
            end
        end
        DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;
    end
%% Number of Coefficient
    DebugPrint('Calculate Number of Coefficients'); 
    %tic
    NbCoeff = 0 ;
    for i = 1 : 2 : 11
        [ aux , auxaux ] = size( kernel{ i } ) ;
        NbCoeff = NbCoeff + aux ;
    end
    NbCoeff = NbCoeff +  VolterraParameters.Static ;
    DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;