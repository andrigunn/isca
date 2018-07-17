function Modis_Stacker_Plot_Data_Age(Data_stacked_age,end_day, Center_date, Date_vector(Center_date))  
%% Plotting data age from Modis_Stacker
%%Testing 
Date = Date_vector(Center_date)
close all
f_age = figure( 'visible',vis,'Position', [50, 100, 1200, 800]);
latlimit = [63.35 66.58]; lonlimit = [-24.6 -13.4];
hold on 
axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit)%,'Position', AxisPos(i, :));

h = pcolorm(geo.lat,geo.lon,Data_stacked_age);
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
    title(['Data age - Center Date: ',datestr(Date_vector(1))])

    caxis([Center_date-end_day end_day-Center_date])
    cmap = cbrewer('div','RdBu',end_day);
    colormap((cmap));
    hb=colorbar;
    set(hb, 'Position', [.91 .13 .017 .78]);
    %set(hb,'TickLabelInterpreter','latex');
    set(hb,'FontSize',12);
    ylabel(hb, 'Data age (Days)')
    tightmap;
    box off;
    ax = gca;
    ax.Visible = 'off';
title('Data Age')
hText = text(0.01,1.0,['Data Age Overview: Date: ',datestr(Date,'dd.mm.yyyy'),' / ',num2str(end_day),' day Stack'],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',12);
%hText = text(0.01,0.0,['Date: ',datestr(Date,'dd.mm.yyyy')],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom');
%hText = text(0.01,0.04,['No data: ',num2str(round(100*prct_clouds)),' \%'],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom','Interpreter','latex');

