# Read and project rainfall data for Haiti

This variant of the codes reads rainfall and saves the values at the **population weighted** centroids of the communes. Centroids are taken from [this repo](https://github.com/ffinger/communews).

## Past rainfall data
Dataset: NASA TRMM_L3 TRMM_3B42RT v7
Units: mm/day)
[Description and References](http://iridl.ldeo.columbia.edu/SOURCES/.NASA/.GES-DAAC/.TRMM_L3/.TRMM_3B42RT/.v7/.daily/.precipitation/X/%2874.625W%29%2868.125W%29RANGEEDGES/Y/%2817.375N%29%2820.125N%29RANGEEDGES/)

###code to read: read_trmm.m
Downloads the data (which is gridded) into a file called **prec_nasa.mat**.
Variables are:
X_nasa: X (longitude) coordinates of the center of grid cells
Y_nasa: Y (latitude) coordinates of the center of grid cells
date_list_nasa: dates of the measurements
nasa_X_Y_day: precipitation (mm/day) in the grid cell X,Y on day 
nasa_day: mean precipitation over all grid cells per day

###code to project: project_trmm.m
Projects the gridded precipitation in prec_nasa.mat to the communes of Haiti by reading the value at the location of the centroids. Output is **prec_nasa_projected.mat**.
Important variables:
R_WS_day: precipitation (mm/day) in each of the 140 communes per day

## Rainfall forecast data
Dataset: NOAA Climate Forecast System v2 Forecasts
[Description](https://www.ncdc.noaa.gov/data-access/model-data/model-datasets/climate-forecast-system-version2-cfsv2)
[Download](http://nomads.ncdc.noaa.gov/thredds/dodsC/modeldata/cfsv2_forecast_6-hourly_9mon_flxf/)

Code to read and save precipitation forecasts at the centroids of the communes: prate_download.m

Each file in the subfolder *forecast* corresponds to a 60 days forecast of rainfall in each communes starting from the date in the file name.


