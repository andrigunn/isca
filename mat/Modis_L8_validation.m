%% GDAL needs to do the following: 
% Resample to 500 m and Warp UTM to WGS
% gdalwarp -tr 500 500  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif
% gdalwarp -t_srs EPSG:4326  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500_wgs.tif

%% TESTING
clear all, close all
%%
mod_data_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\MCDDATA';               % Modis data to compare to 
L08_data_dir = 'E:\Dropbox\Landsat8_2A';                                    % Directory of Landsat data
geo_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo';
img_dir = 'F:\Maelingar\brunnur\Data\ISCA\img\L08_testing'
data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\'; 
print_fig = 1
geo = Modis_make_geo(geo_data_dir);
%% Find all directories from L08 Preprocessing and untaring
cd(L08_data_dir);
L08 = dir('*_untar');   
no_l8_scenes = length(L08)
T = zeros(1,5);
D = zeros(1,1);
F = zeros(1,1);
%%
for i = 1:no_l8_scenes
    L08_subdata_dir = [L08(i).folder,'\',L08(i).name]
    cd(L08_subdata_dir)
    % Read and make metadata for Landsat 8
    L08MetaRead = dir('*MTL*'); 
    L8_meta = L8_metaData(L08MetaRead.name)
    L8_Date = char(L8_meta.L1_METADATA_FILE(24));
    L8_Daten = datenum(L8_Date);
    L8_data_name = char(L8_meta.L1_METADATA_FILE(5));

    cd(mod_data_dir)                                                                    % CD to data folder with hdf files for MOD10A1 product
    mod = dir('M*');   
    mod = dates2header_matFile(mod);   
    ind_modis = find([mod(:).daten] == L8_Daten)
    S = whos( '-file',mod(ind_modis).name)
    load(mod(ind_modis).name);   
    %% Landsat 8 settings
        Fill = 1;
        MV_Fill = NaN;

        Clear =	[322];%, 386, 834, 898, 1346];
        MV_Land = 1;

        Snow = [336, 368 ]%, 400, 432, 848, 880, 912, 944, 1352];
        MV_Snow = 2;

        Water = [324, 388, 836, 900, 1348];
        Cloud_Shadow = [328, 392, 840, 904, 1350];
        Cloud = [352, 368, 416, 432, 480, 864, 880, 928, 944, 992];
        Low_confidence_cloud = [ 324, 328, 352,  834, 836, 840, 848, 864, 880];  %336,368,322,
        Medium_confidence_cloud = [386, 388, 392, 400, 416, 432, 900, 904, 928, 944];
        High_confidence_cloud = [480, 992];
        Low_confidence_cirrus = [ 324, 328,  352, 386, 388, 392, 400, 416, 432, 480]; % 336,368,322,
        High_confidence_cirrus = [834, 836, 840, 848, 864, 880, 898, 900, 904, 912, 928, 944, 992];
        Terrain_occlusion = [1346, 1348, 1350, 1352];

        NaNMask = [Water,Cloud_Shadow,Cloud,Low_confidence_cloud,Medium_confidence_cloud,High_confidence_cloud,Low_confidence_cirrus,High_confidence_cirrus,Terrain_occlusion];
        % read data from Landsat sub folder
        cd(L08_subdata_dir)
        [QA, RQ]  = geotiffread('pixel_qa_500_wgs.tif');
        QA = double(QA);%/100000;
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
    L8_500m = geointerp(QA,RQ,geo.lat,geo.lon,'nearest');
%% Make difference matrix
    modis_comparison_data = MCDAT;
    modis_comparison_data(modis_comparison_data<5)= MV_Land;
    modis_comparison_data(modis_comparison_data>=5)= MV_Snow;
    diff = modis_comparison_data-L8_500m;
    diff(diff == -1) = 1;
%% Plot MODIS data from mod data dir
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis 500 m';
    title_of_figure = 'MODIS'
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_fsca']
    Modis_plotter_L8(MCDAT,geo,name_dataset,name_date,name,'fSCA',print_fig,print_name,img_dir,title_of_figure)   
%% Plot MODIS bSCA
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis 500 m';
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_bsca']
    Modis_plotter_L8(modis_comparison_data,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)   
%% Plot Landsat 8 bSCA
    name_dataset = L8_data_name;
    name_date = datestr(L8_Date,'dd.mm.yyyy');
    name = 'Landsat 8 500 m';
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_L08_bsca']
    Modis_plotter_L8(L8_500m,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)   
%%
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis vs. Landsat 8';
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_vs_L08_dsca']
    Modis_plotter_L8(diff,geo,name_dataset,name_date,name,'dSCA',print_fig,print_name,img_dir)   
%% Stats for comparison
    diff_no_el = sum(sum(~isnan(diff)));
    diff_correct = sum(diff(:) == 0);
    diff_false = sum(diff(:) == 1);
    no_snow_l8 = find(L8_500m == 1);
    no_snow_l8 = numel(no_snow_l8)
    no_land_l8 = find(L8_500m == 2);
    no_land_l8 = numel(no_land_l8)
    
    Confusion_matrix = confusionmat(modis_comparison_data(:),L8_500m(:))
%% Mask the MODIS data tile to the pixel vise coverage of the MODIS tiles
    L8_mask = L8_500m;
    L8_mask(~isnan(L8_mask)) = 1;
    Modis_masked = L8_mask.*modis_comparison_data;
%%
    no_snow_mod = find(Modis_masked == 1);
    no_snow_mod = numel(no_snow_mod)
    no_land_mod = find(Modis_masked == 2);
    no_land_mod = numel(no_land_mod)


%%
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis at Landsat 8 boundary';
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_bsca_L08_boundary']
    Modis_plotter_L8(Modis_masked,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)  

%% Load data to table     
    Ti = [(mod(ind_modis).daten), no_snow_mod, no_land_mod, no_snow_l8,no_land_l8];
    T = [T;Ti];

    Di = [{mod(ind_modis).name}];
    D = [D;Di];

    Fi = [{L8_data_name}];
    F = [F;Fi];

save([data_write_dir,'Landsat_tiles\',L8_data_name,'_',datestr(mod(ind_modis).daten,'yyyymmdd')],'L8_500m');

end

    Modis_Landsat_comp_Stats = table(T(:,1),T(:,2),T(:,3),T(:,4),T(:,5),D(:,1),F(:,1));
    Modis_Landsat_comp_Stats.Properties.VariableNames = {'daten','no_snow_mod','no_land_mod', 'no_snow_l8','no_land_l8','Mod_dataname','L08_dataname'};
    Modis_Landsat_comp_Stats(1,:) = [];


save([data_write_dir,'Stats\','Modis_Landsat8_comp_Stats'],'Modis_Landsat_comp_Stats');

crop(img_dir)
sprintf('FINISHED')

















