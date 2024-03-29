---
title: "nccsdata Part 4: Summary Tables"
date: 2023-11-03
description: Part 4 of 4 data stories covering the nccsdata R package. This story focuses on summarising NCCS legacy data.
featured: false
primaryCtaUrl: https://urbaninstitute.github.io/nccsdata
primaryCtaText: Package Website
format: gfm
type: methods
categories:
  - R packages
author:
  - id: thiya
citation: 
  container-title: National Center for Charitable Statistics
  volume: 1
  issue: 1
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
    - text: Package Reference
      href: https://urbaninstitute.github.io/nccsdata/reference/index.html
      icon: link
    - text: Relevant Vignette
      href: https://urbaninstitute.github.io/nccsdata/articles/summary_stats.html
      icon: article
---

## Introduction

In the final segment of our four-part series on the
[`nccsdata`](https://urbaninstitute.github.io/nccsdata/) package, we
construct tables summarizing NCCS Legacy Data.

## Create Summary Tables

After preparing data using
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html)
and subsequent processing through additional filtering or wrangling, you
can use
[`preview_sample()`](https://urbaninstitute.github.io/nccsdata/reference/preview_sample.html)
to compute summary statistics for legacy datasets.

The following example illustrates this process:

``` r
core <- get_data(dsname = "core",
                 time = "2015")
#> Valid inputs detected. Retrieving data.
#> Downloading core data
#> Requested files have a total size of 115 MB. Proceed
#>                       with download? Enter Y/N (Yes/no/cancel)
#> Core data downloaded
```

``` r
preview_sample(data = core,
              group_by = c("NTEECC", "STATE"),
              var = c("TOTREV"),
              stats = c("count", "mean", "max"))
#> Valid summary fields entered.
#> # A tibble: 13,091 × 5
#> # Groups:   NTEECC [937]
#>    NTEECC STATE count    mean       max
#>    <chr>  <chr> <int> <int64>   <int64>
#>  1 ""     ""      406 1769225 375740413
#>  2 "A01"  "AZ"      2   41647     73295
#>  3 "A01"  "CA"     13 1052177   9241479
#>  4 "A01"  "CO"      2  268455    319830
#>  5 "A01"  "CT"      2  228350    415503
#>  6 "A01"  "DC"      5  446664   1117827
#>  7 "A01"  "DE"      1  268308    268308
#>  8 "A01"  "FL"      2 1181261   1713932
#>  9 "A01"  "GA"      3   64731    109254
#> 10 "A01"  "HI"      3   15371     29528
#> # ℹ 13,081 more rows
```

[`preview_sample()`](https://urbaninstitute.github.io/nccsdata/reference/preview_sample.html)
groups the dataset based on the columns specified in `group_by`, and
computes summary statistics for the user-defined *var* column. The
available summary statistics are:

- `min`: minimum value
- `median`: median value
- `max`: maximum value
- `mean`: mean value
- `count`: count of rows belonging to group

As long as the columns in *group_by* are present in the data set,
[`preview_sample()`](https://urbaninstitute.github.io/nccsdata/reference/preview_sample.html)
will be able to generate a summary table for the user.

## Conclusion

We hope this series has been helpful for working with the
[`nccsdata`](https://urbaninstitute.github.io/nccsdata/index.html)
package. package. Contact the package maintainers with any comments or
suggestions and any additional features you would find useful.
