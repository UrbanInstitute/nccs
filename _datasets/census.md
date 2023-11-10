---
title: Census Crosswalks
date: 2023-05-27
description: A framework for seamlessly adding census data to your nonprofit panel. 
categories:
  - census
  - spatial
  - crosswalks
featured: true
featuredOrder: 4
primaryCtaUrl: "https://urbaninstitute.github.io/nccs/catalogs/catalog-census_crosswalk.html"
primaryCtaCaption:
primaryLinks:
  - text: "Replication Code"
    href: "https://github.com/UI-Research/nccs-geo"
    icon: github
  - text: "R Package"
    href: "https://github.com/UrbanInstitute/geocrosswalk"
    icon: r
author:
- id: cdavis
- id: jlecy
citation: 
  author: "Davis, C. & Lecy, J."
  container-title: "Introducing the geocrosswalk Framework for Seamless Integration of Census Panels into Studies."
---

## Overview

Census data is invaluable to social science research and freely available through the Census API. Unfortunately, adding census data to a study is time-consuming because census tables are complex, geographic units are confusing, the American Community Survey sampling framework is nuanced, and harmonization of data over time requires significant expertise. 

To address this problem we are developing tools to make it easier to append Census data to NCCS data series. The goal is a highly-integrated and intuitive process that requires minimal effor from users. 

Augmenting a file with Census data should be as straight-forward as: 

```r
get_data( 
   dsname = "core",
   time = as.character(2010:2020),
   geo.region = "south",
   ntee = "HEL" ) %>%
append_census( level="tract" )
```

## GEOGRAPHIC CROSSWALK FILES

Any census-designated geography is fundamentally comprised of a collection of either tracts or blocks. We have created a series of crosswalk files that enable interoperability of Census data at a variety of geographic scales.  

Two crosswalk files contain geographic IDs that describe the nested hierarchy of 14 distinct geographic levels of aggregation in order for a study to select the most meaningful level of aggregation. Crosswalk tables organized into geographies **comprised of blocks** and **geographies comprised of tract** as the basic building blocks. 

<img src="https://raw.githubusercontent.com/UrbanInstitute/geocrosswalk/main/img/geo-unit-conversion.png" alt="Nested Geographic Units" width="500">

<br>
<hr>
<br>

