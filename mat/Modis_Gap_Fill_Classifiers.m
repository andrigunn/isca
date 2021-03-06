function Modis_Gap_Fill_Classifiers(data_dir_data_to_classify,save_name)
%% TESTING
%data_dir_data_to_classify = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MCDDATA'
data_dir_data_to_classify = 'F:\Maelingar\brunnur\Data\ISCA\Data\MMCDDATA_5D'
geo_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo';
save_name = 'MMCDDATA_5D'
%% Read DEM for ICELAND from GDAL output
[Zdem,Rdem] = arcgridread([geo_data_dir,'\isl_dem_500m_wgs.txt']);     % Read in DEM for ICELAND
[Zasp,Rasp] = arcgridread([geo_data_dir,'\isl_aspect_500m_wgs.txt']);  % Read in ASPECT for ICELAND

geo = Modis_make_geo(geo_data_dir);
data_write_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\GapFilling_ts';
%%
%load('E:\Dropbox\Remote\geo_mcd43a3');        
%% Map elevation to Lat and Lon from MODIS
X = geo.lat(:);                                                     % Latitudes for MODIS              
Y = geo.lon(:);                                                     % Longitudes for MODIS  
Z = ltln2val(Zdem,Rdem,X,Y);                                    % Map elevation from isl_dem_500m_wgs   
A = ltln2val(Zasp,Rasp,X,Y);                                    % Map elevation from isl_dem_500m_wgs   
%% Reshape for plotting
Xr = reshape(X,2400,2400);
Yr = reshape(Y,2400,2400);
Zr = reshape(Z,2400,2400);
Ar = reshape(A,2400,2400);
%% %% === Make data matrix to classify === %% %%
cd(data_dir_data_to_classify);                                             % CD to data dir 
%
nfile = dir('*.mat')                                            % Find MODIS data files
% There is a naming difference for MMCDDATA_XD data and Merged daily data
% Convert date in nfile file to data structure
TF = contains(nfile(1).name,'MCD10A1');         %Check is data is Merged or from the temporal filter
if TF == 1
    for i = 1:length(nfile);
        dname = nfile(i).name;
        dname = dname(end-10:end-4);
        date_on_graph = dname;
        year = date_on_graph(:,1:4);
        doy= date_on_graph(:,5:end);
        dv = datenum(year,'yyyy');
        modis_daten = dv+str2num(doy);
        nfile(i).datenum = modis_daten;
        nfile(i).Date = modis_daten;
        nfile(i).Date = datestr(modis_daten);
    end
elseif TF == 0
    for i = 1:length(nfile);
        dname = nfile(i).name;
        dname = dname(end-11:end-4);
        date_on_graph = dname;
        year = date_on_graph(:,1:4);
        month = date_on_graph(:,5:6);
        day = date_on_graph(:,7:end);
        date =[year,month,day];
        formatIn = 'yyyymmdd';
        dv = datenum(date,formatIn);
        modis_daten = dv;
        nfile(i).datenum = modis_daten;
        nfile(i).Date = modis_daten;
        nfile(i).Date = datestr(modis_daten);
    end
end
%% === Read MODIS tile for data structure === %% 
clear results GFD
ic = 0;
tic
for ip = 1:1000
    ic = ic+1;
    load(nfile(ip).name)
%% Mask data
    SCA = Data_stacked_sca;
    %Modis_plotter(SCA,geo,'Raw')
    %% Set glacier as fixed 100% snow cover 
    ig = isnan([geo.masks.glaciers]);    iig = double(ig);
    kg = find(iig==1);
    SCA(kg) = 100;                   % Set glacier pixels to 100 fSCA
    %Modis_plotter(SCA,geo,'RAW + Glacier Mask')
    %% Set Water bodies to NaN
    iw = isnan([geo.masks.waterbodies]);    iiw = double(iw);
    kw = find(iiw==1);
    SCA(kw) = NaN;                   % Set glacier pixels to 100 fSCA
    %Modis_plotter(SCA,geo,'RAW + Glacier Mask + Watere bodies')    
    %% Set thresholds of snow/now snow for fSCA
    SCA(SCA<=25)=0; 
    SCA(SCA>25)=1;                                      % Reclassify fSCA to bSCA (fractional snow cover to binary snow cover)
    in_v = geo.ins.island(:);                                       % Masking vector to throw out values over sea 0 is sea and 1 is land
    k = find(in_v==1);                                  % Find index for land elements
    raw_data = [SCA(k),X(k),Y(k),Z(k),A(k)];            % All data matrix
    cloud_cover = sum(isnan(raw_data(:,1)))/length(raw_data(:,1))*100;
