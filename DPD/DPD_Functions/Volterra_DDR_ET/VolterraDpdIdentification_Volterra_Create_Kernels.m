function h = VolterraDpdIdentification_Volterra_Create_Kernels( order, Mem_depth )
    switch order
        %% --- 1st order
        case 1
            h = transpose( 1 : Mem_depth ) ;
        %% --- 3rd order
        case 3
            % size of the Matrix
            D = ( Mem_depth + 1 ) ^ 3 ;
            % Matrix of the kernel
            A = zeros( D , 3 ) ;
            c1 = 0 ; c2 = 0 ; c3 = 0 ;
            for k = 1 : D ;
                A( k, 3) = c3 ; A( k, 2) = c2 ; A( k, 1) = c1 ;
                c3 = c3 + 1 ;
                if c3 > Mem_depth
                    c3 = 0 ; c2 = c2 + 1 ;
                    if c2 > Mem_depth
                        c2 = 0 ; c1 = c1 + 1 ;
                    end
                end
            end
            A(:,3)    = A(:,3) * 1i   ;   
            for k = 1 : D
                B = sort( A , 2 ) ;
                a =    B( k , : ) ;
                % find lines that are the same
                [ x , y ] = find( ( B( : , 1 ) == a( : , 1 ) ) & ( B( : , 2 ) == a( : , 2 ) ) & ( B( : , 3 ) == a( : , 3 ) ) ) ;
                x( 1     ) = [ ] ;
                A( x , : ) = [ ] ;
                if k == length( A )
                    break
                end
            end
            h3 = A ;
            h3( 1 , : ) = [ ] ;
            h3( : ,  3 ) = h3( : , 3 ) * ( -1i ) ;
            h = h3 ;
        %% --- 5th order
        case 5
            D = ( Mem_depth + 1 ) ^ 5 ;
            A = zeros( D , 5 ) ;
            c1 = 0 ; c2 =  0 ; c3 = 0 ; c4 = 0 ; c5 = 0 ;            
            for k = 1 : D
                A( k , 1 ) = c1      ;
                A( k , 2 ) = c2      ;
                A( k , 3 ) = c3      ;
                A( k , 4 ) = c4 * 1i ;
                A( k , 5 ) = c5 * 1i ;
                c5 = c5 + 1 ;
                if c5 > Mem_depth
                    c5 = 0 ; c4 = c4 + 1 ;
                    if c4 > Mem_depth
                        c4 = 0 ; c3 = c3 + 1 ;
                        if c3 > Mem_depth
                            c3 = 0 ; c2 = c2 + 1 ;
                            if c2 > Mem_depth
                                c2 = 0 ; c1 = c1 + 1 ;
                            end
                        end
                    end
                end
            end
            for k = 1 : D
                B = sort( A , 2 ) ;
                a = B( k , : ); 
                [ x , y ] = find( ...
                                  ( B( : , 1 ) == a( : , 1 ) ) ...
                                & ( B( : , 2 ) == a( : , 2 ) ) ...
                                & ( B( : , 3 ) == a( : , 3 ) ) ...
                                & ( B( : , 4 ) == a( : , 4 ) ) ...
                                & ( B( : , 5 ) == a( : , 5 ) ) );
                x( 1 )     = [ ] ;
                A( x , : ) = [ ] ;
                if k == length( A )
                    break
                end
            end
            h5 = A ;
            h5( 1 , : ) = [ ] ;  
            h5( : , 4 ) = h5( : , 4 ) * ( -1i ) ; 
            h5( : , 5 ) = h5( : , 5 ) * ( -1i ) ;            
            h = h5 ;
        %% --- 7th order            
        case 7
            if Mem_depth == 3   % Read coefficients from file (faster than computing them)
                aux = load( 'Kernel_7_MemDepth_3' ) ;
                h   = aux.Kernel_7_MemDepth_3       ;
            elseif Mem_depth == 4   % Read coefficients from file (faster than computing them)
                aux = load( 'Kernel_7_MemDepth_4' ) ;
                h   = aux.Kernel_7_MemDepth_4       ;
            elseif Mem_depth < 3
                D = ( Mem_depth + 1 ) ^ 7 ;
                A = zeros( D , 7 ) ;
                c1 = 0 ; c2 = 0 ; c3 = 0 ; c4 = 0 ; c5 = 0 ; c6 = 0 ; c7 = 0 ;
                for k = 1 : D
                    A( k , 7 ) = c7 * 1i ;
                    A( k , 6 ) = c6 * 1i ;
                    A( k , 5 ) = c5 * 1i ;
                    A( k , 4 ) = c4      ;
                    A( k , 3 ) = c3      ;
                    A( k , 2 ) = c2      ;
                    A( k , 1 ) = c1      ;
                    c7 = c7 + 1 ;
                    if c7 > Mem_depth
                        c7 = 0 ; c6 = c6 + 1 ;
                        if c6 > Mem_depth
                            c6 = 0 ; c5 = c5 + 1 ;
                            if c5 > Mem_depth
                                c5 = 0 ; c4 = c4 + 1 ;   
                                if c4 > Mem_depth
                                    c4 = 0 ; c3 = c3 + 1 ;  
                                    if c3 > Mem_depth
                                        c3 = 0 ; c2 = c2 + 1 ;
                                        if c2 > Mem_depth
                                            c2 = 0 ; c1 = c1 + 1 ;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for k = 1 : D
                    B = sort( A , 2 ) ;
                    a = B( k , : ) ; 
                    [ x , y ] = find( ...
                                      ( B( : , 1 ) == a( : , 1 ) ) ...
                                    & ( B( : , 2 ) == a( : , 2 ) ) ...
                                    & ( B( : , 3 ) == a( : , 3 ) ) ...
                                    & ( B( : , 4 ) == a( : , 4 ) ) ...
                                    & ( B( : , 5 ) == a( : , 5 ) ) ...
                                    & ( B( : , 6 ) == a( : , 6 ) ) ...
                                    & ( B( : , 7 ) == a( : , 7 ) ) ) ;
                    x( 1 )     = [ ] ;
                    A( x , : ) = [ ] ;
                    if k == length( A )
                        break
                    end
                end
                h7          = A                 ;
                h7( 1 , : ) = [ ]               ;
                h7( : , 5 ) = h7( : , 5 ) * -1i ;
                h7( : , 6 ) = h7( : , 6 ) * -1i ;
                h7( : , 7 ) = h7( : , 7 ) * -1i ;
                h           = h7                ;
            end
        %% --- 9th order            
        case 9
            if Mem_depth == 2   % Read coefficients from file (faster than computing them)
                aux = load( 'Kernel_9_MemDepth_2' ) ;
                h   = aux.Kernel_9_MemDepth_2       ;
            else
                D = ( Mem_depth + 1 ) ^ 9 ;
                A = zeros( D , 9 ) ; 
                c1 = 0 ; c2 = 0 ; c3 = 0 ; c4 = 0 ; c5 = 0 ; c6 = 0 ; c7 = 0 ; c8 = 0 ; c9 = 0 ;
                for k = 1 : D
                    A( k ,9 ) = c9 * 1i ;
                    A( k ,8 ) = c8 * 1i ;
                    A( k ,7 ) = c7 * 1i ;
                    A( k ,6 ) = c6 * 1i ;
                    A( k ,5 ) = c5 ;
                    A( k ,4 ) = c4 ;
                    A( k ,3 ) = c3 ;
                    A( k ,2 ) = c2 ;
                    A( k ,1 ) = c1 ;
                    c9 = c9 + 1 ;
                    if c9 > Mem_depth
                        c9 = 0 ; c8 = c8 + 1 ;
                        if c8 > Mem_depth
                            c8 = 0 ; c7 = c7 + 1 ;
                            if c7 > Mem_depth
                                c7 = 0 ; c6 = c6 + 1 ;
                                if c6 > Mem_depth
                                    c6 = 0 ; c5 = c5 + 1 ;
                                    if c5 > Mem_depth
                                        c5 = 0 ; c4 = c4 + 1 ;   
                                        if c4 > Mem_depth
                                            c4 = 0 ; c3 = c3 + 1 ;  
                                            if c3 > Mem_depth
                                                c3 = 0 ; c2 = c2 + 1 ;
                                                if c2 > Mem_depth
                                                    c2 = 0 ; c1 = c1 + 1 ;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for k = 1 : D
                    B = sort( A , 2 ) ;
                    a = B( k , : ) ;
                    [ x , y ] = find( ...
                                      ( B( : , 1 ) == a( : , 1 ) ) ...
                                    & ( B( : , 2 ) == a( : , 2 ) ) ...
                                    & ( B( : , 3 ) == a( : , 3 ) ) ...
                                    & ( B( : , 4 ) == a( : , 4 ) ) ...
                                    & ( B( : , 5 ) == a( : , 5 ) ) ...
                                    & ( B( : , 6 ) == a( : , 6 ) ) ...
                                    & ( B( : , 7 ) == a( : , 7 ) ) ...
                                    & ( B( : , 8 ) == a( : , 8 ) ) ...
                                    & ( B( : , 9 ) == a( : , 9 ) ) ) ;
                    x( 1 )     = [ ] ;
                    A( x , : ) = [ ] ;
                    if k == length( A )
                        break
                    end
                end
                h9          = A                 ;
                h9( 1 , : ) = [ ]               ;
                h9( : , 6 ) = h9( : , 6 ) * -1i ;
                h9( : , 7 ) = h9( : , 7 ) * -1i ;
                h9( : , 8 ) = h9( : , 8 ) * -1i ;
                h9( : , 9 ) = h9( : , 9 ) * -1i ;
                h           = h9                ;
            end
            %% --- 11th order
        case 11
            if Mem_depth == 2;   % Read coefficients from file (faster than computing them)
                aux = load( 'Kernel_11_MemDepth_2' ) ;
                h   = aux.Kernel_11_MemDepth_2       ;
            else
                D = ( Mem_depth + 1 ) ^ 11;
                A = zeros( D , 11 )       ;
                c1 = 0 ; c2 = 0 ; c3 = 0 ;c4 = 0 ; c5 = 0 ; c6 = 0 ; c7 = 0 ; c8 = 0 ; c9 = 0 ; c10 = 0 ; c11 = 0 ;
                for k = 1 : D 
                    A( k ,11 ) = c11 * 1i ;
                    A( k ,10 ) = c10 * 1i ;
                    A( k ,9  ) = c9  * 1i ;
                    A( k ,8  ) = c8  * 1i ;
                    A( k ,7  ) = c7  * 1i ;
                    A( k ,6  ) = c6       ;
                    A( k ,5  ) = c5       ;
                    A( k ,4  ) = c4       ;
                    A( k ,3  ) = c3       ;
                    A( k ,2  ) = c2       ;
                    A( k ,1  ) = c1       ;
                    c11 = c11 + 1 ;
                    if c11 > Mem_depth
                        c11 = 0 ; c10 = c10 + 1 ;
                        if c10 > Mem_depth
                            c10 = 0 ; c9 = c9 + 1 ;
                            if c9 > Mem_depth
                                c9 = 0 ; c8 = c8 + 1 ;
                                if c8 > Mem_depth
                                    c8 = 0 ; c7 = c7 + 1 ;
                                    if c7 > Mem_depth
                                        c7 = 0 ; c6 = c6 + 1 ;
                                        if c6 > Mem_depth
                                            c6 = 0 ; c5 = c5 + 1 ;
                                            if c5 > Mem_depth
                                                c5 = 0 ; c4 = c4 + 1 ;   
                                                if c4 > Mem_depth
                                                    c4 = 0 ; c3 = c3 + 1 ;  
                                                    if c3 > Mem_depth
                                                        c3 = 0 ; c2 = c2 + 1 ;
                                                        if c2 > Mem_depth
                                                            c2 = 0 ; c1 = c1 + 1 ;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for k = 1 : D
                    B = sort( A , 2 ) ;
                    a = B( k , : )    ;
                    [ x , y ] = find( ...
                                      ( B( : , 1  ) == a( : , 1  ) ) ...
                                    & ( B( : , 2  ) == a( : , 2  ) ) ...
                                    & ( B( : , 3  ) == a( : , 3  ) ) ...
                                    & ( B( : , 4  ) == a( : , 4  ) ) ...
                                    & ( B( : , 5  ) == a( : , 5  ) ) ...
                                    & ( B( : , 6  ) == a( : , 6  ) ) ...
                                    & ( B( : , 7  ) == a( : , 7  ) ) ...
                                    & ( B( : , 8  ) == a( : , 8  ) ) ...
                                    & ( B( : , 9  ) == a( : , 9  ) ) ...
                                    & ( B( : , 10 ) == a( : , 10 ) ) ...
                                    & ( B( : , 11 ) == a( : , 11 ) ) ) ;
                    x( 1 )     = [ ] ;
                    A( x , : ) = [ ] ;
                    if k == length( A )
                        break
                    end
                end
                h11           = A                   ;
                h11( 1 , :  ) = [ ]                 ;   
                h11( : , 7  ) = h11( : , 7  ) * -1i ;
                h11( : , 8  ) = h11( : , 8  ) * -1i ;
                h11( : , 9  ) = h11( : , 9  ) * -1i ;
                h11( : , 10 ) = h11( : , 10 ) * -1i ;
                h11( : , 11 ) = h11( : , 11 ) * -1i ;
                h             = h11                 ; 
            end
        otherwise
            display( 'Error: order not programmed' ) ;
    end  