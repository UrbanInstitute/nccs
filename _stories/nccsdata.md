---
title: "nccsdata Part 1: Downloading Data"
date: 2023-11-03
description: "First of four data stories on the nccsdata R Package. This story covers data downloads."
format: gfm
featured: false
page-layout: full
featuredOrder: 1
primaryCtaUrl: https://urbaninstitute.github.io/nccsdata
primaryCtaText: Package Website
type: methods
categories:
  - R packages
author:
  - id: thiya
citation: 
  container-title: National Center for Charitable Statistics
  volume: 1
  issue: 1
  doi: 10.5555/12345678
links:
  - header: Data Stories in this series
    links:
    - text: "Part 1: Downloading Data"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata/
      icon: article
    - text: "Part 2: NTEE Codes"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata-ntee/
      icon: article
    - text: "Part 3: Geographic Filters"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata-geo/
      icon: article
    - text: "Part 4: Summarising Data"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata-summary/
      icon: article
  - header: Package Links
    links:
    - text: Github Repository
      href: https://github.com/UrbanInstitute/nccsdata
      icon: github
    - text: Function Reference
      href: https://urbaninstitute.github.io/nccsdata/reference/index.html
      icon: link
    - text: Relevant Vignette
      href: https://urbaninstitute.github.io/nccsdata/articles/data_pull.html
      icon: article
---

## Introduction