%% Find data that has classification as snow/no snow
    indTrain = isnan(raw_data(:,1));
    j = find(indTrain==1);
    m = find(indTrain==0);
    classify_data   = [raw_data(j,1),raw_data(j,2),raw_data(j,3),raw_data(j,4),raw_data(j,5)];
    classify_data   = classify_data(:,2:5);
    train_data      = [raw_data(m,1),raw_data(m,2),raw_data(m,3),raw_data(m,4),raw_data(m,5)];
% Make tables    
    Train_data         = array2table(train_data);
    Train_data.Properties.VariableNames = {'SnowClass' 'Lat' 'Lon' 'Elevation','Aspect'};
    Classify_data      = array2table(classify_data);
    Classify_data.Properties.VariableNames = {'Lat' 'Lon' 'Elevation','Aspect'};
%% Train and classify data
    [trainedClassifier_KNN_fine, validationAccuracy_KNN_fine] = trainClassifier__KNN_fine(Train_data);
    yfit_KNN_fine = trainedClassifier_KNN_fine.predictFcn(Classify_data); 
    Classified_data_KNN_fine = Classify_data;
    Classified_data_KNN_fine.SnowClass = yfit_KNN_fine;
    gap_filled_data_KNN_fine = [Train_data;Classified_data_KNN_fine];
    snow_pixels_KNN_fine = sum(gap_filled_data_KNN_fine.SnowClass);
    land_pixels_KNN_fine = length(gap_filled_data_KNN_fine.Lat)-snow_pixels_KNN_fine; 
%%   
    [trainedClassifier_TREE_complex, validationAccuracy_TREE_complex] =  trainClassifier_TREE_complex(Train_data);
    yfit_TREE_complex =  trainedClassifier_TREE_complex.predictFcn(Classify_data) ;
    Classified_data_TREE_complex = Classify_data;
    Classified_data_TREE_complex.SnowClass = yfit_TREE_complex;
    gap_filled_data_TREE_complex = [Train_data;Classified_data_TREE_complex];
    snow_pixels_TREE_complex = sum(gap_filled_data_TREE_complex.SnowClass);
    land_pixels_TREE_complex = length(gap_filled_data_TREE_complex.Lat)-snow_pixels_TREE_complex;    
%%
    [trainedClassifier_BOOST, validationAccuracy_BOOST] = trainClassifier_BOOST(Train_data)
    yfit_BOOST =  trainedClassifier_BOOST.predictFcn(Classify_data) ;
    Classified_data_BOOST = Classify_data;
    Classified_data_BOOST.SnowClass = yfit_BOOST;
    gap_filled_data_BOOST = [Train_data;Classified_data_BOOST];
    snow_pixels_BOOST = sum(gap_filled_data_BOOST.SnowClass);
    land_pixels_BOOST = length(gap_filled_data_BOOST.Lat)-snow_pixels_BOOST;   
%%
    [trainedClassifier_KNN_weighted, validationAccuracy_KNN_weighted] = trainClassifier_KNN_weighted(Train_data)
    yfit_KNN_weighted =  trainedClassifier_KNN_weighted.predictFcn(Classify_data) ;
    Classified_data_KNN_weighted = Classify_data;
    Classified_data_KNN_weighted.SnowClass = yfit_KNN_weighted;
    gap_filled_data_KNN_weighted = [Train_data;Classified_data_KNN_weighted];
    snow_pixels_KNN_weighted = sum(gap_filled_data_KNN_weighted.SnowClass);
    land_pixels_KNN_weighted = length(gap_filled_data_KNN_weighted.Lat)-snow_pixels_KNN_weighted;  
