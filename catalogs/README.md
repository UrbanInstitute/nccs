
# STEP 01 - [GENERATE S3 MANIFESTS](https://github.com/UrbanInstitute/nccs/blob/main/catalogs/get-aws-files.R)

[AWS-NCCS-EFILE2.csv](https://github.com/UrbanInstitute/nccs/blob/main/catalogs/AWS-NCCS-EFILE2.csv)

```r
# install.packages( "aws.s3" )
# install.packages( "aws.signature", repos = c(cloudyr = "http://cloudyr.github.io/drat", getOption("repos")))
library( aws.s3 )
library( aws.signature )
library( data.table )
library( lubridate )

# CREATE TOKENS: 
# in windows cmd / powershell:   aws sts get-session-token

mytoken <- "xxx"

Sys.setenv("AWS_ACCESS_KEY_ID" = "xxxxxx",
           "AWS_SECRET_ACCESS_KEY" = "xxxxxxx",
           "AWS_DEFAULT_REGION" = "us-east-1",
           "AWS_SESSION_TOKEN" = mytoken )

locate_credentials()

# USE bucketlist() TO RETRIEVE FILE NAMES
#  nccs-data-archive
#  nccs-data-archive-logs
#  nccs-efile
#  nccsdata

dir.create("AWS")
setwd("AWS")

######
######  NCCSDATA
######

buck.list <- 
  get_bucket( bucket = 'nccsdata' )

dt       <- rbindlist( buck.list )
dt       <- as.data.frame( dt )
dt$Owner <- as.character( dt$Owner )

# remove duplicate rows - drop Owner field

keep <- 
  c( "Key", "LastModified", "ETag", "Size", 
     "StorageClass", "Bucket" )

dt <- dt[ keep ]
dt <- unique( dt )

write.csv( dt, "AWS-NCCSDATA.csv", row.names=F )

######
######  NCCS-EFILE
######

buck.list <- 
  get_bucket( 
    bucket = 'nccs-efile', 
    prefix="parsed", 
    max = Inf  )

dt       <- rbindlist( buck.list )
dt       <- as.data.frame(dt)
dt$Owner <- as.character( dt$Owner )

# remove duplicate rows - drop Owner field

keep <- 
  c( "Key", "LastModified", "ETag", "Size", 
     "StorageClass", "Bucket" )

dt <- dt[ keep ]
dt <- unique( dt ) 

write.csv( dt, "AWS-NCCS-EFILE.csv", row.names=F )
```

# STEP 02 - [CREATE PARSING FUNCTIONS FOR EACH DATA SERIES](https://github.com/UrbanInstitute/nccs/blob/main/catalogs/build-catalog-functions.R)

```r
get_core_paths <- function( paths, tscope="NONPROFIT", fscope="PZ" ) {
  expr <- paste0( "CORE-[0-9]{4}-", tscope )
  matches <- grep( expr, paths, value=T )
  matches <- grep( paste0( "-", fscope, "\\b"), matches, value=T )
  return( matches )
}

get_bmf_paths <- function( paths ) {
  expr <- "BMF-.*-PX"
  matches <- grep( expr, paths, value=T )
  return( matches )
}

make_urls <- function( paths ) {
  base <- "https://nccsdata.s3.us-east-1.amazonaws.com/"
  urls <- paste0( base, paths )
  return( urls )
}

get_core_year <- function( paths ) {
  yyyy <- stringr::str_extract( paths, "-[0-9]{4}-" )
  yyyy <- gsub( "-", "", yyyy )
  return( yyyy )
}

get_core_tscope <- function( paths ) {
  expr1 <- "-501C.-[A-Z]{9}-" 
  expr2 <- "-[A-Z]{9}-SCOPE-501C.-"
  tscope1 <- stringr::str_extract( paths, expr1 )
  tscope2 <- stringr::str_extract( paths, expr2 )
  tscope  <- na.omit( c( tscope1, tscope2 ) )
  tscope <- gsub( "^-|-$", "", tscope )
  return( as.character(tscope) )
}

get_core_fscope <- function( paths ) {
  expr <- "-P[CXZ]{1}\\b" 
  # expr2 <- "-SCOPE-P.\\b"
  # fscope1 <- stringr::str_extract( paths, expr1 )
  fscope <- stringr::str_extract( paths, expr )
  # fscope  <- na.omit( c( fscope1, tscope2 ) )
  fscope <- gsub( "^-|-$", "", fscope )
  return( as.character(fscope) )
}

make_buttons <- function( urls ) {
  buttons <- 
    paste0( 
      "<a href=",
      urls,
      " class='button'> DOWNLOAD </a>" )
  return( buttons ) 
}
```



# STEP 03 - [CREATE A CATALOG TEMPLATE QMD](https://github.com/UrbanInstitute/nccs/blob/main/catalogs/catalog-core.qmd)


```r
library( dplyr )
library( knitr )
library( stringr )

GH.RAW <- "https://github.com/lecy/nccs/blob/main/catalogs/"
d <- read.csv( paste0( GH.RAW, "AWS-NCCSDATA.csv" ) )
source( paste0( GH.RAW, "build-catalog-functions.R" ) )
```



## CORE CATALOG


#### CHARITIES SCOPE PZ

```r
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
```

#### CHARITIES SCOPE PC

```r
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
```


#### NONPROFIT SCOPE PZ

```r
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
```


#### NONPROFIT SCOPE PC

```r
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
```


#### FOUNDATIONS SCOPE PF

```r
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

```


```
.button3 {
  background-color: #0a4c6a;
  color: white;
  border: 2px solid #0a4c6a;   
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 14px;
  border-radius: 4px;
  width: 60px;
}
```
