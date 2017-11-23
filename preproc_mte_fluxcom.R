source("~/.Rprofile")
library(dplyr)
library(ncdf4)
library(abind)

## ALTERNATIVELY, USE DATA DOWNLOADED FROM FLUXCOM WEBSITE:
yearstart = 1980
yearend   = 2013

idx <- 0
for (year in yearstart:yearend){

  idx <- idx + 1
  filn <- paste0( myhome, "/data/gpp_mte/GPP.RF.CRUNCEPv6.annual.", as.character(year), ".nc" )

  nc <- nc_open( filn )
  tmp <- ncvar_get( nc, varid="GPP" )
  tmp <- tmp * 365  # convert to totals, given in units per day
  if (idx>1) {
    gpp <- abind( gpp, tmp, along = 3 )
  } else {
    gpp <- tmp
    lon <- nc$dim$lon$vals
    lat <- nc$dim$lat$vals
  }
  nc_close(nc)

}

## write annual GPP to file
outfilnam <- paste0(myhome, "/data/gpp_mte/gpp_mte_fluxcom_ANN.nc")
cdf.write( gpp, "gpp", 
           lon, lat,
           filnam = outfilnam,
           nvars = 1,
           time = yearstart:yearend,
           make.tdim = TRUE,
           units_time = "year",
           long_name_var1 = "Gross primary productivity",
           units_var1 = "gC m-2 year-1",
           glob_hist = "file created by emcon_iav/preprocess_gpp_mte_fluxcom.R based on GPP.RF.CRUNCEPv6.annual.<year>.nc, downloaded from ftp://ftp.bgc-jena.mpg.de/pub/outgoing/FluxCom/CarbonFluxes/RS+METEO/CRUNCEPv6/raw/annual/ (17.11.2017)."
)
