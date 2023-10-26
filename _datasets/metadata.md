---
title: 990 Metadata
date: 2023-05-27
description: Discrete metadata files that describe other IRS 990 datasets and can be linked to enhance them or used in sampling frameworks. 
categories:
  - 990
  - financial-trends
  - nonprofits
featured: false
primaryCtaUrl: "../../catalogs/catalog-990_metadata.html"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nonprofit-open-data-collective.github.io/data-report-templates/data-dictionary-layout-v7.html"
  - text: "R Script"
    href: "https://urbaninstitute.github.io/nccsdata/"
  - text: "Download"
    href: "https://nccsdata.s3.us-east-1.amazonaws.com/meta/metadata.csv"  
  - text: "Background"
    href: "https://www.aspeninstitute.org/news/open-form-990-data-clearinghouse/"
author:
- id: jdl
- id: tp
- name: "Edmund Choi"
  bio: "Testing bio and author overrides"
citation: 
  author: "Choi. Y & Lee, Y."
  container-title: "Ednel: A large – scale hierarchical dataset in education"
  doi: 10.5555/12345678
---

## Use

```r
library( remotes )
install_github( "UrbanInstitute/nccs-data-package/nccsdata" )

dt <-
  nccsdata::ntee_preview(
    ntee.group = c( "ART", "EDU" ),
    ntee.code = c( "Axx", "B" ),
    ntee.orgtype = "all" )
```
