#!/bin/bash

##----------------------------------------------------
## CABLE
##----------------------------------------------------
cd CABLE/S2

if [ -e CABLE-POP_S2_gpp_ANN.nc ]
then

	## select years
	cdo selyear,1901/2015 CABLE-POP_S2_nbp.nc CABLE-POP_S2_nbp_SUB.nc
	cdo selyear,1901/2015 CABLE-POP_S2_gpp.nc CABLE-POP_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm CABLE-POP_S2_nbp_SUB.nc CABLE-POP_S2_nbp_DPM.nc
	cdo muldpm CABLE-POP_S2_gpp_SUB.nc CABLE-POP_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 CABLE-POP_S2_nbp_DPM.nc CABLE-POP_S2_nbp_SPM.nc
	cdo mulc,86400000 CABLE-POP_S2_gpp_DPM.nc CABLE-POP_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum CABLE-POP_S2_nbp_SPM.nc CABLE-POP_S2_nbp_ANN.nc
	cdo yearsum CABLE-POP_S2_gpp_SPM.nc CABLE-POP_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea CABLE-POP_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 CABLE-POP_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc CABLE-POP_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc CABLE-POP_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc CABLE-POP_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc CABLE-POP_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp CABLE-POP_S2_nbp_GLOB.nc CABLE-POP_S2_nbp_DETR.nc
cdo detrend -selname,gpp CABLE-POP_S2_gpp_GLOB.nc CABLE-POP_S2_gpp_DETR.nc

## variance
cdo timvar CABLE-POP_S2_nbp_DETR.nc CABLE-POP_S2_nbp_VAR.nc
cdo timvar CABLE-POP_S2_gpp_DETR.nc CABLE-POP_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc

cd ../..


##----------------------------------------------------
## CLM
##----------------------------------------------------
cd CLM/S2

if [ -e CLM4.5_S2_gpp_ANN.nc ]
then

	## select years
	cdo selyear,1901/2015 CLM4.5_S2_nbp.nc CLM4.5_S2_nbp_SUB.nc
	cdo selyear,1901/2015 CLM4.5_S2_gpp.nc CLM4.5_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm CLM4.5_S2_nbp_SUB.nc CLM4.5_S2_nbp_DPM.nc
	cdo muldpm CLM4.5_S2_gpp_SUB.nc CLM4.5_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 CLM4.5_S2_nbp_DPM.nc CLM4.5_S2_nbp_SPM.nc
	cdo mulc,86400000 CLM4.5_S2_gpp_DPM.nc CLM4.5_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum CLM4.5_S2_nbp_SPM.nc CLM4.5_S2_nbp_ANN.nc
	cdo yearsum CLM4.5_S2_gpp_SPM.nc CLM4.5_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea CLM4.5_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 CLM4.5_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc CLM4.5_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc CLM4.5_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc CLM4.5_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc CLM4.5_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp CLM4.5_S2_nbp_GLOB.nc CLM4.5_S2_nbp_DETR.nc
cdo detrend -selname,gpp CLM4.5_S2_gpp_GLOB.nc CLM4.5_S2_gpp_DETR.nc

## variance
cdo timvar CLM4.5_S2_nbp_DETR.nc CLM4.5_S2_nbp_VAR.nc
cdo timvar CLM4.5_S2_gpp_DETR.nc CLM4.5_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..

##----------------------------------------------------
## ISAM
##----------------------------------------------------
cd ISAM/S2

if [ -e ISAM_S2_gpp_ANN.nc ]
then

	## select years
	cdo seltimestep,42/156 ISAM_S2_nbp.nc ISAM_S2_nbp_SUB.nc
	cdo seltimestep,42/156 ISAM_S2_gpp.nc ISAM_S2_gpp_SUB.nc

	## sum over vertical dimension (given in kgC m-2 month-1)
	cdo mulc,1000 -vertsum ISAM_S2_nbp_SUB.nc ISAM_S2_nbp_ANN.nc
	cdo mulc,1000 -vertsum ISAM_S2_gpp_SUB.nc ISAM_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea ISAM_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 ISAM_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc ISAM_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc ISAM_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc ISAM_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc ISAM_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp ISAM_S2_nbp_GLOB.nc ISAM_S2_nbp_DETR.nc
cdo detrend -selname,gpp ISAM_S2_gpp_GLOB.nc ISAM_S2_gpp_DETR.nc

## variance
cdo timvar ISAM_S2_nbp_DETR.nc ISAM_S2_nbp_VAR.nc
cdo timvar ISAM_S2_gpp_DETR.nc ISAM_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc mask.nc ones.nc
cd ../..

