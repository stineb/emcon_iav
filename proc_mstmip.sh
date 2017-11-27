#!/bin/bash

proc_mstmip_single (){
	##-----------------------------
	## argument 1 ($1): base file name
	## argument 2 ($2): empty or "timestep" if year axis is messed up
	##-----------------------------

	## convert to netcdf-3 because 4 didn't work for me with cdo.
	nccopy -k nc3 $1_NEE.nc4 $1_NEE.nc
	nccopy -k nc3 $1_GPP.nc4 $1_GPP.nc

	## multiply with days per month
	cdo muldpm $1_NEE.nc $1_NEE_DPM.nc
	cdo muldpm $1_GPP.nc $1_GPP_DPM.nc

	## multiply with seconds per day and convert from kg C to g C
	cdo mulc,86400000 $1_NEE_DPM.nc $1_NEE_SPM.nc
	cdo mulc,86400000 $1_GPP_DPM.nc $1_GPP_SPM.nc

	## get annual sums
	cdo yearsum $1_NEE_SPM.nc $1_NEE_ANN.nc
	cdo yearsum $1_GPP_SPM.nc $1_GPP_ANN.nc

	## detrend at each gridcell
    if [[ $2 = "timestep" ]]
    then
		cdo detrend -seltimestep,82/110 -selname,GPP $1_GPP_ANN.nc $1_GPP_DETR.nc
		cdo detrend -seltimestep,82/110 -selname,NEE $1_NEE_ANN.nc $1_NEE_DETR.nc

		# cdo detrend -seltimestep,101/110 -selname,GPP $1_GPP_ANN.nc $1_GPP_DETR20XX.nc
		# cdo detrend -seltimestep,101/110 -selname,NEE $1_NEE_ANN.nc $1_NEE_DETR20XX.nc
	else
		cdo detrend -selyear,1982/2010 -selname,GPP $1_GPP_ANN.nc $1_GPP_DETR.nc
		cdo detrend -selyear,1982/2010 -selname,NEE $1_NEE_ANN.nc $1_NEE_DETR.nc

		# cdo detrend -selyear,2001/2010 -selname,GPP $1_GPP_ANN.nc $1_GPP_DETR20XX.nc
		# cdo detrend -selyear,2001/2010 -selname,NEE $1_NEE_ANN.nc $1_NEE_DETR20XX.nc
	fi

	## get variance of annual GPP at each pixel
	cdo timvar $1_GPP_DETR.nc $1_GPP_VAR.nc
	cdo timvar $1_NEE_DETR.nc $1_NEE_VAR.nc

	# cdo timvar $1_GPP_DETR20XX.nc $1_GPP_VAR20XX.nc
	# cdo timvar $1_NEE_DETR20XX.nc $1_NEE_VAR20XX.nc

	## get mean field
    if [[ $2 = "timestep" ]]
    then
		cdo timmean -seltimestep,82/110 -selname,GPP $1_GPP_ANN.nc $1_GPP_MEAN.nc
		cdo timmean -seltimestep,82/110 -selname,NEE $1_NEE_ANN.nc $1_NEE_MEAN.nc

		# cdo timmean -seltimestep,82/110 -selname,GPP $1_GPP_ANN.nc $1_GPP_MEAN20XX.nc  		
		# cdo timmean -seltimestep,82/110 -selname,NEE $1_NEE_ANN.nc $1_NEE_MEAN20XX.nc  		
 	else
		cdo timmean -selyear,1982/2010 -selname,GPP $1_GPP_ANN.nc $1_GPP_MEAN.nc
		cdo timmean -selyear,1982/2010 -selname,NEE $1_NEE_ANN.nc $1_NEE_MEAN.nc

		# cdo timmean -selyear,2001/2010 -selname,GPP $1_GPP_ANN.nc $1_GPP_MEAN20XX.nc  		
		# cdo timmean -selyear,2001/2010 -selname,NEE $1_NEE_ANN.nc $1_NEE_MEAN20XX.nc  		
  	fi

	## get relative variance field
	cdo div $1_GPP_VAR.nc $1_GPP_MEAN.nc $1_GPP_RELVAR.nc
	cdo div $1_NEE_VAR.nc $1_NEE_MEAN.nc $1_NEE_RELVAR.nc

	# cdo div $1_GPP_VAR20XX.nc $1_GPP_MEAN20XX.nc $1_GPP_RELVAR20XX.nc
	# cdo div $1_NEE_VAR20XX.nc $1_NEE_MEAN20XX.nc $1_NEE_RELVAR20XX.nc

	## get global totals
	## NBP
	cdo gridarea $1_NEE_ANN.nc gridarea.nc
	cdo mulc,1 -seltimestep,1 $1_NEE_ANN.nc tmp.nc
	cdo div tmp.nc tmp.nc ones.nc
	cdo selname,NEE ones.nc mask.nc
	cdo mul mask.nc gridarea.nc gridarea_masked.nc
	cdo mul gridarea_masked.nc $1_NEE_ANN.nc tmp2.nc
	cdo fldsum tmp2.nc tmp3.nc
	cdo mulc,1e-15 tmp3.nc $1_NEE_GLOB.nc

	## GPP
	cdo mul gridarea_masked.nc $1_GPP_ANN.nc tmp4.nc
	cdo fldsum tmp4.nc tmp5.nc
	cdo mulc,1e-15 tmp5.nc $1_GPP_GLOB.nc

	## detrend
    if [[ $2 = "timestep" ]]
    then
		cdo detrend -seltimestep,82/110 -selname,NEE $1_NEE_GLOB.nc $1_NEE_DETR_GLOB.nc
		cdo detrend -seltimestep,82/110 -selname,GPP $1_GPP_GLOB.nc $1_GPP_DETR_GLOB.nc

		# cdo detrend -seltimestep,101/110 -selname,NEE $1_NEE_GLOB.nc $1_NEE_DETR_GLOB20XX.nc
		# cdo detrend -seltimestep,101/110 -selname,GPP $1_GPP_GLOB.nc $1_GPP_DETR_GLOB20XX.nc
	else 
		cdo detrend -selyear,1982/2010 -selname,NEE $1_NEE_GLOB.nc $1_NEE_DETR_GLOB.nc
		cdo detrend -selyear,1982/2010 -selname,GPP $1_GPP_GLOB.nc $1_GPP_DETR_GLOB.nc

		# cdo detrend -selyear,2001/2010 -selname,NEE $1_NEE_GLOB.nc $1_NEE_DETR_GLOB20XX.nc
		# cdo detrend -selyear,2001/2010 -selname,GPP $1_GPP_GLOB.nc $1_GPP_DETR_GLOB20XX.nc
	fi

	## variance in global total
	cdo timvar $1_NEE_DETR_GLOB.nc $1_NEE_VAR_GLOB.nc
	cdo timvar $1_GPP_DETR_GLOB.nc $1_GPP_VAR_GLOB.nc

	# cdo timvar $1_NEE_DETR_GLOB20XX.nc $1_NEE_VAR_GLOB20XX.nc
	# cdo timvar $1_GPP_DETR_GLOB20XX.nc $1_GPP_VAR_GLOB20XX.nc

	## remove temporary files
	rm tmp.nc tmp2.nc tmp3.nc tmp4.nc tmp5.nc gridarea.nc gridarea_masked.nc *SUB.nc *DPM.nc *SPM.nc mask.nc ones.nc

	return 0
}

