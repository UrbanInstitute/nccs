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

Census data are invaluable to social science research and are available through the census API. Unfortunately, adding census data into a study is time-consuming. This is because census tables are complex, geographic units are confusing, the American Community Survey sampling framework is nuanced, and data harmonization over time requires significant expertise.

To address this problem, we are developing tools to make appending census data to NCCS data series easier. Our aim is a seamlessly integrated and intuitive process requiring minimal effort from users.

Augmenting a file with census data should be as straightforward as:

```r
get_data( 
   dsname = "core",
   time = as.character(2010:2020),
   geo.region = "south",
   ntee = "HEL" ) %>%
append_census( level="tract" )
```

## GEOGRAPHIC CROSSWALK FILES

Any census-designated geography consists of a collection of either tracts or blocks. We have created a series of crosswalk files that enable interoperability of census data across different geographic scales.

Two crosswalk files contain geographic IDs that describe the nested hierarchy of 14 distinct geographic levels of aggregation. They help researchers select the most meaningful level of aggregation for their study. The crosswalk tables are organized into two main categories: geographies **made up of blocks** and geographies **made up of tracts** as the basic building blocks.

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

The many defined geographies may leave you wondering which one is the right choice. The answer depends greatly on how you intend to use the data. 

The short answer is geographies are hard—humans use many ambiguous geographic constructs, like neighborhoods and cities, which work well for everyday life but are challenging to define precisely. For example, should a city include all its suburbs, even if they are autonomous municipalities? Are Minneapolis and Saint Paul one city or two? 

As a result, the census provides various geographic aggregations corresponding to different definitions of place. We choose the geography that best suits our analytical needs for the data.

To illustrate, let’s look at InContext Indiana, which [illustrates](https://www.incontext.indiana.edu/2021/mar-apr/article1.asp) the differences between Metropolitan Statistical Areas, Micropolitan Statistical Areas, and Combined Statistical Areas. These represent different perspectives on towns, cities, and metropolitan regions.

**Metropolitan** Statistical Areas, which include metros with populations above 50,000, and **Micropolitan** Statistical Areas, which are areas with populations between 10,000 and 50,000, are mutually exclusive lists of cities and towns that combine to form **Core Based** Statistical Areas (CBSAs).

**Combined** Statistical Areas (CSAs), on the other hand, are created by identifying adjacent Micro and Metro areas that constitute a coherent economic region based on factors like commerce and commuting.

![](https://raw.githubusercontent.com/UrbanInstitute/nccs/main/_datasets/img/csa-vs-cbsa.png)

In this example, Indiana has <span style="color:#29ABE2; font-weight:bold;">12 Metropolitan Areas</span> and <span style="color:#7AC943; font-weight:bold;">24 Micropolitan Areas</span>, which are part of <span style="color:#F7931E; font-weight:bold;">10 Metropolitan Regions</span> known as Combined Statistical Areas. Out of these CSAs, 7 are within Indiana and 3 extend into neighboring states but include Indiana towns and cities.

The CBSA geographies are formed by combining all of the Metro and Micro areas into a single catalog, but they are all still distinct and mutually exclusive. The CSA geographies are formed by combining multiple Metro and Micro units into aggregated regional units. 

```
939 Core-Based Statistical Areas =
    384 Metropolitan statistical areas +
    547 micropolitan statistical areas

175 Total Combined Statistical Areas:
    808 Metro + Micro Areas joined together to form CSAs
    123 Metro + Micro Areas are not part of any CSA
```
Before settling on a default geographic unit for your study, it’s a good idea to delve into the definitions a bit. This is important because the choice of geographies ultimately determines how data are aggregated, and what insights you can gain or might miss because of the chosen geographic scale.

## HARMONIZED CENSUS FILES

Census geographies change frequently to reflect changes to the underlying administrative units, such as zip codes and voting districts. The formal census boundaries, represented by blocks and tracts, undergo revisions every decade to maintain a balanced population distribution. 

Blocks aim to contain between 600 and 3,000 individuals (ideally 1,800), while tracts contain between 1,200 and 8,000 people (ideally 4,000). To achieve this balance, blocks and tracts can have their boundaries redrawn, be divided into multiple units if population density increases, or be combined if the population declines. 

Because of these changes, geo-IDs do not consistently measure the same populations over time. This inconsistency can be resolved by standardizing the data to a specific period using an apportionment process. This process uses changes in geographic units over time to update earlier census estimates, making them consistent with the current geographic framework.

<img src="https://raw.githubusercontent.com/UrbanInstitute/geocrosswalk/main/img/geocrosswalk-overview.png" alt="Crosswalk example" width="700">

For example, if a tract is split into two new tracts, previous census datasets should also represent this change by dividing the original tract into two parts. These splits are made by approximating the size or density of the new tracts in relation to the original one. 

Harmonization can work in both directions, translating past data to fit current geographies or vice versa. Harmonized datasets require a reference period, which is the geography used as the reference for all years of data.

Another challenge in creating a panel of census variables is that different census processes may measure a single variable at different periods. For example, a variable can be measured differently in the American Community Survey and the Decennial Census. 

Locating all versions of a single variable can be challenging since table names and variable names change each year. Moreover, some variables are only available for small geographies like blocks during census decades. The American Community Survey doesn’t generate enough observations to accurately estimate the variable at very fine geographical scales.

To address these issues, we have selected a set of the most commonly used census variables and created data files harmonized to the 2010 census geography, serving as the most common reference point across most data sources. These harmonized files are available at the block and tract levels. Most measures can be “aggregated up” to your desired geography level using the geocrosswalk files.

## Default Census Variables

A small set of census variables [described in this data dictionary](https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/census_codebook.xlsx) have been harmonized to 2010 geographies and inflation-adjusted to the year 2021. 

They are available for TRACT, COUNTY, and MSA levels of aggregation: 

```
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_1990.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2000.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2005-2009.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2006-2010.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2007-2011.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2008-2012.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2009-2013.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2010-2014.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2011-2015.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2012-2016.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2013-2017.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2014-2018.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2015-2019.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2016-2020.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/tract/tract_2017-2021.csv

https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_1990.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2000.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2005-2009.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2006-2010.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2007-2011.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2008-2012.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2009-2013.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2010-2014.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2011-2015.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2012-2016.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2013-2017.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2014-2018.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2015-2019.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2016-2020.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/county/county_2017-2021.csv

https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_1990.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2000.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2005-2009.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2006-2010.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2007-2011.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2008-2012.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2009-2013.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2010-2014.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2011-2015.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2012-2016.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2013-2017.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2014-2018.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2015-2019.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2016-2020.csv
https://nccsdata.s3.us-east-1.amazonaws.com/geo/data/msa/msa_2017-2021.csv
```

## Nonprofit Data Files

In the NCCS system, all nonprofit data that include address information describing the locations of nonprofits or services are geocoded. This process generates latitude and longitude coordinates for these organizations or activities. The resulting geographic coordinate is matched to census blocks using a [spatial join](https://github.com/UI-Research/nccs-geo/blob/main/join_nccs_block.R). 

Some of the NCCS files contain a block GEOID and a tract GEOID, which include census block FIPS and tract FIPS. You can use these fields to append whichever geographic level you want using the BLOCKX.csv and TRACTX.csv files.

To access the harmonized census panels, refer to the data catalog provided in the “Download” link above.

## Feedback

This project is in active development. If you have questions or feedback please open a [GitHub Issue](https://github.com/UrbanInstitute/geocrosswalk/issues) in the geocrosswalk repo.

<br>
<br>
<br>
<br>


