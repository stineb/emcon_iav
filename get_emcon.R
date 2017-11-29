source("~/.Rprofile")
library(dplyr)
library(ncdf4)
library(pracma)   # provides function 'detrend'

# landsink <- read.csv("/Users/benjaminstocker/data/trendy/v5/Global_Carbon_Budget_2016v1.0_landsink.csv", sep=";")

##-----------------------------------------------------------
## LOAD TRENDY DATA
##-----------------------------------------------------------
filn <- "data/df_var_trendy.Rdata"

if (file.exists(filn)){

  load( filn )

} else {

  filnams <- read.csv("/Users/benjaminstocker/data/trendy/v5/trendy_s2_filnams_gpp.csv", as.is = TRUE)

  df_var_trendy <- tibble()
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
      
      fil <- paste0( basefil_gpp, "_VAR_GLOB.nc" )
      print( paste("opening file: ", fil ) )
      if (file.exists(fil)){
        nc <- try( nc_open( fil ) )
        var_gpp <- ncvar_get( nc, varid="gpp" )
        nc_close(nc)      
      } else {
        var_gpp <- NA
      }

      fil <- paste0( basefil_nbp, "_VAR_GLOB.nc" )
      print( paste("opening file: ", fil ) )
      if (file.exists(fil)){
        nc <- nc_open( fil )
        var_nbp <- ncvar_get( nc, varid="nbp" )
        nc_close(nc)
      } else {
        var_nbp <- NA
      }

      tmp <- data.frame( model=modl, gpp=var_gpp, nbp=var_nbp )
      df_var_trendy <- bind_rows( df_var_trendy, tmp )
      
    }

  }
  save( df_var_trendy, file="data/df_var_trendy.Rdata")

}

## Drop some data that doesn't seem right
df_var_trendy <- df_var_trendy %>% filter( !( model %in%  c("LPJ-GUESS")) )


# ##-----------------------------------------------------------
# ## LOAD RS-GPP DATA
# ##-----------------------------------------------------------
# ## Remote sensing GPP models
# # ## Files for which variance is derived from 30 years data (1982-2011)
# # filnams_30y <- c( paste0( myhome, "/data/gpp_mte/gpp_mte"),
# #                   paste0( myhome, "/data/gpp_mte/gpp_mte_fluxcom")
# #                   )

# # ## Files for which variance is derived from 13 years data (2001-2013)
# # filnams_10y <- c( paste0( myhome, "/data/gpp_bess/gpp_bess"),
# #                   paste0( myhome, "/data/gpp_mte/gpp_mte"),
# #                   paste0( myhome, "/data/gpp_mte/gpp_mte_fluxcom"),
# #                   paste0( myhome, "data/gpp_modis/gpp_modis"),
# #                   paste0( myhome, "data/gpp_vpm/gpp_vpm")
# #                   )

# df_rsmodels <- tibble()
# filnams_rs <- read.csv( "filnams_rsmodels.csv", as.is=TRUE )
# yearrange <- list( l10y=df_rsmodels$model, l30y=c("MTE_FLUXCOM", "MTE", "Pmodel_S0", "Pmodel_S1") )
# # filnams <- list( l10y=filnams_10y, l30y=filnams_30y )

# # for (ilen in c("l30y", "l10y")){
# for (idx in seq(nrow(filnams_rs))){

#   # for ( basefil in filnams[[ ilen ]] ){

#     # if (ilen=="l30y"){
#     #   ext <- ""
#     # } else if (ilen=="l10y"){
#     #   ext <- "_10y"
#     # }

#     if (filnams_rs$model[idx] %in% yearrange$l30y ){
#       filn <- paste0( myhome, "data/", filnams_rs$dir[idx], "/", filnams_rs$filename[idx], "_VAR_GLOB.nc")
#     } else {
#       filn <- paste0( myhome, "data/", filnams_rs$dir[idx], "/", filnams_rs$filename[idx], "_VAR_GLOB20XX.nc")
#     }

#   	if (file.exists(filn)){

#       print( paste("opening file: ", filn ) )
#       nc <- nc_open( filn )
#       gpp <- ncvar_get( nc, varid="gpp" )
#       nc_close(nc)

