%% Temporal filter of MCDAT files from Modis_merger_Aqua_terra.m


%% Inputs                               

%% SYNTAX

%% Folders and directories
clear all; close all; clc
%%
addpath('C:\Users\andrigun\Documents\GitHub\isca\mat')
addpath('E:\Dropbox\Matlab')
addpath('E:\Dropbox\Matlab\mraleigh')
%addpath('E:\Dropbox\Matlab\cbrewer')
cd('C:\Users\andrigun\Documents\GitHub\isca\mat')
%% Define directories
mcd_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MCDDATA';             % Directory with merged Aqua and Terra data
img_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\06_img\MMCDDATA_7D';                       % Directory to store exported images
data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MMCDDATA_7D';        % Directory to write output files
%% Settings
vis = 'off';                                                                         % Visibility of figures On(1) / Off(0)                        
print_fig = 1;                                                                    % Print figure to img_dir folder (1)
geo = Modis_make_geo;                                                               % Data for plotting. Shape files and coordinates of hdf files
Center_Date_option = 1;
write_data = 1
plotting_on = 1
%[ins, outs] = Modis_make_ins_outs;                                                  % Loads masks for exluding data 
day_buffer_forward = 3;                                                               % No of days used in forward buffer  
day_buffer_backward = 3;                                                              % No of days used in backwards buffer  
geo = Modis_make_geo;                                                               % Data for plotting. Shape files and coordinates of hdf files
[ins, outs] = Modis_make_ins_outs;                                                  % Loads masks for exluding data 
%%
%MCD_Stats = table;                                                                  % Make an table to write statistics to 
cd(mcd_data_dir)                                                                    % CD to data folder with hdf files for MOD10A1 product
mcd = dir('MCD10A1*');                                                              % Read directory structure
mcd = dates2header_matFile(mcd);                                                    % Write time and date information to directory information for data
years_in_dataset = unique([mcd.year])                                               % Number of unique years in the datastructure
%
clc
ii = 0;
time_dim = day_buffer_backward + 1 + day_buffer_forward;                   % Number of days used in the temporal filter

% Find each individual year in the dataset MCDAT 
for ky = 10%1:1%length(years_in_dataset);                                     % Counter for number of years in the dataset                             
    ki = find([mcd.year] == years_in_dataset(ky));                         % Indexes for years for k
% Counter for center location in datastructure and +/- days to merge    
    for j = day_buffer_backward:length(ki)-day_buffer_forward;
        ind = ki(j)
        
        if ind == day_buffer_backward                                      % To account for first index ?
            i0 = ind-day_buffer_backward
        else
            i0 = ind-day_buffer_backward-1                                 % All other indexes
        end
        
%% Maker each data stack to merge
            for ji = 1:time_dim                                            % Process each year, time_dim length of filter (days)
                cd(mcd_data_dir)     
                i0 = i0+1
                Data_stack(:,ji) = load(mcd(i0).name);                              % Raw data from Merged AT
                Date_vector(ji,:) = mcd(i0).daten
            end
                
                Modis_Stacker(Data_stack,Date_vector,geo,Center_Date_option,...
                    img_dir,data_write_dir,write_data,plotting_on,print_fig,vis,ins) 
    end
end