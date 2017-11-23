source("~/.Rprofile")
library(raster)
library(dplyr)
library(abind)

source("../utilities/get_days_since.R")

dx <- 0.05
dy <- 0.05
lon <- seq(-180+dx/2, 180-dx/2, by=dx)
lat <- seq(-90+dy/2,90-dy/2, by=dy)

yearstart = 2000
yearend   = 2015

for (year in yearstart:yearend){

  for (moy in seq(12)){

    filnam <- paste0( myhome, "data/gpp_modis/raw_MOD17A2_ntsg/MOD17A2_GPP.", as.character(year), ".M", sprintf("%02d", moy) )
    rasta <- raster( paste0( filnam, ".tif" ) )
    gpp <- rasta %>% as.array() %>% aperm( perm = c(2,1,3) ) %>% array( dim = c(length(lon),length(lat),1,1)) %>% ifelse( .==32767, NA, . )

    ## get time from a different file
    time <- get_days_since( year, startmoy = moy, len = 1, freq = "months" )
    
    ## write annual GPP to file
    cdf.write( gpp, "gpp", 
               lon, lat,
               filnam = paste0( filnam, ".nc" ),
               nvars = 1,
               time = time,
               make.tdim = TRUE,
               make.zdim = TRUE,
               z_dim = 1,
               units_time = "year",
               long_name_var1 = "Gross primary productivity",
               units_var1 = "gC m-2 year-1",
               glob_hist = "created using emcon_iav/preproc_vpm.R based on original files data/gpp_vpm/GPP.VPM.*.v20.HD.tif, downloaded from https://figshare.com/collections/A_global_moderate_resolution_dataset_of_gross_primary_production_of_vegetation_for_2000-2016/3789814."
               )    

  }

}

