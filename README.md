# isca
## Overview
The scope of the project is to create a snow cover climatology for Iceland based on Modis Aqua and Terra MOD10.A1 V006 binary snow cover

## Matlab scripts for the Iceland Snow Cover Analysis Project
### Modis_merger_Aqua_Terra.m
Merge TERRA and AQUA data daily files into one combined file

Uses: 
Modis_make_geo          % Reads the coordinates for the HDF tiles used from Modis
Modis_make_ins_outs     % Makes masks to mask out data
dates2header
Modis_QAQC


%% Combined snow cover maps in Iceland from Modis Aqua and Terra
% Made by: Andri Gunnarsson - andrigun@lv.is
%% Overview - Scope and purpose
% Goal of the project is to create a product (MCD-ISCA) where daily Modis
% images from Aqua and Terra platforms are used to make a daily gap filled
% product for Iceland. 
%% Step 1 - Combinations of MOD10A1 and MYD10A1 - MCD10A1AT
% MCD10A1A reads in for each day number (doy) of a year two files from
% Modis Terra and Aqua. Files are named MOD10A1 (Terra platform) and
% MYD10A1 (Aqua platform). These two files are combined into one file to
% increse spatial data avalibility. Terra (MOD) has priority over Aqua
% (MYD). Outputs from the function are two files, a) MCD10A1A with combined
% data maps and b) MCD10QA1 binary file indicating from which platform a SCA pixel is from 
%% Syntax:  MCD10A1A(FolderLocation)
%% Input:
% FileLocation = folder with files to process
%% Output: 
% MCD10A1A_yyyydoy file with combined data
% MCD10Q1A_yyyydoy file with origin of data of the file



%% Step 2 - Spatial filter with forward and backward looking windows
% MCD10A1B uses the data combined in Step 1 with a backwards and forward
% looking filter to fill in gaps. 
%% Syntax:  MCD10A1B(Forward_doy, Backward_doy,)
%% Input:
Forward_doy  %Number of days to look forward and combine data
%Backward_doy = Number of days to look backward and combine data
%% Output: 