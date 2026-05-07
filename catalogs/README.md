
# Monthly BMF Catalog Refresh

The BMF catalog (`catalog-bmf.qmd`) is rendered from a static manifest CSV
(`AWS-BMF.csv`) that is committed to the repo. There is **no CI automation** —
when new monthly BMF data is published to S3, run this procedure locally to
refresh the snapshot, then commit and push.

### Prerequisites (one-time)

1. Install AWS CLI v2:
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
   unzip -q awscliv2.zip && sudo ./aws/install
   ```
2. Configure your SSO profile:
   ```bash
   aws configure sso
   ```
   Use your Urban Institute SSO; choose any profile name (this guide assumes
   `thiya`). Your role must have `s3:ListBucket` on `nccsdata`.

### Refresh procedure

Run from the `nccs/` project root:

```bash
# 1. Refresh SSO credentials (they expire every 24 hours)
aws sso login --profile thiya

# 2. Export credentials into env vars (aws.s3 R package reads from env, not profile files)
eval "$(aws configure export-credentials --profile thiya --format env)"
export AWS_DEFAULT_REGION=us-east-1

# 3. Rebuild AWS-BMF.csv by listing the three BMF prefixes in s3://nccsdata
Rscript catalogs/get-aws-files.R bmf

# 4. (Optional) re-run tests
Rscript catalogs/tests/test-bmf-helpers.R
Rscript catalogs/tests/render-bmf-with-fixture.R

# 5. Re-render the catalog page
quarto render catalogs/catalog-bmf.qmd

# 6. Commit and push BOTH the source AND the rendered output
git add catalogs/AWS-BMF.csv catalogs/catalog-bmf.qmd catalogs/catalog-bmf.html catalogs/catalog-bmf_files
git commit -m "Refresh BMF catalog snapshot (YYYY-MM)"
git push
```

> **Important: CI does not render Quarto.** The GitHub Actions workflow
> (`.github/workflows/build.yml`) only runs `bundle exec jekyll build`. It
> does **not** run `quarto render`. The deployed catalog page is whatever
> `catalogs/catalog-bmf.html` is committed to the repo.
>
> This means **any change to `catalog-bmf.qmd` must be followed by
> `quarto render` locally, and BOTH files committed together.** If you
> commit the `.qmd` without re-rendering, the live site will keep showing
> the old HTML and your change will appear to have done nothing.
>
> The same applies to the other Quarto catalog pages
> (`catalog-core.qmd`, `catalog-efile-v2.qmd`, etc.) — edit `.qmd`,
> render, commit both.

### S3 layout (for reference)

`get-aws-files.R` builds `AWS-BMF.csv` from five prefixes in the public
`nccsdata` bucket:

| Source       | S3 prefix                       | Notes                                                     |
|--------------|---------------------------------|-----------------------------------------------------------|
| `master`     | `master/bmf/`                   | Master BMF, state-sliced + headline `bmf_master.csv`      |
| `geocoded`   | `geocoding/master/merged/`      | Master BMF with lat/lon                                   |
| `processed`  | `processed/bmf/YYYY_MM/`        | Transformed monthly BMF (2023-06 → present)               |
| `legacy`     | `processed/bmf-legacy/YYYY_MM/` | Harmonized legacy monthly BMF (1989-2022)                 |
| `raw_legacy` | `legacy/bmf/`                   | Raw NCCS 501CX-NONPROFIT-PX vintages                      |

Raw IRS monthly archives at `raw/bmf/{YYYY-MM}-BMF.csv` are *not* in the
manifest — the catalog page references them via URL pattern only.

Per-month quality reports are templated to
`https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/bmf_<YYYY>_<MM>_quality_report.html`
and rendered automatically by `catalogs/R/bmf_helpers.R`.

### Troubleshooting

- **`Access Denied` on `get_bucket()`** — credentials aren't in the env. Re-run
  step 2 above. Check with `env | grep AWS_`.
- **`No objects under prefix '...'` warning** — the prefix string in
  `get-aws-files.R` doesn't match what's in the bucket. Verify with
  `aws s3 ls s3://nccsdata/processed/`.
- **SSO session expired** — re-run `aws sso login --profile thiya` and
  re-export credentials (step 2). Sessions last 24 hours.

---

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
