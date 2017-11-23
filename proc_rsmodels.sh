#!/bin/bash

here=`pwd`

##----------------------------------------------------
## MTE
##----------------------------------------------------
cd ~/data/gpp_mte/

Rscript preproc_mte.R

## select years
cdo selyear,1982/2011 gpp_mte_NICE.nc gpp_mte_SUB.nc

## multiply with days per month
cdo muldpm gpp_mte_SUB.nc gpp_mte_DPM.nc

## multiply with seconds per day and convert from kg C to g C
cdo mulc,86400000 gpp_mte_DPM.nc gpp_mte_SPM.nc

## get annual sums
cdo yearsum gpp_mte_SPM.nc gpp_mte_ANN.nc

## get global totals
## GPP
cdo gridarea gpp_mte_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 gpp_mte_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,gpp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc gpp_mte_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc gpp_mte_GLOB.nc

## detrend
cdo detrend -selyear,1982/2011 -selname,gpp gpp_mte_GLOB.nc gpp_mte_DETR.nc

## variance
cdo timvar gpp_mte_DETR.nc gpp_mte_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc

cd $here


##----------------------------------------------------
## MTE-FLUXCOM
##----------------------------------------------------
cd ~/data/gpp_mte/

## concatenae annual files (cdo mergetime doesn't work)
Rscript preprocess_gpp_mte_fluxcom.R

## get global totals
## GPP
cdo gridarea gpp_mte_fluxcom_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 gpp_mte_fluxcom_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,gpp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc gpp_mte_fluxcom_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc gpp_mte_fluxcom_GLOB.nc

## detrend
cdo detrend -selyear,1982/2011 -selname,gpp gpp_mte_fluxcom_GLOB.nc gpp_mte_fluxcom_DETR.nc

## variance
cdo timvar gpp_mte_fluxcom_DETR.nc gpp_mte_fluxcom_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc

cd $here

##----------------------------------------------------
## VPM
##----------------------------------------------------
cd ~/data/gpp_vpm/

## concatenae annual files (cdo mergetime doesn't work)
Rscript preprocess_vpm.R

## get global totals
## GPP
cdo gridarea gpp_vpm_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 gpp_vpm_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,gpp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc gpp_vpm_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc gpp_vpm_GLOB.nc

## detrend (original 2000-2016)
cdo detrend -selname,gpp gpp_vpm_GLOB.nc gpp_vpm_DETR_20XX.nc

## variance
cdo timvar gpp_vpm_DETR_20XX.nc gpp_vpm_VAR_20XX.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc gridarea.nc gridarea_masked.nc mask.nc ones.nc

cd $here


##----------------------------------------------------
## BESS
##----------------------------------------------------
cd ~/data/gpp_vpm/

## multiply with days per month
cdo muldpm gpp_bess.nc gpp_bess_DPM.nc

## get annual sums
cdo yearsum gpp_bess_DPM.nc gpp_bess_ANN.nc


## get global totals
## GPP
cdo gridarea gpp_bess_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 gpp_bess_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,gpp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc gpp_bess_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc gpp_bess_GLOB.nc

## detrend (original 2001-2015)
cdo detrend -selname,gpp gpp_bess_GLOB.nc gpp_bess_DETR_20XX.nc

## variance
cdo timvar gpp_bess_DETR_20XX.nc gpp_bess_VAR_20XX.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc gridarea.nc gridarea_masked.nc mask.nc ones.nc

cd $here


##----------------------------------------------------
## MODIS
##----------------------------------------------------
cd ~/data/gpp_modis/

## get global totals
## GPP
cdo gridarea gpp_modis_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 gpp_modis_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,gpp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc gpp_modis_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc gpp_modis_GLOB.nc

## detrend (original 2000-2015)
cdo detrend -selname,gpp gpp_modis_GLOB.nc gpp_modis_DETR_20XX.nc

## variance
cdo timvar gpp_modis_DETR_20XX.nc gpp_modis_VAR_20XX.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc gridarea.nc gridarea_masked.nc mask.nc ones.nc

cd $here



