**[Geographies Derived from Blocks](https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/BLOCKX.csv)** (11,078,297 blocks/rows, 748MB)
- [Census Designated Places](https://www.census.gov/programs-surveys/bas/information/cdp.html)
- [Urban/Rural Areas (Census Defined)](https://www.census.gov/programs-surveys/geography/guidance/geo-areas/urban-rural.html)
- [Urban/Rural Areas (NCES Defined)](https://nces.ed.gov/surveys/annualreports/topical-studies/locale/definitions)
- [Voting Districts](https://www2.census.gov/geo/pdfs/reference/GARM/Ch14GARM.pdf)
- [ZIP Code equivalents (ZCTAs)](https://www.census.gov/programs-surveys/geography/guidance/geo-areas/zctas.html)


<br>
<hr>
<br>

**[Geographies Derived from Tracts](https://nccsdata.s3.us-east-1.amazonaws.com/geo/xwalk/TRACTX.csv)** (74,091 tracts/rows, 15MB) 
- States (State FIPS)
- Counties (County FIPS)
- [Woodard's Cutural Regions](https://www.independent.co.uk/news/world/americas/us-map-11-separate-nations-colin-woodward-yankeedom-new-netherland-the-midlands-tidewater-greater-appalachia-a8078261.html)
- [American Cultural Regions (Louf et al. 2023)](https://www.nature.com/articles/s41599-023-01611-3)
- [Census Regions](https://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf)
- [Public Use Microdata Areas (PUMAs)](https://www.census.gov/programs-surveys/geography/guidance/geo-areas/pumas.html)
- [Core Based Statistical Areas (CBSAs)](https://carolinatracker.unc.edu/stories/2020/10/28/cbsa_geography/)
- [Combined Statistical Areas (CSAs)](https://www.census.gov/geographies/reference-maps/2020/geo/csa.html)

<br>
<hr>
<br>

### Selecting Geographies

Why are there so many defined geographies and how do we know which one to use? 

The answer will depend greatly upon your intended use case of the data. The short answer is geographies are hard - humas use many ambiguous geographic constructs like neighborhoods and cities that work fine for everyday life but are challenging to operationalize when they require precise boundaries. Should a city include all of the suburbs, for example, since they are autonomous municipalities? Are Minneapolis and St. Paul one city or two? As a result, the Census provides a variety of geographic aggregations that correspond to different definitions of place. We can select the geography that best corresponds to the notion of "place" in the analysis we would like to do with the data.  

As an example, InContext Indiana provides a [nice illustration](https://www.incontext.indiana.edu/2021/mar-apr/article1.asp) of the differences between Metropolitan Statistical Areas, Micropolitan Statistical Areas, and Combined Statistical Areas. These are different ways of thinking about towns, cities, and metropolitan regions. 

**Metropolitan** Statistical Areas (metros with populations above 50,000) and **Micropolitan** Statistical Areas (populations above 10,000 and below 50,000) are mutually exclusive lists of cities and towns that are combined to form **Core Based** Statistical Areas (CBSAs). **Combined** Statistical Areas (populations that form a coherent commercial and commuting zone) are created by identifying adjacent Micro and Metro areas that constitute a coherent economic region. 

![](https://raw.githubusercontent.com/UrbanInstitute/nccs/main/_datasets/img/csa-vs-cbsa.png)

In this example there are <span style="color:#29ABE2; font-weight:bold;">12 Metro Areas</span> in Indiana and <span style="color:#7AC943; font-weight:bold;">24 Micropolitan Areas</span>. They belong to <span style="color:#F7931E; font-weight:bold;">10 metropolitan regions</span> (Combined Statistical Areas), 7 of which are located inside the state and 3 of which are CSAs in neighboring states that contain Indiana towns and cities. 

The CBSA geographies are formed by combining all of the Metro and Micro areas into a single catalog, but they are all still distinct and mutually exclusive. The CSA geographies are formed by combining multiple Metro and Micro units into aggregated regional units. 

```
939 Core-Based Statistical Areas =
    384 Metropolitan statistical areas +
    547 micropolitan statistical areas

175 Total Combined Statistical Areas:
    808 Metro + Micro Areas joined together to form CSAs
    123 Metro + Micro Areas are not part of any CSA
```

Explore the definitions a bit before selecting a default geographic unit of analysis for your study because the geographies ultimately determine how data is aggregated, and thus what sorts of insights are uncovered or lost because of geographic scale. 

## HARMONIZED CENSUS FILES

Census geographies change frequently to reflect changes to the underlying administrative units like zip codes and voting districts. Formal census boundaries - blocks and tracts - change every ten years when the geographies are redrawn to ensure that each block contains between 600 and 3,000 individuals (optimally 1,800) and tracts contain between 1,200 and 8,000 people (optimally 4,000). Blocks and tracts either have boundaries redrawn to maintain balance, they can be split into multiple units if population density is increasing, or multiple units can be combined if population is in decline. As a result, geo-IDs are not measuring consistent populations over time unless the data is standardized to a specific time period using an apportionment process. The process uses changes in geographic units over time to adjust previous census estimates so that they are comportable with current geographies. 

<img src="https://raw.githubusercontent.com/UrbanInstitute/geocrosswalk/main/img/geocrosswalk-overview.png" alt="Crosswalk example" width="700">

For example, if a tract was split into two new tracts, in past census datasets the original tract would need to be split into two tracts as well. These splits are made using approximations based upon the size or density of the new tracts relative to the original tract. Harmonization can be done in either direction (translating past data to current geographies or vice-versa). Harmonized datasets require a reference period, which is the geography used as the reference for all years of data. 

The other challenge to creating a panel of census variables is that a single variable might be measured by different census processes at different time periods (for example, the American Community Survey vs. the Dicennial Census). It can be confusing to try to locate all versions of a single variable and the table names and variable names change each year. More so, some variables are only available for small geographies like blocks during census decades since the American Community Survey does not generate enough observations to accurately estimate the variable at a minute geography. 

To address all of these issues we have selected a set of the most commonly-used census variables and created data files that are harmonized to the 2010 census geography (the most common reference group across most data sources). They are available at the block and tract levels. Most measures can be "aggregated up" into your desired geography using the geocrosswalk files. 

## Nonprofit Data Files

All nonprofit data within the NCCS ecosystem that has address information describing locations of nonprofits or services are geocoded in order to generate latitude and longitude coordinates of the organizations or activities. The geographic coordinate is matched to census blocks using a [spatial join](https://github.com/UI-Research/nccs-geo/blob/main/join_nccs_block.R). 

Some of the NCCS files will contain a block GEOID and a tract GEOID that contain census block FIPS and tract FIPS. These fields can be used to append whichever geographic level is desired through the BLOCKX.csv and TRACTX.csv files.

The harmonized census panels can be found in the data catalog above (the "Download" link). 

## Feedback

This project is actively being developed. If you have questions or feedback please reach out to the creators Chris Davis and Jesse Lecy through the "Get Help" link above.  

<br>
<br>
<br>
<br>


