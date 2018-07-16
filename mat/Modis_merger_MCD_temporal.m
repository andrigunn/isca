%%
%function Data_merged = Modis_tile_merger(Data_stack)
% Merging of Modis tiles stack with priority to dataset in center data
% position
%% Inputs
% Data_stack

%% FOR TESTING
day_buffer_forward = 3;                                                               % No of days used in forward buffer  
day_buffer_backward = 3;  
Center_date = day_buffer_forward+1;    % Indication of center data in data structure, for 7 days filtering center day is no 4
Data_stack = D;
Date_vector
%% Set matrixes
% Original Center day Matrix (CDM0)
Data_CDM0 = Data_stack(Center_date).MCDAT;
Date_CDM0 = Date_vector(Center_date)
ind_nan_CDM0 = find(isnan(Data_CDM0));                % NAN values in CDM0 (1 = NaN / 0 = Data) 

Data_CDM_F1 = Data_stack(Center_date+1).MCDAT; 
Data_CDM_B1 = Data_stack(Center_date-1).MCDAT; 

Data_CDM_F2 = Data_stack(Center_date+2).MCDAT; 
Data_CDM_B2 = Data_stack(Center_date-2).MCDAT; 

Data_CDM_F3 = Data_stack(Center_date+3).MCDAT; 
Data_CDM_B3 = Data_stack(Center_date-3).MCDAT; 

Date_CDM_F1 = Date_vector(Center_date+1); 
Date_CDM_B1 = Date_vector(Center_date-1); 

Date_CDM_F2 = Date_vector(Center_date+2); 
Date_CDM_B2 = Date_vector(Center_date-2); 

Date_CDM_F3 = Date_vector(Center_date+3); 
Date_CDM_B3 = Date_vector(Center_date-3); 


Data_CDM1 = Data_CDM0;
Data_CDMF3(ind_nan_CDM0) = Data_CDM_F3(ind_nan_CDM0);

Data_CDMF3B3(ind_nan_CDM0) = Data_CDM_F3B3(ind_nan_CDM0);
%% View data stack
clc, close all
Modis_plotter(Data_CDM0,geo,    ['CDM0 Date: ',datestr(Date_CDM0)]) 
Modis_plotter(Data_CDM_F1,geo,  ['Data_CDM_F1 Date: ',datestr(Date_CDM_F1)]) 
Modis_plotter(Data_CDM_B1,geo,  ['Data_CDM_B1 Date: ',datestr(Date_CDM_B1)]) 
Modis_plotter(Data_CDM_F2,geo,  ['Data_CDM_F2 Date: ',datestr(Date_CDM_F2)]) 
Modis_plotter(Data_CDM_B2,geo,  ['Data_CDM_B2 Date: ',datestr(Date_CDM_B2)]) 
Modis_plotter(Data_CDM_F3,geo,  ['Data_CDM_F3 Date: ',datestr(Date_CDM_F3)]) 
Modis_plotter(Data_CDM_B3,geo,  ['Data_CDM_B3 Date: ',datestr(Date_CDM_B3)]) 
%%
indices = find(isnan(D1));
D1(indices) = 0;
D1(indices) = D1(indices) + D2(indices);




