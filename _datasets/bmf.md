---
title: Business Master File (BMF)
date: 2024-06-01
description: All active organizations that have been granted nonprofit status by the IRS.
categories:
  - BMF
  - sample-framework
  - metadata
featured: true
featuredOrder: 2
primaryCtaUrl: "https://nccsdata.s3.amazonaws.com/harmonized/bmf/unified/BMF_UNIFIED_V1.1.csv"
primaryCtaCaption: 1.3 GB
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nccsdata.s3.amazonaws.com/harmonized/harmonized_data_dictionary.xlsx"
    icon: article
  - text: "BMF By State"
    href: "../../catalogs/catalog-bmf.html"
    icon: download
citation: 
  author: "Jesse Lecy"
  citationDate: "2024"
  container-title: "NCCS Unified BMF"
  doi:
---

## Unified BMF

The IRS releases a Business Master File every month which serves as the most recent and comprehensive record of tax exempt organizations in the United States. However, organizations that are no longer active are removed from each new BMF release.

To facilitate the creation of consistent time-series datasets, NCCS has created a Unified BMF which aggregates information from every historic BMF dataset into a single file. The Unified BMF contains one row for each organization that was granted tax-exempt status and appeared in any BMF file from 1989 to present day. There are ~3.8 million nonprofits present in the file, ~1.8 million of which are currently active. 

The Unified BMF has some additional upgrades:

* The most recent address available for each organization has been geocoded and matched to a Census Block.
* The BLOCK FIPS variable can be decomposed into a TRACT, COUNTY, or STATE FIPS to make it easier to [merge Census Data](https://urbaninstitute.github.io/nccs/catalogs/catalog-census_crosswalk.html).
* [NCCS Census Crosswalk](https://nccs.urban.org/nccs/datasets/census/) files make it easy to aggregate data to 14 different geographic levels (metros, regions, urban/rural areas, etc.).
* A Metro FIPS code that uses [CBSA metropolitan and micropolitan definitions](https://carolinatracker.unc.edu/stories/2020/10/28/cbsa_geography/) has been added, replacing the previous PMSA designations.
* The BMF includes an indicator for the first and last years the organization appears in the NCCS Core data series, making it easier to build sampling frameworks using information about availability data for each organization. 

The team is currently developing a research guide to accompany this BMF. While that effort is underway, we are releasing a beta version of the Unified BMF together with a rudimentary data dictionary. Legacy single-year BMF files can still be accessed as well. 

{% include components/button.html
  text = "Unified BMF"
  href = "https://nccsdata.s3.amazonaws.com/harmonized/bmf/unified/BMF_UNIFIED_V1.1.csv"
  style = "primary"
%}

<br>

{% include components/button.html
  text = "Legacy BMF Files"
  href = "https://nccs.urban.org/nccs/catalogs/catalog-bmf.html"
  style = "primary"
%}

## Raw IRS BMF Files 

Starting in June, 2023, we began archiving monthly snapshots of IRS BMF files released on their [Exempt Organizations Business Master File Extract (EO BMF)](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf) page. 

Note that it will use a separate [Data Dictionary](https://www.irs.gov/pub/irs-soi/eo-info.pdf) and it will not include all of the variables in the NCCS BMF files. For the typical user these will not be as useful, but we include them here for those that need to replicate a workflow built using raw IRS files from a specific point a time. 


```r
# install.packages( "curl" )
# install.packages( "data.table" )
# install.packages( "readr" )

library( curl )
library( data.table )
library( readr )

# ------------------

base     <- "https://nccsdata.s3.us-east-1.amazonaws.com/raw/bmf/"
YYYYMM   <- format( Sys.time(), "%Y-%m-" )  # "2024-12-"  current month
filename <- paste0( YYYYMM, "BMF.csv" )     # "2024-12-BMF.csv"
URL      <- paste0( base, filename )        # "https://.../2024-12-BMF.csv"
 
# ------------------ 

dir.create("bmf")
setwd("bmf")

# SLIGHTLY FASTER DOWNLOAD FUNCTION
curl::curl_download( url=URL, destfile=filename, mode="wb" )
bmf <- read.csv( filename )

# ------------------

# DEFAULT DOWNLOAD FUNCTION 
download.file( url=URL, destfile=filename, method="curl" )
bmf <- read.csv( filename )

# ------------------

# FASTER READ CSV OPTIONS 
bmf <- data.table::fread( filename )
bmf <- readr::read_csv( filename )

# ------------------ 

# ARCHIVED VERSIONS FROM JUNE 2023 ONWARD:
filename <- "2023-06-BMF.csv"
URL      <- paste0( base, filename ) 
curl::curl_download( url=URL, destfile=filename, mode="wb" )
bmf <- read.csv( filename )
```

<br>


## Version Control

| Version | Release | Notes |
| :---: | :---: | :---: |
| 0.0 | June 21 2024 | Beta Version |
| 1.0 | July 1st 2024 | Unified BMF |
| 1.1 | Marc 4th 2024 | Fixed EIN2 for consistent formatting |
| 1.1 | Marc 4th 2024 | State-level BMFs |


Users are encouraged to submit any questions and comments regarding this data set on our [contact page](https://nccs.urban.org/nccs/contact/).


## BMF Overview

The IRS 990 Business Master File, often referred to as the "BMF," is a database maintained by the Internal Revenue Service (IRS). It contains information about tax-exempt organizations and other entities that are required to file various forms of the IRS Form 990 series. These organizations include:

1. All 501(c)(3) charitable organizations, foundations, religious entities.
2. Social welfare organizations, civic leagues, and associations with status 501c4. 
3. Business leagues and associations: Such as chambers of commerce, trade associations, and other organizations eligible for tax-exempt status under section 501(c)(6).
4. Social clubs: Organizations that meet the criteria for tax-exempt status under section 501(c)(7) of the Internal Revenue Code.
5. Political organizations including entities that are tax-exempt under section 527, which includes political action committees (PACs).

The IRS 990 Business Master File contains key information about these organizations, including their legal names, addresses, EINs (Employer Identification Numbers), filing statuses, and the forms they have filed. This database helps the IRS and the public track and monitor the activities of tax-exempt organizations and ensures that they comply with the tax laws and regulations applicable to their specific tax-exempt status.

The BMF is the defacto sampling framework for many studies involving nonprofits as it contains the universe of all organizations that have been granted recognized tax exempt status by the IRS, remain active, and have filed required IRS 990 forms to remain in compliance with requirements about disclosure of activities and governance. The BMF does NOT include, however: 

* Organizations that are legal organizations incorporated and operating as nonprofits at the state level but have opted to not apply for formal tax-exempt status from the IRS.
* Some special categories of nonprofits such as churches and religious groups that are not required to seek formal recognition to exercise their tax-exempt status.
* Informal civic groups or social movements that are unincorporated, including organizations that are allowed to exercise nonprofit status through a fiscal sponsorship program under parent nonprofit.
* Some exceptional cases like 501(c)(4) organizations that opt to self-declare their intent to operate using Form 8976 instead of the typical application process with the IRS. They must file 990's to remain compliant, but since the IRS never formally rules on their status they do not appear in the BMF. 

Researchers, government agencies, journalists, and the general public often use the IRS 990 Business Master File to access information about nonprofit organizations, assess their financial health, and evaluate their compliance with tax regulations. The data in this file can provide valuable insights into the operations and finances of these entities. It's worth noting that while certain information from Form 990 filings is publicly available and can be accessed through the IRS website or other sources, sensitive information like donor names and addresses is typically redacted to protect privacy.
