function Modis_Stacker_Plot_Data_sca(Data_stacked_sca,end_day, Date,geo,print_fig,img_dir,print_name,vis)
%% Plotting data sca from Modis_Stacker
%%Testing 
f_sca = figure( 'visible',vis,'Position', [50, 100, 1200, 800]);
latlimit = [63.35 66.58]; lonlimit = [-24.6 -13.4];
hold on 
axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit)%,'Position', AxisPos(i, :));
lw = 0.1

h = pcolorm(geo.lat,geo.lon,Data_stacked_sca);
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
    
    caxis([0 100])
    cmap = cbrewer('seq','BuPu',100);
    colormap((cmap));
    hb=colorbar;
    set(hb, 'Position', [.91 .13 .017 .78]);
    %set(hb,'TickLabelInterpreter','latex');
    set(hb,'FontSize',12);
    ylabel(hb, 'fSCA (%)')
    tightmap;
    box off;
    ax = gca;
    ax.Visible = 'off';
    title('Data Age')
    hText = text(0.01,1.0,['Data SCA Overview: Date: ',datestr(Date,'dd.mm.yyyy'),' / ',num2str(end_day),' day Stack'],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',12);

if print_fig == 1
    cd(img_dir)
    print(f_sca,[datestr(Date,'yyyymmdd'),print_name],'-dpng') 
    crop(img_dir)
else end