##----------------------------------------------------
## JSBACH
##----------------------------------------------------
cd JSBACH/S2

if [ -e JSBACH_S2_gpp_ANN.nc ]
then

	## select years
	cdo selyear,1901/2015 JSBACH_S2_nbp.nc JSBACH_S2_nbp_SUB.nc
	cdo selyear,1901/2015 JSBACH_S2_gpp.nc JSBACH_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm JSBACH_S2_nbp_SUB.nc JSBACH_S2_nbp_DPM.nc
	cdo muldpm JSBACH_S2_gpp_SUB.nc JSBACH_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 JSBACH_S2_nbp_DPM.nc JSBACH_S2_nbp_SPM.nc
	cdo mulc,86400000 JSBACH_S2_gpp_DPM.nc JSBACH_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum JSBACH_S2_nbp_SPM.nc JSBACH_S2_nbp_ANN.nc
	cdo yearsum JSBACH_S2_gpp_SPM.nc JSBACH_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea JSBACH_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 JSBACH_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc JSBACH_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc JSBACH_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc JSBACH_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc JSBACH_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp JSBACH_S2_nbp_GLOB.nc JSBACH_S2_nbp_DETR.nc
cdo detrend -selname,gpp JSBACH_S2_gpp_GLOB.nc JSBACH_S2_gpp_DETR.nc

## variance
cdo timvar JSBACH_S2_nbp_DETR.nc JSBACH_S2_nbp_VAR.nc
cdo timvar JSBACH_S2_gpp_DETR.nc JSBACH_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..


##----------------------------------------------------
## LPJ-GUESS
##----------------------------------------------------
cd LPJ-GUESS/S2

if [ -e LPJ-GUESS_S2_gpp_ANN.nc ]
then

	## select years
	cdo mulc,3.1536e10 -chname,nbp.yearly,nbp -selyear,1901/2015 LPJ-GUESS_S2_nbp.nc LPJ-GUESS_S2_nbp_ANN.nc
	cdo chname,gpp.monthly,gpp -selyear,1901/2015 LPJ-GUESS_S2_gpp_fEst.nc LPJ-GUESS_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm LPJ-GUESS_S2_gpp_SUB.nc LPJ-GUESS_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 LPJ-GUESS_S2_gpp_DPM.nc LPJ-GUESS_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum LPJ-GUESS_S2_gpp_SPM.nc LPJ-GUESS_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea LPJ-GUESS_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 LPJ-GUESS_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc LPJ-GUESS_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc LPJ-GUESS_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc LPJ-GUESS_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc LPJ-GUESS_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp LPJ-GUESS_S2_nbp_GLOB.nc LPJ-GUESS_S2_nbp_DETR.nc
cdo detrend -selname,gpp LPJ-GUESS_S2_gpp_GLOB.nc LPJ-GUESS_S2_gpp_DETR.nc

## variance
cdo timvar LPJ-GUESS_S2_nbp_DETR.nc LPJ-GUESS_S2_nbp_VAR.nc
cdo timvar LPJ-GUESS_S2_gpp_DETR.nc LPJ-GUESS_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..


##----------------------------------------------------
## LPX-Bern
##----------------------------------------------------
cd LPX-Bern/S2

if [ -e LPX_S2_gpp_ANN.nc ]
then

	# Pre-process data
	Rscript /Users/benjaminstocker/emcon_iav/preproc_lpx.R

	## select years WARNING: THERE IS SOMETHING WRONG WITH THE LAST YEAR, THEREFORE REMOVING 2015
	cdo selyear,1901/2014 LPX_S2_nbp_NICE.nc LPX_S2_nbp_SUB.nc
	cdo selyear,1901/2014 LPX_S2_gpp_NICE.nc LPX_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm LPX_S2_nbp_SUB.nc LPX_S2_nbp_DPM.nc
	cdo muldpm LPX_S2_gpp_SUB.nc LPX_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 LPX_S2_nbp_DPM.nc LPX_S2_nbp_SPM.nc
	cdo mulc,86400000 LPX_S2_gpp_DPM.nc LPX_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum LPX_S2_nbp_SPM.nc LPX_S2_nbp_ANN.nc
	cdo yearsum LPX_S2_gpp_SPM.nc LPX_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea LPX_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 LPX_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc LPX_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc LPX_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc LPX_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc LPX_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp LPX_S2_nbp_GLOB.nc LPX_S2_nbp_DETR.nc
cdo detrend -selname,gpp LPX_S2_gpp_GLOB.nc LPX_S2_gpp_DETR.nc

