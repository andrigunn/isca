%% GDAL needs to do the following: 
% Resample to 500 m and Warp UTM to WGS
% gdalwarp -tr 500 500  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif
% gdalwarp -t_srs EPSG:4326  LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500.tif LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500_wgs.tif

%% TESTING
cd('E:\Dropbox\Landsat8_2A\LC082180142018062001T1-SC20180807094409')
L8_meta = L8_metaData('LC08_L1TP_218014_20180620_20180703_01_T1_MTL.txt')

% Directory with Modis data to compare to 
mod_data_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\MCDDATA';
cd(mod_data_dir)                                                                    % CD to data folder with hdf files for MOD10A1 product
mod = dir('M*');   
mod = dates2header_matFile(mod);   

L8_Date = char(L8_meta.L1_METADATA_FILE(24));
L8_Daten = datenum(L8_Date);

ind_modis = find([mod(:).daten] == L8_Daten)
load(mod(ind_modis).name);   

%%
cd('E:\Dropbox\Landsat8_2A\LC082180142018062001T1-SC20180807094409')
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

[QA, RQ]  = geotiffread('LC08_L1TP_218014_20180620_20180703_01_T1_pixel_qa_500_wgs.tif');
QA = double(QA);%/100000;
%%
% Mask NaN Fill
c = ismember(QA,Fill);
indexes_clear = find(c);
QA(c) = MV_Fill; 
%
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
%%
L8_500m = geointerp(QA,RQ,geo.lat,geo.lon,'nearest');
%val = ltln2val(QA, RQ, lat, lon);
%
%%
geo_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo';
geo = Modis_make_geo(geo_data_dir);
%%
close all

modis_comparison_data = MCDAT;
modis_comparison_data(modis_comparison_data<5)= MV_Land;
modis_comparison_data(modis_comparison_data>=5)= MV_Snow;
diff = modis_comparison_data-L8_500m;
diff(diff == -1) = 1;
%%
Modis_plotter_L8(MCDAT,geo,'MCDAT fSCA','fSCA')   
%%
Modis_plotter_L8(modis_comparison_data,geo,'MODIS SCA','bSCA')   
%%
Modis_plotter_L8(L8_500m,geo,'LANDSAT8 500 m','bSCA')   
%%
Modis_plotter_L8(diff,geo,'DIFF MODIS AND LANDSAT8','dSCA')   
%% Stats for comparison
    diff_no_el = sum(sum(~isnan(diff)))
    diff_correct = sum(diff(:) == 0)
    diff_false = sum(diff(:) == 1)
    no_snow_l8 = find(L8_500m == 1)
    no_snow_l8 = numel(no_snow_l8)
    no_land_l8 = find(L8_500m == 2)
    no_land_l8 = numel(no_land_l8)
    
    Confusion_matrix = confusionmat(modis_comparison_data(:),L8_500m(:))
    
% %%
%   y = unique(diff);
%   if any(isnan(y))
%     y(isnan(y)) = []; % remove all nans
%     y(end+1) = NaN; % add the unique one.
%   end
%   
%   y
% 
% 
















