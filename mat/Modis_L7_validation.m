%% GDAL needs to do the following: 
% Resample to 500 m and Warp UTM to WGS
% gdalwarp -tr 500 500  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif
% gdalwarp -t_srs EPSG:4326  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500_wgs.tif

%% TESTING
clear all, close all
%%
mod_data_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\MCDDATA';               % Modis data to compare to 
L07_data_dir = 'E:\Dropbox\Landsat7_2A';                                    % Directory of Landsat data
geo_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo';
img_dir = 'F:\Maelingar\brunnur\Data\ISCA\img\L07_testing'
data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\'; 
print_fig = 1
geo = Modis_make_geo(geo_data_dir);
%% Find all directories from L08 Preprocessing and untaring
cd(L07_data_dir);
L07 = dir('*_untar');   
no_l7_scenes = length(L07)
T = zeros(1,5);
D = zeros(1,1);
F = zeros(1,1);
%%
for i = 1:no_l7_scenes
    L07_subdata_dir = [L07(i).folder,'\',L07(i).name]
    cd(L07_subdata_dir)
    % Read and make metadata for Landsat 8
    L07MetaRead = dir('*MTL*'); 
    L7_meta = L8_metaData(L07MetaRead.name)
    L7_Date = char(L7_meta.L1_METADATA_FILE(24));
    L7_Daten = datenum(L7_Date);
    L7_data_name = char(L7_meta.L1_METADATA_FILE(5));

    cd(mod_data_dir)                                                                    % CD to data folder with hdf files for MOD10A1 product
    mod = dir('M*');   
    mod = dates2header_matFile(mod);   
    ind_modis = find([mod(:).daten] == L7_Daten)
    S = whos( '-file',mod(ind_modis).name)
    load(mod(ind_modis).name);   
%% Landsat 7 settings
        Fill = 1;
        MV_Fill = NaN;

        Clear =	[66,130];%66, 130
        MV_Land = 1;

        Snow = [80, 112 ]%80, 112, 144, 176
        MV_Snow = 2;

        Water = [68, 132];
        Cloud_Shadow = [72, 136];
        Cloud = [96, 160, 176, 224];%, 112
        Low_cloud_confidence = [ 68, 72, 96 ]; % 112 66,80
        Medium_cloud_confidence = [ 132, 136, 144, 160, 176]; %130,
        High_cloud_confidence =	224;

        NaNMask = [Water,Cloud_Shadow,Cloud,Low_cloud_confidence,Medium_cloud_confidence,High_cloud_confidence];
%% Read data from Landsat sub folder
        cd(L07_subdata_dir)
        [QA, RQ]  = geotiffread('LE07_L1TP_216014_20100608_20161214_01_T1_pixel_qa_wgs.tif');
        QA = double(QA);%/100000;
%% Mask data
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
%% Resample L7 to MODIS pixels
    L7_500m = geointerp(QA,RQ,geo.lat,geo.lon,'nearest');
%% Make difference matrix
    modis_comparison_data = MCDAT;
    modis_comparison_data(modis_comparison_data<5)= MV_Land;
    modis_comparison_data(modis_comparison_data>=5)= MV_Snow;
    diff = modis_comparison_data-L7_500m;
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
    name_dataset = L7_data_name;
    name_date = datestr(L7_Date,'dd.mm.yyyy');
    name = 'Landsat 7 @500 m';
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_L07_bsca']
    Modis_plotter_L8(L7_500m,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)   
%%
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis vs. Landsat 7';
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_vs_L08_dsca']
    Modis_plotter_L8(diff,geo,name_dataset,name_date,name,'dSCA',print_fig,print_name,img_dir)   
%% Stats for comparison
    diff_no_el = sum(sum(~isnan(diff)));
    diff_correct = sum(diff(:) == 0);
    diff_false = sum(diff(:) == 1);
    no_snow_l7 = find(L7_500m == 1);
    no_snow_l7 = numel(no_snow_l7)
    no_land_l7 = find(L7_500m == 2);
    no_land_l7 = numel(no_land_l7)
    
    Confusion_matrix = confusionmat(modis_comparison_data(:),L7_500m(:))
%% Mask the MODIS data tile to the pixel vise coverage of the MODIS tiles
    L7_mask = L7_500m;
    L7_mask(~isnan(L7_mask)) = 1;
    Modis_masked = L7_mask.*modis_comparison_data;
%%
    no_snow_mod = find(Modis_masked == 1);
    no_snow_mod = numel(no_snow_mod)
    no_land_mod = find(Modis_masked == 2);
    no_land_mod = numel(no_land_mod)


%%
    name_dataset = [mod(ind_modis).name];
    name_date = datestr(mod(ind_modis).daten,'dd.mm.yyyy');
    name = 'Modis at Landsat 7 boundary';
    print_name = [datestr(mod(ind_modis).daten,'yyyymmdd'),'_mod_bsca_L07_boundary']
    Modis_plotter_L8(Modis_masked,geo,name_dataset,name_date,name,'bSCA',print_fig,print_name,img_dir)  

%% Load data to table     
    Ti = [(mod(ind_modis).daten), no_snow_mod, no_land_mod, no_snow_l7,no_land_l7];
    T = [T;Ti];

    Di = [{mod(ind_modis).name}];
    D = [D;Di];

    Fi = [{L7_data_name}];
    F = [F;Fi];

save([data_write_dir,'Landsat_tiles\',L7_data_name,'_',datestr(mod(ind_modis).daten,'yyyymmdd')],'L7_500m');

end

    Modis_Landsat_comp_Stats = table(T(:,1),T(:,2),T(:,3),T(:,4),T(:,5),D(:,1),F(:,1));
    Modis_Landsat_comp_Stats.Properties.VariableNames = {'daten','no_snow_mod','no_land_mod', 'no_snow_l7','no_land_l7','Mod_dataname','L07_dataname'};
    Modis_Landsat_comp_Stats(1,:) = [];


save([data_write_dir,'Stats\','Modis_Landsat7_comp_Stats'],'Modis_Landsat_comp_Stats');

crop(img_dir)
sprintf('FINISHED')

















