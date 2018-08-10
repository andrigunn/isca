function Modis_plotter_L8(data,geo,name_dataset,name_date,name,cbar,print_fig,print_name,img_dir,title_of_figure)   

vis = 'on';
addpath('E:\Dropbox\Matlab\cbrewer');
f = figure( 'visible',vis,'Position', [50, 100, 900, 600]);
%

latlimit = [63.35 66.58];
lonlimit = [-24.6 -13.4];
axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit);
hold on 
lw = 0.1;
h = pcolorm(geo.lat,geo.lon,data);
isl_color = [224/255 224/255 224/255];
glacier_color = [224/255 224/255 224/255];
shading flat;
fillm([geo.utlina_isl(4524).Y],[geo.utlina_isl(4524).X], 'FaceColor',isl_color,'linewidth',lw);
fillm([geo.utlina_vat.Y],[geo.utlina_vat.X], 'FaceColor',glacier_color,'linewidth',lw);
fillm([geo.utlina_hof.Y],[geo.utlina_hof.X], 'FaceColor',glacier_color,'linewidth',lw);
fillm([geo.utlina_lan.Y],[geo.utlina_lan.X], 'FaceColor',glacier_color,'linewidth',lw);
uistack(h,'top');

plotm([geo.utlina_isl(4524).Y],[geo.utlina_isl(4524).X], 'k','linewidth',lw);
plotm([geo.utlina_vat.Y],[geo.utlina_vat.X], 'k','linewidth',lw);
plotm([geo.utlina_hof.Y],[geo.utlina_hof.X], 'k','linewidth',lw);
plotm([geo.utlina_lan.Y],[geo.utlina_lan.X], 'k','linewidth',lw);


hb=colorbar;
if cbar == 'fSCA'
    cmap = cbrewer('seq','GnBu',10);
    caxis([0 100])
    %colormap(flipud(cmap));
    colormap((cmap));
    hb.Label.String = 'fSCA (%)';
    hb.Label.FontSize = 12;
    
    name_str1 = ['NDSI Snow Cover fSCA'];
    name_str2 = [name_dataset];
    name_str3 = title_of_figure;
    hText = text(0.01,0.03,name_str1,'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.5,1,name_str3,'Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle', 'Interpreter', 'none');
    hText = text(0.7,0.03,['ID: ',name_str2],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.01,0.06,['Date: ',name_date],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.01,0.09,[name],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    


elseif cbar == 'bSCA'
    cmap = [ 0 204/255 0; isl_color; 255/255 255/255 255/255]
    caxis([1 2])
    
    colormap((cmap));
    hb.Label.String = 'bSCA [0/1]';
    hb.Label.FontSize = 12;
    
    name_str1 = ['NDSI Snow Cover bSCA'];
    name_str2 = [name_dataset];
    hText = text(0.01,0.03,name_str1,'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.7,0.03,['ID: ',name_str2],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.01,0.06,['Date: ',name_date],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.01,0.09,[name],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    

    colorbar('Ticks',[1.16,1.49,1.825],...
         'TickLabels',{'No Snow','No Data','Snow'})

elseif cbar == 'dSCA'
    cmap = [ 0 204/255 0; isl_color; 255/255 0 0]
    caxis([0 1])
    
    colormap((cmap));
    hb.Label.String = 'Comparison [0/1]';
    hb.Label.FontSize = 12;
    
    name_str1 = ['Classification comparison'];
    name_str2 = [name_dataset];
    hText = text(0.01,0.03,name_str1,'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    %hText = text(0.75,0.03,name_str2,'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.01,0.06,['Date: ',name_date],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    hText = text(0.01,0.09,[name],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom', 'Interpreter', 'none');
    

    colorbar('Ticks',[0.16,0.49,0.825],...
         'TickLabels',{'True','No Data','False'})
else
end

tightmap;
box off;
ax = gca;
ax.Visible = 'off';

if print_fig == 1
    cd(img_dir)
    print([print_name],'-dpng') 
    else
end

