function [out_Basis, out_MaxM] = Generate_Basis(M, N, model, polyorder, Mstep, MNL, ML, varargin)

% Supported Mode MP, H_EMP, Mod_H_EMP, CRV, ECRV, ECRV_Pruned
% Currently not supported UB_MP, NB_EMP, Mod_NB_EMP, Deriv_MP
if strcmp(polyorder,'odd')
    incr = 2;
elseif strcmp(polyorder,'odd_even')
    incr = 1;
elseif strcmp(polyorder,'odd_aug')
    incr = 2;
end

% Hotfix if varargin is passed from another varargin
if length(varargin) == 1 && iscell(varargin{1})
    varargin = varargin{1};
end

% Make the parallel FIR internally
add_P_FIR = 0;
if length(model) >  4 && strcmp(model(1:4), 'Mod_')
    add_P_FIR = 1;
    model = model(5:end);
    FIR_M = varargin{1};
end

switch model
    case 'MP'
        get_MP;
    case 'H_EMP'
        get_H_EMP;
    case 'CRV'
        get_CRV;
    case 'CRV_Pruned'
        get_CRV_Pruned;
    case 'ECRV'
        get_ECRV;
	case 'ECRV_Pruned'
		get_ECRV_Pruned;
	case 'UB_MP'
        error('UB_MP Not currently supported!');
        % get_UB_MP(varargin);
    case 'NB_EMP'
        error('NB_EMP Not currently supported!');
        % get_NB_EMP;
    case 'Deriv_EMP'
        error('Deriv_EMP Not currently supported!');
        % get_Deriv_EMP;
    otherwise
        error('Error: Modification choice not recognized');
end

if strcmp(polyorder,'odd_aug') && N > 0
    % First column is always x(n), add x(n)|x(n)|
    B = Basis(1);
    B.P.N = 1;
    B.func = @(mem) mem(:,1).*(abs(mem(:,1)));
    Basis = [Basis(1), B, Basis(2:end)];
end

if add_P_FIR
    % First column is always x(n)
    for fir_t = 2:FIR_M
        FIR_Basis(fir_t-1) = Basis(1);
        FIR_Basis(fir_t-1).P.M = fir_t;
        FIR_Basis(fir_t-1).func = @(mem) mem(:,fir_t);
    end
    
    Basis = [Basis, FIR_Basis];
    MaxM = max(MaxM, FIR_M);
end

out_Basis = Basis;
out_MaxM = MaxM;

