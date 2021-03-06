%% GDAL needs to do the following: 

%% TESTING
clear all, close all, clc
%%
addpath('C:\Users\andrigun\Documents\GitHub\isca')
mod_data_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\MCDDATA';               % Modis data to compare to 
%mod_data_dir = '/Users/andrigun/Dropbox/01 - Icelandic Snow Observatory - ISO/ISCA/05_data/MCDDATA';
%S2_data_dir = 'D:\Sentinel2_2A'
S2_data_dir = 'X:\isca_backup\SCL'
%S2_data_dir = '/Users/andrigun/Dropbox/Sentinel2A';                         % Directory of Sentinel data
geo_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo';
%geo_data_dir = '/Users/andrigun/Dropbox/01 - Icelandic Snow Observatory - ISO/ISCA/05_data/geo';
img_dir = 'F:\Maelingar\brunnur\Data\ISCA\img\S2_testing'
%img_dir = '/Users/andrigun/Dropbox/01 - Icelandic Snow Observatory - ISO/ISCA';
data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\'; 
%data_write_dir = '/Users/andrigun/Dropbox/01 - Icelandic Snow Observatory - ISO/ISCA/05_data';
print_fig = 1
geo = Modis_make_geo(geo_data_dir);
%% Find all directories from L08 Preprocessing and untaring
cd(S2_data_dir);
%%
S2 = dir('*QA*');   
T = zeros(1,5);
D = zeros(1,1);
F = zeros(1,1);
%S2(1:127) = [];
no_S2_scenes = length(S2)
%% Stop in 444. Started in 700 again Check in between
for i = 1:no_S2_scenes
    %%
    cd(S2_data_dir);
    %S2_subdata_dir = [S2(i).name]%,'\GRANULE',L08(i).name]
    %cd(S2_subdata_dir)
    %% Read and make metadata for Sentinel 2
    %S2MetaRead = dir('MTD*'); 
    %MTDMSIL2A = S2_meta_lineRead(S2MetaRead.name)
    %[ S2_meta ] = xml2struct( S2MetaRead.name)
    %S2_Date = S2_meta.n1_colon_Level_dash_2A_User_Product.n1_colon_General_Info.L2A_Product_Info.PRODUCT_START_TIME.Text
    %S2_Date = S2_meta.n1_colon_Level_dash_2A_User_Product.n1_colon_General_Info.Product_Info.PRODUCT_START_TIME.Text
    %S2_Daten = datenum(S2_Date,'yyyy-mm-dd')%THH:MM:SS.FFFZ')
    %S2_Date = datestr(S2_Daten,'yyyy-mm-dd')
    S2_data_name = S2(i).name;
       
    expression = '[0123456789]+T[0123456789]';
    startIndex = regexp(S2_data_name,expression)
    
    S2_Daten = datenum(S2_data_name(15:15+7),'yyyymmdd')%THH:MM:SS.FFFZ')
    S2_Date = datestr(S2_Daten,'yyyy-mm-dd')
    
    %S2_data_name = S2_meta.n1_colon_Level_dash_2A_User_Product.n1_colon_General_Info.L2A_Product_Info.PRODUCT_URI_2A.Text
    %S2_data_name = S2_meta.n1_colon_Level_dash_2A_User_Product.n1_colon_General_Info.Product_Info.PRODUCT_URI.Text
    %% Load MODIS data for the aquire date of Sentinel 2A
    cd(mod_data_dir)                                                                    % CD to data folder with hdf files for MOD10A1 product
    mod = dir('M*');   
    mod = dates2header_matFile(mod);
    
    ind_modis = find([mod(:).daten] == S2_Daten)
   if isempty(ind_modis) == 1
        continue
    end
    S = whos( '-file',mod(ind_modis).name)
    load(mod(ind_modis).name);   
    %% Sentinel 2 settings
%     var scl = SCL;
% if (scl == 0) { // No Data
%   return [0, 0, 0]; // black
% } else if (scl == 1) { // Saturated / Defective
%   return [1, 0, 0.016]; // red
% } else if (scl == 2) { // Dark Area Pixels
%   return [0.525, 0.525, 0.525]; // gray
% } else if (scl == 3) { // Cloud Shadows
%   return [0.467, 0.298, 0.043]; // brown
% } else if (scl == 4) { // Vegetation
%   return [0.063, 0.827, 0.176]; // green
% } else if (scl == 5) { // Bare Soils
%   return [1, 1, 0.325]; // yellow
% } else if (scl == 6) { // Water
%   return [0, 0, 1]; // blue
% } else if (scl == 7) { // Clouds low probability / Unclassified
%   return [0.506, 0.506, 0.506]; // medium gray
% } else if (scl == 8) { // Clouds medium probability
%   return [0.753, 0.753, 0.753]; // light gray
% } else if (scl == 9) { // Clouds high probability
%   return [0.949, 0.949, 0.949]; // very light gray
% } else if (scl == 10) { // Cirrus
%   return [0.733, 0.773, 0.925]; // light blue/purple
% } else if (scl == 11) { // Snow / Ice
%   return [0.325, 1, 0.980]; // cyan
% } else { // should never happen
%   return [0,0,0];
% }
        Fill = 0;
        MV_Fill = NaN;

        Clear =	[4, 5];%, 386, 834, 898, 1346];
        MV_Land = 1;

        Snow = [11];%, 400, 432, 848, 880, 912, 944, 1352];
        MV_Snow = 2;

        NaNMask = [1,2,3,6,7,8,9,10];
