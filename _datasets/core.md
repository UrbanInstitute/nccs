---
title: NCCS Core Series
date: 2024-07-23
description: A comprehensive panel of nonprofit organizations that file IRS form 990
categories:
  - 990
  - financial-trends
  - nonprofits
featured: true
featuredOrder: 1
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaText: Data Catalog
primaryCtaCaption:
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nccsdata.s3.amazonaws.com/harmonized/core/CORE-HRMN_dd.csv"
    icon: article
author:
- id: jlecy
- id: thiya
citation: 
  author: "Jesse Lecy"
  citationDate: "2024"
  container-title: "NCCS Core Series"
---

## Update: Harmonized Core Dataset

The NCCS CORE data set for PC and PZ filers has been updated with the following changes:

1. **Variable Harmonization**: Standardized variable names based on the [master concordance file](https://github.com/Nonprofit-Open-Data-Collective/irs-efile-master-concordance-file) created by the [Nonprofit Open Data Collective](https://nonprofit-open-data-collective.github.io/). PC and PZ data sets now require 1 data dictionary.
2. **Tax Year**: Files have been reorganized according to tax year and not filing year. See section at the bottom of the page for difference between tax year and fiscal year.
3. **Updated Data**: Data for tax years 2020 and 2021 have been added.Filings for the 2022 tax year are still being periodically released by the IRS and will be updated periodically.

The PF filings for private foundations will require significant additional processing before they can be made ready for release. They are currently scheduled for release early 2025.

## Versioning

| Version | Release | Notes |
| :---: | :---: | :---: |
| 0.0 | July 23rd 2024 | Beta Version (Current) |
| 1.0 | September 23rd 2024 | Research Guide Complete |

## Overview

The Core Data Series is a comprehensive dataset that provides essential information on nonprofit operations spanning the past 30 years. It serves as a valuable resource for researchers, policymakers, funders, and anyone interested in understanding nonprofit sector dynamics in the United States.

The NCCS Core Data Series is derived from nonprofits’ annual Form 990 filings with the Internal Revenue Service (IRS). These data include financial information, governance details, and other organizational characteristics. The key components include the following:

* **Financial data**: includes revenue, expenses, assets, and liabilities, enabling financial analysis and benchmarking  
* **Programs and activities**: descriptions of the organization's activities, programs, and mission statements  
* **Geographic information**: the location and service areas of nonprofits  
* **Time series data**: offer data from 1989 onward, which makes it possible to track trends in the nonprofit sector  


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

Data can be downloaded via the [**data catalog**](https://urbaninstitute.github.io/nccs/catalogs/catalog-core.html). 

Variables are described in the [**data dictionary**](https://nccsdata.s3.amazonaws.com/harmonized/core/CORE-HRMN_dd.csv). Please note that documentation of variable locations on the 990 Forms and Scheulues is based upon 2016 versions. They are 99% the same as current forms but you may encounter a few discrepancies. The [**2016 990 Forms**]( https://github.com/Nonprofit-Open-Data-Collective/irs-efile-master-concordance-file/tree/master/01-irs-990_forms/2016) are linked here for reference. 

A table listing all information that nonprofits disclose, organized by [Form 990 and Schedule Parts](https://github.com/Nonprofit-Open-Data-Collective/irs-efile-master-concordance-file/tree/master?tab=readme-ov-file#form-990-and-schedule-sections), has been compiled for your convenience.  

Static organizational attributes (501c type, corporate form, NTEE code, etc.) and geocoded attributes (address, lat-lon coordinates, census FIPS codes) are all available in the [Business Master File](https://nccs.urban.org/nccs/datasets/bmf/). They can be used with [**Census Crosswalk**](https://nccs.urban.org/nccs/datasets/census/) files to aggregate data to your desired geographic level (tracts, zips, counties, metro areas, etc.) or join NCCS data without other datasets that use standard Census FIPS GEOIDs. 

A basic [**Census Demographics Data File**](https://urbaninstitute.github.io/nccs/catalogs/catalog-census_crosswalk.html) has been prepared. It contains ~20 demographic variables (population size, income, poverty, and race) covering four decades and is available at the tract, county, and MSA level. 

```r
library( dplyr )
URL <- "https://raw.githubusercontent.com/UI-Research/nccs-geo/main/get_census_data.R"
source( URL )

df  <- get_census_data( geo="msa" )      # 918 metro areas, all years 
df  <- get_census_data( geo="county" )   # 3,142 counties, all years 
df  <- get_census_data( geo="tract" )    # 72,597 tracts, all years 

# default format is 'long' (stacked years)
df  <- get_census_data( geo="msa", years=2010:2019 )

# return data in a wide format:
dfw <- get_census_data( geo="msa", years=c(1990,2000,2010), format="wide" )

# available years
c(  1990, 2000, 2007, 2008, 2009, 2010, 2011, 2012,
    2013, 2014, 2015, 2016, 2017, 2018, 2019  )
```

## Data Series Attributes 

The dataset covers a wide range of nonprofit organizations, including charities, foundations, religious organizations, educational institutions, and more. It encompasses organizations of various sizes, missions, and locations across the United States.

The NCCS Core Data Series is widely used by researchers, policymakers, and nonprofits themselves to gain insights into the sector. It can inform studies on topics such as nonprofit financial health, sector trends, and the effects of policy changes on charitable organizations.

The data are publicly available through the NCCS website and can be accessed by researchers, analysts, and organizations interested in nonprofit-related research. NCCS takes measures to ensure data quality and accuracy, making it a reliable resource for research and analysis.

## Sample Scope Definitions

All 990 filers are split into five groups using combinations of two variables:

* **organizational type scope or tscope** This variable distinguishes between 501c3 public charities, 501c3 private foundations, and all other types of 501c organizations. 
* **Form filing scope or fscope**: This variable describes which types of filers are included in the dataset. 

![image](https://github.com/lecy/nccs/assets/1209099/8a2d94ca-346a-4679-b30e-f3328a7d0df9)

**Private foundations**: These are straightforward. They are always categorized as 501(c)(3) charities and they exclusively use Form 990-PF for filing. Unlike other nonprofits, small private foundations do not have the option of filing the 990-N ePostcard. They must submit a full 990-PF to stay in compliance and maintain their tax-exempt status.

**Other nonprofits**: For other nonprofits, the situation is a little trickier. They are divided into two categories: 

*	**501(c)(3) public charities**: These organizations are distinct because all donations made to them are tax deductible. Datasets containing 501(c)(3) organizations are labeled 501C3-SCOPE-CHARITIES. 
*	**Other organizations with tax-exempt types**: This category includes tax-exempt types 501(c)(1) to 501(c)(92), excluding the 501(c)(3) charities. These are labeled as 501CE-SCOPE-NONPROFIT, with 501cE standing for "everything other than 501(c)(3).”  

**Form Scope:**

The Core Data Series contains two types of form scope: 

* All full 990 filers (fscope=**PC**)  
* The broader 990 + 990EZ filers (fscope=**PZ**)

![image](https://github.com/lecy/nccs/assets/1209099/cf809446-da58-4867-9870-b0035a942847)
 
**Data File Naming**

The data are organized into five files that have the following naming conventions:

![image](https://github.com/lecy/nccs/assets/1209099/f25e1bc8-ff5e-4188-8125-956fd8f26ac9)

**Form Scope PZ**: The datasets with form scope of PZ will contain the full set of 990 and 990-EZ tax filers for a given year, but the trade-off is that 990-EZ filers have a much smaller form and thus fewer variables. Datasets with PZ scope represent a more extensive population and a more limited selection of fields. 

**Form Scope PC**: Datasets with form scope of PC will contain the smaller subset of full 990 form filers but contain a larger number of variables. 

The PZ and PF versions of the data series are available from 1989-2019. The PC version is a more recent edition, available from 2012-2019.

See the [Data Guide](https://nccs-data.urban.org/NCCS-data-guide.pdf) for more details. 

**Exclusion of 990N ePostcard Filers:**

The Core Series does not include 990N ePostcard filers, even though they are the most common type of nonprofit. These organizations have annual revenues below $50,000, and the 990N form they file includes minimal information, including updates to the organization address and key contact.

While these organizations may have limited financial resources, they play a significant role in the voluntary sector and civil society. For example, many volunteer-run nonprofits like parent teacher associations, block associations, and little league clubs fall in this group. They actively build social capital in communities and provide important collective actions that can be accomplished with very modest financial support. 

This is an important consideration when designing a sampling framework for a study. The Core Series will not capture the activities of these small organizations. If these organizations are relevant to your study, consider incorporating information from the [990N ePostcard Dataset](https://urbaninstitute.github.io/nccs/datasets/postcard/) or 1023-EZ data on nonprofit startups.

## Definition of "Year" in File Names

The NCCS Core data files are organized based on the dates when the tax returns were filed. For example, the 2015 dataset included all of the 990 tax returns that were received by the IRS in the 2015 calendar year.

<br>
<br>
<br>
<br>










