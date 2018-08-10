function Modis_Merger(mod_data_dir,myd_data_dir,img_dir,data_write_dir,geo_data_dir,cmapSnow,vis,printFigure,plotting_on);
%% Merge TERRA and AQUA data daily files into one combined file
%  If there is no AQUA file only TERRA is used for the first years of
%  operation
% Andri Gunnarsson
% November 201

%% Inputs                               

%% SYNTAX

%% OUTPUTS
% MODDATA               to data_write_dir\MODDATA\ folder
% MYDDATA               to data_write_dir\MYDDATA\ folder
% MCDDATA               to data_write_dir\MCDDATA\ folder
% Modis_Merger_Stats    to data_write_dir\Stats\ folder
%%
geo = Modis_make_geo(geo_data_dir);                                                               % Data for plotting. Shape files and coordinates of hdf files
[ins, outs] = Modis_make_ins_outs(geo_data_dir);                                              % Loads masks for exluding data 
%%
MAT_Stats = table;                                                                  % Make an table to write statistics to 
cd(mod_data_dir)                                                                    % CD to data folder with hdf files for MOD10A1 product
mod = dir('MOD10A1*');                                                              % Read directory structure
cd(myd_data_dir);                                                                   % CD to data folder with hdf files for MYD10A1 product
myd = dir('MYD10A1*');                                                              % Read directory structure
mod = dates2header(mod);                                                            % Write time and date information to directory information for data
myd = dates2header(myd);                                                            % Write time and date information to directory information for data    
%% Check quality of input to find missing dates
[missing_dates_mod first_day_mod last_day_mod ] = Modis_QAQC(mod);                  
[missing_dates_myd first_day_myd last_day_myd ] = Modis_QAQC(myd);
%% Mergin of data. %%
% A) Select a MOD tile
% B) Check if a MYD tile is avaliable for the same day
% C) If a MYD exist merge else use the MOD only
start_date = first_day_mod; % Date our analyse starts from 
end_data   = last_day_mod;  % Date to end our analyse

run_dates = [start_date:1:end_data];
total_number_days = numel(run_dates);
GRID_NAME= 'MOD_Grid_Snow_500m';    % Grid name from HDF file
DATAFIELD_NAME='NDSI_Snow_Cover';   % DAta field from HDF file
%%
clc
ii = 0;
for k = run_dates;
    ii = ii+1;