## variance
cdo timvar LPX_S2_nbp_DETR.nc LPX_S2_nbp_VAR.nc
cdo timvar LPX_S2_gpp_DETR.nc LPX_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..


##----------------------------------------------------
## ORCHIDEE
##----------------------------------------------------
cd ORCHIDEE/S2

if [ -e orchidee_S2_gpp_ANN.nc ]
then

	## correcting messed up time axis and selecting years 1901-2015
	Rscript /Users/benjaminstocker/emcon_iav/preproc_orchidee.R

	## multiply with days per month
	cdo muldpm orchidee_S2_nbp_NICE.nc orchidee_S2_nbp_DPM.nc
	cdo muldpm orchidee_S2_gpp_NICE.nc orchidee_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 orchidee_S2_nbp_DPM.nc orchidee_S2_nbp_SPM.nc
	cdo mulc,86400000 orchidee_S2_gpp_DPM.nc orchidee_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum orchidee_S2_nbp_SPM.nc orchidee_S2_nbp_ANN.nc
	cdo yearsum orchidee_S2_gpp_SPM.nc orchidee_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea orchidee_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 orchidee_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc orchidee_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc orchidee_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc orchidee_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc orchidee_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp orchidee_S2_nbp_GLOB.nc orchidee_S2_nbp_DETR.nc
cdo detrend -selname,gpp orchidee_S2_gpp_GLOB.nc orchidee_S2_gpp_DETR.nc

## variance
cdo timvar orchidee_S2_nbp_DETR.nc orchidee_S2_nbp_VAR.nc
cdo timvar orchidee_S2_gpp_DETR.nc orchidee_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..


##----------------------------------------------------
## SDGVM
##----------------------------------------------------
cd SDGVM/S2

if [ -e SDGVM_S2_gpp_ANN.nc ]
then

	## select years (original from Jan 1860 - Oct 2013, total 1872 time steps = 156 years. Therefore should be to Dec 2015. Correct the damn file.)
	Rscript preproc_sdgvm.R

	## subset years
	cdo selyear,1901/2015 SDGVM_S2_nbp_NICE.nc SDGVM_S2_nbp_SUB.nc
	cdo selyear,1901/2015 SDGVM_S2_gpp_NICE.nc SDGVM_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm SDGVM_S2_nbp_SUB.nc SDGVM_S2_nbp_DPM.nc
	cdo muldpm SDGVM_S2_gpp_SUB.nc SDGVM_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 SDGVM_S2_nbp_DPM.nc SDGVM_S2_nbp_SPM.nc
	cdo mulc,86400000 SDGVM_S2_gpp_DPM.nc SDGVM_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum SDGVM_S2_nbp_SPM.nc SDGVM_S2_nbp_ANN.nc
	cdo yearsum SDGVM_S2_gpp_SPM.nc SDGVM_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea SDGVM_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 SDGVM_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc SDGVM_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc SDGVM_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc SDGVM_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc SDGVM_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp SDGVM_S2_nbp_GLOB.nc SDGVM_S2_nbp_DETR.nc
cdo detrend -selname,gpp SDGVM_S2_gpp_GLOB.nc SDGVM_S2_gpp_DETR.nc

## variance
cdo timvar SDGVM_S2_nbp_DETR.nc SDGVM_S2_nbp_VAR.nc
cdo timvar SDGVM_S2_gpp_DETR.nc SDGVM_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..


##----------------------------------------------------
## VEGAS
##----------------------------------------------------
cd VEGAS/S2

if [ -e VEGAS_S2_gpp_ANN.nc ]
then

	## subset years
	cdo selyear,1901/2015 VEGAS_S2_nbp.nc VEGAS_S2_nbp_SUB.nc
	cdo selyear,1901/2015 VEGAS_S2_gpp.nc VEGAS_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm VEGAS_S2_nbp_SUB.nc VEGAS_S2_nbp_DPM.nc
	cdo muldpm VEGAS_S2_gpp_SUB.nc VEGAS_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 VEGAS_S2_nbp_DPM.nc VEGAS_S2_nbp_SPM.nc
	cdo mulc,86400000 VEGAS_S2_gpp_DPM.nc VEGAS_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum VEGAS_S2_nbp_SPM.nc VEGAS_S2_nbp_ANN.nc
	cdo yearsum VEGAS_S2_gpp_SPM.nc VEGAS_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea VEGAS_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 VEGAS_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc VEGAS_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc VEGAS_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc VEGAS_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc VEGAS_S2_gpp_GLOB.nc