%% Nested function
    function get_MP
        MaxM = (M - 1) * Mstep + 1;
        idx=0;
        for t=1:Mstep:M * Mstep
            for Expon=0:incr:N
                idx=idx+1;
                Basis(idx).P.M = t;
                Basis(idx).P.N = Expon;
                Basis(idx).func = @(mem) mem(:,t).*(abs(mem(:,t)).^Expon);
            end
        end
    end

    function get_UB_MP(memory_step)
        % if isempty(memory_step)
        % mem_step = 1;
        % else
        % mem_step = memory_step{1};
        % end
        % c = 0; k_idx = po;
        % for Expon=0:incr:N
        % k = M - Expon / incr * mem_step;
        % if k < 1
        % k = 1;
        % else
        % k_idx = Expon;
        % end
        % c = c + k;
        % end
        % m_idx = k;
        % A = zeros(r, c);
        % col = 1;
        % n_idx = N;
        % for t=1:M
        % input_m = input_shifted((M-t+1):(end-t+1));
        % A(:,col)= input_m;
        % for Expon=0:incr:n_idx
        % col_off = Expon/incr;
        % A(:,col+col_off) = input_m.*(abs(input_m).^ Expon);
        % end
        % if t >= m_idx
        % col = col + floor(n_idx/incr) + 1;
        % n_idx = k_idx - floor((t - m_idx) / mem_step) * incr - 1;
        % else
        % col = col + po;
        % end
        % end
    end

    function get_H_EMP
        MaxM = (M - 1) * Mstep + 1;
        idx = 0;
        for t=1:Mstep:M * Mstep
            for Expon=0:incr:N
                if Expon == 0 && t ~= 1
                    continue;
                end
                idx=idx+1;
                Basis(idx).P.M = t;
                Basis(idx).P.N = Expon;
                Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,t)).^Expon);
            end
        end
    end

    function get_NB_EMP
        %         MaxM = M;
        %         idx=0;
        %         % Sampling Frequency -- Hard code as per PlotSpectrum.m
        %         Fs    = 100e6;
        %         for Expon = 0:incr:N
        %             idx=idx+2;
        %             Basis(idx-1).P.M = 1;
        %             Basis(idx-1).P.N = Expon;
        %             Basis(idx-1).func = @(mem) mem(:,1).*(abs(mem(:,1).^Expon));
        %             % The first deriv
        %             Basis(idx).P.M = 2;
        %             Basis(idx).P.N = Expon;
        %             t=1;
        %             Basis(idx).func = @makeDeriv;
        %         end
        %
        %         function yo = makeDeriv(mem)
        %             input_NB = [mem(1,t+1); mem(:,t)];
        %             deriv = diff(abs(input_NB))*Fs;
        %             yo = deriv.*mem(:,t).*(abs(mem(:,t)).^Expon);
        %         end
    end

    function get_Deriv_EMP
        %         MaxM = M;
        %         idx=0;
        % %         Sampling Frequency -- Hard code as per PlotSpectrum.m
        %         Fs    = 100e6;
        %         for t=1:M
        %             for Expon=0:incr:N
        %                 idx=idx+1;
        %                 Basis(idx-1).P.M = 1;
        %                 Basis(idx-1).P.N = Expon;
        %                 Basis(idx-1).func = @(deriv) deriv(:,1).*(abs(deriv(:,1).^Expon));
        %             end
        %         end
    end

    function get_CRV
        MaxM = (M - 1) * Mstep + 1;
        idx = 0;
        % Static non-linearity
        for i=0:incr:N
            idx=idx+1;
            Basis(idx).P.M = 1;
            Basis(idx).P.N = i;
            Basis(idx).P.K = 0;
            Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1).^i));
        end
        % CRV cross terms with x(n)
        for t=1:Mstep:(M-1) * Mstep
            for i=0:incr:N-2
                for k=incr:incr:N
                    idx=idx+1;
                    Basis(idx).P.M = t+Mstep;
                    Basis(idx).P.N = i;
                    Basis(idx).P.K = k;
                    Basis(idx).P.L = 1;
                    Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1)).^i).*(abs(mem(:,t+Mstep)).^k);
                end
            end
        end
        % CRV cross terms with x(n-m)
        for t=1:Mstep:(M-1)*Mstep
            for i=0:incr:N
                for k=0:incr:N
                    idx=idx+1;
                    Basis(idx).P.M = t+Mstep;
                    Basis(idx).P.N = i;
                    Basis(idx).P.K = k;
                    Basis(idx).P.L = 2;
                    Basis(idx).func = @(mem) mem(:,t+1).*(abs(mem(:,1)).^i).*(abs(mem(:,t+Mstep)).^k);
                end
            end
        end
    end

    function get_CRV_Pruned
%         MaxM = (M - 1) * Mstep + 1;
        MaxM = max((ML - 1) * Mstep + 1,(MNL - 1) * Mstep + 1);
        idx = 0;
        % Static non-linearity
        for i=0:incr:N
            idx=idx+1;
            Basis(idx).P.M = 1;
            Basis(idx).P.N = i;
            Basis(idx).P.K = 0;
            Basis(idx).P.L = 0;
            Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1).^i));
        end
        % CRV cross terms with x(n)
        for t=1:Mstep:(M-1) * Mstep
            for i=0:incr:N-2
                for k=incr:incr:N
                    idx=idx+1;
                    Basis(idx).P.M = t+Mstep;
                    Basis(idx).P.N = i;
                    Basis(idx).P.K = k;
                    Basis(idx).P.L = 1;
                    Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1)).^i).*(abs(mem(:,t+Mstep)).^k);
                end
            end
        end
        % CRV cross terms with x(n-m)