% Find if we have data tiles that match the date we look for 
    imod_name = find([mod.daten]==k);      % index of file for the date
    imyd_name = find([myd.daten]==k);      % index of file for the date
 
    if isempty(imod_name) == 1 && isempty(imyd_name) == 1; 
        continue
    end
    
        if isempty(imod_name) == 0;         % Zero if numbers are in matrix 
        fname_mod = mod(imod_name).name;   % name of the HDF file from MOD to use
        cd(mod_data_dir);
        
        [MODDATA, MODDATA_NAME,MODHDF_DATE] = Modis_import_data_hdf(...
        fname_mod, GRID_NAME, DATAFIELD_NAME); 
        
        [av_mo,no_el_in_mo,no_el_data_mo,no_el_clouds_mo,prct_data_in_mo,prct_clouds_in_mo,csum1_mo,csum2_mo] =...
        Modis_in_filter_sca(MODDATA, ins.in_isl);
             if plotting_on == 1;
                Modis_Merger_Plot_Aqua_Terra(MODDATA,vis,printFigure,k,MODDATA_NAME,img_dir,geo,prct_clouds_in_mo,cmapSnow);    
             else
                end
        save([data_write_dir,'MODDATA\',MODDATA_NAME(1:15)],'MODDATA'); 
        
        else
            clear MODDATA MODDATA_NAME MODHDF_DATE    
            av_mo = nan;
            no_el_in_mo= nan;
            no_el_data_mo= nan;
            no_el_clouds_mo= nan;
            prct_data_in_mo= nan;
            prct_clouds_in_mo= nan;
            csum1_mo= nan;
            csum2_mo= nan;
        end
    
        if isempty(imyd_name) == 0;      % Zero if numbers are in matrix 
            fname_myd = myd(imyd_name).name;    % name of the HDF file from MYD to use%   
            cd(myd_data_dir);
            [MYDDATA, MYDDATA_NAME,MYDHDF_DATE] = Modis_import_data_hdf(...
            fname_myd, GRID_NAME, DATAFIELD_NAME); 
            [av_my,no_el_in_my,no_el_data_my,no_el_clouds_my,prct_data_in_my,prct_clouds_in_my,csum1_my,csum2_my] =...
            Modis_in_filter_sca(MYDDATA, ins.in_isl);
                if plotting_on == 1;
                  Modis_Merger_Plot_Aqua_Terra(MYDDATA,vis,printFigure,k,MYDDATA_NAME,img_dir,geo,prct_clouds_in_my,cmapSnow); 
                else
                end
            save([data_write_dir,'MYDDATA\',MYDDATA_NAME(1:15)],'MYDDATA'); 
        else
            clear MYDDATA MYDDATA_NAME MYDHDF_DATE
            av_my = nan;
            no_el_in_my= nan;
            no_el_data_my= nan;
            no_el_clouds_my= nan;
            prct_data_in_my= nan;
            prct_clouds_in_my= nan;
            csum1_my= nan;
            csum2_my= nan;
        end
        
        if isempty(imod_name) == 0;
            MCDAT = MODDATA;
            x = isnan(MCDAT);
            MCDDATA_NAME = MODDATA_NAME; MCDDATA_NAME(2) = 'C';
            mod_used = 1;
        elseif isempty(imod_name) == 1;
            MCDAT = MYDDATA;
            MCDDATA_NAME = MYDDATA_NAME; MCDDATA_NAME(2) = 'C';
            myd_used = 2;
        end
        
        if isempty(imyd_name) == 0;
            MCDAT(x) = MYDDATA(x);
        else
            MCDAT = MODDATA;
        end
        
        % Reiknum tölfræði fyrir samsetningur
        [av_mc,no_el_in_mc,no_el_data_mc,no_el_clouds_mc,prct_data_in_mc,prct_clouds_in_mc,csum1_mc,csum2_mc] =...
        Modis_in_filter_sca(MCDAT, ins.in_isl);
        % Búum til dagsetningar fyrir tölfræðitöfluna
        Daten = k;
        tb = time_builder(k); 
        year = tb(1); 
        month = tb(2);
        day = tb(3);
        hour = tb(4);
        minute = tb(5);
        doy = tb(6);
        % Búum til töfluna
        
        x_t =  table(Daten,year,month,day,hour,minute,doy,...
                     av_mo,no_el_in_mo,no_el_data_mo,no_el_clouds_mo,prct_data_in_mo,prct_clouds_in_mo,csum1_mo,csum2_mo,...
                     av_my,no_el_in_my,no_el_data_my,no_el_clouds_my,prct_data_in_my,prct_clouds_in_my,csum1_my,csum2_my,...
                     av_mc,no_el_in_mc,no_el_data_mc,no_el_clouds_mc,prct_data_in_mc,prct_clouds_in_mc,csum1_mc,csum2_mc);
        MAT_Stats = [MAT_Stats;x_t];

       
        Modis_Merger_Plot_Aqua_Terra(MCDAT,vis,printFigure,k,MCDDATA_NAME,img_dir,geo,prct_clouds_in_mc,cmapSnow); 
        save([data_write_dir,'MCDDATA\',MCDDATA_NAME(1:15)],'MCDAT'); 
        
        close all
        sprintf(['Date ',datestr(Daten),' done'])
end
         
        save([data_write_dir,'Stats\','Modis_Merger_Stats'],'MAT_Stats');  
    
    sprintf('FINISHED WITH ALL')
