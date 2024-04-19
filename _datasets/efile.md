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
primaryCtaUrl: "../../catalogs/catalog-efile.html"
primaryCtaCaption:
primaryLinks:
  - text: "R Package"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs990efile"
    icon: r
author:
- id: jlecy
citation: 
  author: "Jesse Lecy"
  citationDate: "2023"
  container-title: "NCCS IRS 990 Efile Data"
  doi:
---

The IRS 990 Electronic Filing (Efile) Database refers to a collection of Form 990 documents submitted by tax-exempt organizations starting in 2012. Whereas the NCCS Core data series is more comprehensive in terms of organizations in the dataset (all paper + electronic filers), the Efile database provides the most comprehensive financial and operational information about the organization's activities, governance, and finances.

In 2015 the IRS began releasing Efile data containing almost all of the Form 990 + Schedule fields submitted by nonprofits, which greatly increased availability of the data on nonprofits. Previously most public nonprofit databases like the NCCS Core files were limited to the few dozen financial variables that were released through the IRS SOI Extract tables. The Efile database, in contrast, consists of millions of files containing individual returns that include over 2,000 fields from the 990 forms and schedules. 

The data is shared in XML formats that are challenging to use. NCCS provides a version that has been converted into a relational database with 126 distinct tables that reflect the discrte Parts represented on Form 990 and Schedules.  

<a class="btn -tertiary " href="https://nonprofit-open-data-collective.github.io/irs990efile/data-dictionary/data-dictionary.html">
  <span>DATA DICTIONARY</span>
</a>

The Efile Data is more comprehensive in terms of the fields that are available, but it is more limited in terms of organizations that appear in the database. Up until 2023 electronic filing was voluntary for most nonprofits. There was rapid adoption because electronic filing is convenient, but it took some time for nonprofits to adapt and transition from paper filings. As a result, you see a steady increase in the number of efilers across time:   

**990 Efile Returns by Form Type and Tax Year**

|     |    990|  990EZ|  990PF|  990T|
|:----|------:|------:|------:|-----:|
|2009 |  33311|  15470|   2345|     0|
|2010 | 123026|  63326|  25249|     0|
|2011 | 159504|  82048|  34597|     0|
|2012 | 179688|  93750|  39933|     0|
|2013 | 198856| 104375|  45887|     0|
|2014 | 218620| 116417|  53442|     0|
|2015 | 233520| 124894|  58815|     0|
|2016 | 243903| 130485|  62988|     0|
|2017 | 261612| 139146|  68950|     0|
|2018 | 271442| 149384|  80138|     0|
|2019 | 283649| 152579|  87773|     0|
|2020 | 318850| 169296| 114605| 22616|
|2021 | 319445| 192642| 116404| 22469|
|2022 | 158730| 135775|  81631|  7154|

Form 990 filings contain a wealth of information, including details about an organization's revenue, expenses, assets, liabilities, executive compensation, board members, mission statement, and descriptions of its programs and activities. 

While most parts of Form 990 and Schedules are made available to the public, some sensitive information is redacted to protect the privacy of donors.

Due to the absense of paper filers in this data series it is recommended for research that does not require the full population of filers. The larger the organization is the more likely they are to file electronically. Sample weights can be created by comparing efilers to the nonprofits in the BMF or Core files.  



<br>
<br>
<hr>
<br>
<br>
