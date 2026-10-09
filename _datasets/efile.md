---
title: IRS 990 Efilers
date: 2023-05-27
description: A comprehensive panel of nonprofit organizations that file IRS form 990. 
categories:
  - 990
  - financial-trends
  - nonprofits
featured: true
featuredOrder: 3
primaryCtaUrl: "../../catalogs/catalog-efile-v3_1.html"
primaryCtaCaption:
primaryLinks:
  - text: "990-PF Data Catalog"
    href: "../../catalogs/catalog-efilepf-v3_1.html"
    icon: database
  - text: "ef2"
    href: "https://nonprofit-open-data-collective.github.io/ef2/"
    icon: r
  - text: "concordance990"
    href: "https://nonprofit-open-data-collective.github.io/concordance990/"
    icon: r
  - text: "panel990"
    href: "https://nonprofit-open-data-collective.github.io/panel990/"
    icon: r
  - text: "fiscal"
    href: "https://nonprofit-open-data-collective.github.io/fiscal/"
    icon: r
  - text: "governance"
    href: "https://nonprofit-open-data-collective.github.io/governance/"
    icon: r
  - text: "peopleparser"
    href: "https://nonprofit-open-data-collective.github.io/peopleparser/"
    icon: r
  - text: "titleclassifier"
    href: "https://nonprofit-open-data-collective.github.io/titleclassifier/"
    icon: r
author:
- id: jlecy
citation: 
  author: "Jesse Lecy"
  citationDate: "2026"
  container-title: "NCCS IRS 990 Efile Data"
  doi:
---

The IRS 990 Electronic Filing (Efile) Database is built from the Form 990 returns that tax-exempt organizations file electronically, starting with the 2009 tax year. Whereas the NCCS Core data series is more comprehensive in terms of the organizations it covers (all paper and electronic filers), the Efile database provides the most comprehensive information about each organization's activities, governance, and finances.

In 2016 the IRS began releasing efile returns containing almost all of the fields on Form 990 and its schedules, which greatly increased the information available about nonprofits. Previously most public nonprofit databases, like the NCCS Core files, were limited to the few dozen financial variables released in the IRS SOI Extract tables. The Efile database, in contrast, is built from millions of individual returns with thousands of fields from the 990 forms and schedules.

The IRS shares the returns as XML documents, which are challenging to use. NCCS converts them into two relational databases, with one or more tables for each Part of the forms and schedules:

* **Form 990 and 990-EZ** (public charities and other exempt organizations): 131 tables. [Data catalog](../../catalogs/catalog-efile-v3_1.html)
* **Form 990-PF** (private foundations): 80 tables. [Data catalog](../../catalogs/catalog-efilepf-v3_1.html)

Every table is published for each tax year as CSV and Parquet. The [panel990](https://nonprofit-open-data-collective.github.io/panel990/) R package downloads tables and assembles multi-year panels with BMF organization fields attached.

**Data dictionaries (concordance990)**

<a class="btn -tertiary " href="https://nonprofit-open-data-collective.github.io/concordance990/articles/data-dictionary-990.html">
  <span>990 / 990-EZ (HTML)</span>
</a>
<a class="btn -tertiary " href="https://nonprofit-open-data-collective.github.io/concordance990/print/data-dictionary-990.pdf">
  <span>990 / 990-EZ (PDF)</span>
</a>
<a class="btn -tertiary " href="https://nonprofit-open-data-collective.github.io/concordance990/articles/data-dictionary-990pf.html">
  <span>990-PF (HTML)</span>
</a>
<a class="btn -tertiary " href="https://nonprofit-open-data-collective.github.io/concordance990/print/data-dictionary-990pf.pdf">
  <span>990-PF (PDF)</span>
</a>

Form 990 filings contain a wealth of information, including details about an organization's revenue, expenses, assets, liabilities, executive compensation, board members, mission statement, and descriptions of its programs and activities.

The Efile data are more comprehensive in terms of the fields available, but before 2021 they are more limited in terms of the organizations that appear. Until the 2021 tax year, electronic filing was voluntary for most nonprofits, except:

* Organizations with more than $10 million in assets
* Private foundations, for tax years beginning after July 1, 2019
* Small organizations filing the 990-N postcard (revenue under $50K), which is always electronic but is not part of this database

Adoption grew steadily because electronic filing is convenient, so the number of efilers increases across time (see the table below). E-filing became mandatory for almost all tax-exempt organizations beginning with the 2021 tax year (returns filed in 2022), so recent waves contain nearly all of the organizations in the NCCS Core data series, with many more variables available.

**E-filed returns by tax year and return type (efile_v3_1 and efilepf_v3_1, published 2026-10-09)**

![Stacked bar chart of e-filed returns per tax year, 2009 to 2025, by Form 990, 990-EZ and 990-PF](https://raw.githubusercontent.com/UrbanInstitute/nccs/main/_datasets/img/efile_count.png)

| Tax year |     990 |  990-EZ |  990-PF |   Total |
|:---------|--------:|--------:|--------:|--------:|
| 2009     |  33,311 |  15,470 |   2,345 |  51,126 |
| 2010     | 123,025 |  63,326 |  25,249 | 211,600 |
| 2011     | 159,504 |  82,048 |  34,597 | 276,149 |
| 2012     | 179,688 |  93,750 |  39,933 | 313,371 |
| 2013     | 198,855 | 104,375 |  45,887 | 349,117 |
| 2014     | 218,619 | 116,417 |  53,442 | 388,478 |
| 2015     | 233,519 | 124,894 |  58,815 | 417,228 |
| 2016     | 243,903 | 130,484 |  62,988 | 437,375 |
| 2017     | 261,612 | 139,145 |  68,950 | 469,707 |
| 2018     | 271,442 | 149,384 |  80,138 | 500,964 |
| 2019     | 283,694 | 152,623 |  87,789 | 524,106 |
| 2020     | 320,343 | 169,865 | 114,957 | 605,165 |
| 2021     | 336,489 | 202,729 | 119,354 | 658,572 |
| 2022     | 349,396 | 206,375 | 122,914 | 678,685 |
| 2023     | 359,351 | 208,863 | 125,565 | 693,779 |
| 2024     | 360,911 | 207,825 | 124,337 | 693,073 |
| 2025     | 102,869 | 103,732 |  67,525 | 274,126 |

The most recent tax year is always partial: returns are due months after the fiscal year ends, and it can take two to three years for the IRS to process and release most of them.

Because paper filers are absent before 2021, earlier waves are best suited to research that does not require the full population of filers. The larger the organization, the more likely it is to file electronically. Sample weights can be created by comparing efilers to the nonprofits in the BMF or Core files.

While most parts of Form 990 and its schedules are made available to the public, [some sensitive information is redacted by the IRS or nonprofits to protect the privacy of donors](https://www.adlercolvin.com/blog/2015/06/08/exempt-organizations-can-redact-donor-identifying-information-from-irs-form-990-schedule-b-before-public-disclosure/). 

Earlier releases remain available for reproducibility; see the version history in the [data catalog](../../catalogs/catalog-efile-v3_1.html#version-history).

<br>
<br>
<hr>
<br>
<br>