here=`pwd`
myhome=~

##----------------------------------------------------
## Define simulation:
##----------------------------------------------------
sim="SG3"

# ##----------------------------------------------------
# # Biome-BGC:
# # 	NEE: Net Ecosystem Exchange = HeteroResp+AutoResp+Fire_flux-GPP; land use change and product emissions are not simulated.
# ##----------------------------------------------------
# cd $myhome/data/mstmip/BIOME-BGC/${sim}

# if [[ ! -e BIOME-BGC_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e BIOME-BGC_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
# then
# 	echo "proc_mstmip_single BIOME-BGC_${sim}_Monthly"
# fi

# cd $here


# ##----------------------------------------------------
# ## CLASS-CTEM-N:
# ## 	NEE: Net Ecosystem Exchange = -Net Ecosystem Productivity; disturbance emissions (fire flux and land use change emissions) and product emissions are not simulated.
# ##----------------------------------------------------
# cd $myhome/data/mstmip/CLASS-CTEM-N/${sim}

# if [[ ! -e CLASS-CTEM-N_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e CLASS-CTEM-N_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
# then
# 	proc_mstmip_single CLASS-CTEM-N_${sim}_Monthly
# fi

# cd $here


##----------------------------------------------------
## CLM4:
## 	Net Ecosystem Exchange = HeteroResp+AutoResp+Disturbance_Emissions_(CO2)+Product_Emissions_(CO2)-GPP where Disturbance_Emissions_(CO2) includes fire flux and land use change emissions. Net Ecosystem Exchange also includes hrv_xsmrpool flux (maintenance respiration deficit).
##----------------------------------------------------
cd $myhome/data/mstmip/CLM4/${sim}

