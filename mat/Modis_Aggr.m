function Modis_Aggr(Center_Date_option,day_buffer_forward,day_buffer_backward,...
                    mcd_data_dir,data_write_dir,img_dir,write_data,...
                    print_fig,plotting_on,vis,...
                    test_mode, test_date,...
                    cmapSnow,cmapAge,...
                    geo_data_dir)
%%
% Makes a data stack from MCD10A1_YYYYDOY merged Aqua and Terra tiles for
% same dates and then aggrigates the stack
%
% 
% 
%% RELEASE NOTES
%   Written by Andri Gunnarsson (andrigun@lv.is), July 2018
% 
%% SYNTAX
%    
% 
%% INPUTS
%   Data_stack = 1xN structure where N is the number of days in the stack
%       to be merged. The dimensions of each N tile match 2400 x 2400 pixels
%   Date_vector = Nx1 vector with dates in Matlab datenum format for each N
%       day used to aggregate over
%   geo = Shape files and geometric plotting structures for masking and
%       plotting of data

%   Center_Date_option= options to select which date is used to merge data onto , where   
%       % 1 = Uses a center date in the middle of the data stack
%       % 2 = Uses the last (newset) date in the stack
%   img_dir = location where to export images if print_fig is on
%   data_write_dir = location to write a *.mat data file of the aggrigated
%   results
%   write_data = option to select if aggrigated data is written to a file
%       stored in data_write_dir
%   plotting_on = 1 to make plots, 0 then no plots are made
%   print_fig = image printed to img_dir
%   vis = 1 makes the plotted figure visible, else figure is not printed to
%       screen
%   ins = in Mask to use for data statics claculations
%
%% OUTPUTS


%% NOTE:    
%   All statistical calulations refer to a in mask to the Modis_in_filter_sca.m funtion
%% SCRIPTS REQUIRED
%   Modis_Stacker
%   Modis_in_filter_sca.m
%   For plotting:
%      Modis_Stacker_Plot_Data_Age.m
%      Modis_Stacker_Plot_Data_Age.m
%
%% TESTING
% vis = 'off';                                                                      % Visibility of figures On(1) / Off(0)                        
% print_fig = 1;                                                                    % Print figure to img_dir folder (1)
% Center_Date_option = 1;
% write_data = 1
% plotting_on = 1
% mcd_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MCDDATA';             % Directory with merged Aqua and Terra data
% img_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\06_img\MMCDDATA_7D';                       % Directory to store exported images
% data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MMCDDATA_7D';        % Directory to write output files
% day_buffer_forward = 3;                                                               % No of days used in forward buffer  
% day_buffer_backward = 3;                                                              % No of days used in backwards buffer  
%% SETTINGS

%% Settings
Modis_Aggr_Stats = table;                                                                  % Make an table to write statistics to 
geo = Modis_make_geo(geo_data_dir);                                                             % Data for plotting. Shape files and coordinates of hdf files
[ins, outs] = Modis_make_ins_outs(geo_data_dir);                                                  % Loads masks for exluding data 
%%
cd(mcd_data_dir);                                                                    % CD to data folder with hdf files for MOD10A1 product
mcd = dir('MCD10A1*');                                                              % Read directory structure
mcd = dates2header_matFile(mcd);                                                    % Write time and date information to directory information for data
years_in_dataset = unique([mcd.year]);                                               % Number of unique years in the datastructure
ii = 0;
time_dim = day_buffer_backward + 1 + day_buffer_forward;                   % Number of days used in the temporal filter

if test_mode == 0
% Find each individual year in the dataset MCD10A1

for ky = 1:length(years_in_dataset);                                       % Counter for number of years in the dataset                             
    ki = find([mcd.year] == years_in_dataset(ky));                         % Indexes for years in ky
% Counter for center location in datastructure and +/- days to merge    
    for j = day_buffer_backward:length(ki)-day_buffer_forward;
        ind = ki(j);
        
        if ind == day_buffer_backward;                                      % To account for first index ?
            i0 = ind-day_buffer_backward;
        else
            i0 = ind-day_buffer_backward-1;                                 % All other indexes
        end
    end
%% Maker each data stack to merge
            for ji = 1:time_dim;                                            % Process each year, time_dim length of filter (days)
                cd(mcd_data_dir);     
                i0 = i0+1;
                Data_stack(:,ji) = load(mcd(i0).name);                              % Raw data from Merged AT
                Date_vector(ji,:) = mcd(i0).daten;
                Data_name(ji,:) = mcd(i0).name;
            end
                
        %Stacked_Stats = 
        Modis_Stacker(Data_stack,Date_vector,geo,Center_Date_option,img_dir,data_write_dir,write_data,plotting_on,print_fig,vis,ins,cmapSnow,cmapAge); 
        %x_t =  table(Stacked_Stats)
end

Modis_Aggr_Stats =[Modis_Aggr_Stats;x_t];

else % If test mode is enabled
       i0 = find([mcd(:).daten] == test_date);
       i0 = i0-1;
       sprintf('Test on')
       %% Maker each data stack to merge
            for ji = 1:time_dim;                                            % Process each year, time_dim length of filter (days)
                cd(mcd_data_dir);     
                i0 = i0+1;
                Data_stack(:,ji) = load(mcd(i0).name);                              % Raw data from Merged AT
                Date_vector(ji,:) = mcd(i0).daten;
                Data_name(ji,:) = mcd(i0).name;
            end
                sprintf('Test on')
                Modis_Stacker(Data_stack,Date_vector,geo,Center_Date_option,...
                    img_dir,data_write_dir,write_data,plotting_on,print_fig,vis,ins,test_mode,cmapSnow,cmapAge); 
end

save([data_write_dir,'Stats\','Modis_Aggr_Stats',],'Modis_Aggr_Stats');
sprintf('FINISHED')
end