%         for t=1:Mstep:(M-1)*Mstep
        for t=1:Mstep:(ML-1)*Mstep
            for i=0:incr:N
                for k=0:incr:N
                    idx=idx+1;
                    Basis(idx).P.M = t+Mstep;
                    Basis(idx).P.N = i;
                    Basis(idx).P.K = k;
                    Basis(idx).P.L = 2;
                    Basis(idx).func = @(mem) mem(:,t+1).*(abs(mem(:,1)).^i).*(abs(mem(:,t+Mstep)).^k);
                end
            end
        end
        % Now prune the Basis
        po = length(0:incr:N);
		Static_Basis = Basis(1:po);
		Dynamic_Basis = Basis(po+1:end);
        % Filter out everything that has combined order > N
		DB_select = false(size(Dynamic_Basis));
		for i=1:length(Dynamic_Basis)
			BasisParam = Dynamic_Basis(i).P;
			BasisOrder = BasisParam.N + BasisParam.K;
		%     if BasisOrder <= model_APD.N
			if BasisOrder <= N - BasisParam.M
				DB_select(i) = true;
			end
            % Keep the static nonlinearity
%             if(BasisParam.K == 0 && BasisParam.M == 1)
%                 DB_select(i) = true;
%             end
            % Keep the linear memory
            if(BasisParam.K == 0 && BasisParam.N == 0)
                DB_select(i) = true;
            % Keep the first MNL terms of the nonlinear memory
            elseif (BasisParam.M > MNL)
                DB_select(i) = false;    
            end
		end
		New_DB = Dynamic_Basis(DB_select);
		Basis = [Static_Basis, New_DB];
    end

    function get_ECRV
        MaxM = (M - 1) * Mstep + 1;
        idx = 0;
        % Static non-linearity
        for i=0:incr:N
            idx=idx+1;
            Basis(idx).P.M = 1;
            Basis(idx).P.N = i;
            Basis(idx).P.K = 0;
            Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1).^i));
        end
        % CRV cross terms with x(n)
        for t=1:Mstep:(M-1) * Mstep
            for i=0:incr:N-2
                for k=incr:incr:N
                    idx=idx+1;
                    Basis(idx).P.M = t+Mstep;
                    Basis(idx).P.N = i;
                    Basis(idx).P.K = k;
                    Basis(idx).P.L = 1;
                    Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1)).^i).*(abs(mem(:,t+Mstep)).^k);
                end
            end
        end
    end

	function get_ECRV_Pruned
        MaxM = (M - 1) * Mstep + 1;
        idx = 0;
        % Static non-linearity
        for i=0:incr:N
            idx=idx+1;
            Basis(idx).P.M = 1;
            Basis(idx).P.N = i;
            Basis(idx).P.K = 0;
            Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1).^i));
        end
        % CRV cross terms with x(n)
        for t=1:Mstep:(M-1) * Mstep
            for i=0:incr:N-2
                for k=incr:incr:N
                    idx=idx+1;
                    Basis(idx).P.M = t+Mstep;
                    Basis(idx).P.N = i;
                    Basis(idx).P.K = k;
                    Basis(idx).P.L = 1;
                    Basis(idx).func = @(mem) mem(:,1).*(abs(mem(:,1)).^i).*(abs(mem(:,t+Mstep)).^k);
                end
            end
        end
		% Now prune the Basis
        po = length(0:incr:N);
		Static_Basis = Basis(1:po);
		Dynamic_Basis = Basis(po+1:end);

		% Filter out everything that has combined order > N
		DB_select = false(size(Dynamic_Basis));
		for i=1:length(Dynamic_Basis)
			BasisParam = Dynamic_Basis(i).P;
			BasisOrder = BasisParam.N + BasisParam.K;
		%     if BasisOrder <= model_APD.N
			if BasisOrder <= N - BasisParam.M
				DB_select(i) = true;
			end
		end
		New_DB = Dynamic_Basis(DB_select);
		Basis = [Static_Basis, New_DB];
    end
end
