library(dplyr)
library(ncdf4)

source("../utilities/get_days_since.R")

nc <- nc_open( paste0( myhome, "data/trendy/v5/ORCHIDEE/S2/orchidee_S2_nbp.nc" ) )
nbp <- ncvar_get( nc, varid="nbp" )
lon <- nc$dim$longitude$vals
lat <- nc$dim$latitude$vals
nc_close(nc)

nc <- nc_open( paste0( myhome, "data/trendy/v5/ORCHIDEE/S2/orchidee_S2_gpp.nc" ) )
gpp <- ncvar_get( nc, varid="gpp" )
lon <- nc$dim$longitude$vals
lat <- nc$dim$latitude$vals
nc_close(nc)

## take only years up to 2015
nbp <- nbp[,,1:1380]
gpp <- gpp[,,1:1380]

nbp <- array( nbp, dim = c(720,360,1,1380))
gpp <- array( gpp, dim = c(720,360,1,1380))

## get time from a different file
time <- get_days_since( 1901, 1380, "months" )

cdf.write( nbp, "nbp",
           lon, lat,
           filnam = paste0( myhome, "data/trendy/v5/ORCHIDEE/S2/orchidee_S2_nbp_NICE.nc" ),
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = "days since 1970-01-01 00:00:00",
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_orchidee.R"
)

cdf.write( gpp, "gpp",
           lon, lat,
           filnam = paste0( myhome, "data/trendy/v5/ORCHIDEE/S2/orchidee_S2_gpp_NICE.nc" ),
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = "days since 1970-01-01 00:00:00",
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_orchidee.R"
)
