---
title: 527 Political Action Committees
date: 2023-05-30 12:00:00
description: Electronic filings made by 527 organizations. 
primaryCtaUrl: "../../catalogs/catalog-pacs.html"
primaryCtaCaption: "Includes data dictionaries"
primaryLinks:
  - text: "GitHub Repository"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/README.md"
    icon: github
  - text: "R Scripts"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/parse-pol-org-disclosures.R"
    icon: r
  - text: Data Dictionary
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/data-dictionary.md"
    icon: github
categories:
  - elections
  - campaign finance
  - 501c4
featured: true
featuredOrder: 5
author:
- id: eboris 
- id: mpost
- id: jlecy  
citation: 
  author: "Lecy, J.D. (2023)."
  container-title: "Nonprofit Political Action Committee (PAC) Data: Parsing IRS 8871 and 8872 ASCII Files."
---

 

 

## Political Nonprofits

Nonprofits with 527 status are [primarily established](https://www.irs.gov/charities-non-profits/political-organizations) to “influence the selection, nomination, election, appointment or defeat of candidates to federal, state or local public office.”  In the post–Citizen's United era, where powerful interest groups are seeking new ways to assert political influence, data related to these political nonprofits have become more important than ever.

Political action committees often emerge when nonprofits, typically incorporated with 501(c)(4) status (as opposed to 501(c)(3) charities), apply for 527 status. This application process is documented in forms such as [completing Form 8871](https://www.irs.gov/charities-non-profits/political-organizations/political-organization-filing-and-disclosure). **POL-ORGS-FM-8871** and **POL-ORGS-SCHED-D**, **POL-ORGS-SCHED-E**, and **POL-ORGS-SCHED-R** all contain metadata and disclosures from the application process. These documents are static files describing the characteristics of these organizations.

Once recognized, these political nonprofits are required to continue filing IRS 990 forms, similar to typical nonprofits. But they are also required to submit [Form 8872 disclosures](https://www.irs.gov/charities-non-profits/political-organizations/political-organization-filing-and-disclosure) which are described in tables like **POL-ORGS-FM-8872**, **POL-ORGS-SCHED-A**, and **POL-ORGS-SCHED-B**. 

The IRS regularly releases data on PAC activities,  as documented in Forms 8871 and 8872. Unfortunately, the [data are released in complicated ASCII formats](https://forms.irs.gov/app/pod/dataDownload/dataDownload). These files can be challenging to work with because of mixed data types within rows and occasionally data irregularities that break the ASCII structure. To make these data available to the sector, Jesse Lecy has developed a parser to transform these raw files into well-structured tables. 

## Usage

```r
# 2023-05-POL-ORGS-FM-8871.csv  >>  organization details
# 2023-05-POL-ORGS-SCHED-D.csv  >>  director and officer information
# 2023-05-POL-ORGS-SCHED-E.csv  >>  election authority IDs 
# 2023-05-POL-ORGS-SCHED-R.csv  >>  related entities records

# 2023-05-POL-ORGS-FM-8872.csv  >>  required annual disclosures 
# 2023-05-POL-ORGS-SCHED-A.csv  >>  individual donations
# 2023-05-POL-ORGS-SCHED-B.csv  >>  organizational donations 


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


<table class=" lightable-material-dark" style='font-family: "Source Sans Pro", helvetica, sans-serif; margin-left: auto; margin-right: auto; font-size: 12px'>
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

|         |                                                                                          |
|:--------|:-----------------------------------------------------------------------------------------|
| <a class="btn -tertiary " href="https://bolderadvocacy.org/resource/comparison-of-501c3s-501c4s-and-political-527-organizations/"> LINK </a>  | <span style="font-family:Times New Roman; font-size:12;"> Bolder Advocacy's useful taxonomy: "**Comparison of 501(c)(3)s, 501(c)(4)s, and Political 527 Organizations**"  </span>|  
| <a class="btn -tertiary " href="https://journals.sagepub.com/doi/abs/10.1177/08997640211066495"> LINK </a>  | <span style="font-family:Times New Roman; font-size:12;">  Post, M. A., Boris, E. T., & Stimmel, C. L. (2023). The advocacy universe: A methodology to identify politically active 501 (c)(4) organizations. _Nonprofit and Voluntary Sector Quarterly_, 52(1), 260-274. [https://doi.org/10.1177/08997640211066495](https://doi.org/10.1177/08997640211066495). </span>  |    
| <a class="btn -tertiary " href="https://www.degruyter.com/document/doi/10.1515/npf-2021-0061/html"> LINK </a>   | <span style="font-family:Times New Roman; font-size:12;"> Post, M. A., & Boris, E. T. (2022, December). Nonprofit Political Engagement: The Roles of 501 (c)(4) Social Welfare Organizations in Elections and Policymaking. _In Nonprofit Policy Forum_ (Vol. 14, No. 2, pp. 131-155).[https://doi.org/10.1515/npf-2021-0061](https://doi.org/10.1515/npf-2021-0061). </span> |
| <a class="btn -tertiary " href="https://bolderadvocacy.org/resource/the-connection-strategies-for-creating-and-operating-501c3s-501c4s-and-political-organizations/"> LINK </a>  | <span style="font-family:Times New Roman; font-size:12;">  Bolder Advocacy's excellent guide for nonprofits: ***The Connection: Strategies for Creating and Operating 501(c)(3)s, 501(c)(4)s, and Political Organizations*** </span> | 


### Related Topics 

|         |                                                                                          |
|:--------|:-----------------------------------------------------------------------------------------|
| <a class="btn -tertiary " href="https://osf.io/huz3c/"> REPLICATION FILES </a>  |  <span style="font-family:Times New Roman; font-size:12;"> Han, B., Ho, B., & Xia, Z. (2023). Political ideology of nonprofit organizations. ***Social Science Quarterly***. <https://doi.org/10.1111/ssqu.13309>.  </span> |
| <a class="btn -tertiary " href="https://lecy.github.io/political-ideology-of-nonprofits/"> REPLICATION FILES </a>  | <span style="font-family:Times New Roman; font-size:12;"> Lecy, J. D., Ashley, S. R., & Santamarina, F. J. (2019). Do nonprofit missions vary by the political ideology of supporting communities? Some preliminary results. _Public Performance & Management Review_, 42(1), 115-141.<https://doi.org/10.1080/15309576.2018.1526092> </span> |

<br>
<br>
<br>
<br>

