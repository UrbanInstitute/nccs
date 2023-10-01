---
title: 527 Political Action Committees
date: 2023-05-30 12:00:00
description: Electronic filings made by 527 organizations. 
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "GitHub Repository"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/README.md"
  - text: "Data Dictionary"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/data-dictionary.md"
  - text: "Data Dictionary CSV"
    href: "https://nccsdata.s3.us-east-1.amazonaws.com/public/pac/tidy-data-dictionary.csv"
  - text: "R Program"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/parse-pol-org-disclosures.R"
  - text: "Get Help"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/issues"
categories:
  - elections
  - campaign finance
  - 501c4
featured: true
featuredOrder: 4
---

## Political Nonprofits

Nonprofits with 527 status are organized primarily to "influence the selection, nomination, election, appointment or defeat of candidates to federal, state or local public office." In a post Citizen's United world where powerful interest groups seek new ways to assert political influence data on political nonprofits are more important than ever. 

Political Action Committees are formed when nonprofits, those typically incorporated with 501c4 status (as opposed to 501c3 charities) apply for 527 status by [completing Form 8871](https://www.irs.gov/charities-non-profits/political-organizations/political-organization-filing-and-disclosure). **POL-ORGS-FM-8871** and **POL-ORGS-SCHED-D**, **POL-ORGS-SCHED-E**, and **POL-ORGS-SCHED-R** all contain metadata and disclosures from the application process. They are static files describing organizations traits. 

Once recognized they are required to continue filing IRS 990 forms like typical nonprofits, but they are also required to complete [Form 8872 disclosures](https://www.irs.gov/charities-non-profits/political-organizations/political-organization-filing-and-disclosure) described in tables **POL-ORGS-FM-8872**, **POL-ORGS-SCHED-A**, and **POL-ORGS-SCHED-B**. 

The IRS regularly releases data on PAC activities described in Forms 8871 and 8872. Unfortunately, [data is released in complicated ASCII formats](https://forms.irs.gov/app/pod/dataDownload/dataDownload): data types are mixed by row and a small percentage of cases break the ASCII structure because of malformed data. To make this data available to the sector Jesse Lecy has written a parser to convert the raw files into well-structured tables. 

## Usage

```r
# 2023-05-POL-ORGS-FM-8871.csv  >>  drganization details
# 2023-05-POL-ORGS-FM-8872.csv  >>  political donations data 
# 2023-05-POL-ORGS-SCHED-A.csv  >>  
# 2023-05-POL-ORGS-SCHED-B.csv  >>
# 2023-05-POL-ORGS-SCHED-D.csv
# 2023-05-POL-ORGS-SCHED-E.csv
# 2023-05-POL-ORGS-SCHED-R.csv 

###
###   DATA PREVIEW
###

library( dplyr )
library( kableExtra )

FILENAME <- "2023-05-POL-ORGS-FM-8871.csv"
BASE.URL <- "https://nccsdata.s3.us-east-1.amazonaws.com/public/pac/"
d <- read.csv( paste0( BASE.URL, FILENAME ) )

keep <- c( )

k <- 
  d %>%
  select( ORGANIZATION_NAME, EIN, PURPOSE ) %>% 
  head() %>%  
  kable( format="html" ) %>%
  kable_material_dark()
```


<table class=" lightable-material-dark" style='font-family: "Source Sans Pro", helvetica, sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;"> ORGANIZATION_NAME </th>
   <th style="text-align:right;"> EIN </th>
   <th style="text-align:left;"> PURPOSE </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Dan Swecker for Senate Campaign </td>
   <td style="text-align:right;"> 912121950 </td>
   <td style="text-align:left;"> Tax exempt political organization - Political campaign </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FRIENDS OF TOM CALDERON </td>
   <td style="text-align:right;"> 954857244 </td>
   <td style="text-align:left;"> RAISE FUNDS TO ELECT CANDIDATE </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ASGM PAC </td>
   <td style="text-align:right;"> 61596525 </td>
   <td style="text-align:left;"> POLITICAL ACTION COMMITTEE TO PROMOTE LEGISLATION FAVORABLE TO WORKERS COMPENSATION SAFETY GROUPS IN NEW YORK STATE. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Comm to Elect Judge Robert Ross to Supreme Court </td>
   <td style="text-align:right;"> 113601603 </td>
   <td style="text-align:left;"> Committe to Elect Judge Robert Ross to the Supreme Court of the State of New York </td>
  </tr>
  <tr>
   <td style="text-align:left;"> CAMPAIGN TO RE ELECT BOB  MC CASLIN </td>
   <td style="text-align:right;"> 912082049 </td>
   <td style="text-align:left;"> SENATORIAL RE ELECTION CAMPAIGN </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rosanne Bader for Mt. SAC School Board </td>
   <td style="text-align:right;"> 330963550 </td>
   <td style="text-align:left;"> Promoting and fundraising for candidate for election to office </td>
  </tr>
</tbody>
</table>


<br>
<hr>
<br>

## Background 

For more information on 527 political organizations and other types of political activity in the nonprofit sector check out the following resources: 

<a class="btn -tertiary " href="https://bolderadvocacy.org/resource/comparison-of-501c3s-501c4s-and-political-527-organizations/">
  <span> LINK </span> </a>  Bolder Advocacy's useful taxonomy: **Comparison of 501(c)(3)s, 501(c)(4)s, and Political 527 Organizations**
  
<a class="btn -tertiary " href="https://journals.sagepub.com/doi/abs/10.1177/08997640211066495">
  <span> LINK </span> </a>  Post, M. A., Boris, E. T., & Stimmel, C. L. (2023). The advocacy universe: A methodology to identify politically active 501 (c)(4) organizations. Nonprofit and Voluntary Sector Quarterly, 52(1), 260-274.

|         |                                                                                          |
|:--------|:-----------------------------------------------------------------------------------------|
| <a class="btn -tertiary " href="https://journals.sagepub.com/doi/abs/10.1177/08997640211066495">
  <span> LINK </span> </a> | Post, M. A., Boris, E. T., & Stimmel, C. L. (2023). The advocacy universe: A methodology to identify politically active 501 (c)(4) organizations. Nonprofit and Voluntary Sector Quarterly, 52(1), 260-274. |
| <a class="btn -tertiary " href="https://journals.sagepub.com/doi/abs/10.1177/08997640211066495">
  <span> LINK </span> </a> | Post, M. A., Boris, E. T., & Stimmel, C. L. (2023). The advocacy universe: **A methodology** to identify politically active 501 (c)(4) organizations. Nonprofit and Voluntary Sector Quarterly, 52(1), 260-274. |

<a class="btn -tertiary " href="https://www.degruyter.com/document/doi/10.1515/npf-2021-0061/html">
  <span> LINK </span> </a>  Post, M. A., & Boris, E. T. (2022, December). Nonprofit Political Engagement: The Roles of 501 (c)(4) Social Welfare Organizations in Elections and Policymaking. In Nonprofit Policy Forum (Vol. 14, No. 2, pp. 131-155). De Gruyter.

<a class="btn -tertiary " href="https://lecy.github.io/political-ideology-of-nonprofits/">
  <span> REPLICATION FILES </span> </a>  Lecy, J. D., Ashley, S. R., & Santamarina, F. J. (2019). Do nonprofit missions vary by the political ideology of supporting communities? Some preliminary results. Public Performance & Management Review, 42(1), 115-141.

<a class="btn -tertiary " href="https://bolderadvocacy.org/resource/the-connection-strategies-for-creating-and-operating-501c3s-501c4s-and-political-organizations/">
  <span> LINK </span> </a>   Bolder Advocacy's excellent guide for nonprofits: **The Connection: Strategies for Creating and Operating 501(c)(3)s, 501(c)(4)s, and Political Organizations**





<br>
<br>
<hr>
<br>


