calc_sd_nbp <- function( sd_gpp, f_ra, tau, sd_closs, do.plot=FALSE ){

  ## Number of time steps
  ntsteps <- 10000

  ## Define GPP with interannual variability, drawn from normal distribution
  gpp_vec <- rnorm( mean = 130, sd = sd_gpp, n = ntsteps )

  ## Initialise C stock
  c_stock <- 0

  ## Initialise net C balance
  nbp_vec <- rep( NA, ntsteps )

  ## Initialise C stock output variable
  out_c_stock <- rep( NA, ntsteps )

  for (it in seq(ntsteps)){

    out_c_stock[it] <- c_stock

    c_loss <- 1/tau * c_stock + (1-f_ra) * gpp_vec[it]

    ## add noise to c_loss (~disturbance)
    c_loss <- rnorm( mean = c_loss, sd = sd_closs, n = 1 ) 

    c_gain <- gpp_vec[it]
    nbp_vec[it] <- c_gain - c_loss

    ## update stock
    c_stock <- c_stock + c_gain - c_loss

  }

  ## Evaluate standard deviation in NBP (take only last 1000 years)
  sd_nbp <- sd( tail( nbp_vec, n=1000 ), na.rm = TRUE )

  if (do.plot){
    ## Plot time series of c_stock
    plot( 1:ntsteps, out_c_stock, type="l" )
  }

  return( sd_nbp )
}

## Fraction of GPP used for biomass production (ration of NPP:GPP)
f_ra <- 0.8

## Turnover time of C in biomass
tau <- 30

## Standard deviation of respiration/disturbance (C loss), in PgC
sd_closs <- 10

sd_gpp_vec <- seq( 1, 10, 0.1 )
sd_nbp_vec <- sapply( sd_gpp_vec, function(x) calc_sd_nbp( x, f_ra, tau, sd_closs=sd_closs, x==10 ) )

plot( sd_gpp_vec, sd_nbp_vec, pch=16 )


## => The slope of sd_nbp_vec vs. sd_gpp_vec is equal to f_ra. It's therefore a measure for the fraction of GPP that remains within the system???