function [ kernel , NbCoeff ] = VolterraDpdIdentification_GenerateVolterraKernels( VolterraParameters )
    kernel = cell( 11, 1 ) ;
    NbCoeff = 0;
    for i = 1 : 2 : 11
        if VolterraParameters.Order( i )
            %tic
            DebugPrint( [ 'Creating kernal #' num2str( i ) ] ) ;
            kernel{ i } = VolterraDpdIdentification_Volterra_Create_Kernels( i, VolterraParameters.Order( i ) ) ;
            [aux, auxaux] = size(kernel{i});
            NbCoeff = NbCoeff + aux;
            % DebugPrint( [ '  ------>  ' num2str(toc) 's' ] ) ;
        end
    end
    NbCoeff = NbCoeff + VolterraParameters.Static ;