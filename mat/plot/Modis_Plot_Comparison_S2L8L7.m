clear all, close all, clc
cd('E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\Stats')
%%
L8 = load('Modis_Landsat8_comp_Stats.mat');
L7 = load('Modis_Landsat7_comp_Stats.mat');
S2 = load('Modis_Sentine2_comp_Stats.mat');
%%
dv = datevec(L8.Modis_Landsat_comp_Stats.daten);
month_L8 = dv(:,2);

dv = datevec(L7.Modis_Landsat_comp_Stats.daten);
month_L7 = dv(:,2);

dv = datevec(S2.Modis_Sentinel_comp_Stats.daten);
month_S2 = dv(:,2);
%% L7 comparison 
close all
figure, hold on
    pointsize = 30;
    scatter(L7.Modis_Landsat_comp_Stats.no_snow_mod,L7.Modis_Landsat_comp_Stats.no_snow_l7,pointsize,month_L7,'filled','o')
    xlabel('Modis no. of pixels as snow')
    ylabel('Landsat 7 no. of pixels as snow')
    grid on
    plot([0,10*10^4],[0,10*10^4],'k')
    axis([0,10*10^4,0,10*10^4])
    %legend('Landsat 7')
    title('Landsat 7 vs. MCDAT')
    cmap = cbrewer('qual', 'Set1', 10)
    colormap(cmap)
    colorbar
    colorbar('Ticks',[  2.36,   3.16,   4,      4.8,    5.55,   6.33,   7.15,   8,      8.8,    9.6     ],...
         'TickLabels',{'Feb',   'Mar',  'Apr',  'May',  'Jun',  'Jul',  'Aug',  'Sep',  'Okt'   ,'Nov'})
%%
%% L8 comparison 
close all
figure, hold on
    pointsize = 30;

    scatter(L8.Modis_Landsat_comp_Stats.no_snow_mod,L8.Modis_Landsat_comp_Stats.no_snow_l8,pointsize,month_L8,'filled','o')
    xlabel('Modis no. of pixels as snow')
    ylabel('Landsat 8 no. of pixels as snow')
    grid on
    plot([0,10*10^4],[0,10*10^4],'k')
    axis([0,10*10^4,0,10*10^4])
    title('Landsat 8 vs. MCDAT')
    cmap = cbrewer('qual', 'Set1', 10)
    colormap(cmap)
    colorbar
    colorbar('Ticks',[  2.36,   3.16,   4,      4.8,    5.55,   6.33,   7.15,   8,      8.8,    9.6     ],...
         'TickLabels',{'Feb',   'Mar',  'Apr',  'May',  'Jun',  'Jul',  'Aug',  'Sep',  'Okt'   ,'Nov'})
%% S2 comparison 
close all
figure, hold on
    pointsize = 30;

    scatter(S2.Modis_Sentinel_comp_Stats.no_snow_mod,S2.Modis_Sentinel_comp_Stats.no_snow_S2,pointsize,month_S2,'filled','o')
    xlabel('Modis no. of pixels as snow')
    ylabel('Sentinel 2 no. of pixels as snow')
    grid on
    plot([0,4*10^4],[0,4*10^4],'k')
    axis([0,4*10^4,0,4*10^4])
    title('Sentinel 2 vs. MCDAT')
    cmap = cbrewer('qual', 'Set1', 10)
    colormap(cmap)
    colorbar
    colorbar('Ticks',[  2.36,   3.16,   4,      4.8,    5.55,   6.33,   7.15,   8,      8.8,    9.6     ],...
         'TickLabels',{'Feb',   'Mar',  'Apr',  'May',  'Jun',  'Jul',  'Aug',  'Sep',  'Okt'   ,'Nov'})
