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
---

## Overview

The Core Data Series is a comprehensive dataset that provides essential information on nonprofit operations spanning the past 30 years. It serves as a valuable resource for researchers, policymakers, funders, and anyone interested in understanding nonprofit sector dynamics in the United States.

The NCCS Core Data Series is derived from nonprofits’ annual Form 990 filings with the Internal Revenue Service (IRS). These data include financial information, governance details, and other organizational characteristics. The key components include the following:

 •	**Financial data**: includes revenue, expenses, assets, and liabilities, enabling financial analysis and benchmarking
 •	**Programs and activities**: descriptions of the organization's activities, programs, and mission statements
 •	**Geographic information**: the location and service areas of nonprofits
 •	**Time series data**: offer data from 1989 onward, which makes it possible to track trends in the nonprofit sector


## Versions

The data is separated into three populations: 

* 501c3 Charities (990 + 990EZ filers)
* 501c3 Private Foundations (990PF filers)
* All other 501c Nonprofits (990 + 990EZ filers) 

Two versions differ by organizational size (smaller nonprofits file Form 990EZ):

* PZ version: all 990 + 990EZ filers - a larger number of organizations but smaller number of variables 
* PC version: only includes full Form 990 filers - a smaller number of organizations but a larger number of variables

The PZ version includes approximately 150 variables from 400,000 nonprofits. The PC version includes about 300 variables from 200,000 nonprofits. These numbers vary over time.

Private foundations all file Form 990PF, regardless of size.

## Use

Data can be downloaded via the [**data catalog**](https://urbaninstitute.github.io/nccs/catalogs/catalog-core.html) page or the [**nccsdata R package**](https://urbaninstitute.github.io/nccsdata/). Statistical packages have the advantage of process documentation and reproducibility. Data acquisition steps with the package might look like one of the following queries: 

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

Learn more from the “Introducing the nccsdata Package” [data story](https://urbaninstitute.github.io/nccs/stories/nccsdata/) or the [package website](https://urbaninstitute.github.io/nccsdata/index.html). 

## Data Series Attributes 

The dataset covers a wide range of nonprofit organizations, including charities, foundations, religious organizations, educational institutions, and more. It encompasses organizations of various sizes, missions, and locations across the United States.

The NCCS Core Data Series is widely used by researchers, policymakers, and nonprofits themselves to gain insights into the sector. It can inform studies on topics such as nonprofit financial health, sector trends, and the effects of policy changes on charitable organizations.

The data are publicly available through the NCCS website and can be accessed by researchers, analysts, and organizations interested in nonprofit-related research. NCCS takes measures to ensure data quality and accuracy, making it a reliable resource for research and analysis.

## Sample Scope Definitions

All 990 filers are split into five groups using combinations of two variables:

  * **organizational type scope or tscope** This variable distinguishes between 501c3 public charities, 501c3 private foundations, and all other types of 501c organizations.   * **Form filing scope or fscope**: This variable describes which types of filers are included in the dataset.

![image](https://github.com/lecy/nccs/assets/1209099/8a2d94ca-346a-4679-b30e-f3328a7d0df9)

**Private foundations**: These are straightforward. They are always categorized as 501(c)(3) charities and they exclusively use Form 990-PF for filing. Unlike other nonprofits, small private foundations do not have the option of filing the 990-N ePostcard. They must submit a full 990-PF to stay in compliance and maintain their tax-exempt status.

**Other nonprofits**: For other nonprofits, the situation is a little trickier. They are divided into two categories: 

 •	**501(c)(3) public charities**: These organizations are distinct because all donations made to them are tax deductible. Datasets containing 501(c)(3) organizations are labeled 501C3-SCOPE-CHARITIES. 
 •	**Other organizations with tax-exempt types**: This category includes tax-exempt types 501(c)(1) to 501(c)(92), excluding the 501(c)(3) charities. These are labeled as 501CE-SCOPE-NONPROFIT, with 501cE standing for "everything other than 501(c)(3).”

**Form Scope:**

The Core Data Series contains two types of form scope: 
 * All full 990 filers (fscope=**PC**)
 * The broader 990 + 990EZ filers (fscope=**PZ**).

![image](https://github.com/lecy/nccs/assets/1209099/cf809446-da58-4867-9870-b0035a942847)
 
**Data File Naming**

The data are organized into five files that have the following naming conventions:

![image](https://github.com/lecy/nccs/assets/1209099/f25e1bc8-ff5e-4188-8125-956fd8f26ac9)

**Form Scope PZ**: The datasets with form scope of PZ will contain the full set of 990 and 990-EZ tax filers for a given year, but the trade-off is that 990-EZ filers have a much smaller form and thus fewer variables. Datasets with PZ scope represent a more extensive population and a more limited selection of fields. 

**Form Scope PC**: Datasets with form scope of PC will contain the smaller subset of full 990 form filers but contain a larger number of variables. 

The PZ and PF versions of the data series are available from 1989-2022. The PC version is a more recent edition, available from 2012-2022.

See the [Data Guide](https://nccs-data.urban.org/NCCS-data-guide.pdf) for more details. 
**Exclusion of 990N ePostcard Filers:**

The Core Series does not include 990N ePostcard filers, even though they are the most common type of nonprofit. These organizations have annual revenues below $50,000, and the 990N form they file includes minimal information, including updates to the organization address and key contact.

While these organizations may have limited financial resources, they play a significant role in the voluntary sector and civil society. For example, many volunteer-run nonprofits like parent teacher associations, block associations, and little league clubs fall in this group. They actively build social capital in communities and provide important collective actions that can be accomplished with very modest financial support. 

This is an important consideration when designing a sampling framework for a study. The Core Series will not capture the activities of these small organizations. If these organizations are relevant to your study, consider incorporating information from the [990N ePostcard Dataset](https://urbaninstitute.github.io/nccs/datasets/postcard/) or 1023-EZ data on nonprofit startups.

## Definition of "Year" in File Names

In the past, the NCCS Core data files were organized based on the dates when the tax returns were filed. For example, the 2015 dataset included all of the 990 tax returns that were received by the IRS in the 2015 calendar year.

The new NCCS Core has been reorganized by the tax year, or the closest approximation we can get to the period of performance described by the 990 data. Time gets complicated because nonprofits can select their own accounting periods with fiscal years that can end in any month. As a result, the tax year does not align perfectly with the calendar year. For example, tax year 2018 can include activities from some months in 2018 and some months in 2019. But this new approach approximates the true period of nonprofit performance much more closely than organizing panels by filing dates.

<br>
<br>
<br>
<br>










