---
title: Form 990N 'Postcard' Filers
date: 2023-05-27
description: A comprehensive panel of nonprofit organizations that file IRS form 990. 
categories:
  - 990
  - financial-trends
  - nonprofits
featured: false
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nonprofit-open-data-collective.github.io/data-report-templates/data-dictionary-layout-v7.html"
  - text: "R Package"
    href: "https://urbaninstitute.github.io/nccsdata/"
  - text: "Data History"
    href: "https://urbaninstitute.github.io/nccsdata/news/index.html"  
  - text: "Research Guide"
    href: "https://nonprofit-open-data-collective.github.io/titleclassifier/data-raw/DATA-PREP.html"
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
