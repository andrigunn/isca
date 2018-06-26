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
mcd_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MCDDATA'; % Directory with merged Aqua and Terra data
img_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\06_img\tmp';           % Directory to store exported images
data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\';      % Directory to write output files
%% Settings
% vis = 'on';                                                                         % Visibility of figures On(1) / Off(0)                        
% printFigure = 0;                                                                    % Print figure to img_dir folder (1)
% geo = Modis_make_geo;                                                               % Data for plotting. Shape files and coordinates of hdf files
% [ins, outs] = Modis_make_ins_outs;                                                  % Loads masks for exluding data 
day_buffer_forward = 3;                                                               % No of days used in forward buffer  
day_buffer_backward = 3;                                                              % No of days used in backwards buffer  
%%
MCD_Stats = table;                                                                  % Make an table to write statistics to 
cd(mcd_data_dir)                                                                    % CD to data folder with hdf files for MOD10A1 product
mcd = dir('MCD10A1*');                                                              % Read directory structure
mcd = dates2header_matFile(mcd);                                                            % Write time and date information to directory information for data

years_in_dataset = unique([mcd.year])
%%
clc
ii = 0;
time_dim = day_buffer_backward + 1 + day_buffer_forward;
for k = 1:1%length(years_in_dataset);                                         % Counter for number of years in the dataset                             
    ki = find([mcd.year] == years_in_dataset(k));                           % Indexes for years for k
    
    for j = day_buffer_backward:length(ki)-day_buffer_forward;
        ind = ki(j)
        % Make data stack
        if ind == 3
            i0 = ind-day_buffer_backward
        else
            i0 = ind-day_buffer_backward-1
        end
        
        for ji = 1:time_dim
            i0 = i0+1
            D(:,:)=load(mcd(i0).name);
            D() = 
        end
    end
    
end


%%
D = load('MCD10A1_2000055.mat')
%%
%     ii = ii+1;
% % Find if we have data tiles that match the date we look for 
%     imod_name = find([mod.daten]==k);      % index of file for the date
%     imyd_name = find([myd.daten]==k);      % index of file for the date
%  
%     if isempty(imod_name) == 1 && isempty(imyd_name) == 1 
%         continue
%     end
%     
%         if isempty(imod_name) == 0         % Zero if numbers are in matrix 
%         fname_mod = mod(imod_name).name;   % name of the HDF file from MOD to use
%         cd(mod_data_dir)
%         
%         [MODDATA, MODDATA_NAME,MODHDF_DATE] = Modis_import_data_hdf(...
%         fname_mod, GRID_NAME, DATAFIELD_NAME); 
%         
%         [av_mo,no_el_in_mo,no_el_data_mo,no_el_clouds_mo,prct_data_in_mo,prct_clouds_in_mo,csum1_mo,csum2_mo] =...
%         Modis_in_filter_sca(MODDATA, ins.in_isl);
%         %Modis_plot_merger_AT(MODDATA,vis,printFigure,k,MODDATA_NAME,img_dir,geo,prct_clouds_in_mo)    
%         save([data_write_dir,'MODDATA\',MODDATA_NAME(1:15)],'MODDATA'); 
        
%         else
%             clear MODDATA MODDATA_NAME MODHDF_DATE    
%             av_mo = nan;
%             no_el_in_mo= nan;
%             no_el_data_mo= nan;
%             no_el_clouds_mo= nan;
%             prct_data_in_mo= nan;
%             prct_clouds_in_mo= nan;
%             csum1_mo= nan;
%             csum2_mo= nan;
%         end
%     
%         if isempty(imyd_name) == 0      % Zero if numbers are in matrix 
%             fname_myd = myd(imyd_name).name;    % name of the HDF file from MYD to use%   
%             cd(myd_data_dir)
%             [MYDDATA, MYDDATA_NAME,MYDHDF_DATE] = Modis_import_data_hdf(...
%             fname_myd, GRID_NAME, DATAFIELD_NAME); 
%             [av_my,no_el_in_my,no_el_data_my,no_el_clouds_my,prct_data_in_my,prct_clouds_in_my,csum1_my,csum2_my] =...
%             Modis_in_filter_sca(MYDDATA, ins.in_isl);
% 
%             %Modis_plot_merger_AT(MYDDATA,vis,printFigure,k,MYDDATA_NAME,img_dir,geo,prct_clouds_in_my) 
%             save([data_write_dir,'MYDDATA\',MYDDATA_NAME(1:15)],'MYDDATA'); 
%         else
%             clear MYDDATA MYDDATA_NAME MYDHDF_DATE
%             av_my = nan;
%             no_el_in_my= nan;
%             no_el_data_my= nan;
%             no_el_clouds_my= nan;
%             prct_data_in_my= nan;
%             prct_clouds_in_my= nan;
%             csum1_my= nan;
%             csum2_my= nan;
%         end
%         
%         if isempty(imod_name) == 0
%             MCDAT = MODDATA;
%             x = isnan(MCDAT);
%             MCDDATA_NAME = MODDATA_NAME; MCDDATA_NAME(2) = 'C';
%             mod_used = 1
%         elseif isempty(imod_name) == 1
%             MCDAT = MYDDATA;
%             MCDDATA_NAME = MYDDATA_NAME; MCDDATA_NAME(2) = 'C';
%             myd_used = 2
%         end
%         
%         if isempty(imyd_name) == 0
%             MCDAT(x) = MYDDATA(x);
%         else
%             MCDAT = MODDATA;
%         end
        
%         % Reiknum t�lfr��i fyrir samsetningur
%         [av_mc,no_el_in_mc,no_el_data_mc,no_el_clouds_mc,prct_data_in_mc,prct_clouds_in_mc,csum1_mc,csum2_mc] =...
%         Modis_in_filter_sca(MCDAT, ins.in_isl);
%         % B�um til dagsetningar fyrir t�lfr��it�fluna
%         Daten = k;
%         tb = time_builder(k); 
%         year = tb(1); 
%         month = tb(2);
%         day = tb(3);
%         hour = tb(4);
%         minute = tb(5);
%         doy = tb(6);
%         % B�um til t�fluna
%         
%         x_t =  table(Daten,year,month,day,hour,minute,doy,...
%                      av_mo,no_el_in_mo,no_el_data_mo,no_el_clouds_mo,prct_data_in_mo,prct_clouds_in_mo,csum1_mo,csum2_mo,...
%                      av_my,no_el_in_my,no_el_data_my,no_el_clouds_my,prct_data_in_my,prct_clouds_in_my,csum1_my,csum2_my,...
%                      av_mc,no_el_in_mc,no_el_data_mc,no_el_clouds_mc,prct_data_in_mc,prct_clouds_in_mc,csum1_mc,csum2_mc);
%         MCT_Stats = [MAT_Stats;x_t];
% 
%        
%         Modis_P_merger_Aqua_Terra(MCDAT,vis,printFigure,k,MCDDATA_NAME,img_dir,geo,prct_clouds_in_mc) 
%         save([data_write_dir,'MCDDATA\',MCDDATA_NAME(1:15)],'MCDAT'); 
%         
%         close all
%         %clear MCDAT MODDATA MYDDATA x_t
end
         
%         save([data_write_dir,'Stats\','MAT_Stats'],'MAT_Stats');  
%     
%     sprintf('FINISHED')
