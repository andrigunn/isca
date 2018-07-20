%% Runfile for Modis ISCA
clear all; close all; clc
%% Add Paths to Code
addpath('C:\Users\andrigun\Documents\GitHub\isca\mat')
addpath('C:\Users\andrigun\Documents\GitHub\isca\mat\plot')
addpath('C:\Users\andrigun\Documents\GitHub\isca\mat\sub')
addpath('E:\Dropbox\Matlab')
addpath('E:\Dropbox\Matlab\mraleigh')
addpath('E:\Dropbox\Matlab\cbrewer')
%% Define directories
mod_data_dir = 'E:\Dropbox\Remote\MODIS DATA\MOD10A1';                              % Directory with Terra data
myd_data_dir = 'E:\Dropbox\Remote\MODIS DATA\MYD10A1';                              % Directory with Aqua data
img_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\06_img\tmp';       % Directory to store exported images
data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\';  % Directory to write output files

vis = 'on';                                                                        % Visibility of figures On(1) / Off(0)                        
printFigure = 0;                                                                    % Print figure to img_dir folder (1)

%% Parameters and settings - Modis_Aggr.m
% Main runfile for the MODIS ISCA
tic
day_buffer_forward = 3;                                                               % No of days used in forward buffer  
day_buffer_backward = 3;                                                              % No of days used in backwards buffer  
Center_Date_option = 1;
%
test_mode = 0;
DateString = '19-May-2010';
formatIn = 'dd-mmm-yyyy';
test_date= datenum(DateString,formatIn);

vis = 'off';                                                                      % Visibility of figures On(1) / Off(0)                        
print_fig = 1;                                                                    % Print figure to img_dir folder (1)
write_data = 0;
plotting_on = 1;
cmapSnow = cbrewer('seq','Blues',100);
cmapAge =  cbrewer('div','RdYlBu',(day_buffer_forward+day_buffer_backward+1));
% Define directories 
mcd_data_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MCDDATA';             % Directory with merged Aqua and Terra data
img_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\06_img\MMCDDATA_7D';                       % Directory to store exported images
data_write_dir = 'E:\Dropbox\01 - Icelandic Snow Observatory - ISO\ISCA\05_data\MMCDDATA_7D';        % Directory to write output files
% Function
close all, clc
Modis_Aggr(Center_Date_option,day_buffer_forward,day_buffer_backward,...
                    mcd_data_dir,data_write_dir,img_dir,write_data,...
                    print_fig,plotting_on,vis,test_mode,test_date,cmapSnow,cmapAge)

toc



