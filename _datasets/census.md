---
title: Census Crosswalks
date: 2023-05-27
description: A framework for seamlessly adding census data to your nonprofit panel. 
categories:
  - census
  - spatial
  - crosswalks
featured: false
featuredOrder: 5
primaryCtaUrl: ""
primaryCtaCaption: "Census data period: 1990-2020"
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/census_codebook.xlsx"
  - text: "BLOCKX.csv 784MB"
    href: "https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/BLOCKX.csv"
  - text: "TRACTX.csv 15MB"
    href: "https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/TRACTX.csv"
  - text: "geocrosswalk R Package"
    href: "https://github.com/UrbanInstitute/geocrosswalk"
  - text: "Crosswalk Code"
    href: "https://github.com/UI-Research/nccs-geo"
  - text: "Get Help"
    href: "https://github.com/UrbanInstitute/geocrosswalk/issues"
author:
- id: cdavis
- id: jlecy
citation: 
  author: "Davis, C. & Lecy, J."
  container-title: "Introducing the geocrosswalk Framework for Seamless Integration of Census Panels into Studies."
  doi: 10.5555/12345678
---

## Overview

Census data is invaluable to social science research and freely available through the Census API. Unfortunately, adding census data to a study is complex and time-consuming because census tables are complex, geographic units are confusing, the ACS vs dicennial sampling framework is nuanced, and harmonization of data over time requires significant expertise. 

To address this problem we are developing tools to make adding census data to your research database as easy as: 

```r
get_data( 
   core,
   years=2010:2020,
   geo.region=“southeast”,
   ntee=“human services” ) %>%
append_census( level=“tract” )
```

In order to make this possible we have created new data infrastructure including: 

**CROSSWALK FILES**

Any census-designated geography is fundamentally comprised of a collection of either tracts or blocks. The crosswalk files contain geographic IDs that describe the nested hierarchy of 14 distinct geographic levels of aggregation in order for a study to select the most meaningful level of aggregation. Crosswalk tables organized into geographies **comprised of blocks** and **geographies comprised of tract** as the basic building blocks. 

<img src="https://raw.githubusercontent.com/UrbanInstitute/geocrosswalk/main/img/geo-unit-conversion.png" alt="Nested Geographic Units" width="500">

<br>
<hr>
<br>

**[from block](https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/BLOCKX.csv)** (11,078,297 blocks/rows, 748MB)
- Census Place
- Urban Areas
- Voting Districts
- ZCTAs
- NCES Locales

<br>
<hr>
<br>

**[from tract](https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/TRACTX.csv)** (74,091 tracts/rows, 15MB) 
- Public Use Microdata Areas (PUMAs)
- Core Based Statistical Areas (CBSAs)
- Combined Statistical Areas (CSAs)
- County
- State
- Woodard's Cutural Regions
- American Communities Cultural Regions
- Census Regions
- Census Divisions

<br>
<hr>
<br>

**HARMONIZED CENSUS FILES**

Census geographies change frequently to reflect changes to the underlying administrative units like zip codes and voting districts. Formal census boundaries - blocks and tracts - change every ten years when the geographies are redrawn to ensure that each block contains between 600 and 3,000 individuals (optimally 1,800) and tracts contain between 1,200 and 8,000 people (optimally 4,000). Blocks and tracts either have boundaries redrawn to maintain balance, they can be split into multiple units if population density is increasing, or multiple units can be combined if population is in decline. As a result, geo-IDs are not measuring consistent populations over time unless the data is standardized to a specific time period using an apportionment process. The process uses changes in geographic units over time to adjust previous census estimates so that they are comportable with current geographies. 

<img src="https://raw.githubusercontent.com/UrbanInstitute/geocrosswalk/main/img/geocrosswalk-overview.png" alt="Crosswalk example" width="300">

For example, if a tract was split into two new tracts, in past census datasets the original tract would need to be split into two tracts as well. These splits are made using approximations based upon the size or density of the new tracts relative to the original tract. Harmonization can be done in either direction (translating past data to current geographies or vice-versa). Harmonized datasets require a reference period, which is the geography used as the reference for all years of data. 

The other challenge to creating a panel of census variables is that a single variable might be measured by different census processes at different time periods (for example, the American Community Survey vs. the Dicennial Census). It can be confusing to try to locate all versions of a single variable and the table names and variable names change each year. More so, some variables are only available for small geographies like blocks during census decades since the American Community Survey does not generate enough observations to accurately estimate the variable at a minute geography. 

To address all of these issues we have selected a set of the most commonly-used census variables and created data files that are harmonized to the 2010 census geography (the most common reference group across most data sources). They are available at the block and tract levels. Most measures can be "aggregated up" into your desired geography using the geocrosswalk files. 

## Nonprofit Data Files

All nonprofit data within the NCCS ecosystem that has address information describing locations of nonprofits or services are geocoded in order to generate latitude and longitude coordinates of the organizations or activities. The geographic coordinate is matched to census blocks using a [spatial join](https://github.com/UI-Research/nccs-geo/blob/main/join_nccs_block.R). 

Some of the NCCS files will contain a block GEOID and a tract GEOID that contain census block FIPS and tract FIPS. These fields can be used to append whichever geographic level is desired through the BLOCKX.csv and TRACTX.csv files.

The harmonized census panels can be found in the data catalog above (the "Download" link). 

## Feedback

This project is actively being developed. If you have questions or feedback please reach out to the creators Chris Davis and Jesse Lecy through the "Get Help" link above.  




