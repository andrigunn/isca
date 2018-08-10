function Modis_Merger_Plot_Aqua_Terra(data,vis,printFigure, date,data_name,img_dir, geo,prct_clouds,cmapSnow)   
%% Plotting outlines *.shp files

f = figure( 'visible',vis,'Position', [50, 100, 900, 600]);

    latlimit = [63.35 66.58];
    lonlimit = [-24.6 -13.4];
    axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit);
    hold on 
    lw = 0.1;
    h = pcolorm(geo.lat,geo.lon,data);
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
cmap = cmapSnow%
colormap((cmap));
hb=colorbar;
set(hb, 'Position', [.91 .13 .017 .78]);

set(hb,'FontSize',12);
tightmap;
box off;
ax = gca;
ax.Visible = 'off';
name_str = [data_name(1:7),' V006 ',data_name(9:12),data_name(13:15),' NDSI Snow Cover'];
hText = text(0.01,0.0,name_str,'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom');
hText = text(0.01,0.08,['Date: ',datestr(date,'dd.mm.yyyy')],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom');
hText = text(0.01,0.04,['No data: ',num2str(round(100*prct_clouds)),' %'],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom');

%%
set(gcf,'color','w');
if printFigure == 1;
    cd(img_dir);
%export_fig(f,'testexport','-png');
print(f,data_name,'-dpng','-r0')
else
close(f)
end
