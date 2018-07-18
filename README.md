# Iceland Snow Cover Analysis Project (ISCA)
## Overview
The scope of the project is to create a snow cover climatology for Iceland based on Modis Aqua and Terra MOD10.A1 V006 snow cover. The tools applied here can also be applied to make a "operational" product by merging daily AQUA and TERRA snow cover tiles with various temporal settings to reduce missing data due to clouds.
The project is written in Matlab but will be move to Python in the near future. 

The tools listed here do the following:
- Merge daily MODIS Aqua and Terra snow cover tiles (Tested for MOD10A1 V006)
- Apply a temporal aggregate filter with variable number of days that either aggregate to a center date in a Modis data stack or a end date in a Moids data stack
- Gap fill remaining pixels with machine learning algorythms 


## Matlab scripts 
### Modis_Merger.m
Merge TERRA and AQUA data daily files into one combined file

Uses: 
Modis_make_geo          	% Reads the coordinates for the HDF tiles used from Modis
Modis_make_ins_outs     	% Makes masks to mask out data
dates2header				% Date format from hdf to Matlab datenumbers
Modis_QAQC					% Checks for missing tiles
Modis_P_merger_Aqua_Terra	% Plotting functions for merged tiles
Modis_in_filter_sca			% Tools to filter 

Input: MODIS MOD10A1, MODIS MYD10A1
Output: MCD10A1_YYYYDOY merged Aqua and Terra tiles for same dates

Add: NetCDF storage

### Modis_Aggr.m
Aggregate merged output from Modis_Merger.m with a temporal filter of certain number of days

Input: MCD10A1_YYYYDOY merged Aqua and Terra tiles for same dates
Output: MMCDDATA_XXD_YYYYDOY
    where XX is the number of days for the temporal filter