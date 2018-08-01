function mask_from_shape(Mask_shp_file, geo_data_dir, Masking_option)
%% INPUT
% Mask_shp_file:    File that has the extent of the areas to mask
% Masking_option where: 
%       0 mask inside of shapefile as zero
%       1 mask inside of shapefile as one
%       2 mask inside of shapefile as NaN and outside as one(1)
%       3 mask outside of shapefile as NaN and inside as one(1)
%% Set glaciers to 100
%Mask_shp_file = shaperead('corine_12_glaciers_wgs.shp')
Mask_shp_file = shaperead('corine_12_water_bodies_wgs.shp')
Masking_option = 2
geo_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo';
%%
geo = Modis_make_geo(geo_data_dir); 

%% Make the mask from the shape file
S = Mask_shp_file;
[ix iy] = size(geo.lat);
in = zeros(ix,ix);
%%
shape_number = length(S);           % Find number of shapes in the shape file to process
for i = 1:shape_number;
    [in_n on] = inpolygon(geo.lon,geo.lat,S(i).X,S(i).Y);
    in = in+ in_n;
end
%% Set shape mask values 
if Masking_option == 2
    in(in == 1) = NaN;
    in(in == 0) = 1;
elseif Masking_option == 3
    in(in == 0) = NaN;
end

%% Plotting of mask
vis = 'on'
f = figure( 'visible',vis,'Position', [50, 100, 1200, 800]);
latlimit = [63.35 66.58]; lonlimit = [-24.6 -13.4];
hold on 
axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit)%,'Position', AxisPos(i, :));
lw = 0.1;
    pcolorm(geo.lat,geo.lon,in);
    shading flat;
    colorbar 
    plotm([S.Y],[S.X], 'k','linewidth',lw);
    

%% Write to mask structure
cd(geo_data_dir)
geoMasks.waterbodies_isl = in;




