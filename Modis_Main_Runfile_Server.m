%% Runfile for Modis ISCA
clear all; close all; clc
%% Add Paths to Code
addpath('C:\Users\andrigun\Documents\GitHub\isca\mat')
addpath('C:\Users\andrigun\Documents\GitHub\isca\mat\plot')
addpath('C:\Users\andrigun\Documents\GitHub\isca\mat\sub')
addpath('F:\Maelingar\brunnur\mFiles\common')
% addpath('E:\Dropbox\Matlab\mraleigh')
% addpath('E:\Dropbox\Matlab\cbrewer')
%% Define directories
mod_data_dir = 'F:\Maelingar\brunnur\Data\ModisData\MOD10A1_006';                              % Directory with Terra data
myd_data_dir = 'F:\Maelingar\brunnur\Data\ModisData\MYD10A1_006';                              % Directory with Aqua data
img_dir = 'F:\Maelingar\brunnur\Data\ISCA\img\';       % Directory to store exported images
data_write_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\';  % Directory to write output files
geo_data_dir = 'F:\Maelingar\brunnur\geo';

vis = 'off';                                                                        % Visibility of figures On(1) / Off(0)                        
printFigure = 0;    
plotting_on = 0;
cmapSnow = cbrewer('seq','Blues',100);

Modis_Merger(...
    mod_data_dir,myd_data_dir,img_dir,data_write_dir,geo_data_dir,...
    cmapSnow,...
    vis,printFigure,plotting_on)

%% Parameters and settings - Modis_Aggr.m
% Main runfile for the MODIS ISCA
tic
day_buffer_forward = 1;                                                               % No of days used in forward buffer  
day_buffer_backward = 1;                                                              % No of days used in backwards buffer  
Center_Date_option = 1;

test_mode = 0;
DateString = '19-May-2010';
formatIn = 'dd-mmm-yyyy';
test_date= datenum(DateString,formatIn);

vis = 'off';                                                                      % Visibility of figures On(1) / Off(0)                        
print_fig = 1;                                                                    % Print figure to img_dir folder (1)
write_data = 1;
plotting_on = 0;
cmapSnow = cbrewer('seq','Blues',100);
cmapAge =  cbrewer('div','RdYlBu',(day_buffer_forward+day_buffer_backward+1));
% Define directories 
mcd_data_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\MCDDATA';             % Directory with merged Aqua and Terra data
img_dir = 'F:\Maelingar\brunnur\Data\ISCA\img\';       % Directory to store exported images
data_write_dir = 'F:\Maelingar\brunnur\Data\ISCA\Data\';  % Directory to write output files
geo_data_dir = 'F:\Maelingar\brunnur\geo';
%% Function
day_buffer_forward = 1;                                                               % No of days used in forward buffer  
day_buffer_backward = 1;                                                              % No of days used in backwards buffer  
Center_Date_option = 1;
Modis_Aggr(Center_Date_option,day_buffer_forward,day_buffer_backward,...
                    mcd_data_dir,data_write_dir,img_dir,write_data,...
                    print_fig,plotting_on,vis,test_mode,test_date,...
                    cmapSnow,cmapAge,...
                    geo_data_dir)

day_buffer_forward = 2;                                                               % No of days used in forward buffer  
day_buffer_backward = 2;                                                              % No of days used in backwards buffer  
Center_Date_option = 1;
Modis_Aggr(Center_Date_option,day_buffer_forward,day_buffer_backward,...
                    mcd_data_dir,data_write_dir,img_dir,write_data,...
                    print_fig,plotting_on,vis,test_mode,test_date,...
                    cmapSnow,cmapAge,...
                    geo_data_dir)
               
day_buffer_forward = 3;                                                               % No of days used in forward buffer  
day_buffer_backward = 3;                                                              % No of days used in backwards buffer  
Center_Date_option = 1;
Modis_Aggr(Center_Date_option,day_buffer_forward,day_buffer_backward,...
                    mcd_data_dir,data_write_dir,img_dir,write_data,...
                    print_fig,plotting_on,vis,test_mode,test_date,...
                    cmapSnow,cmapAge,...
                    geo_data_dir)

day_buffer_forward = 4;                                                               % No of days used in forward buffer  
day_buffer_backward = 4;                                                              % No of days used in backwards buffer  
Center_Date_option = 1;
Modis_Aggr(Center_Date_option,day_buffer_forward,day_buffer_backward,...
                    mcd_data_dir,data_write_dir,img_dir,write_data,...
                    print_fig,plotting_on,vis,test_mode,test_date,...
                    cmapSnow,cmapAge,...
                    geo_data_dir)





