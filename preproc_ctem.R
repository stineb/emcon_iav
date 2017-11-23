library(dplyr)
library(ncdf4)

source("../utilities/get_days_since.R")

nc <- nc_open( paste0( myhome, "data/trendy/v5/CLASS-CTEM/S2/CLASS-CTEM_S2_nbp.nc" ) )
nbp <- ncvar_get( nc, varid="nbp" )
dx <- 360/dim(nbp)[1]
dy <- 180/dim(nbp)[2]
lon <- c( seq( from=0+dx/2, to = 180 - dx/2, by = dx ), seq( from=-180 + dx/2, to = 0-dx/2, by=dx ))
lat <- seq( from=-90+dy/2, to=90-dy/2, by=dy )
nc_close(nc)

nc <- nc_open( paste0( myhome, "data/trendy/v5/CLASS-CTEM/S2/CLASS-CTEM_S2_gpp.nc" ) )
gpp <- ncvar_get( nc, varid="gpp" )
nc_close(nc)

nbp <- array( nbp, dim = c(length(lon),length(lat),1,dim(nbp)[3]))
gpp <- array( gpp, dim = c(length(lon),length(lat),1,dim(gpp)[3]))

## get time from a different file
time <- get_days_since( 1861, 1860, "months" )

cdf.write( nbp, "nbp",
           lon, lat,
           filnam = paste0( myhome, "data/trendy/v5/CLASS-CTEM/S2/CLASS-CTEM_S2_nbp_NICE.nc" ),
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = "days since 1970-01-01 00:00:00",
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_ctem.R"
)

cdf.write( gpp, "gpp",
           lon, lat,
           filnam = paste0( myhome, "data/trendy/v5/CLASS-CTEM/S2/CLASS-CTEM_S2_gpp_NICE.nc" ),
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = "days since 1970-01-01 00:00:00",
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_ctem.R"
)
