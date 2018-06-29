%function D_merged = Modis_tile_merger(D1,D2)
% Merging of two Modis tiles with priority to dataset in center data
% position

%% FOR TESTING
Center_date = day_buffer_forward+1;    % Indication of center data in data structure, for 7 days filtering center day is no 4
Data_structure = D;
day_buffer_forward = 3;                                                               % No of days used in forward buffer  
day_buffer_backward = 3;  
%% Set matrixes
cD = [D(Center_date).MCDAT];        % Center date matrix
cD_u = cD;                          % Matrix that is updated
data_age = cD;                      % Matrix for data age
data_age(:,:) = nan;                % Set data age matrix to nan
ind_nan_cD = isnan(cD);             % NAN values in center day matrix

%% Make data read vector
day_size = day_buffer_forward+day_buffer_backward+1;
F = ones(1,day_size)
F(1) = Center_date; 
%%
for i = [Center_date
        
    cD_u(ind_nan_cD) = df1(ind_nan_cD);

end

%%
ind_nan_cD_u = isnan(cD_u);
cD_u(ind_nan_cD_u) = db1(ind_nan_cD_u);

ind_nan_cD_u = isnan(cD_u);
cD_u(ind_nan_cD_u) = db2(ind_nan_cD_u);

ind_nan_cD_u = isnan(cD_u);
cD_u(ind_nan_cD_u) = df2(ind_nan_cD_u);

ind_nan_cD_u = isnan(cD_u);
cD_u(ind_nan_cD_u) = db3(ind_nan_cD_u);

ind_nan_cD_u = isnan(cD_u);
cD_u(ind_nan_cD_u) = df3(ind_nan_cD_u);

Modis_plotter(cD_u,geo)   

%%

indices = find(isnan(D1));
D1(indices) = 0;
D1(indices) = D1(indices) + D2(indices);

D3 = D_merged;
end
