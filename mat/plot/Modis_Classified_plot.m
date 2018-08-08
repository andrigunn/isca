%function analyze_classified_data(data)

%% TESTING
data = gap_filled_data_KNN_fine;
min = 0
max = 1800
de = 100

%%

ii = 0;
close all,
D = [];
no_pixels_class = [];
for i = min:de:max;
    ii = ii+1;
    if i == min;
        ix = find(data.Elevation < min+de);
    elseif i > min && i < max;
        ix = find(data.Elevation > i & data.Elevation < i+de);
    elseif i == max;
        ix = find(data.Elevation > max-de);
    end
    
    eleband = i;
    ld = length(ix);
    Dtemp = [ones(ld,1)*eleband,data.SnowClass(ix)];
    D = [D;Dtemp];
    
    no_pixels = length(ix);
    no_snow_pixels = find(data.SnowClass(ix)==1);
    no_land_pixels = find(data.SnowClass(ix)==0);
    
    no_pixels_classs = [eleband, no_pixels,length(no_snow_pixels),length(no_land_pixels)]
    no_pixels_class =[no_pixels_class;no_pixels_classs]
end 

%% Plot
close all,
figure
barh(no_pixels_class(:,1),no_pixels_class(:,2))
figure
barh(no_pixels_class(:,1),no_pixels_class(:,3))
figure
barh(no_pixels_class(:,1),no_pixels_class(:,4))


        
   



