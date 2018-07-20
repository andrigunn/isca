function Modis_Stacker_Plot_Stack(Data_stack,Date_vector,Center_date, geo,print_fig,img_dir,print_name,vis,lw,cmapSnow)
%% TESTING
%lw = 0.1
%% Plotting data age from Modis_Stacker
latlimit = [63.35 66.58]; lonlimit = [-24.6 -13.4];
lw = 0.1;
f_stack = figure( 'visible',vis,'Position', [50, 100, 1800, 500]);
for i = 1:length(Data_stack);
    hold on 
    subplot(1,length(Data_stack),i),    hold on 
        axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit)%,'Position', AxisPos(i, :));
        % Remove -9999 from stack
        Data_stack(i).MCDAT(Data_stack(i).MCDAT == -9999) = NaN;
        h = pcolorm(geo.lat,geo.lon,Data_stack(i).MCDAT);
        shading flat;
        hText = text(0.01,1.0,['Date: ',datestr(Date_vector(i),'dd.mm.yyyy')],'Units','normalized','HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',12);

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
        cmap = cmapSnow;
        colormap((cmap));
        tightmap;
        box off;
        ax = gca;
        ax.Visible = 'off';
end

if print_fig == 1
    cd(img_dir)
    print([datestr(Date_vector(Center_date),'yyyymmdd'),print_name],'-dpng') 
    crop(img_dir)
    else
end
        

        

