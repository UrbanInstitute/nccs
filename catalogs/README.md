library( dplyr )
library( knitr )
library( stringr )


d <- read.csv( "AWS-NCCSDATA.csv" )

source( "build-catalog-functions.R" )


## CORE CATALOG


#### CHARITIES SCOPE PZ

paths <- get_core_paths( paths=d$Key, tscope="CHARITIES", fscope="PZ" )
urls  <- make_urls( paths )
make_buttons( urls )


BUTTONS <- make_buttons( urls )
TSCOPE  <- get_core_tscope( paths )
FSCOPE  <- get_core_fscope( paths )
YEAR    <- get_core_year( paths )

catalog <- 
  data.frame( 
    BUTTONS, 
    NP_TYPE=TSCOPE, 
    FORM_SCOPE=FSCOPE, 
    YEAR=YEAR )

knitr::kable( catalog )


#### CHARITIES SCOPE PC

paths <- get_core_paths( paths=d$Key, tscope="CHARITIES", fscope="PZ" )
urls  <- make_urls( paths )
make_buttons( urls )


BUTTONS <- make_buttons( urls )
TSCOPE  <- get_core_tscope( paths )
FSCOPE  <- get_core_fscope( paths )
YEAR    <- get_core_year( paths )

catalog <- 
  data.frame( 
    BUTTONS, 
    NP_TYPE=TSCOPE, 
    FORM_SCOPE=FSCOPE, 
    YEAR=YEAR )

knitr::kable( catalog )


#### NONPROFIT SCOPE PZ

paths <- get_core_paths( paths=d$Key, tscope="NONPROFIT", fscope="PZ" )
urls  <- make_urls( paths )
make_buttons( urls )


BUTTONS <- make_buttons( urls )
TSCOPE  <- get_core_tscope( paths )
FSCOPE  <- get_core_fscope( paths )
YEAR    <- get_core_year( paths )

catalog <- 
  data.frame( 
    BUTTONS, 
    NP_TYPE=TSCOPE, 
    FORM_SCOPE=FSCOPE, 
    YEAR=YEAR )

knitr::kable( catalog )


#### NONPROFIT SCOPE PC

paths <- get_core_paths( paths=d$Key, tscope="NONPROFIT", fscope="PC" )
urls  <- make_urls( paths )
make_buttons( urls )


BUTTONS <- make_buttons( urls )
TSCOPE  <- get_core_tscope( paths )
FSCOPE  <- get_core_fscope( paths )
YEAR    <- get_core_year( paths )

catalog <- 
  data.frame( 
    BUTTONS, 
    NP_TYPE=TSCOPE, 
    FORM_SCOPE=FSCOPE, 
    YEAR=YEAR )

knitr::kable( catalog )


#### FOUNDATIONS SCOPE PF

paths <- get_core_paths( paths=d$Key, tscope="PRIVFOUND", fscope="PF" )
urls  <- make_urls( paths )
make_buttons( urls )


BUTTONS <- make_buttons( urls )
TSCOPE  <- get_core_tscope( paths )
FSCOPE  <- get_core_fscope( paths )
YEAR    <- get_core_year( paths )

catalog <- 
  data.frame( 
    BUTTONS, 
    NP_TYPE=TSCOPE, 
    FORM_SCOPE=FSCOPE, 
    YEAR=YEAR )

knitr::kable( catalog )