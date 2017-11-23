library(dplyr)
library(ncdf4)

source("../utilities/get_days_since.R")

nc <- nc_open( paste0( myhome, "data/trendy/v5/SDGVM/S2/SDGVM_S2_nbp.nc" ) )
nbp <- ncvar_get( nc, varid="nbp" )
lon <- nc$dim$lon$vals
lat <- nc$dim$lat$vals
nc_close(nc)

nc <- nc_open( paste0( myhome, "data/trendy/v5/SDGVM/S2/SDGVM_S2_gpp.nc" ) )
gpp <- ncvar_get( nc, varid="gpp" )
nc_close(nc)

nbp <- array( nbp, dim = c(length(lon),length(lat),1,dim(nbp)[3]))
gpp <- array( gpp, dim = c(length(lon),length(lat),1,dim(gpp)[3]))

## get time from a different file
time <- get_days_since( 1860, 1872, "months" )

cdf.write( nbp, "nbp",
           lon, lat,
           filnam = paste0( myhome, "data/trendy/v5/SDGVM/S2/SDGVM_S2_nbp_NICE.nc" ),
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = "days since 1970-01-01 00:00:00",
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_sdgvm.R"
)

cdf.write( gpp, "gpp",
           lon, lat,
           filnam = paste0( myhome, "data/trendy/v5/SDGVM/S2/SDGVM_S2_gpp_NICE.nc" ),
           nvars = 1,
           time = time,
           make.zdim = TRUE,
           z_dim = 1,
           make.tdim = TRUE,
           units_time = "days since 1970-01-01 00:00:00",
           units_var1 = "kg C m-2 s-1",
           glob_hist = "created by emcon_iav/preproc_sdgvm.R"
)