if [[ ! -e CLM4_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e CLM4_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single CLM4_${sim}_Monthly
fi

cd $here


##----------------------------------------------------
## CLM4VIC:	
## 	Net Ecosystem Exchange = HeteroResp+AutoResp+Disturbance_Emissions_(CO2)+Product_Emissions_(CO2)-GPP where Disturbance_Emissions_(CO2) includes fire flux and land use change emissions. Net Ecosystem Exchange also includes hrv_xsmrpool flux (maintenance respiration deficit).
##----------------------------------------------------
cd $myhome/data/mstmip/CLM4VIC/${sim}

if [[ ! -e CLM4VIC_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e CLM4VIC_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single CLM4VIC_${sim}_Monthly
fi

cd $here


##----------------------------------------------------
## DLEM:
## 	NEE: The Net Ecosystem Exchange reported does not incorporate all reported simulated subcomponents. It is calculated using mass balance: Net Ecosystem Exchange = HeteroResp+AutoResp-GPP+Proddec+Lulc where Proddec is Product_Emissions_(CO2) and Lulc is annual land use change emissions. Lulc is first apportioned equally across all 12 months. DLEM does not simulate fire flux.	
##----------------------------------------------------
cd $myhome/data/mstmip/DLEM/${sim}

if [[ ! -e DLEM_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e DLEM_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single DLEM_${sim}_Monthly
fi

cd $here


##----------------------------------------------------
## GTEC:
## 	NEE: Net Ecosystem Exchange = HeteroResp+AutoResp+Product_Emissions_(CO2)-GPP; fire flux and land use change emissions are not simulated.
##----------------------------------------------------
cd $myhome/data/mstmip/GTEC/${sim}

if [[ ! -e GTEC_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e GTEC_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single GTEC_${sim}_Monthly
fi

cd $here


##----------------------------------------------------
## LPJ-wsl:
## 	Net Ecosystem Exchange = HeteroResp+AutoResp+Disturbance_Emissions_(CO2)-GPP; where Disturbance_Emissions_(CO2) includes both fire flux and land use change emissions. Product emissions are not simulated. Net Ecosystem Exchange also includes grazing emissions.
##----------------------------------------------------
cd $myhome/data/mstmip/LPJ-WSL/${sim}

if [[ ! -e LPJ-wsl_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e LPJ-wsl_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single LPJ-wsl_${sim}_Monthly
fi

cd $here

##----------------------------------------------------
## ORCHIDEE-LSCE:
## 	Net Ecosystem Exchange = HeteroResp+AutoResp+Disturbance_Emissions_(CO2)+Product_Emissions_(CO2)-GPP; where Disturbance_Emissions_(CO2) includes only land use change emissions. Fire flux is not simulated.		
##----------------------------------------------------
cd $myhome/data/mstmip/ORCHIDEE-LSCE/${sim}

if [[ ! -e ORCHIDEE-LSCE_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e ORCHIDEE-LSCE_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single ORCHIDEE-LSCE_${sim}_Monthly
fi

cd $here

##----------------------------------------------------
## SiB3:
## 	Net Ecosystem Exchange = -Net Ecosystem Productivity; disturbance emissions (fire flux and land use change emissions) and product emissions are not simulated.	
##----------------------------------------------------
cd $myhome/data/mstmip/SiB3/${sim}

if [[ ! -e SiB3_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e SiB3_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single SiB3_${sim}_Monthly
fi

cd $here

##----------------------------------------------------
## SiBCASA: 
## 	Net Ecosystem Exchange = HeteroResp+AutoResp+Disturbance_Emissions_(CO2)-GPP; where Disturbance_Emissions_(CO2) includes only land use change emissions. Fire flux and product emissions are not simulated.
##----------------------------------------------------
cd $myhome/data/mstmip/SiBCASA/${sim}

if [[ ! -e SiBCASA_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e SiBCASA_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single SiBCASA_${sim}_Monthly
fi

cd $here

##----------------------------------------------------
## TEM:
## 	Net Ecosystem Exchange = HeteroResp+AutoResp+Disturbance_Emissions_(CO2)+Product_Emissions_(CO2)-GPP where Disturbance_Emissions_(CO2) includes fire flux and land use change emissions.	
##----------------------------------------------------
cd $myhome/data/mstmip/TEM6/${sim}

if [[ ! -e TEM6_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e TEM6_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single TEM6_${sim}_Monthly
fi

cd $here

##----------------------------------------------------
## VEGAS2.1:
## 	Net Ecosystem Exchange = HeteroResp+AutoResp+Disturbance_Emissions_(CO2)+Product_Emissions_(CO2)-GPP where Disturbance_Emissions_(CO2) includes fire flux and land use change emissions.	
##----------------------------------------------------
cd $myhome/data/mstmip/VEGAS2.1/${sim}

if [[ ! -e VEGAS2.1_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e VEGAS2.1_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single VEGAS2.1_${sim}_Monthly
fi

cd $here

##----------------------------------------------------
## VISIT:
## 	Net Ecosystem Exchange = -Net Ecosystem Productivity; disturbance emissions (fire flux and land use change emissions) and product emissions are not simulated.	
##----------------------------------------------------
cd $myhome/data/mstmip/VISIT/${sim}

if [[ ! -e VISIT_${sim}_Monthly_GPP_DETR_GLOBXXX.nc || ! -e VISIT_${sim}_Monthly_NEE_DETR_GLOBXXX.nc ]]
then
	proc_mstmip_single VISIT_${sim}_Monthly
fi

cd $here