%% read data from Landsat sub image folder
    clear S2_scl_scene
        %S2_scl_scene = [S2_meta.n1_colon_Level_dash_2A_User_Product.n1_colon_General_Info.Product_Info.Product_Organisation.Granule_List{1, 1}.Granule.IMAGE_FILE{1, 12}.Text]
        %S2_scl_scene = [S2_meta.n1_colon_Level_dash_2A_User_Product.n1_colon_General_Info.Product_Info.Product_Organisation.Granule_List(1, 1).Granule.IMAGE_FILE(1, 12).Text]
        %S2_scl_scene = S2_scl_scene(1:end-30)
       %% cd(S2_subdata_dir)
        %cd([S2_data_dir,'\',S2_subdata_dir])
        cd(S2_data_dir)
%         cd(S2_subdata_dir)
%         cd('GRANULE')
%         a1 = dir
        %% name = a1(~strncmp(a1, 'L*', 1))   % No files starting with '.'
%         folder = char({a1(3).name})
%         cd(folder)
%         cd('IMG_DATA\R60m')
         S2_scl_scene = [S2_data_name];
        %%
        [QA, RQ]  = geotiffread(S2_scl_scene);
        QA = double(QA);
%%
        % Mask NaN Fill
            c = ismember(QA,Fill);
            indexes_clear = find(c);
            QA(c) = MV_Fill; 
        % Mask NaN 
            c = ismember(QA,NaNMask);
            indexes_clear = find(c);
            QA(c) = MV_Fill;
        % Mask Land Pixels
            c = ismember(QA,Clear);
            indexes_clear = find(c);
            QA(c) = MV_Land; 
        % Mask Snow Pixels
            c = ismember(QA,Snow);
            indexes_clear = find(c);
            QA(c) = MV_Snow; 
%% Resample L8 to MODIS pixels
    S2_500m = geointerp(QA,RQ,geo.lat,geo.lon,'nearest');
%% Make difference matrix
    modis_comparison_data = MCDAT;
    modis_comparison_data(modis_comparison_data<5)= MV_Land;
    modis_comparison_data(modis_comparison_data>=5)= MV_Snow;
    diff = modis_comparison_data-S2_500m;
    diff(diff == -1) = 1;
%% Plot MODIS data from mod data dir
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis 500 m';
    title_of_figure = 'MODIS'
    print_name = [num2str(i),'_',datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_fsca']
    Modis_plotter_L8(MCDAT,geo,name_dataset,name_date,name,'fSCA',print_fig,print_name,img_dir,title_of_figure)   
%% Plot MODIS bSCA
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis 500 m';
    print_name = [num2str(i),'_',datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_bsca']
    Modis_plotter_L8(modis_comparison_data,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)   
%% Plot Landsat 8 bSCA
    name_dataset = S2_data_name;
    name_date = datestr(S2_Date,'dd.mm.yyyy');
    name = 'Sentinel 2A@500 m';
    print_name = [num2str(i),'_',datestr(mod(ind_modis).daten,'yyyymmdd'),'_S2A_bsca']
    Modis_plotter_L8(S2_500m,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)   
%%
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis vs. Sentinel 2A';
    print_name = [num2str(i),'_',datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_vs_S2A_dsca']
    Modis_plotter_L8(diff,geo,name_dataset,name_date,name,'dSCA',print_fig,print_name,img_dir)   
%% Stats for comparison
    diff_no_el = sum(sum(~isnan(diff)));
    diff_correct = sum(diff(:) == 0);
    diff_false = sum(diff(:) == 1);
    no_snow_S2 = find(S2_500m == 1);
    no_snow_S2 = numel(no_snow_S2)
    no_land_S2 = find(S2_500m == 2);
    no_land_S2 = numel(no_land_S2)
    
    Confusion_matrix = confusionmat(modis_comparison_data(:),S2_500m(:))
%% Mask the MODIS data tile to the pixel vise coverage of the MODIS tiles
    S2_mask = S2_500m;
    S2_mask(~isnan(S2_mask)) = 1;
    Modis_masked = S2_mask.*modis_comparison_data;
%%
    no_snow_mod = find(Modis_masked == 1);
    no_snow_mod = numel(no_snow_mod)
    no_land_mod = find(Modis_masked == 2);
    no_land_mod = numel(no_land_mod)

%%
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis at Sentinel 2A boundary';
    print_name = [num2str(i),'_',datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_bsca_S2A_boundary']
    Modis_plotter_L8(Modis_masked,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)  

%% Load data to table     
    Ti = [(mod(ind_modis).daten), no_snow_mod, no_land_mod, no_snow_S2,no_land_S2];
    T = [T;Ti];

    Di = [{mod(ind_modis).name}];
    D = [D;Di];

    Fi = [{S2_data_name}];
    F = [F;Fi];

save([data_write_dir,'Sentinel_tiles\',S2_data_name,'_',datestr(mod(ind_modis).daten,'yyyymmdd'),'.mat'],'S2_500m');
close all
end

    Modis_Sentinel_comp_Stats = table(T(:,1),T(:,2),T(:,3),T(:,4),T(:,5),D(:,1),F(:,1));
    Modis_Sentinel_comp_Stats.Properties.VariableNames = {'daten','no_snow_mod','no_land_mod', 'no_snow_S2','no_land_S2','Mod_dataname','S2_dataname'};
    Modis_Sentinel_comp_Stats(1,:) = [];


save([data_write_dir,'Stats\','Modis_Sentine2_comp_Stats'],'Modis_Sentinel_comp_Stats');

crop(img_dir)
sprintf('FINISHED')

















