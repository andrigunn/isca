figure, hold on
geo_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\geo';
geo = Modis_make_geo(geo_data_dir);  
latlimit = [63.35 66.58];
lonlimit = [-24.6 -13.4];
axesm('MapProjection','mercator','MapLatLimit',latlimit,'MapLonLimit',lonlimit);
lw = 0.5;
fillm([geo.utlina_isl(4524).Y],[geo.utlina_isl(4524).X], 'FaceColor',[224/255 224/255 224/255],'linewidth',lw);
fillm([geo.utlina_vat.Y],[geo.utlina_vat.X], 'w','linewidth',lw);
fillm([geo.utlina_hof.Y],[geo.utlina_hof.X], 'w','linewidth',lw);
fillm([geo.utlina_lan.Y],[geo.utlina_lan.X], 'w','linewidth',lw);
plotm([geo.utlina_isl(4524).Y],[geo.utlina_isl(4524).X], 'k','linewidth',lw);
plotm([geo.utlina_vat.Y],[geo.utlina_vat.X], 'k','linewidth',lw);
plotm([geo.utlina_hof.Y],[geo.utlina_hof.X], 'k','linewidth',lw);
plotm([geo.utlina_lan.Y],[geo.utlina_lan.X], 'k','linewidth',lw);

S_x(isnan(S_x))=0;
S_y(isnan(S_y))=0;
S_hit(isnan(S_hit))=0;
S_hit((S_hit==0))=0.01;
S_fjo((S_fjo==0))=0.01;
S_fjo(isnan(S_fjo))=0;

r = S_fjo;
c = S_hit;

%r1 = randi(10,1,10);
%r2 = randi(10,1,10);
%a = 30*randi(5,1,10);
bubsizes = [min(r) quantile(r,[0.25, 0.5, 0.75]) max(r)];
legentry=cell(size(bubsizes));

for ind = 1:numel(bubsizes)
   bubleg(ind) = plotm(0,0,'ro','markersize',sqrt(bubsizes(ind)),'MarkerFaceColor','red');
   set(bubleg(ind),'visible','off')
   legentry{ind} = num2str(bubsizes(ind));
end
hraw = scatterm(S_x,-S_y,r/8,c,'filled','MarkerFaceAlpha',.5)
colormap(cbrewer('seq','Reds',10))
colormap(cbrewer('qual','Set1',10))
colorbar
%legend(legentry)

title('Average correlation - MODIS vs. Manned observations bSCA')

% h = scatter(r1,r2,a,'r','MarkerFaceColor','red')
% legend(legentry)