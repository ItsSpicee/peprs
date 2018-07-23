function [ x_filtered] = digital_filterout_bel( x, fs ,f_start, f_end)
%this function filter the needed band only
    res             = fs/length(x);
    freq            = -fs/2:res: fs/2 - res;
    data_filtered_f = zeros(size(x));
    x_f = fftshift(fft(x))/length(x);
    nf              = min(abs(real(x_f))) + 1j* min(abs(imag(x_f)));
    f_dc_index      = find(ismember(freq,0)); 
% Filtering the postive freq
    f_edge          = [f_start f_end];
    f_edge_index    = find(ismember(freq,f_edge)); 
    data_filtered_f(f_edge_index(1):f_edge_index(2)) =x_f(f_edge_index(1):f_edge_index(2));
    data_filtered_f(f_dc_index:f_edge_index(1)-1) = nf;
    data_filtered_f(f_edge_index(2)+1 : end) = nf;
% Filtering the negative freq
    f_edge          = [-f_end -f_start ];
    f_edge_index    = find(ismember(freq,f_edge)); 
    data_filtered_f(f_edge_index(1):f_edge_index(2)) = x_f(f_edge_index(1):f_edge_index(2));
    data_filtered_f(f_edge_index(2)+1:f_dc_index) = nf;
    data_filtered_f(1:f_edge_index(1)-1) = nf;
    
    %ps_bel(data_filtered_f, fs, 1);
    x_filtered = ifft(ifftshift(data_filtered_f));
end

