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
primaryCtaUrl: "https://lecy.github.io/nonprofitdataproject/download"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nonprofit-open-data-collective.github.io/data-report-templates/data-dictionary-layout-v7.html"
  - text: "R Package"
    href: "https://github.com/Nonprofit-Open-Data-Collective/peopleparser/blob/master/README.md"
  - text: "Data History"
    href: "https://pkgdown.r-lib.org/news/index.html" 
  - text: "Research Guide"
    href: "https://nonprofit-open-data-collective.github.io/titleclassifier/data-raw/DATA-PREP.html"
  - text: "Validation Report"
    href: "https://nonprofit-open-data-collective.github.io/data-report-templates/test-layout.html"
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

```r
library( remotes )
install_github( "UrbanInstitute/nccs-data-package/nccsdata" )

dt <-
  nccsdata::ntee_preview(
    ntee.group = c( "ART", "EDU" ),
    ntee.code = c( "Axx", "B" ),
    ntee.orgtype = "all" )
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






