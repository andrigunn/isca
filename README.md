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
Modis_P_merger_Aqua_Terra
Modis_in_filter_sca

Input: MODIS MOD10A1, MODIS MYD10A1
Output: MCD10A1_YYYYDOY merged Aqua and Terra tiles for same dates

Add: NetCDF storage

###