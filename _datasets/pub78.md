---
title: Pub78 - Nonprofits Eligible to Receive Tax Deductible Donations
date: 2023-05-27
description: The catalog of all nonprofits currently eligiable to receive tax-deductible donations. 
categories:
  - charities
  - 501c3
  - 'sampling framework'
featured: false
featuredOrder: 10
primaryCtaUrl: "https://nccsdata.s3.us-east-1.amazonaws.com/public/pub78/2023-10-CURRENT-EXEMPT-ORGS-DATABASE.csv"
primaryCtaCaption: "File size: 120MB"
primaryLinks:
  - text: "Data Dictionary"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-current-exempt-orgs-database#data-dictionary"
  - text: "GitHub Code"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-current-exempt-orgs-database"
  - text: "Raw IRS Data"
    href: "https://www.irs.gov/charities-non-profits/tax-exempt-organization-search-bulk-data-downloads"
  - text: "Tax Exempt Organization Search"
    href: "https://apps.irs.gov/app/eos/"
author:
- id: jdl
citation: 
  author: "Choi. Y & Lee, Y."
  container-title: "Ednel: A large – scale hierarchical dataset in education"
  doi: 10.5555/12345678
---

## Overview

IRS Publication 78 (Pub78) is a publicly available list maintained by the Internal Revenue Service (IRS) in the United States. This list identifies organizations that have been granted tax-exempt status under section 501(c)(3) of the Internal Revenue Code. It is a catalog of charities and nonprofit organizations that are eligible to receive tax-deductible donations.

Pub78 serves as a valuable resource for those involved in the world of philanthropy, tax planning, nonprofit management, or researchers. It helps ensure that donations are directed toward legitimate and tax-deductible causes while providing transparency in the nonprofit sector. It promotes trust in the sector by making it easy for sector stakeholders to verify deductability requirements: 

**Citizen Donors:** Individuals and businesses who donate to organizations listed in Publication 78 may be eligible for tax deductions. These deductions can reduce the taxable income of the donor, potentially resulting in lower tax liability.

**Grantmakers:** Foundations and grant-making institutions often refer to Publication 78 to confirm the tax-exempt status of potential grantees. This ensures that their funds are used for charitable purposes.

**Researchers:** Academics, policymakers, and philanthropic organizations may use this list to assess the legitimacy and transparency of nonprofit organizations. It helps in due diligence when evaluating the effectiveness and trustworthiness of charitable organizations.

**Regulators:** For IRS compliance purposes, organizations listed in Publication 78 must meet specific criteria and follow tax regulations. Research related to nonprofit compliance or tax law may involve consulting this list.

## Limitations 

Publication 78 is an example of "instantaneous" IRS dataset, which means it contains the list of nonprofits that are currently eligible to receive tax deductible donations. Organizations that lose status are removed from the list, but no history is provided of organizations that have been on the list in the past.

It is also incomplete a few important ways: 

* Nonprofits that are part of affiliate structures and file joint 990s will not appear in Pub78, even though they have a unique EIN and may operate independently (affiliation structures vary greatly from coalition to franchise to chapter models). Only the parent organization will appear in Pub78, even though all affiliates are also eligible to receive tax-deductible donations.
* Many churches and religious groups are de facto eligible to receive tax deductible donations but have not formally registered with the IRS, and thus would not appear in Pub78.
* Nonprofits often use an informal or updated name (often called their "doing business as" DBA or a "sort code"), which may differ from their official name in the IRS database. If you do not know their EIN it may be hard to locate the correct organization in the database.  

## Usage 

```r
###
###   DATA PREVIEW
###

library( dplyr )
library( kableExtra )

FILENAME <- "2023-10-CURRENT-EXEMPT-ORGS-DATABASE.csv"
BASE.URL <- "https://nccsdata.s3.us-east-1.amazonaws.com/public/pub78/"
d <- read.csv( paste0( BASE.URL, FILENAME ) )

d %>%
  head() %>%  
  kbl() %>%
  kable_minimal()
```

<!--

To get HTML table to copy into this page: 

k <- 
  d %>%
  head() %>%  
  kbl() %>%
  kable_minimal()

cat(k) 

-->

<table class=" lightable-minimal" style='font-family: "Trebuchet MS", verdana, sans-serif; font-size: 12; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:right;"> ein </th>
   <th style="text-align:left;"> legal_name </th>
   <th style="text-align:left;"> city </th>
   <th style="text-align:left;"> state </th>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> deductibility_status </th>
   <th style="text-align:left;"> ID </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 587764 </td>
   <td style="text-align:left;"> Iglesia Bethesda Inc. </td>
   <td style="text-align:left;"> Lowell </td>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:left;"> United States </td>
   <td style="text-align:left;"> PC </td>
   <td style="text-align:left;"> ID-000587764 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 635913 </td>
   <td style="text-align:left;"> Ministerio Apostolico Jesucristo Es El Senor Inc. </td>
   <td style="text-align:left;"> Lawrence </td>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:left;"> United States </td>
   <td style="text-align:left;"> PC </td>
   <td style="text-align:left;"> ID-000635913 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 765634 </td>
   <td style="text-align:left;"> Mercy Chapel International </td>
   <td style="text-align:left;"> Mattapan </td>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:left;"> United States </td>
   <td style="text-align:left;"> PC </td>
   <td style="text-align:left;"> ID-000765634 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 841363 </td>
   <td style="text-align:left;"> Agape House of Prayer </td>
   <td style="text-align:left;"> Mattapan </td>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:left;"> United States </td>
   <td style="text-align:left;"> PC </td>
   <td style="text-align:left;"> ID-000841363 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 852649 </td>
   <td style="text-align:left;"> Bethany Presbyterian Church </td>
   <td style="text-align:left;"> Brookline </td>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:left;"> United States </td>
   <td style="text-align:left;"> PC </td>
   <td style="text-align:left;"> ID-000852649 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 889899 </td>
   <td style="text-align:left;"> Academic and Behavioral Clinic Inc. </td>
   <td style="text-align:left;"> Boston </td>
   <td style="text-align:left;"> MA </td>
   <td style="text-align:left;"> United States </td>
   <td style="text-align:left;"> PC </td>
   <td style="text-align:left;"> ID-000889899 </td>
  </tr>
</tbody>
</table>


<br>
<br>
<hr>
<br>
<br>