# 			tmp <- data.frame( model=filnams_rs$model[idx], gpp=gpp, nbp=NA )
# 			df_rsmodels <- bind_rows( df_rsmodels, tmp )
		
#     } else {
#       print( paste( "file does not exist: ", filn ) )
#     }
  	
# 	# }
# }

# ##-----------------------------------------------------------
# ## LOAD MSTMIP DATA
# ##-----------------------------------------------------------
# ## SG1
# ##-----------------------------------------------------------
# df_var_mstmip_sg1 <- tibble()
# filnams_mstmip_sg1 <- read.csv( "filnams_mstmip_sg1.csv", as.is=TRUE )

# for (idx in seq(nrow(filnams_mstmip_sg1))){

#   filn <- paste0( myhome, "data/mstmip/", filnams_mstmip_sg1$model[idx], "/SG1/", filnams_mstmip_sg1$basename[idx], "_GPP_VAR_GLOB.nc")
# 	if (file.exists(filn)){
#     print( paste("opening file: ", filn ) )
#     nc <- nc_open( filn )
#     gpp <- ncvar_get( nc, varid="GPP" )
#     nc_close(nc)
#   } else {
#     print( paste( "file does not exist: ", filn ) )
#     gpp <- NA
#   }

#   filn <- paste0( myhome, "data/mstmip/", filnams_mstmip_sg1$model[idx], "/SG1/", filnams_mstmip_sg1$basename[idx], "_NEE_VAR_GLOB.nc")
# 	if (file.exists(filn)){
#     print( paste("opening file: ", filn ) )
#     nc <- nc_open( filn )
#     nbp <- ncvar_get( nc, varid="NEE" )
#     nc_close(nc)
#   } else {
#     print( paste( "file does not exist: ", filn ) )
#     nbp <- NA
#   }	
# 	tmp <- data.frame( model=filnams_mstmip_sg1$model[idx], gpp=gpp, nbp=nbp )
# 	df_var_mstmip_sg1 <- bind_rows( df_var_mstmip_sg1, tmp )
	  	
# }

# ## Drop some data that doesn't seem right
# df_var_mstmip_sg1 <- df_var_mstmip_sg1 %>% filter( !( model %in%  c("GTEC")) )

# ##-----------------------------------------------------------
# ## SG3
# ##-----------------------------------------------------------
# df_var_mstmip_sg3 <- tibble()
# filnams_mstmip_sg3 <- read.csv( "filnams_mstmip_sg3.csv", as.is=TRUE )

# for (idx in seq(nrow(filnams_mstmip_sg3))){

#   filn <- paste0( myhome, "data/mstmip/", filnams_mstmip_sg3$model[idx], "/SG3/", filnams_mstmip_sg3$basename[idx], "_GPP_VAR_GLOB.nc")
# 	if (file.exists(filn)){
#     print( paste("opening file: ", filn ) )
#     nc <- nc_open( filn )
#     gpp <- ncvar_get( nc, varid="GPP" )
#     nc_close(nc)
#   } else {
#     print( paste( "file does not exist: ", filn ) )
#     gpp <- NA
#   }

#   filn <- paste0( myhome, "data/mstmip/", filnams_mstmip_sg3$model[idx], "/SG3/", filnams_mstmip_sg3$basename[idx], "_NEE_VAR_GLOB.nc")
# 	if (file.exists(filn)){
#     print( paste("opening file: ", filn ) )
#     nc <- nc_open( filn )
#     nbp <- ncvar_get( nc, varid="NEE" )
#     nc_close(nc)
#   } else {
#     print( paste( "file does not exist: ", filn ) )
#     nbp <- NA
#   }	
# 	tmp <- data.frame( model=filnams_mstmip_sg3$model[idx], gpp=gpp, nbp=nbp )
# 	df_var_mstmip_sg3 <- bind_rows( df_var_mstmip_sg3, tmp )
	  	
# }

# ## Drop some data that doesn't seem right
# df_var_mstmip_sg3 <- df_var_mstmip_sg3 %>% filter( !( model %in%  c("GTEC")) )

