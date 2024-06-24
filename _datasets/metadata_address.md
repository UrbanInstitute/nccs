---
title: Address Metadata Table
date: 2024-06-21
description: Metadata Table of Geocoded Nonprofit EINs
categories:
  - sample-framework
  - metadata
  - spatial
featured: false
featuredOrder:
primaryCtaUrl: "https://nccsdata.s3.amazonaws.com/meta/metadata-address-geocoded.csv"
primaryCtaCaption: 1.2 GB
primaryLinks:
  - text: "Data Dictionary"
    href: "https://docs.google.com/spreadsheets/d/1wEWa0gCTvKcF7-VxLzm6dCqC060HJu8FleVehrncedg/edit?usp=sharing"
    icon: article
citation: 
  author: "Jesse Lecy"
  citationDate: "2024"
  container-title: "NCCS Address Metadata Table"
  doi:
---

## Overview

To provide researchers with granular geospatial data, NCCS has used the Urban Institute's [Geocoder](https://urban-institute.medium.com/choosing-a-geocoder-for-the-urban-institute-86192f656c5f) to geocode all addresses found in the [Unified BMF](https://nccs.urban.org/nccs/datasets/bmf/).

This allows researchers to map any nonprofit in our data archives to the Census State, County, Block, Tract and CSA level. Additional Census demographic data can then be easily appended using the [Census Crosswalks](https://nccs.urban.org/nccs/datasets/census/).

The download links for this metadata table and its accompanying data dictionary can be found on the side bar.

## Version Control

| Version | Notes | Release Date |
| :---: | :---: | :---: |
| 0.0 (**Current**) | Beta Version | 24th June 2024 |

## Limitations

### Geocoder Accuracy

While Urban's geocoder outperforms other comparable alternatives across various [performance benchmarks](https://urban-institute.medium.com/choosing-a-geocoder-for-the-urban-institute-86192f656c5f) its results are not perfect.

The quality of the input address provided determines the accuracy of the matched address to a large extent. Unfortunately, cleaning input addresses is a messy and imprecise process, with many smaller exempt organizations submitting single PO Box numbers in their filings.

The metadata table thus comes with both the address as found in the 990 and the address matched by the Urban Geocoder, and an accompanying match score.