function [VolterraParameters , VolterraCoeff, VolterraOutput , StaticOutput , NMSE] = VolterraDpdIdentification_ET (Pr, Out, Vdd, VolterraParameters, NbOfPoint, DPD)

%         VolterraParameters.ModifiedKernels = false ;
%         VolterraParameters.ModifiedFile    = '.\kernels2consider\withDelayedInput\5_5_EOConj.txt' ;
%         VolterraParameters.DDR             = true ;
%         VolterraParameters.DDRorder        = 2 ;
%       % VolterraParameters.Order           = [ h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 ] ;
%         VolterraParameters.Order           = [ 5  0  3  0  3  0  0  0  0  0   0   ] ;
%         VolterraParameters.Static          = 7 ;
DebugPrint( 'Import and plot data' );
tic
PS  = NbOfPoint ;
CDTRFTB = 1+0*1e2 ;
[In,Out,Vdd_import] = VolterraDpdIdentification_ImportData_ET(Pr,Out,Vdd,PS,CDTRFTB);

if DPD
    aux = In;
    In = Out;
    Out = aux;
end
data.In  = In;
data.Out = Out;

size(data.In);

data.Vdd = Vdd_import(1:size(data.In,1));
size(data.Vdd);

VolterraDpdIdentification_PlotFigures(In, Out);
DebugPrint( [ '  ------>  ' num2str(toc) 's' ] );

%% Volterra Series parameters and kernels generations
DebugPrint( 'Volterra kernels' ) ;

VolterraParameters.ModifiedKernels = VolterraParameters.ModifiedKernels;
VolterraParameters.ModifiedFile    = VolterraParameters.ModifiedFile;
VolterraParameters.DDR             = VolterraParameters.DDR;
VolterraParameters.DDRorder        = VolterraParameters.DDRorder;
% VolterraParameters.Order           = [ h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11 ];
VolterraParameters.Order           = VolterraParameters.Order;
VolterraParameters.Static          = VolterraParameters.Static;

if not ( VolterraParameters.ModifiedKernels )
    [ kernel , NbCoeff ] = VolterraDpdIdentification_GenerateVolterraKernels(VolterraParameters);
    VolterraParameters.Kernel   = kernel;
    VolterraParameters.NbCoeff  = NbCoeff*VolterraParameters.NSupply;
    if VolterraParameters.DDR
        [ kernel , NbCoeff ] = VolterraDpdIdentification_PruneVolterraKernels(VolterraParameters);
        VolterraParameters.Kernel   = kernel;
        VolterraParameters.NbCoeff  = NbCoeff*VolterraParameters.NSupply;
    end
else
    [ kernel , NbCoeff  ] = VolterraDpdIdentification_ModifiedKernels(VolterraParameters);
    VolterraParameters.Static   = VolterraParameters.Static;
    VolterraParameters.Order    = [ 1 1 1 1 1 1 1 1 1 1 1 ];
    VolterraParameters.Kernel   = kernel;
    VolterraParameters.NbCoeff  = (NbCoeff + VolterraParameters.Static)*VolterraParameters.NSupply;
end

%% Identify Volterra series coefficients
DebugPrint('Identify Volterra series coefficients');

dataaux = data;

%     dataaux.In  = dataaux.In(  1 : 10000 ) ;
%     dataaux.Out = dataaux.Out( 1 : 10000 ) ;

[ VolterraCoeff , StaticCoeff ] = VolterraDpdIdentification_IdentifyVolterraCoeff_ET (dataaux, VolterraParameters);

%% Apply Volterra
DebugPrint( 'Apply Volterra series coefficients' );

[ VolterraOutput , StaticOutput ] = VolterraDpdIdentification_ApplyVolterra_ET(data, VolterraParameters, VolterraCoeff, StaticCoeff);

%% Modeling Performance
DebugPrint( 'Modeling Performance' );

[ meanInput , maxInput, NMSE ] = VolterraDpdIdentification_PlotVMFigures( data.In , data.Out , VolterraOutput , VolterraCoeff , StaticOutput );
VolterraParameters.maxInput = maxInput;
VolterraParameters.meanInput = meanInput;
DebugPrint(['mean of output signal = ' num2str(meanInput) ' dB']);
DebugPrint( [ '  ------>  ' num2str(toc) 's' ] );
DebugPrint(VolterraParameters.NbCoeff);
