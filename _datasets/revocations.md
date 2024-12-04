---
title: Revocations Database
date: 2023-05-27
description: Database of all nonprofit entities that have had their tax exempt status revoked
categories:
  - revocations
featured: false
primaryCtaUrl: "https://urbaninstitute.github.io/nccs/catalogs/catalog-revocations.html"
primaryCtaCaption:
primaryLinks:
  - text: "IRS Revocations Site"
    href: "https://www.irs.gov/charities-non-profits/tax-exempt-organization-search"
    icon: article
author:
- id: jlecy
citation: 
  author: "Lecy, J."
  container-title: "IRS Revocations Database"
---


## Overview

Most tax-exempt organizations other than churches and certain church-related organizations are required to file an annual information return or notice with the IRS.

Organizations that do not file for three consecutive years automatically lose their tax-exempt status. An automatic revocation is effective on the original filing due date of the third annual return or notice. (Section 6033(j) of the Internal Revenue Code).


## Use

You will find a list of archived files through the download button at the top left of this page. You can download CSV files directly through that page. 

Alternatively, you can read files from the data server directly into R. The code below will also ensure you have the most recent file available. 

```r
# install.packages( "curl" )
# install.packages( "readr" )

# ------------------

library( curl )
library( readr )

BASE      <- "https://nccsdata.s3.us-east-1.amazonaws.com/raw/revocations/"
YYYYMM    <- format( Sys.time(), "%Y-%m-" )              # "2024-12-"  current month
FILENAME  <- paste0( YYYYMM, "REVOCATIONS-ORGS.csv" )    # "2024-12-REVOCATIONS-ORGS.csv"
URL       <- paste0( BASE, FILENAME )                    # "https://.../2024-12-REVOCATIONS-ORGS.csv"

# READ DIRECTLY IF YOUR
# INTERNET SPEED IS HIGH
d <- read.csv( URL )

# OR TRY A FASTER VERSION 
d <- readr::read_csv( URL )

# DOWNLOAD FILE FIRST (BETTER FOR SLOW INTERNET)  
curl::curl_download( url=URL, destfile=FILENAME, mode="wb" )
d <- readr::read_csv( FILENAME )

d |> head() |> knitr::kable()  # preview the data
```


|ein       |legal_name                                       |doing_business_as_name |
|:---------|:------------------------------------------------|:----------------------|
|010349609 |ANDROSCOGGIN VALLEY SQUARE AND COMPASS CORP      |NA                     |
|010512664 |NEW YEARS BY THE BAY                             |NA                     |
|010975114 |FIRST NIGHT FLATHEAD                             |NA                     |
|030417311 |BLOOMINGBURG FIRE COMPANY INC                    |NA                     |
|036006155 |ROYAL & SELECT MASTERS OF VERMONT                |18 SPRINGFIELD COUNCIL |
|041185560 |BENEVOLENT & PROTECTIVE ORDER OF ELKS OF THE USA |1306 CLINTON           |


|organization_address |city         |state |zip_code   |country |
|:--------------------|:------------|:-----|:----------|:-------|
|PO BOX 622           |AUBURN       |ME    |04212-0622 |US      |
|PO BOX 103           |BELFAST      |ME    |04915-0103 |US      |
|PO BOX 2896          |KALISPELL    |MT    |59903-2896 |US      |
|PO BOX 1039          |BLOOMINGBURG |NY    |12721-1039 |US      |
|71 MAIN ST           |SPRINGFIELD  |VT    |05156-2904 |US      |
|128 SCHOOL ST        |CLINTON      |MA    |01510-2915 |US      |


|exemption_type |revocation_date |revocation_posting_date |exemption_reinstatement_date |
|:--------------|:---------------|:-----------------------|:----------------------------|
|07             |15-AUG-2024     |11-NOV-2024             |NA                           |
|03             |15-AUG-2024     |11-NOV-2024             |NA                           |
|03             |15-AUG-2024     |11-NOV-2024             |NA                           |
|04             |15-AUG-2024     |11-NOV-2024             |NA                           |
|10             |15-AUG-2024     |11-NOV-2024             |NA                           |
|08             |15-AUG-2024     |11-NOV-2024             |NA                           |


