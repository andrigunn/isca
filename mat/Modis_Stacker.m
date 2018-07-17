function Modis_Stacker(Data_stack,Date_vector,geo,Center_Date_option)  
%% 
% Stack MODIS tiles from a tiled structure
%% INPUTS
% Data_stack: a data stack with m x 2400 x 2400 where m is the number of
% days
% geo: a mat file with shape files and other plotting stuff
% Date_vector: a 1 x m vector with datenumbers for each day in the data
% stack
% Center_Date_option is the tile that other tiles are merged to. 
%   Two possibilties:
%       1 gives the center date as the true center of the data stack
%       2 gives the center data as the newest tile, i.e. the last day in
%       the stack
%% OUTPUTS

%% TESTING
Data_stack = Data_stack;
Date_vector = Date_vector;
Center_Date_option = 1           % Date to merge other tiles to 

%% SETTINGS
vis = 'on';
addpath('E:\Dropbox\Matlab\cbrewer');
lw = 0.1;                                   % Line width for plotting
no_days = size(Data_stack);
no_days = no_days(2);                       % Find number of days in data stack 
no_data_number = -9999
%% Determine Center date
    if Center_Date_option == 1
        Center_date = (length(Data_stack)-1)/2+1;           % Find the center of the data stack
    else
        Center_date = length(Data_stack);                   % Finds the end date of the data stack
    end
%% Start by merging the first and last days of the stack
clc
% Make an empty matrix with no data number values
Data_stacked_sca = ones(2400,2400)*no_data_number;                          % Matrix for SCA values
Data_stacked_age = ones(2400,2400)*no_data_number;                          % Matrix for data age values

if Center_Date_option == 1
    [start_day end_day] = size(Data_stack);
%Merge the tiles that are forward/backward of center date
    for i = 1:(Center_date-1)
        % Find indexes with and withput data
        ind_data_back = find(~isnan(Data_stack(i).MCDAT));                  % Indexes for DATA values in stack date  
        ind_data_forw = find(~isnan(Data_stack(end_day+1-i).MCDAT));        % Indexes for DATA values in stack date  
                       
        % Add to the matrix. Forward has priority to back        
        Data_stacked_sca(ind_data_back) = Data_stack(i).MCDAT(ind_data_back);
        Data_stacked_sca(ind_data_forw) = Data_stack(i).MCDAT(ind_data_forw);
        
        Data_stacked_age(ind_data_back) = i-Center_date;
        Data_stacked_age(ind_data_forw) = (end_day+1-i)-Center_date;
        
    end
        % Add Center Day Stack to the merged stack
        ind_data_cdm = find(~isnan(Data_stack(Center_date).MCDAT));                  % Indexes for DATA values in center stack date
        Data_stacked_sca(ind_data_cdm) = Data_stacked_sca(ind_data_cdm); 
        Data_stacked_age(ind_data_cdm) = 0;
        % Make no data number as NaN
        Data_stacked_sca(Data_stacked_sca == no_data_number) = NaN;
        
        % Make data age into true age in days, not index number of data stack
        Data_stacked_age(Data_stacked_age == no_data_number) = NaN;             % NaN no data values
        
    
    else
end