[`nccsdata`](https://urbaninstitute.github.io/nccsdata/) provides tools
to read, filter and append metadata to publicly available NCCS Core and
BMF data sets. It’s features include:

1.  Downloading Legacy Core and BMF Datasets from the NCCS Archive
    across multiple years to construct panel datasets for research
2.  Providing information on the [National Taxonomy of Exempt Entities
    (NTEE)](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEE-disaggregated/README.md)
    used by the IRS and NCCS to classify nonprofits
3.  Providing information on U.S. Census units that can be used to
    filter downloaded data by geography
4.  Constructing summary tables for downloaded data

In part 1 of this 4-part series on the
[`nccsdata`](https://urbaninstitute.github.io/nccsdata/) package, we
introduce the package and describe the process of downloading NCCS
legacy data with the help of
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html).
Parts 2 to 4 cover NTEE codes, census data and summary tables
respectively.

## Installation

You can install the development version of `nccsdata` directly from its
[GitHub repository](https://github.com/UrbanInstitute/nccsdata) with:

``` r
install.packages("devtools")
devtools::install_github("UrbanInstitute/nccsdata")
```

Next, load in the package with:

``` r
library(nccsdata)
```

## Downloading Data

[`nccsdata`](https://urbaninstitute.github.io/nccsdata/) can be used to
download legacy core data from 1989 to 2019 for charities, nonprofits,
or private foundations that file their respective required IRS forms
such as Form 990, 990EZs, or both.

This data can be filtered based on the type of organization, the type of
IRS forms files,
[NTEE](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEE-disaggregated/README.md)
codes and geographic units from the US census.

``` r
core_2005_nonprofit_pz <- get_data(dsname = "core",
                                   time = "2005",
                                   scope.orgtype = "NONPROFIT",
                                   scope.formtype = "PZ")
#> Requested files have a total size of 82.6 MB. Proceed
#>                       with download? Enter Y/N (Yes/no/cancel)


tibble::as_tibble(core_2005_nonprofit_pz)
#> # A tibble: 157,211 × 150
#>    NTEECC new.code   type.org broad.category major.group univ  hosp  two.digit
#>    <chr>  <chr>      <chr>    <chr>          <chr>       <lgl> <lgl> <chr>    
#>  1 J40    RG-HMS-J40 RG       HMS            J           FALSE FALSE 40       
#>  2 W30    RG-PSB-W30 RG       PSB            W           FALSE FALSE 30       
#>  3 W30    RG-PSB-W30 RG       PSB            W           FALSE FALSE 30       
#>  4 W30    RG-PSB-W30 RG       PSB            W           FALSE FALSE 30       
#>  5 W30    RG-PSB-W30 RG       PSB            W           FALSE FALSE 30       
#>  6 Y42    RG-MMB-Y42 RG       MMB            Y           FALSE FALSE 42       
#>  7 S41    RG-PSB-S41 RG       PSB            S           FALSE FALSE 41       
#>  8 N60    RG-HMS-N60 RG       HMS            N           FALSE FALSE 60       
#>  9 S41    RG-PSB-S41 RG       PSB            S           FALSE FALSE 41       
#> 10 S41    RG-PSB-S41 RG       PSB            S           FALSE FALSE 41       
#> # ℹ 157,201 more rows
#> # ℹ 142 more variables: further.category <int>, division.subdivision <chr>,
#> #   broad.category.description <chr>, major.group.description <chr>,
#> #   code.name <chr>, division.subdivision.description <chr>, keywords <chr>,
#> #   further.category.desciption <chr>, ntee2.code <chr>, EIN <chr>,
#> #   TAXPER <int>, STYEAR <int>, CONT <int>, DUES <int>, SECUR <int64>,
#> #   SALESEXP <int64>, INVINC <int>, SOLICIT <int>, GOODS <int>, GRPROF <int>, …
```

``` r
core_2005_artnonprofits_newyork <- get_data(dsname = "core",
                                            time = "2016",
                                            scope.orgtype = "NONPROFIT",
                                            scope.formtype = "PZ",
                                            ntee = "ART",
                                            geo.state = "NY")
#> Requested files have a total size of 113.6 MB. Proceed
#>                       with download? Enter Y/N (Yes/no/cancel)
tibble::as_tibble(core_2005_artnonprofits_newyork)
#> # A tibble: 346 × 168
#>    NTEECC new.code   type.org broad.category major.group univ  hosp  two.digit
#>    <chr>  <chr>      <chr>    <chr>          <chr>       <lgl> <lgl> <chr>    
#>  1 A01    AA-ART-A00 AA       ART            A           FALSE FALSE 1        
#>  2 A01    AA-ART-A00 AA       ART            A           FALSE FALSE 1        
#>  3 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#>  4 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#>  5 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#>  6 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#>  7 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#>  8 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#>  9 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#> 10 A03    PA-ART-A00 PA       ART            A           FALSE FALSE 3        
#> # ℹ 336 more rows
#> # ℹ 160 more variables: further.category <int>, division.subdivision <chr>,
#> #   broad.category.description <chr>, major.group.description <chr>,
#> #   code.name <chr>, division.subdivision.description <chr>, keywords <chr>,
#> #   further.category.desciption <chr>, ntee2.code <chr>, EIN <int>,
#> #   ACCPER <int>, ACTIV1 <dbl>, ACTIV2 <dbl>, ACTIV3 <dbl>, ADDRESS <chr>,
#> #   AFCD <dbl>, ASS_BOY <dbl>, ASS_EOY <dbl>, BOND_BOY <dbl>, BOND_EOY <dbl>, …
```

Data is downloaded with the
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
function. In this story, we provide several examples of how this
function can be used to retrieve this legacy data.

## Downloading Core Data

With
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
we can define the type of data, range of data (in years), organization
type, and form type for the data we wish to download using the arguments
*dsname*, *time*, *scope.orgtype*, and *scope.formtype* respectively.

The acceptable values for these arguments are:

- `dsname`: The type of data to download
  - `core`: NCCS Legacy Core
    [data](https://urbaninstitute.github.io/nccs/datasets/core/)
  - `bmf`: NCCS Business Master File (BMF)
    [data](https://urbaninstitute.github.io/nccs/datasets/bmf/)
- `time`: Any year from 1989-2019 where data is available. Full catalog
  can be found
  - [here](https://urbaninstitute.github.io/nccs/catalogs/catalog-core.html)
    for core data
  - [here](https://urbaninstitute.github.io/nccs/catalogs/catalog-bmf.html)
    for bmf data
- `scope.orgtype`
  - `CHARITIES`: All charities
  - `NONPROFIT`: All nonprofits
  - `PRIVFOUND`: All private foundations
- `scope.formtype`
  - `PC`: Nonprofits that file the full IRS Form 990
  - `EZ`: Nonprofits that file 990EZs only
  - `PZ`: Nonprofits that file both full Form 990s and 990EZs
  - `PF`: Private foundation filings

For example, the below code snippet downloads NCCS core data from the
year 2015 for all non-profits that file both full 990s and 990EZs.

``` r
core <- get_data(dsname = "core",
                 time = "2015",
                 scope.orgtype = "NONPROFIT",
                 scope.formtype = "PZ")
```

Whenever
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
is used, users will receive a prompt that provides the download size of
the requested data, and requests permission to perform the download.
This allows the user to preemptively cancel downloads that are too large
for their computers or internet connections to handle.

## Filtering data downloads using NTEE codes

[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
can also pull only a subset of the data based on NTEE classifications
using its various *ntee* associated arguments as shown in the example
below.

``` r
core_art <- get_data(dsname = "core",
                     time = "2015",
                     scope.orgtype = "NONPROFIT",
                     scope.formtype = "PZ",
                     ntee = c("ART"))
```

In the above code snippet, we pull the same dataset but only select rows
belonging to nonprofits involved in the Arts, Culture and Humanities. A
full description of NTEE codes is available
[here](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEE-disaggregated/README.md).

The available *ntee* arguments are:

- `ntee`: Any valid full or partial NTEE code
- `ntee.group`: Level 1 of a full NTEE code
- `ntee.code`: Levels 2-4 of a full NTEE code
- `ntee.orgtype`: Level 5 of a full NTEE code

Part 2 of this series of data stories covers NTEE codes, their structure
and additional NTEE associated functions in greater detail.

## Filtering Data By Geography

We can filter the data by US census units through
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)’s
*geo* arguments. The code snippet below returns rows belonging to
Nonprofits from New York City, NY using *geo.state* and *geo.city* for
state and city level filtering respectively.

``` r
core_NYC <- get_data(dsname = "core",
                     time = "2015",
                     scope.orgtype = "NONPROFIT",
                     scope.formtype = "PZ",
                     geo.state = "NY",
                     geo.city = "New York City")
```

Additional *geo* arguments can be used to subset the data by county
(*geo.county*) and region (*geo.region*).

*geo* arguments must be used in conjunction with one another:

- `geo.state` = “IN”, `geo.county` = “Allen” for “Allen, IN”
- `geo.state` = “CA”, `geo.city` = “San Francisco” for “San Francisco,
  CA”

[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
layers these filters to subset the data by the desired geographic unit.
Using only 1 argument will return all rows that fall within the
requested geographic region (e.g. *geo.region* = “south” returns all
rows from the southern states or *geo.city* = “Lebanon” returns all rows
belonging to cities with the name ‘Lebanon’).

Further information on these geographic filters and additonal
geography-related functions is provided in Part 3 of this data story.

## Appending BMF Data to Core Data

[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
automatically appends NTEE metadata to the requested data set and can
also be configured to append BMF data to any downloaded core data set.

Appending metadata from the IRS Business Master File (BMF) requires the
downloading of an additional download of 185 MB and can be toggled
on/off with *append_bmf*.

``` r
corebmf <- get_data(dsname = "core",
                    time = "2015",
                    scope.orgtype = "NONPROFIT",
                    scope.formtype = "PZ",
                    append.bmf = TRUE)
```

## Downloading BMF Data

The *geo* and *ntee* arguments mentioned above can also be used to
download and filter BMF data. The below code snippet returns the subset
of BMF for California-based nonprofits from the Arts, Culture, and
Humanities group.

``` r
bmf <- get_data(dsname = "bmf",
                ntee = c("ART"),
                geo.state = c("CA"))
```

## Conclusion

With the
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
function, researchers familiar with R can easily access NCCS data for
use in their work. Further details about the package are available on
the official *nccsdata* package
[website](https://urbaninstitute.github.io/nccsdata/)
