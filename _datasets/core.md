---
title: NCCS Core Series
date: 2023-05-27
description: A comprehensive panel of nonprofit organizations that file IRS form 990. 
categories:
  - 990
  - financial-trends
  - nonprofits
featured: true
featuredOrder: 1
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nonprofit-open-data-collective.github.io/data-report-templates/data-dictionary-layout-v7.html"
  - text: "R Package"
    href: "https://urbaninstitute.github.io/nccsdata/"
  - text: "Data History"
    href: "https://urbaninstitute.github.io/nccsdata/news/index.html"  
  - text: "Research Guide"
    href: "https://nonprofit-open-data-collective.github.io/titleclassifier/data-raw/DATA-PREP.html"
author:
- id: jdl
- id: tp
- name: "Edmund Choi"
  bio: "Testing bio and author overrides"
citation: 
  author: "Choi. Y & Lee, Y."
  container-title: "Ednel: A large – scale hierarchical dataset in education"
  doi: 10.5555/12345678
---

## Use

Data can be downloaded via the data catalog or the **nccsdata** R package. Statistical packages have the advantage of documentation and reproducibility. 

```r
###  SELECT DATA BY: 
###    dsname = nccs data series
###    time = years of data desired
###    ntee = subsectors to include
###    desired geography: 
###    geo.state, geo.city, geo.county

devtools::install_github("UrbanInstitute/nccsdata")
library(nccsdata)

dat <-
  get_data(  dsname = "core",
             time   = 2005     )

dat <-
  get_data(  dsname = "core",
             time   = 2005,
             ntee   = "ART"   )

###
###  MULTIPLE GEOGRAPHIES ARE SUPPORTED 
###

dat <-
  get_data(  dsname = "core",
             time   = 2005,
             ntee   = "ART",   
             geo.state = "CA"   )

dat <-
  get_data(  dsname = "core",
             time   = 2005,
             geo.city = "san francisco" )

dat <-
  get_data(  dsname = "core",
             time   = 2005,
             geo.county = "autauga"  )
```


## Overview

The Core Data Series is a vital resource for researchers, policymakers, and anyone interested in understanding the nonprofit sector in the United States. The NCCS, a project of the Urban Institute, collects, compiles, and disseminates data on nonprofits and charitable organizations. The Core Data Series, in particular, is a comprehensive dataset that provides essential information about these organizations. 

Data Collection and Sources: The NCCS Core Data Series collects data from various sources, including the Internal Revenue Service (IRS) Form 990 filings, which nonprofits are required to submit. This data includes financial information, governance details, and other organizational characteristics.

Scope: The dataset covers a wide range of nonprofit organizations, including charities, foundations, religious organizations, educational institutions, and more. It encompasses organizations of various sizes, missions, and geographic locations across the United States.

Key Information: The Core Data Series provides detailed information on nonprofit organizations, including:

* Financial Data: Revenue, expenses, assets, and liabilities, allowing for financial analysis and benchmarking.
* Programs and Activities: Descriptions of the organization's activities, programs, and mission statements.
* Geographic Information: Location and service areas of nonprofits.
* Time Series Data: Researchers can access historical data, which is crucial for tracking trends and changes in the nonprofit sector over time.

Customized Reports: Users can generate custom reports and analyses based on their research interests and needs, allowing for in-depth exploration of nonprofit data.

Research and Policy Insights: The NCCS Core Data Series is widely used by researchers, policymakers, and nonprofits themselves to gain insights into the sector. It can inform studies on topics such as nonprofit financial health, sector trends, and the impact of policy changes on charitable organizations.

Accessibility: The data is made available to the public through the NCCS website and can be accessed by researchers, analysts, and organizations interested in nonprofit-related research.

Data Quality: The NCCS takes measures to ensure data quality and accuracy, making it a reliable resource for research and analysis.

## Organization 