##-----------------------------------------------------------
## CMIP5 HISTORICAL 1982-2011
## This loads:
## ts.GPP
## ts.NBP
## filesGPP
## filesNBP
## 
## Explanation:
## Die ts files enhalten j??hrliche Zeitreihen von NBP und GPP (Pg/Yr) von 1870-2100 (RCP8.5) f??r 39 Modelll??ufe. 
## files... enth??lt die modellnamen dieser 39 L??ufe in der gleichen Reihenfolge. 
## 
## z.B.
## gpp_ann_CanESM2_rcp85_r1i1p1_g025.nc
## 
## ann heisst annual. CANESM2 ist das modell, rcp85 ist das forcing ab 2005 (davor ist es immer historical), r1i1p1 ist der Lauf. Manche Modelle haben mehrere L??ufe, i.e., r2i1p1 etc. g025 war die Aufl??sung (2.5x2.5??).
##-----------------------------------------------------------
filn <- "data/df_var_cmip_hist_agg.Rdata"

# if (file.exists(filn)){
if (file.exists("figgdi")){
    
  load( filn )
  load( "data/df_var_cmip_hist.Rdata" )

} else {

  load("data/4Beni_CMIP5_historical_global_GPP_NBP_fromJakob.Rdata")

  ## put into nice format: dataframe holding one global value for variance in GPP and NBP
  df_var_cmip_hist <- tibble()
  for (idx in seq(length(filesGPP))){

    ## extract model name
    pos <- regexpr( '_rcp85_', filesGPP[idx] ) 
    model <- substr( filesGPP[idx], start = 9, stop = pos-1 )
    df_tmp <- tibble( year=1870:2100, gpp=ts.GPP[idx,], nbp=ts.NBP[idx,] ) %>% filter( year %in% 1982:2011 )
    res_gpp <- lm( gpp ~ year, data=df_tmp )$residuals
    res_nbp <- lm( nbp ~ year, data=df_tmp )$residuals
    df_tmp <- df_tmp %>% mutate( gpp_detr=res_gpp, nbp_detr=res_nbp )
    addrow <- df_tmp %>% summarise( model=model, gpp=sd(gpp_detr), nbp=sd(nbp_detr) )
    df_var_cmip_hist <- bind_rows( df_var_cmip_hist, addrow )
  }

  ## Drop some data because it just looks not right
  df_var_cmip_hist_unfiltered <- df_var_cmip_hist
  # df_var_cmip_hist <- df_var_cmip_hist %>% filter( !( model %in%  c("GFDL-ESM2M")) )
  # df_var_cmip_hist <- df_var_cmip_hist %>% filter( !( model %in%  c("CanESM2", "CMCC-CESM","GFDL-ESM2M", "MIROC-ESM", "MIROC-ESM-CHEM")) )
  # df_var_cmip_hist[ which(df_var_cmip_hist$model=="GFDL-ESM2M"), 2:3 ] <- df_var_cmip_hist[ which(df_var_cmip_hist$model=="GFDL-ESM2M"), 2:3 ] * 0.1  # assuming that there is a factor 10 problem

  ## Aggregate across ensemble members
  df_var_cmip_hist_agg <- df_var_cmip_hist %>% group_by( model ) %>%  summarise_all( mean )


  ##-----------------------------------------------------------
  ## Combine and evaluate linear relationship
  ##-----------------------------------------------------------
  save( df_var_cmip_hist, file="data/df_var_cmip_hist.Rdata" )
  save( df_var_cmip_hist_agg, file="data/df_var_cmip_hist_agg.Rdata" )

}


