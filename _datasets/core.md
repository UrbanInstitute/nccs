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
- id: jlecy
citation: 
  author: "Jesse Lecy"
  citationDate: "2023"
  container-title: "What's New with NCCS Data?"
  doi: 10.5555/xxxxxxxxxxx
---

## Use

Data can be downloaded via the [**data catalog**](https://lecy.github.io/nccs/catalogs/catalog-core.html) page or the [**nccsdata R package**](https://urbaninstitute.github.io/nccsdata/). Statistical packages have the advantage of process documentation and reproducibility. Data acquisition steps with the package might look like one of the following queries: 

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

Learn more from the data story titled "Introducing the nccsdata Package" or the [package documentation](https://urbaninstitute.github.io/nccsdata/reference/index.html). 

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

## Organization of the Data

All 990 filers are split into five groups using combinations of two variables: organizational type scope or **tscope** (501c3 public charities vs 501c3 private foundations vs all other 501c type nonprofit organizations), and form filing scope or **fscope** that describes which types of filers are included in the dataset. 

![image](https://github.com/lecy/nccs/assets/1209099/8a2d94ca-346a-4679-b30e-f3328a7d0df9)

Private foundations are the simple case. They are always 501c3 charities and they can only ever file Form 990-PF. Unlike other nonprofits, small private foundations do not have the option of filing the 990-N ePostcard. They are required to file a full 990-PF to stay in compliance and not risk losing their tax exempt status. 

The rest of the nonprofits are a little trickier. The world gets divided into 501c3 public charities, which are distinct in that all donations made to charities are tax deductible. Datasets that contain 501c3 organizations are labeled 501C3-SCOPE-CHARITIES. The rest of the organizations - those with tax exept types 501c1 to 501c92 excluding the 501c3 charities category - are labeled 501CE-SCOPE-NONPROFIT (501cE stands for "everything other than 501c3"). 

The Core Data Series contains two types of form scope: all full 990 filers (fscope=**PC**), and the more inclusive 990 + 990EZ filers (fscope=**PZ**). 

![image](https://github.com/lecy/nccs/assets/1209099/cf809446-da58-4867-9870-b0035a942847)
 
The data is thus divided between five files that have the following naming conventions: 

![image](https://github.com/lecy/nccs/assets/1209099/f25e1bc8-ff5e-4188-8125-956fd8f26ac9)

The datasets with form scope of PZ will contain the full set of 990 and 990-EZ tax filers for a given year, but the trade-off is that 990-EZ filers have a much smaller form and thus fewer variables. Datasets with PZ scope represent a more extensive population and a more limited selection of fields. Datasets with form scope of PC will contain the smaller subset of full 990 form filers but contain a larger numer of variables. The PZ and PF versions of the data series are available from 1989-2022. The PC version is a more recent edition that is only available from 2012-2022. 

See the [Data Guide](https://nccs-data.urban.org/NCCS-data-guide.pdf) for more details. 

## Definition of "Year" in File Names

One other detail to note is that legacy NCCS Core data files were organized by **filing dates**. For example, the 2015 dataset contained all of the 990 tax returns that were received by the IRS in the 2015 calendar year. 

The new NCCS Core has be reorganized instead by **tax year**, or the closest approximation we can get to period described by the data in the form. It gets complicated because nonprofits can select their own accounting periods with fiscal years that can end in any month, so the tax year does not entirely correspond to the calendar year. But it is a much closer approximation than organizing panels by filing dates. 

<br>
<br>
<br>
<br>










