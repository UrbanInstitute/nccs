---
title: Dataset Sample Full Fields
date: 2023-05-27
description: Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit
categories:
  - environment
  - lorem
  - testing
featured: true
featuredOrder: 1
primaryCtaUrl: "https://lecy.github.io/nonprofitdataproject/download"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "R Package"
    href: "https://github.com/Nonprofit-Open-Data-Collective/peopleparser/blob/master/README.md"
  - text: "Data History"
    href: "https://pkgdown.r-lib.org/news/index.html" 
  - text: "Research Guide"
    href: "https://nonprofit-open-data-collective.github.io/titleclassifier/data-raw/DATA-PREP.html"
  - text: "Validation Report"
    href: "https://nonprofit-open-data-collective.github.io/data-report-templates/test-layout.html"
  - text: "Data Profile Template"
    href: "https://nonprofit-open-data-collective.github.io/data-report-templates/data-dictionary-layout-v7.html"
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

## Overview

Sit delectus inventore architecto optio tempora Labore error cumque officiis culpa nesciunt Necessitatibus facilis excepturi eaque eveniet consectetur? Maiores numquam a natus aliquid nulla, voluptatum Error officiis amet eos porro

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


Sit harum necessitatibus excepturi suscipit tenetur? Animi iusto magnam illo porro aspernatur. Perspiciatis reprehenderit impedit quisquam aliquam ex, dicta. Perferendis similique perferendis fuga ipsum optio? Aspernatur rem distinctio odit explicabo

Lorem consequatur qui rem quibusdam repellendus in voluptatum Explicabo excepturi culpa laudantium minima exercitationem. Animi accusantium temporibus necessitatibus delectus nemo. Minus explicabo praesentium ratione debitis consectetur atque Itaque velit omnis.

- Donec id elit non mi porta gravida at eget metus.
- Nullam quis risus eget urna mollis ornare vel eu leo.
    - Donec ullamcorper nulla non metus auctor fringilla.
    - Aenean lacinia bibendum nulla sed consectetur.
- Cras mattis consectetur purus sit amet fermentum.

### Lorem Ipsum

Elit aut impedit alias deserunt blanditiis Placeat libero laboriosam quas iste nisi. Ut dicta nulla tempore beatae aliquid repudiandae soluta? Magnam rerum magni minus voluptate ea Eligendi harum obcaecati error