##-----------------------------------------------------------
## CMIP5 RCP85 2071-2100
## This loads:
## ts.GPP
## ts.NBP
## filesGPP
## filesNBP
## 
## Explanation:
## Die ts files enhalten j??hrliche Zeitreihen von NBP und GPP (Pg/Yr) von 1870-2100 (RCP8.5) f??r 39 Modelll??ufe. 
## files... enth??lt die modellnamen dieser 39 L??ufe in der gleichen Reihenfolge. 
## 
## z.B.
## gpp_ann_CanESM2_rcp85_r1i1p1_g025.nc
## 
## ann heisst annual. CANESM2 ist das modell, rcp85 ist das forcing ab 2005 (davor ist es immer historical), r1i1p1 ist der Lauf. Manche Modelle haben mehrere L??ufe, i.e., r2i1p1 etc. g025 war die Aufl??sung (2.5x2.5??).
##-----------------------------------------------------------
filn <- "data/df_var_cmip_rcp85_agg.Rdata"

# if (file.exists(filn)){
if (file.exists("figgdi")){
    
  load( filn )
  load( "data/df_var_cmip_rcp85.Rdata" )

} else {

  load("data/4Beni_CMIP5_historical_global_GPP_NBP_fromJakob.Rdata")

  ## put into nice format: dataframe holding one global value for variance in GPP and NBP
  df_var_cmip_rcp85 <- tibble()
  for (idx in seq(length(filesGPP))){

    ## extract model name
    pos <- regexpr( '_rcp85_', filesGPP[idx] ) 
    model <- substr( filesGPP[idx], start = 9, stop = pos-1 )
    df_tmp <- tibble( year=1870:2100, gpp=ts.GPP[idx,], nbp=ts.NBP[idx,] ) %>% filter( year %in% 2071:2100 )
    res_gpp <- lm( gpp ~ year, data=df_tmp )$residuals
    res_nbp <- lm( nbp ~ year, data=df_tmp )$residuals
    df_tmp <- df_tmp %>% mutate( gpp_detr=res_gpp, nbp_detr=res_nbp )
    addrow <- df_tmp %>% summarise( model=model, gpp=sd(gpp_detr), nbp=sd(nbp_detr) )
    df_var_cmip_rcp85 <- bind_rows( df_var_cmip_rcp85, addrow )
  }

  ## Drop some data because it just looks not right
  df_var_cmip_rcp85_unfiltered <- df_var_cmip_rcp85
  df_var_cmip_rcp85 <- df_var_cmip_rcp85 %>% filter( !( model %in%  c("GFDL-ESM2M")) )
  # df_var_cmip_rcp85 <- df_var_cmip_rcp85 %>% filter( !( model %in%  c("CanESM2", "CMCC-CESM","GFDL-ESM2M", "MIROC-ESM", "MIROC-ESM-CHEM")) )
  # df_var_cmip_rcp85[ which(df_var_cmip_rcp85$model=="GFDL-ESM2M"), 2:3 ] <- df_var_cmip_rcp85[ which(df_var_cmip_rcp85$model=="GFDL-ESM2M"), 2:3 ] * 0.1  # assuming that there is a factor 10 problem

  ## Aggregate across ensemble members
  df_var_cmip_rcp85_agg <- df_var_cmip_rcp85 %>% group_by( model ) %>%  summarise_all( mean )


  ##-----------------------------------------------------------
  ## Combine and evaluate linear relationship
  ##-----------------------------------------------------------
  save( df_var_cmip_rcp85, file="data/df_var_cmip_rcp85.Rdata" )
  save( df_var_cmip_rcp85_agg, file="data/df_var_cmip_rcp85_agg.Rdata" )

}


##-----------------------------------------------------------
## CMIP5 PI-CONTROL 
## (same format as historical)
##-----------------------------------------------------------
filn <- "data/df_var_cmip_ctrl_agg.Rdata"

