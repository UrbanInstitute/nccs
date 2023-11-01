---
title: nccsdata R Package
date: 2023-08-28
description: nccsdata provides tools to read, filter and append metadata to publicly available NCCS Core and BMF data sets.
format: gfm
featured: false
page-layout: full
featuredOrder: 1
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
  - header: Package Files
    links:
    - text: Github Repository
      href: https://github.com/UrbanInstitute/nccsdata
      icon: github
    - text: Package Reference
      href: https://urbaninstitute.github.io/nccsdata/reference/index.html
      icon: link
---

## Overview

The`get_data()` function from
[`nccsdata`](https://urbaninstitute.github.io/nccsdata/) downloads NCCS
legacy data sets hosted on publicly accessible S3 buckets and processes
them for the user.

In this story, we provide several examples of how this function can be
used to retrieve this legacy data.

``` r
library(nccsdata)
```

## Downloading Core Data

We can define the type of data, range of data (in years), organization
type, and form type using the arguments `dsname`, `time`,
`scope.orgtype`, and `scope.formtype` respectively.

``` r
core <- get_data(dsname = "core",
                 time = "2015",
                 scope.orgtype = "NONPROFIT",
                 scope.formtype = "PZ")
```

The function downloads NCCS core data from the year 2015 for all
non-profits that file both full 990s and 990EZs. Other possible argument
values are:

- `scope.orgtype`
  - `CHARITIES`: All charities
  - `NONPROFIT`: All nonprofits
  - `PRIVFOUND`: All private foundations
- `scope.formtype`
  - `PC`: Nonprofits that file the full IRS Form 990
  - `EZ`: Nonprofits that file 990EZs only
  - `PZ`: Nonprofits that file both full Form 990s and 990EZs
  - `PF`: Private foundation filings

The data is available from the years 1989 to 2019. `get_data()` also
provides prompts with the size of the requested data downloads.

## Filtering data using NTEE codes

We can also pull only a subset of the data based on NTEE classifications
using the various `ntee` associated arguments in `get_data()`.

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
These descriptions can also be accessed using `ntee_preview()`.

## Filtering Data By Geography

We can subset the data by geographic units with the `geo` arguments from
`get_data()`.

``` r
core_NYC <- get_data(dsname = "core",
                     time = "2015",
                     scope.orgtype = "NONPROFIT",
                     scope.formtype = "PZ",
                     geo.state = "NY",
                     geo.city = "New York City")
```

The code above returns rows belonging to Nonprofits from New York City,
NY. Additional arguments `geo` arguments can be used to subset the data
by county (`geo.county`) and region (`geo.region`).

`geo` arguments must be used in conjunction with one another:

- `geo.state` = “IN”, `geo.county` = “Allen” for “Allen, IN”
- `geo.state` = “CA”, `geo.city` = “San Francisco” for “San Francisco,
  CA”

`get_data()` layers these filters to subset the data by the desired
geographic unit. Using only 1 argument will return all geographic units
that fall within it (e.g. `geo.region` = “south” returns all rows from
the southern states or `geo.city` = “Lebanon” returns all rows belonging
to cities with the name ‘Lebanon’).

## Appending BMF Data to Core Data

`get_data()` automatically appends NTEE metadata to the requested data
set. Appending metadata from the IRS Business Master File (BMF) requires
the downloading of an additional download of 185 MB and can be toggled
on/off with `append_bmf`.

``` r
corebmf <- get_data(dsname = "core",
                    time = "2015",
                    scope.orgtype = "NONPROFIT",
                    scope.formtype = "PZ",
                    append.bmf = TRUE)
```

BMF metadata is now appended to the downloaded Core data set.

## Downloading BMF Data

The `geo` and `ntee` arguments mentioned above can also be used to
download and filter BMF data.

``` r
bmf <- get_data(dsname = "bmf",
                ntee = c("ART"),
                geo.state = c("CA"))
```