## detrend
cdo detrend -selname,nbp VEGAS_S2_nbp_GLOB.nc VEGAS_S2_nbp_DETR.nc
cdo detrend -selname,gpp VEGAS_S2_gpp_GLOB.nc VEGAS_S2_gpp_DETR.nc

## variance
cdo timvar VEGAS_S2_nbp_DETR.nc VEGAS_S2_nbp_VAR.nc
cdo timvar VEGAS_S2_gpp_DETR.nc VEGAS_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..


##----------------------------------------------------
## VISIT
##----------------------------------------------------
cd VISIT/S2

if [ -e VISIT_S2_gpp_ANN.nc ]
then

	## subset years
	cdo selyear,1901/2015 VISIT_S2_nbp.nc VISIT_S2_nbp_SUB.nc
	cdo selyear,1901/2015 VISIT_S2_gpp.nc VISIT_S2_gpp_SUB.nc

	## multiply with days per month
	cdo muldpm VISIT_S2_nbp_SUB.nc VISIT_S2_nbp_DPM.nc
	cdo muldpm VISIT_S2_gpp_SUB.nc VISIT_S2_gpp_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 VISIT_S2_nbp_DPM.nc VISIT_S2_nbp_SPM.nc
	cdo mulc,86400000 VISIT_S2_gpp_DPM.nc VISIT_S2_gpp_SPM.nc

	## get annual sums
	cdo yearsum VISIT_S2_nbp_SPM.nc VISIT_S2_nbp_ANN.nc
	cdo yearsum VISIT_S2_gpp_SPM.nc VISIT_S2_gpp_ANN.nc

fi

## get global totals
## NBP
cdo gridarea VISIT_S2_nbp_ANN.nc gridarea.nc
cdo mulc,1 -seltimestep,1 VISIT_S2_nbp_ANN.nc tmp.nc
cdo div tmp.nc tmp.nc ones.nc
cdo selname,nbp ones.nc mask.nc
cdo mul mask.nc gridarea.nc gridarea_masked.nc
cdo mul gridarea_masked.nc VISIT_S2_nbp_ANN.nc tmp2.nc
cdo fldsum tmp2.nc tmp3.nc
cdo mulc,1e-15 tmp3.nc VISIT_S2_nbp_GLOB.nc

## GPP
cdo mul gridarea_masked.nc VISIT_S2_gpp_ANN.nc tmp4.nc
cdo fldsum tmp4.nc tmp5.nc
cdo mulc,1e-15 tmp5.nc VISIT_S2_gpp_GLOB.nc

## detrend
cdo detrend -selyear,1982/2015 -selname,nbp VISIT_S2_nbp_GLOB.nc VISIT_S2_nbp_DETR.nc
cdo detrend -selyear,1982/2015 -selname,gpp VISIT_S2_gpp_GLOB.nc VISIT_S2_gpp_DETR.nc

## variance
cdo timvar VISIT_S2_nbp_DETR.nc VISIT_S2_nbp_VAR.nc
cdo timvar VISIT_S2_gpp_DETR.nc VISIT_S2_gpp_VAR.nc

## remove temporary files
rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc
cd ../..



# doesn't work:
# cdo fldsum -mul -mul -selname,nbp -div mulc,1 -seltimestep,1 CABLE-POP_S2_nbp_ANN.nc mulc,1 -seltimestep,1 CABLE-POP_S2_nbp_ANN.nc -gridarea CABLE-POP_S2_nbp_ANN.nc CABLE-POP_S2_nbp_ANN.nc CABLE-POP_S2_nbp_GLOB.nc


# import csv
# import os

# wdir = '/Users/benjaminstocker/data/trendy/v5/'
# filnams_s2_gpp = wdir + 'trendy_s2_filnams_gpp.csv'

# with open(filnams_s2_gpp, 'r') as csvfile:

#     csvreader = csv.reader(csvfile)

#     for row in csvreader:
#         if not row[1] in (None, ""):
#             base = row[7][0:-3]
#             modl = row[1]
#             print base
#             print modl

#             ## detrending data for each gridcell
#             os.system('cdo detrend ' + base + '.nc ' + base + '_detr.nc' )

#             ## take variance over years for each gridcell
#             os.system('cdo timvar ' + base + '_detr.nc ' + base + '_var.nc' )

#             ## take mean across year for each gridcell
#             os.system('cdo timmean ' + base + '.nc ' + base + '_mean.nc' )

#             ## divide variance by mean
#             os.system('cdo div ' + base + '_var.nc ' + base + '_mean.nc ' + base + '_relvar.nc' )

#             ## time series of global total
#             os.system('cdo fldsum ' + base + '.nc ' + base + '_globaltotal.nc' )

