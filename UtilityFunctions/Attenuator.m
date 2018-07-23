classdef Attenuator < handle
% returns attenuation (positive) in dB at a given frequency
% checks that the S11 and S22 are < -30 dB (i.e. good 50 ohms matching)
    properties (SetAccess = private)
        s2p_file
        frequency
        data        
    end
    
    methods
        % constructor
        function obj = Attenuator(s2p_file)
            obj.s2p_file = s2p_file;
            addpath('.\Sparameter_Functions'); % access to S-Parameter toolbox
            [obj.frequency obj.data] = SXPParse(s2p_file);
            rmpath('.\Sparameter_Functions');
        end 
        
        % get attenuation at frequency 
        function output = attenuation(obj, freq)
            ind = find(obj.frequency == freq);
            if(ind)
                if (20*log10(abs(obj.data(1,1,ind))) > -20)
                    fprintf('Warning: Attenuator S11 greater than -20 dB at frequency %g\n', freq)
                end
                if (20*log10(abs(obj.data(2,2,ind))) > -20)
                    fprintf('Warning: Attenuator S22 greater than -20 dB at frequency %g\n', freq)
                end
                output = -20*log10(abs(obj.data(2,1,ind)));
            else
                error('Attenuator S2P does not contain data at the requested frequency %g Hz\n', freq);
            end
        end
               
    end
    
end