%%
    results(ic,1:14) = [nfile(ip).datenum,cloud_cover,...
                        validationAccuracy_KNN_fine,    snow_pixels_KNN_fine,    land_pixels_KNN_fine...
                        validationAccuracy_TREE_complex,snow_pixels_TREE_complex,land_pixels_TREE_complex...
                        validationAccuracy_BOOST,       snow_pixels_BOOST,       land_pixels_BOOST,...
                        validationAccuracy_KNN_weighted,snow_pixels_KNN_weighted,land_pixels_KNN_weighted];
%% Daily save of data    
    GFD.KNNW = gap_filled_data_KNN_weighted;
    GFD.KNNF = gap_filled_data_KNN_fine;
    GFD.TREE = gap_filled_data_TREE_complex;
    GFD.BOOS = gap_filled_data_BOOST;
    GFD.DATE = nfile(ip).datenum;
    DNAME = GFD.DATE;
    save([data_write_dir,'\',num2str(DNAME),'_GFD_',save_name],'GFD');
end
%%
Results = array2table(results)
Results.Properties.VariableNames = {'Date','CloudCover','Val_acc_KNN','SnowPixels_KNN','LandPixels_KNN','Val_acc_TREE','SnowPixels_TREE','LandPixels_TREE','Val_acc_BOO','SnowPixels_BOO','LandPixels_BOO','Val_acc_KNNw','SnowPixels_KNNw','LandPixels_KNNw'};

save([data_write_dir,'\GapFilledData_tmp',save_name],'Results');

%data_write_dir

C = 'DONE !!!'

toc






% %% Plot results for mapping elevation
%     f = figure('Position', [500,100, 900, 600])
%     latlimit = [63.35 66.58];
%     lonlimit = [-24.6 -13.4];
%     axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit,'Frame','on');
%     pcolorm(Xr,Yr,Zr), 
%     shading interp
%     demcmap(Zr,100)
%     hb = colorbar
%     set(hb,'FontSize',12);
%     %title(hb, '%')
%     %caxis([0 2000])
%     ylabel(hb, 'Elevation (m a.s.l.)','FontSize',12)
%     tightmap;
%     lw = 1.1;
%     x = S(4524).Y;
%     y = S(4524).X;
%     plotm([S(4524).Y],[S(4524).X], 'k','linewidth',lw);
%     northarrow('latitude',63.5,'longitude',-24,'linewidth',0.5)
%     box off
%     set(gcf,'color','w');
%     axis off
% %%
%     f = figure('Position', [500,100, 900, 600])
%     latlimit = [63.35 66.58];
%     lonlimit = [-24.6 -13.4];
%     axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit,'Frame','on');
%     pcolorm(Xr,Yr,Ar), 
%     shading interp
%     hb = colorbar
%     colormap(parula(10))
%     set(hb,'FontSize',12);
%     %title(hb, '%')
%     ylabel(hb, 'Aspect (deg)','FontSize',12)
%     tightmap;
%     lw = 1.1;
%     x = S(4524).Y;
%     y = S(4524).X;
%     plotm([S(4524).Y],[S(4524).X], 'k','linewidth',lw);
%     northarrow('latitude',63.5,'longitude',-24,'linewidth',0.5)
%     box off
%     set(gcf,'color','w');
%     axis off

% iplot = 0;
%     if iplot == 1;
%         close all
%         SCA_b = D8;
%         SCA_b(SCA_b<=25)=0; 
%         SCA_b(SCA_b>25)=1; 
%         f = figure('Position', [500,100, 900, 600])
%         latlimit = [63.35 66.58];
%         lonlimit = [-24.6 -13.4];
%         axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit,'Frame','on');
%         pcolorm(lat,lon,SCA_b), shading interp
%     else
%     end