#if (file.exists(filn)){
if (file.exists("figgdi")){
  
  load( filn )
  load( "data/df_var_cmip_ctrl.Rdata" )

} else {

  rm("filesGPP")
  rm("ts.GPP")
  rm("ts.NBP")
  load("data/4Beni_CMIP5_picontrol_global_GPP_NBP_fromJakob.Rdata")

  ## put into nice format: dataframe holding one global value for variance in GPP and NBP
  df_var_cmip_ctrl <- tibble()
  for (idx in seq(length(filesGPP))){

    ## extract model name
    pos <- regexpr( '_piControl_', filesGPP[idx] ) 
    model <- substr( filesGPP[idx], start = 9, stop = pos-1 )
    if (model=="CESM1-CAM5-1-FV2"){
      print("beni")
    }
    df_tmp <- tibble( year=1870:1919, gpp=ts.GPP[idx,], nbp=ts.NBP[idx,] )
    res_gpp <- lm( gpp ~ year, data=df_tmp )$residuals
    res_nbp <- lm( nbp ~ year, data=df_tmp )$residuals
    df_tmp <- df_tmp %>% mutate( gpp_detr=res_gpp, nbp_detr=res_nbp )
    addrow <- df_tmp %>% summarise( model=model, gpp=sd(gpp_detr), nbp=sd(nbp_detr) )
    df_var_cmip_ctrl <- bind_rows( df_var_cmip_ctrl, addrow )
  }

  ## Drop some data because it just looks not right
  df_var_cmip_ctrl_unfiltered <- df_var_cmip_ctrl
  df_var_cmip_ctrl <- df_var_cmip_ctrl %>% filter( !( model %in%  c("CESM1-CAM5-1-FV2")) )
  # df_var_cmip_ctrl[ which(df_var_cmip_ctrl$model=="GFDL-ESM2M"), 2:3 ] <- df_var_cmip_ctrl[ which(df_var_cmip_ctrl$model=="GFDL-ESM2M"), 2:3 ] * 0.1  # assuming that there is a factor 10 problem

  ## Aggregate across ensemble members
  df_var_cmip_ctrl_agg <- df_var_cmip_ctrl %>% group_by( model ) %>%  summarise_all( mean )


  ##-----------------------------------------------------------
  ## Combine and evaluate linear relationship
  ##-----------------------------------------------------------
  save( df_var_cmip_ctrl, file="data/df_var_cmip_ctrl.Rdata" )
  save( df_var_cmip_ctrl_agg, file="data/df_var_cmip_ctrl_agg.Rdata" )

}

## get linear model for sd(GPP) ~ sd(NBP)
lm_emcon <- lm( gpp ~ nbp, data=bind_rows( df_var_trendy, df_var_cmip_hist, df_var_cmip_ctrl, df_var_cmip_rcp85 ) )
# lm_emcon_agg <- lm( gpp ~ nbp, data=bind_rows( df_var_trendy, df_var_cmip_hist_agg, df_var_mstmip_sg1, df_var_mstmip_sg3 ) )
lm_emcon_agg <- lm( gpp ~ nbp, data=bind_rows( df_var_trendy, df_var_cmip_hist_agg, df_var_cmip_ctrl_agg, df_var_cmip_rcp85_agg ) )

print(summary(lm_emcon))
print(summary(lm_emcon_agg))

