source("~/.Rprofile")
library(dplyr)
library(ncdf4)
library(pracma)   # provides function 'detrend'

landsink <- read.csv("/Users/benjaminstocker/data/trendy/v5/Global_Carbon_Budget_2016v1.0_landsink.csv", sep=";")

filnams <- read.csv("/Users/benjaminstocker/data/trendy/v5/trendy_s2_filnams_gpp.csv", as.is = TRUE)
filnams$nice <- rep(NA, nrow(filnams))

df_var <- data.frame()

for (idx in 1:nrow(filnams)){

	if (filnams$orig[idx]!=""){

		modl <- as.character(filnams$modl[idx])
		if (modl=="LPJ-GUESS"){
			basefil_gpp <- paste0( "/Users/benjaminstocker/data/trendy/v5/", modl, "/S2/", as.character(filnams$orig[idx]) ) %>% substr( start=1, stop=nchar(.)-8)
			basefil_nbp <- paste0( "/Users/benjaminstocker/data/trendy/v5/", modl, "/S2/", as.character(filnams$orig[idx]) ) %>% substr( start=1, stop=nchar(.)-12) %>% paste0( "_nbp" )
		} else {
			basefil_gpp <- paste0( "/Users/benjaminstocker/data/trendy/v5/", modl, "/S2/", as.character(filnams$orig[idx]) ) %>% substr( start=1, stop=nchar(.)-3)
			basefil_nbp <- paste0( "/Users/benjaminstocker/data/trendy/v5/", modl, "/S2/", as.character(filnams$orig[idx]) ) %>% substr( start=1, stop=nchar(.)-7) %>% paste0( "_nbp" )			
		}
		
		fil <- paste0( basefil_gpp, "_VAR.nc" )
		print( paste("opening file: ", fil ) )
		if (file.exists(fil)){
			nc <- try( nc_open( fil ) )
			var_gpp <- ncvar_get( nc, varid="gpp" )
			nc_close(nc)			
		} else {
			var_gpp <- NA
		}

		fil <- paste0( basefil_nbp, "_VAR.nc" )
		print( paste("opening file: ", fil ) )
		if (file.exists(fil)){
			nc <- nc_open( fil )
			var_nbp <- ncvar_get( nc, varid="nbp" )
			nc_close(nc)
		} else {
			var_nbp <- NA
		}

		tmp <- data.frame( model=modl, gpp=var_gpp, nbp=var_nbp )
		df_var <- rbind( df_var, tmp )
		
		
	}

}

## Remote sensing GPP models
# ## Files for which variance is derived from 30 years data (1982-2011)
# filnams_30y <- c( paste0( myhome, "/data/gpp_mte/gpp_mte"),
#                   paste0( myhome, "/data/gpp_mte/gpp_mte_fluxcom")
#                   )

# ## Files for which variance is derived from 13 years data (2001-2013)
# filnams_10y <- c( paste0( myhome, "/data/gpp_bess/gpp_bess"),
#                   paste0( myhome, "/data/gpp_mte/gpp_mte"),
#                   paste0( myhome, "/data/gpp_mte/gpp_mte_fluxcom"),
#                   paste0( myhome, "data/gpp_modis/gpp_modis"),
#                   paste0( myhome, "data/gpp_vpm/gpp_vpm")
#                   )

df_rsmodels <- data.frame()
filnams_rs <- read.csv( "filnams_rsmodels.csv", as.is=TRUE )
# filnams <- list( l10y=filnams_10y, l30y=filnams_30y )

# for (ilen in c("l30y", "l10y")){
for (idx in seq(nrow(filnams_rs))){

  # for ( basefil in filnams[[ ilen ]] ){

    # if (ilen=="l30y"){
    #   ext <- ""
    # } else if (ilen=="l10y"){
    #   ext <- "_10y"
    # }

  	filn <- paste0( myhome, "data/", filnams_rs$dir[idx], "/", filnams_rs$filename[idx], "_VAR_GLOB20XX.nc")
    # if (!file.exists(paste0( myhome, basefil, "_VAR", ext, ".nc"))){
    if (file.exists(filn)){

      print( paste("opening file: ", filn ) )
      nc <- nc_open( filn )
      gpp <- ncvar_get( nc, varid="gpp" )
      nc_close(nc)

			tmp <- data.frame( model=filnams_rs$model[idx], gpp=gpp, nbp=NA )
			df_rsmodels <- rbind( df_rsmodels, tmp )
		
    } else {
      print( paste( "file does not exist: ", filn ) )
    }
  	
	# }
}

par(las=1)
with( df_var, plot( nbp, gpp, pch=16, xlab="var(NBP), PgC/yr", ylab="var(GPP), PgC/yr", xlim=c(0,3.2), ylim=c(0,7) ) )
text( df_var$nbp+0.03, df_var$gpp, df_var$model, adj = 0, cex=0.8 )
abline( lm( gpp ~ nbp, data=df_var ), lty=2 )
abline( lm( gpp ~ nbp, data=filter(df_var, model!="LPJ-GUESS") ) )
abline( v=var(landsink$budget), col="red")
text( var(landsink$budget), 6.7, "from budget", col="red" )
abline( h=df_rsmodels$gpp, col=add_alpha("black", 0.3) )
xvals <- rep(2.0, nrow(df_rsmodels))
xvals[which(df_rsmodels$model=="VPM")] <- 2.3
text( xvals, df_rsmodels$gpp, df_rsmodels$model, col=add_alpha("black", 0.5), adj=c(0,-0.05), cex=0.8)













