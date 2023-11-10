---
title: NCCS Core Series
date: 2023-05-27
description: A comprehensive panel of nonprofit organizations that file IRS form 990
categories:
  - 990
  - financial-trends
  - nonprofits
featured: true
featuredOrder: 1
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaCaption:
primaryLinks:
  - text: "R Package"
    href: "https://urbaninstitute.github.io/nccsdata/"
    icon: r
author:
- id: jlecy
- id: thiya
citation: 
  author: "Jesse Lecy"
  citationDate: "2023"
  container-title: "NCCS Legacy Core Series"
  doi:
---

## Overview

The Core Data Series is a comprehensive dataset that provides essential information on nonprofit operations over the last 30 years. It serves as a key resource for researchers, policymakers, funders, and anyone interested in understanding nonprofit sector dynamics in the United States. 

The NCCS Core Data Series is derived from the Internal Revenue Service (IRS) Form 990 filings, which nonprofits are required to submit on an annual basis. This data includes financial information, governance details, and other organizational characteristics.

* Financial Data: Revenue, expenses, assets, and liabilities, allowing for financial analysis and benchmarking.
* Programs and Activities: Descriptions of the organization's activities, programs, and mission statements.
* Geographic Information: Location and service areas of nonprofits.
* Time Series Data: Data is available starting from 1989, which makes it possible to track trends in the nonprofit sector over time.

## Versions

The data is separated into three populations: 

* 501c3 Charities (990 + 990EZ filers)
* 501c3 Private Foundations (990PF filers)
* All other 501c Nonprofits (990 + 990EZ filers) 

There are also two versions that differ by organizational size (smaller nonprofits file Form 990EZ):  

* PZ version: all 990 + 990EZ filers - a larger number of organizations but smaller number of variables 
* PC version: only full Form 990 filers - a smaller number of organizations but larger number of variables

The PZ version includes approximately 150 variables from 400,000 nonprofits. The PC version includes approximately 300 variables from 200,000 nonprofits. These numbers vary over time. 

Private foundations all file Form 990PF, regardless of size. 

## Use

Data can be downloaded via the [**data catalog**](https://lecy.github.io/nccs/catalogs/catalog-core.html) page or the [**nccsdata R package**](https://urbaninstitute.github.io/nccsdata/). Statistical packages have the advantage of process documentation and reproducibility. Data acquisition steps with the package might look like one of the following queries: 

```r
###  SELECT DATA BY: 
###    dsname = nccs data series
###    time = years of data desired
###    ntee = subsectors to include
###    desired geography: 
###    geo.state, geo.city, geo.county

install.packages("devtools")
devtools::install_github("UrbanInstitute/nccsdata")
library(nccsdata)

dat <- get_data(dsname = "core",
                time   = "2005")

dat <- get_data(dsname = "core",
                time   = "2005",
                ntee   = "ART")

###
###  MULTIPLE GEOGRAPHIES ARE SUPPORTED 
###

dat <- get_data(dsname = "core",
                time   = "2005",
                ntee   = "ART",   
                geo.state = "CA")

dat <- get_data(dsname = "core",
                time   = "2005",
                geo.city = "san francisco")

dat <- get_data(dsname = "core",
                time   = "2005",
                geo.county = "autauga")
```

Learn more from the [data story](https://urbaninstitute.github.io/nccs/stories/nccsdata/) or the [package website](https://urbaninstitute.github.io/nccsdata/index.html). 

## Data Series Attributes 

The dataset covers a wide range of nonprofit organizations, including charities, foundations, religious organizations, educational institutions, and more. It encompasses organizations of various sizes, missions, and geographic locations across the United States. 

The NCCS Core Data Series is widely used by researchers, policymakers, and nonprofits themselves to gain insights into the sector. It can inform studies on topics such as nonprofit financial health, sector trends, and the impact of policy changes on charitable organizations.

The data is made available to the public through the NCCS website and can be accessed by researchers, analysts, and organizations interested in nonprofit-related research. NCCS takes measures to ensure data quality and accuracy, making it a reliable resource for research and analysis.

## Sample Scope Definitions

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

Note that 990N ePostcard filers are the most common type of nonprofit but are not included in the Core Series. The ePostcard filers all have annual revenues below $50,000 per years, and the 990N form includes very little information (updates to the organization address and key contact). Although these organizations mobilize a modest amount of financial resources they also represent a substantive portion of the voluntary sector and civil society. For example, many volunteer-run nonprofits like Parent Teacher Associations, block associations, and little league clubs would fall in this group. They actively build social capital in communities and provide important collective action functions that can be accomplished with very modest financial support. This is an important consideration when designing a sampling framework for a study since the Core Series will not capture these activities. If small organizations matter in your study consider incorporating information from the [990N ePostcard Dataset](https://urbaninstitute.github.io/nccs/datasets/postcard/) or 1023-EZ data on nonprofit startups.  

## Definition of "Year" in File Names

One other detail to note is that legacy NCCS Core data files were organized by **filing dates**. For example, the 2015 dataset contained all of the 990 tax returns that were received by the IRS in the 2015 calendar year. 

The new NCCS Core has be reorganized instead by **tax year**, or the closest approximation we can get to period of performance described by the 990 data. Time gets complicated because nonprofits can select their own accounting periods with fiscal years that can end in any month, so the tax year does not correspond perfectly to a calendar year (tax year 2018 can include activities from some months im 2018 and some months in 2019, for example). But it is a much closer approximation than organizing panels by filing dates. 



<br>
<br>
<br>
<br>