##-----------------------------------------------------------
## Plot
##-----------------------------------------------------------
pdf("fig/varGPP_varNBP_emconstr.pdf")

	par(las=1)

	## TRENDY
	# with( df_var_trendy, plot( nbp, gpp, pch=16, xlab="sd(NBP), PgC/yr", ylab="sd(GPP), PgC/yr", xlim=c(0,13), ylim=c(0,32) ) )
  # with( df_var_trendy, plot( nbp, gpp, pch=16, xlab="sd(NBP), PgC/yr", ylab="sd(GPP), PgC/yr", xlim=c(0,13), ylim=c(0,32), type="n" ) )
  with( df_var_trendy, plot( sqrt(nbp), sqrt(gpp), pch=16, xlab="sd(NBP), PgC/yr", ylab="sd(GPP), PgC/yr", xlim=c(0,4), ylim=c(0,7) ) )
	text( sqrt(df_var_trendy$nbp)+0.05, sqrt(df_var_trendy$gpp), df_var_trendy$model, adj = 0, cex=0.4 )

	# ## CMIP historical (each ensemble member)
	# with( df_var_cmip_hist, points( nbp, gpp, pch=17, col=add_alpha("tomato", 0.5), cex=0.5 ) )
	# text( df_var_cmip_hist$nbp+0.05, df_var_cmip_hist$gpp, df_var_cmip_hist$model, adj = 0, cex=0.4, col=add_alpha("tomato", 0.5)  )

	## CMIP historical (aggregated by ensemble members)
	with( df_var_cmip_hist_agg, points( nbp, gpp, pch=17, col=add_alpha("tomato", 0.5), cex=1 ) )
	text( df_var_cmip_hist_agg$nbp+0.05, df_var_cmip_hist_agg$gpp, df_var_cmip_hist_agg$model, adj = 0, cex=0.4, col=add_alpha("tomato",0.5)  )

  # ## CMIP RCP8.5 (each ensemble member)
  # with( df_var_cmip_rcp85, points( nbp, gpp, pch=17, col=add_alpha("tomato4", 0.5), cex=0.5 ) )
  # text( df_var_cmip_rcp85$nbp+0.05, df_var_cmip_rcp85$gpp, df_var_cmip_rcp85$model, adj = 0, cex=0.4, col=add_alpha("tomato4", 0.5)  )

  ## CMIP RCP8.5 (aggregated by ensemble members)
  with( df_var_cmip_rcp85_agg, points( nbp, gpp, pch=17, col=add_alpha("orchid", 0.5), cex=1 ) )
  text( df_var_cmip_rcp85_agg$nbp+0.05, df_var_cmip_rcp85_agg$gpp, df_var_cmip_rcp85_agg$model, adj = 0, cex=0.4, col=add_alpha("orchid",0.5)  )

  # ## CMIP picontrol (each ensemble member)
  # with( df_var_cmip_ctrl, points( nbp, gpp, pch=17, col=add_alpha("royalblue3", 0.5), cex=0.5 ) )
  # text( df_var_cmip_ctrl$nbp+0.05, df_var_cmip_ctrl$gpp, df_var_cmip_ctrl$model, adj = 0, cex=0.4, col=add_alpha("royalblue3", 0.5)  )

  ## CMIP picontrol (aggregated by ensemble members)
  with( df_var_cmip_ctrl_agg, points( nbp, gpp, pch=17, col=add_alpha("royalblue3", 0.5), cex=1 ) )
  text( df_var_cmip_ctrl_agg$nbp+0.05, df_var_cmip_ctrl_agg$gpp, df_var_cmip_ctrl_agg$model, adj = 0, cex=0.4, col=add_alpha("royalblue3", 0.5)  )

	# ## MsTMIP SG1
	# with( df_var_mstmip_sg1, points( nbp, gpp, pch=17, col=add_alpha("springgreen", 1) ) )
	# text( df_var_mstmip_sg1$nbp+0.05, df_var_mstmip_sg1$gpp, df_var_mstmip_sg1$model, col=add_alpha("springgreen", 1), adj = 0, cex=0.8 )
	# 
	# ## MsTMIP SG3
	# with( df_var_mstmip_sg3, points( nbp, gpp, pch=17, col=add_alpha("springgreen3", 1) ) )
	# text( df_var_mstmip_sg3$nbp+0.05, df_var_mstmip_sg3$gpp, df_var_mstmip_sg3$model, col=add_alpha("springgreen3", 1), adj = 0, cex=0.8 )
	# 
	# abline( lm( gpp ~ nbp, data=df_var_trendy ), lty=2 )
	# abline( lm_emcon )
  abline( lm_emcon_agg )

	# ## add vertical line for land sink from budget
	# abline( v=sd(landsink$budget), col="red")
	# text( sd(landsink$budget), 6.7, "from budget", col="red" )

	# abline( h=df_rsmodels$gpp, col=add_alpha("black", 0.3) )
	# xvals <- rep(2.0, nrow(df_rsmodels))
	# xvals[which(df_rsmodels$model=="VPM")] <- 2.3
	# text( xvals, df_rsmodels$gpp, df_rsmodels$model, col=add_alpha("black", 0.5), adj=c(0,-0.05), cex=0.8)

  legend( "bottomright", c("TRENDY", "CMIP5, historical", "CMIP5, RCP 8.5", "CMIP5, PI-control"), col=c("black", add_alpha("tomato",0.5), add_alpha("orchid",0.5), add_alpha("royalblue3", 0.5)), pch=c(16,17,17,17), bty = "n", cex=0.8 )

dev.off()













