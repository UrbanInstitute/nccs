---
title: 527 Political Action Committees
date: 2023-05-30 12:00:00
description: Electronic filings made by 527 organizations. 
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaCaption: "File size: 246kb"
primaryLinks:
  - text: "GitHub Repository"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/README.md"
  - text: "Data Dictionary"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/data-dictionary.md"
  - text: "Data Dictionary CSV"
    href: "https://nccsdata.s3.us-east-1.amazonaws.com/public/pac/tidy-data-dictionary.csv"
  - text: "R Program"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-527-political-action-committee-disclosures/blob/main/parse-pol-org-disclosures.R"
categories:
  - elections
  - campaign finance
  - 501c4
featured: true
featuredOrder: 4
---

## Political Nonprofits

Nonprofits with 527 status are organized primarily to "influence the selection, nomination, election, appointment or defeat of candidates to federal, state or local public office".

## Usage

```r
# 2023-05-POL-ORGS-FM-8871.csv  >>  Organization Information including Officers/Directors and Related Entities
# 2023-05-POL-ORGS-FM-8872.csv  >>  Political donations data 
# 2023-05-POL-ORGS-SCHED-A.csv
# 2023-05-POL-ORGS-SCHED-B.csv
# 2023-05-POL-ORGS-SCHED-D.csv
# 2023-05-POL-ORGS-SCHED-E.csv
# 2023-05-POL-ORGS-SCHED-R.csv 

# DATA PREVIEW

library( dplyr )
library( kableExtra )

URL <- "https://nccsdata.s3.us-east-1.amazonaws.com/public/pac/"
FILENAME <- "2023-05-POL-ORGS-FM-8871.csv"
d <- read.csv( paste0( URL, FILENAME ) )

keep <- c("ORGANIZATION_NAME", "EIN", "PURPOSE" )

k <- 
  d[keep] %>% 
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
<br>
<hr>
<br>


