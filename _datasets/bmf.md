---
title: Business Master File (BMF)
date: 2024-06-01
description: All active organizations that have been granted nonprofit status by the IRS.
categories:
  - BMF
  - sample-framework
  - metadata
featured: true
featuredOrder: 2
primaryCtaUrl: "https://nccsdata.s3.amazonaws.com/harmonized/bmf/unified/BMF_UNIFIED_V1.1.csv"
primaryCtaCaption: 1.3 GB
primaryLinks:
  - text: "Data Dictionary"
    href: "https://nccsdata.s3.amazonaws.com/harmonized/harmonized_data_dictionary.xlsx"
    icon: article
citation: 
  author: "Jesse Lecy"
  citationDate: "2024"
  container-title: "NCCS Unified BMF"
  doi:
---

## Unified BMF

The IRS releases a Business Master File every month which serves as the most recent and comprehensive record of tax exempt organizations in the United States. However, organizations that are no longer active are removed from each new BMF release.

To facilitate the easier creation of time-series panel data sets, NCCS has created a Unified BMF which aggregates all unique EINs (unique identification numbers for nonprofits) across every historic BMF data set into a single panel.

This Unified BMF contains all recorded exempt organizations between 1989 and 2024. The team is currently developing a research guide to accompany this BMF. While that effort is underway, we are releasing a beta version of the Unified BMF together with a rudimentary data dictionary. The link to downloading these files can be found in the sidebar of this page.

Users are encouraged to submit any questions and comments regarding this data set on our [contact page](https://nccs.urban.org/nccs/contact/).

## Version Roadmap

| Version | Release | Notes |
| :---: | :---: | :---: |
| 0.0 | June 21 2024 | Beta Version (Current) |
| 1.0 | July 4th 2024 | Research Guide Complete |
| 1.1 | July 18th 2024 | State-level Data Marts |

## BMF Overview

The IRS 990 Business Master File, often referred to as the "BMF," is a database maintained by the Internal Revenue Service (IRS) in the United States. It contains information about tax-exempt organizations and other entities that are required to file various forms of the IRS Form 990 series. These organizations include:

1. All 501(c)(3) charitable organizations, foundations, religious entities.
2. Social welfare organizations, civic leagues, and associations with status 501c4. 
3. Business leagues and associations: Such as chambers of commerce, trade associations, and other organizations eligible for tax-exempt status under section 501(c)(6).
4. Social clubs: Organizations that meet the criteria for tax-exempt status under section 501(c)(7) of the Internal Revenue Code.
5. Political organizations including entities that are tax-exempt under section 527, which includes political action committees (PACs).

The IRS 990 Business Master File contains key information about these organizations, including their legal names, addresses, EINs (Employer Identification Numbers), filing statuses, and the forms they have filed. This database helps the IRS and the public track and monitor the activities of tax-exempt organizations and ensures that they comply with the tax laws and regulations applicable to their specific tax-exempt status.

The BMF is the defacto sampling framework for many studies involving nonprofits as it contains the universe of all organizations that have been granted recognized tax exempt status by the IRS, remain active, and have filed required IRS 990 forms to remain in compliance with requirements about disclosure of activities and governance. The BMF does NOT include, however: 

* Organizations that are legal organizations incorporated and operating as nonprofits at the state level but have opted to not apply for formal tax-exempt status from the IRS.
* Some special categories of nonprofits such as churches and religious groups that are not required to seek formal recognition to exercise their tax-exempt status.
* Informal civic groups or social movements that are unincorporated, including organizations that are allowed to exercise nonprofit status through a fiscal sponsorship program under parent nonprofit.
* Some exceptional cases like 501(c)(4) organizations that opt to self-declare their intent to operate using Form 8976 instead of the typical application process with the IRS. They must file 990's to remain compliant, but since the IRS never formally rules on their status they do not appear in the BMF. 

Researchers, government agencies, journalists, and the general public often use the IRS 990 Business Master File to access information about nonprofit organizations, assess their financial health, and evaluate their compliance with tax regulations. The data in this file can provide valuable insights into the operations and finances of these entities. It's worth noting that while certain information from Form 990 filings is publicly available and can be accessed through the IRS website or other sources, sensitive information like donor names and addresses is typically redacted to protect privacy.