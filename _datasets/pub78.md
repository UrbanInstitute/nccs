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
    icon: github
  - text: "GitHub Repository"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-current-exempt-orgs-database"
    icon: github
  - text: "Raw IRS Data"
    href: "https://www.irs.gov/charities-non-profits/tax-exempt-organization-search-bulk-data-downloads"
    icon: link
  - text: "IRS Tax Exempt Organization Search"
    href: "https://apps.irs.gov/app/eos/"
    icon: link
author:
- id: jlecy
citation: 
  author: "Lecy, JD"
  citationDate: 2023
  container-title: "NCCS Pub78 Database"
---

## Overview

IRS Publication 78 (Pub78) is a publicly available list maintained by the United States Internal Revenue Service (IRS). This list identifies organizations granted tax-exempt status under section 501(c)(3) of the Internal Revenue Code. Pub78 is a catalog of charities and nonprofit organizations eligible for tax-deductible donations.

Pub78 holds significant value for those involved in philanthropy, tax planning, nonprofit management, or research. It helps ensure that donations are directed toward legitimate and tax-deductible causes while providing transparency in the nonprofit sector. The publication fosters trust in the sector by simplifying the verification of deductibility requirements for stakeholders. The stakeholders include the following:

 •	**Citizen donors**: Individuals and businesses that donate to organizations listed in Publication 78 may be eligible for tax deductions. These deductions can reduce the donor’s taxable income, potentially reducing tax liability.

 •	**Grantmakers**: Foundations and grantmaking institutions often refer to Publication 78 to confirm the tax-exempt status of potential grantees. This ensures they are channeling funds toward charitable purposes.

 •	**Researchers**: Academics, policymakers, and philanthropic organizations may use this list to assess nonprofit organizations' legitimacy and transparency. It aids in conducting due diligence when evaluating the effectiveness and trustworthiness of charitable organizations.

 •	**Regulators**: For IRS compliance purposes, organizations listed in Publication 78 must meet specific criteria and adhere to tax regulations. Research related to nonprofit compliance or tax law may involve consulting this list.

## Limitations 

Publication 78 is an example of an “instantaneous” IRS dataset, which contains the current list of nonprofits eligible to receive tax-deductible donations. Organizations that lose their tax-exempt status are removed from the list, but it doesn’t provide any historical data about organizations that were previously on the list. 

Publication 78 has some notable limitations:

 •	**Incomplete representation of affiliated nonprofits**: Nonprofits that are part of affiliate structures and file joint 990s will not appear in Pub78. Even though these affiliates have unique Employer Identification Numbers (EINs) and may operate independently, only the parent organizations will appear in Pub78. Affiliation structures vary greatly from coalition to franchise to chapter models, and all affiliates are also eligible to receive tax-deductible donations.
 
 •	**Unregistered religious groups**: Many churches and religious groups are de facto eligible to receive tax-deductible donations but may not have formally registered with the IRS. Consequently, they would not appear in Pub78.
 
•	**Challenges in identifying nonprofits**: Nonprofits often use informal or updated names, commonly referred to as their “doing business as” (DBA) or a “sort code.” These names may differ from their official names in the IRS database. If you do not know its EIN, locating the correct organization in the database can be challenging.

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


## Deductability Code Meaning

From the IRS website and [Publication 526](https://www.irs.gov/forms-pubs/about-publication-526):

*In general, an individual who itemizes deductions may deduct contributions to most charitable organizations up to 50% (60% for cash contributions) of his or her adjusted gross income computed without regard to net operating loss carrybacks. Individuals generally may deduct charitable contributions to other organizations up to 30% of their adjusted gross income (computed without regard to net operating loss carrybacks). These limitations (and organizational status) are indicated as follows:*

| **Code** | **Type of organization and use of contribution.**                                                                                                                                                                                                                                                                    | **Deductibility Limitation**     |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| PC       | A public charity.                                                                                                                                                                                                                                                                                                    | 50% (60% for cash contributions) |
| POF      | A private operating foundation.                                                                                                                                                                                                                                                                                      | 50% (60% for cash contributions) |
| PF       | A private foundation.                                                                                                                                                                                                                                                                                                | 30% (generally)                  |
| GROUP    | Generally, a central organization holding a group exemption letter, whose subordinate units covered by the group exemption are also eligible to receive tax-deductible contributions, even though they are not separately listed.                                                                                    | Depends on various factors       |
| LODGE    | A domestic fraternal society, operating under the lodge system, but only if the contribution is to be used exclusively for charitable purposes.                                                                                                                                                                      | 30%                              |
| UNKWN    | A charitable organization whose public charity status has not been determined.                                                                                                                                                                                                                                       | Depends on various factors       |
| EO       | An organization described in section 170(c) of the Internal Revenue Code other than a public charity or private foundation.                                                                                                                                                                                          | Depends on various factors       |
| FORGN    | A foreign-addressed organization. These are generally organizations formed in the United States that conduct activities in foreign countries. Certain foreign organizations that receive charitable contributions deductible pursuant to treaty are also included, as are organizations created in U.S. possessions. | Depends on various factors       |
| SO       | A Type I, Type II, or functionally integrated Type III supporting organization.                                                                                                                                                                                                                                      | 50% (60% for cash contributions) |
| SONFI    | A non-functionally integrated Type III supporting organization.                                                                                                                                                                                                                                                      | 50% (60% for cash contributions) |
| SOUNK    | A supporting organization, unspecified type.                                                                                                                                                                                                                                                                         | 50% (60% for cash contributions) |


*Contributions must actually be paid in cash or other property before the close of an individual's tax year to be deductible for that tax year, whether the individual uses the cash or accrual method.*

*If an individual donates property other than cash to a qualified organization, the individual may generally deduct the fair market value of the property. If the property has appreciated in value, however, some adjustments may have to be made.*

*The rules relating to how to determine fair market value are discussed in Publication 561, Determining the Value of Donated Property. For a more comprehensive discussion of the rules covering income tax deductions for charitable contributions by individuals, see Publication 526, Charitable Contributions.*

<br>
<br>
<hr>
<br>
<br>




