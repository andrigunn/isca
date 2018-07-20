function Stacked_Stats = Modis_Stacker(Data_stack,Date_vector,geo,Center_Date_option,img_dir,data_write_dir,write_data,plotting_on,print_fig,vis,ins,test_mode,cmapSnow,cmapAge)  
% Aggregates merged MOD10A1 and MYD10A1 (MCDAT) data from the input
% datastack to a single aggregated structure with data age and aggregated
% fSCA
% 
%% RELEASE NOTES
%   Written by Andri Gunnarsson (andrigun@lv.is), July 2018
% 
%% SYNTAX
%   Modis_Stacker(Data_stack,Date_vector,geo,Center_Date_option)  
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
%   Stacked_Stats = Main results of the aggrigation, where columns are:
%       1. Center date of the aggrigated stack, i.e. the date other tiles
%          in the stack are aggregated to 
%       2. prct_data_in_merged_stack; Percent of data in the aggrigated
%           stack. (1-prct_data_in_merged_stack) is cloud cover over the
%           period
%       3. Number of days used in the aggrigate
%       4. Rows 4:(4+(N-1)) where N is the number of days used. 
%           The day number in Matlab format of the dates that are used. 
%       5. Rows (4+(N)):(4+N+N-1) where N is the number of days used.
%           The associated data availibility for each day prior to aggrigation
%% NOTE:    
%   All statistical calulations refer to a in mask to the Modis_in_filter_sca.m funtion
%% SCRIPTS REQUIRED
%   Modis_in_filter_sca.m
%   For plotting:
%      Modis_Stacker_Plot_Data_Age.m
%       Modis_Stacker_Plot_Data_Age.m
%% TESTING
%Data_stack = Data_stack;
%Date_vector = Date_vector;
%Center_Date_option = 1           % Date to merge other tiles to 
%vis = 'on';
%% SETTINGS
no_days = size(Data_stack);
no_days = no_days(2);                       % Find number of days in data stack 
no_data_number = -9999;
lw = 0.1;
%% Determine Center date
    if Center_Date_option == 1;
        Center_date = (length(Data_stack)-1)/2+1;           % Find the center of the data stack
    else
        Center_date = length(Data_stack);                   % Finds the end date of the data stack
    end
%% Start by merging the first and last days of the stack
% Make an empty matrix with no data number values
Data_stacked_sca = ones(2400,2400)*no_data_number;                          % Matrix for SCA values
Data_stacked_age = ones(2400,2400)*no_data_number;                          % Matrix for data age values

if Center_Date_option == 1;
    [start_day, end_day] = size(Data_stack);
%Merge the tiles that are forward/backward of center date
    for i = 1:(Center_date-1);
        % Find indexes with and withput data
        ind_data_back = find(~isnan(Data_stack(i).MCDAT));                  % Indexes for DATA values in stack date  
        ind_data_forw = find(~isnan(Data_stack(end_day+1-i).MCDAT));        % Indexes for DATA values in stack date  
                       
% Add to the matrix. Forward has priority to back        
        Data_stacked_sca(ind_data_back) = Data_stack(i).MCDAT(ind_data_back);

    if  test_mode == 1;
        Modis_Stacker_Plot_Data_sca(Data_stacked_sca,end_day,Date_vector(i),geo,print_fig,img_dir,['_DIS_',num2str(end_day+1-i),'_',datestr(Date_vector(Center_date),'yyyymmdd'),'_',num2str(end_day),'D_Stack_fsca'],vis,lw,cmapSnow);
    else
    end
    
        Data_stacked_sca(ind_data_forw) = Data_stack(end_day+1-i).MCDAT(ind_data_forw);
        
    if  test_mode == 1;
        Modis_Stacker_Plot_Data_sca(Data_stacked_sca,end_day,Date_vector(end_day+1-i),geo,print_fig,img_dir,['_DIS_',num2str(end_day+1-i),'_',datestr(Date_vector(Center_date),'yyyymmdd'),'_',num2str(end_day),'D_Stack_fsca'],vis,lw,cmapSnow);
    else
    end
        
        
        Data_stacked_age(ind_data_back) = i-Center_date;
        Data_stacked_age(ind_data_forw) = (end_day+1-i)-Center_date;
        
    end
%% Add Center Day Stack to the merged stack
        ind_data_cdm = find(~isnan(Data_stack(Center_date).MCDAT));          % Indexes for DATA values in center stack date
        Data_stacked_sca(ind_data_cdm) = Data_stacked_sca(ind_data_cdm); 
        Data_stacked_age(ind_data_cdm) = 0;
        % Make no data number as NaN
        Data_stacked_sca(Data_stacked_sca == no_data_number) = NaN;
        
        % Make data age into true age in days, not index number of data stack
        Data_stacked_age(Data_stacked_age == no_data_number) = NaN;          % NaN no data values
%% Make Stats for the merging
% For merged stack
    [av_sca_merged_stack,no_el_in,no_el_data,no_el_clouds,prct_data_in_merged_stack,prct_clouds_in_merged_stack,csum1,csum2] =...
    Modis_in_filter_sca(Data_stacked_sca, ins.in_isl);
%% For individual dates
for k = 1:end_day
    [av_sca,no_el_in,no_el_data,no_el_clouds,prct_data_in,prct_clouds_in,csum1,csum2] =...
    Modis_in_filter_sca(Data_stack(k).MCDAT, ins.in_isl);
    %Write to a table
    Merged_stats(k,:) = [Date_vector(k),prct_data_in];
end
     StackedResults = [ Date_vector(Center_date),...           % Center date of merged stack
     prct_data_in_merged_stack,...                          % Percent of data in the merged stack
     end_day];    
    
     Stacked_Stats = [StackedResults,Merged_stats(:,1)',Merged_stats(:,2)']
    else
end

if  test_mode == 1;
    print_name = 'Stack_out'
    Modis_Stacker_Plot_Stack(Data_stack,Date_vector,Center_date, geo,print_fig,img_dir,print_name,vis,lw,cmapSnow)
else
end
% Plotting
if plotting_on ==1;
    close all, clc
    lw = 0.1;                                   % Line width for plotting
    Date = Date_vector(Center_date);
    Modis_Stacker_Plot_Data_Age(Data_stacked_age,end_day,Center_date,Date,geo,print_fig,img_dir,['_Agg_',num2str(end_day),'D_Stack_age'],vis,lw,cmapAge);
    Modis_Stacker_Plot_Data_sca(Data_stacked_sca,end_day,Date,geo,print_fig,img_dir,['_Agg_',num2str(end_day),'D_Stack_fsca'],vis,lw,cmapSnow);
else
end
%% Write data to MAT file
if write_data == 1; 
    cd(data_write_dir);
    save(['MMCDDATA_7D_',datestr(Date,'yyyymmdd'),'.mat'],'Stacked_Stats', 'Data_stacked_age', 'Date_vector', 'Data_stacked_sca');
else
end
    

