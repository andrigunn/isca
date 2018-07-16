function Modis_plotter_stack(Data_stack,Date_vector,geo,Center_Date_option)  
%% 
% Plotting function for a MODIS SCA data stack
%% INPUTS
% Data_stack: a data stack with m x 2400 x 2400 where m is the number of
% days
% geo: a mat file with shape files and other plotting stuff
% Date_vector: a 1 x m vector with datenumbers for each day in the data
% stack
% Center_Date_option is the tile that other tiles are merged to. 
%   Two possibilties:
%       1 gives the center date as the true center of the data stack
%       2 gives the center data as the newest tile, i.e. the last day in
%       the stack
%% OUTPUTS

%% TESTING
Data_stack = Data_stack;
Date_vector = Date_vector;
Center_Date_option = 1           % Date to merge other tiles to 

%% SETTINGS
vis = 'on';
addpath('E:\Dropbox\Matlab\cbrewer');
lw = 0.1;                                   % Line width for plotting
no_days = size(Data_stack);
no_days = no_days(2);                       % Find number of days in data stack 
%% Determine Center date
    if Center_Date_option == 1
        Center_date = (length(Data_stack)-1)/2+1;           % Find the center of the data stack
    else
        Center_date = length(Data_stack);                   % Finds the end date of the data stack
    end
%% Start by merging the first and last days of the stack
clc
clear Data_stacked
if Center_Date_option == 1
    [start_day end_day] = size(Data_stack);
%Merge the tiles that are forward/backward of center date
    for i = 1:(Center_date-1)
        ind_nan_back = find(isnan(Data_stack(i).MCDAT));                    % NAN values in stack date (1 = NaN / 0 = Data) 
        ind_nan_forw = find(isnan(Data_stack(i+Center_date).MCDAT));        % NAN values in stack date (1 = NaN / 0 = Data) 
        
        Data_stacked = Data_stack(i).MCDAT;
        
        
        %Data_stacked(i).MMCDAT = Data_stack(i).MCDAT  
        
    end
    
    
    else
end
































%% MAKE FIGURE
clc, close all
f = figure( 'visible',vis,'Position', [50, 100, 1800, 1800/no_days]);
latlimit = [63.35 66.58]; lonlimit = [-24.6 -13.4];
hold on 


for i = 1:no_days
    subplot(1,no_days,i)
    axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit)%,'Position', AxisPos(i, :));
    h = pcolorm(geo.lat,geo.lon,Data_stack(i).MCDAT);
    shading flat;
    fillm([geo.utlina_isl(4524).Y],[geo.utlina_isl(4524).X], 'FaceColor',[224/255 224/255 224/255],'linewidth',lw);
    fillm([geo.utlina_vat.Y],[geo.utlina_vat.X], 'w','linewidth',lw);
    fillm([geo.utlina_hof.Y],[geo.utlina_hof.X], 'w','linewidth',lw);
    fillm([geo.utlina_lan.Y],[geo.utlina_lan.X], 'w','linewidth',lw);
    uistack(h,'top');
    plotm([geo.utlina_isl(4524).Y],[geo.utlina_isl(4524).X], 'k','linewidth',lw);
    plotm([geo.utlina_vat.Y],[geo.utlina_vat.X], 'k','linewidth',lw);
    plotm([geo.utlina_hof.Y],[geo.utlina_hof.X], 'k','linewidth',lw);
    plotm([geo.utlina_lan.Y],[geo.utlina_lan.X], 'k','linewidth',lw);
    title(datestr(Date_vector(i)))
end

%% cmap = cbrewer('seq','Blues',25);
caxis([0 100])
cmap = cbrewer('seq','YlGnBu',25);
colormap((cmap));
hb=colorbar;
set(hb, 'Position', [.91 .13 .017 .78]);
set(hb,'TickLabelInterpreter','latex');
set(hb,'FontSize',12);
tightmap;
box off;
ax = gca;
ax.Visible = 'off';

%name_str = [data_name(1:7),' V006 ',data_name(9:12),data_name(13:15),' NDSI Snow Cover'];
hText = text(0.01,1.0,date_data,'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom','Interpreter','latex');
%hText = text(0.01,0.08,['Date: ',datestr(date,'dd.mm.yyyy')],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom','Interpreter','latex');
%hText = text(0.01,0.04,['No data: ',num2str(round(100*prct_clouds)),' \%'],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom','Interpreter','latex');

