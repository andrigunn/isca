%% Make geo files for plotting MODIS data
function geo = Modis_make_geo
cd('E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo')
load('geo_hv17.mat')
% Make geo structure
geo.lat = lat;
geo.lon = lon; 
geo.utlina_isl = shaperead('is50v_strandlina_flakar_ll');
geo.utlina_vat = shaperead('VATNAJ__UTLINA');
geo.utlina_hof = shaperead('HOFSJ_UTLINA_nn');
geo.utlina_lan = shaperead('LANGJ_UTLINA');