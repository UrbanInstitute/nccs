---
title: Form 990-N ePostcard Filers
date: 2023-05-27
description: A database of small nonprofits that do not file full 990 forms. 
categories:
  - 990N
  - grassroots
  - orgs
featured: false
primaryCtaUrl: "https://nccsdata.s3.us-east-1.amazonaws.com/raw/e-postcard/2023-09-E-POSTCARD.csv"
primaryCtaCaption: "File size: 330MB"
primaryLinks:
  - text: "GitHub Repository"
    href: "https://github.com/Nonprofit-Open-Data-Collective/irs-990n-postcard-filers"
    icon: github
author:
- id: jlecy
- id: esearing
citation: 
  author: "Lecy, JD"
  citationDate: 2023
  container-title: "NCCS Form 990-N(e-Postcard) Filers Database"
---


## About 

Nonprofits that file IRS Form 990-N, also known as the “e-Postcard,” are typically small tax-exempt organizations. Form 990-N is the simplest and least detailed of the annual information returns required by the IRS. It is intended for organizations with relatively modest gross receipts. Here’s what characterizes nonprofits that typically file Form 990-N:

  * **Small Revenue:** These nonprofits usually have annual gross receipts of $50,000 or less. Gross receipts include all income, donations, grants, and other funds received during the fiscal year.
  * **Exempt from Filing Form 990, 990EZ, not 990PF:** These organizations are generally exempt from filing the more detailed Forms 990 or 990-EZ, required for larger nonprofits. Form 990-N provides a simplified way to report basic financial and operational information. Private foundations, regardless of their size, are required to file Form 990PF and cannot use the convenient e-postcard version. A small group of specialized nonprofits, such as hospitals, are also required to file the full 990, regardless of size.
  * **Typical Types of 990-N Filers:** The nonprofits that often use Form 990-N include community-based organizations, small local charities, volunteer groups, clubs, and similar entities. Examples might include small youth sports teams, local animal shelters, or neighborhood associations.
  * **Limited Reporting:** Form 990-N is very basic and requires minimal reporting. Organizations typically need to provide their contact information, confirm their tax-exempt status, and state whether they've had any gross receipts during the reporting year.
  * **It Meets the Annual Filing Requirement:** Even though it's a simplified form, eligible organizations must file Form 990-N annually to maintain their tax-exempt status. Failure to file for three consecutive years can lead to automatic revocation of tax-exempt status.

For larger nonprofits with gross receipts above $50,000 but below $200,000 (or total assets below $500,000), Form 990-EZ can be used. It provides more detailed financial information than Form 990-N but is still less comprehensive than the full Form 990.

The ePostcard 990-N database is an instantaneous database. This means it only contains data from the organizations’ most recent 990-N filing and doesn’t provide a historic record of every year filed. An organization may appear in the dataset with the most recent filing dated several years ago, but it is likely still in compliance with annual filing requirements if it has since graduated to filing form 990EZ or the full 990.

## Use

```r
library( dplyr )
library( kableExtra )

BASE.URL <- "https://nccsdata.s3.us-east-1.amazonaws.com/raw/e-postcard/"
FILE     <- "2023-09-E-POSTCARD.csv" 
d <- read.csv( paste0( BASE.URL, FILE ) )

preview1 <- 
  c("ein", "legal_name", "tax_year",  "gross_receipts_under_25000", 
    "terminated", "tax_period_begin_date", "tax_period_end_date" )

d %>%
  select( preview1 ) %>%
  head() %>%  
  kbl() %>%
  kable_styling( 
    bootstrap_options = "striped", 
    full_width = F,
    font_size = 10, 
    position = "left" )
```

<table class="table table-striped" style="font-size: 10px; width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:right;"> ein </th>
   <th style="text-align:left;"> legal_name </th>
   <th style="text-align:right;"> tax_year </th>
   <th style="text-align:left;"> gross_receipts_under_25000 </th>
   <th style="text-align:left;"> terminated </th>
   <th style="text-align:left;"> tax_period_begin_date </th>
   <th style="text-align:left;"> tax_period_end_date </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 10002847 </td>
   <td style="text-align:left;"> HULLS COVE NEIGHBORHOOD ASSOCIATION </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 01-01-2022 </td>
   <td style="text-align:left;"> 12-31-2022 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10019709 </td>
   <td style="text-align:left;"> ANCIENT FREE &amp; ACCEPTED MASONS OF MAINE </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 01-01-2022 </td>
   <td style="text-align:left;"> 12-31-2022 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10027415 </td>
   <td style="text-align:left;"> ANCIENT FREE &amp; ACCEPTED MASONS OF MAINE </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 04-01-2022 </td>
   <td style="text-align:left;"> 03-31-2023 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10052240 </td>
   <td style="text-align:left;"> CUMBERLAND BAR ASSOCIATION </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 01-01-2022 </td>
   <td style="text-align:left;"> 12-31-2022 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10056995 </td>
   <td style="text-align:left;"> NATIONAL KITCHEN &amp; BATH ASSO </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 01-01-2022 </td>
   <td style="text-align:left;"> 12-31-2022 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10067817 </td>
   <td style="text-align:left;"> INDEPENDENT ORDER OF ODD FELLOWS </td>
   <td style="text-align:right;"> 2022 </td>
   <td style="text-align:left;"> TRUE </td>
   <td style="text-align:left;"> FALSE </td>
   <td style="text-align:left;"> 01-01-2022 </td>
   <td style="text-align:left;"> 12-31-2022 </td>
  </tr>
</tbody>
</table>

```r
preview2 <- 
  c("officer_name", "officer_zip", 
    "organization_address_line_1", 
    "organization_city", "organization_state", 
    "organization_zip" )

d %>%
  select( preview2 ) %>%
  head() %>%  
  kbl() %>%
  kable_styling( 
    bootstrap_options = "striped", 
    full_width = F,
    font_size = 10, 
    position = "left" )
```



<table class="table table-striped" style="font-size: 10px; width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;"> officer_name </th>
   <th style="text-align:left;"> officer_zip </th>
   <th style="text-align:left;"> organization_address_line_1 </th>
   <th style="text-align:left;"> organization_city </th>
   <th style="text-align:left;"> organization_state </th>
   <th style="text-align:left;"> organization_zip </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Joanne Sousa </td>
   <td style="text-align:left;"> 04644 </td>
   <td style="text-align:left;"> 6 Neighborhood Way </td>
   <td style="text-align:left;"> Hulls Cove </td>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:left;"> 04644 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Lee Oliver </td>
   <td style="text-align:left;"> 04730 </td>
   <td style="text-align:left;"> PO Box 1348 </td>
   <td style="text-align:left;"> Houlton </td>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:left;"> 04730 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> William Bruns </td>
   <td style="text-align:left;"> 04915 </td>
   <td style="text-align:left;"> 17 Wight St </td>
   <td style="text-align:left;"> Belfast </td>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:left;"> 04915 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Jennifer Lechner </td>
   <td style="text-align:left;"> 04032 </td>
   <td style="text-align:left;"> PO Box 434 </td>
   <td style="text-align:left;"> Freeport </td>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:left;"> 04032 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bonnie L Ferreira </td>
   <td style="text-align:left;"> 04064 </td>
   <td style="text-align:left;"> 161 Saco Ave </td>
   <td style="text-align:left;"> Old Orchard Beach </td>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:left;"> 04064 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Michael Anderson </td>
   <td style="text-align:left;"> 04210 </td>
   <td style="text-align:left;"> 80 Caron Lane </td>
   <td style="text-align:left;"> Auburn </td>
   <td style="text-align:left;"> ME </td>
   <td style="text-align:left;"> 04210 </td>
  </tr>
</tbody>
</table>

## Coverage 

As of the fall of 2023, the database includes a single filing from more than 1.3 million organizations.

The dataset contains the most recent ePostcard filing made by each organization in the dataset. If an organization no longer appears in the dataset it could mean one of the following: 

  *	Revoked status: Its tax-exempt status has been revoked. You can verify this by checking the revocations database. 
  *	Noncompliance: It is not complying with the filing requirements, and its tax-exempt status is likely to be revoked shortly. 
  *	Graduation to the 990EZ or full 990 forms: You can confirm this by checking the Core data series.

The last available observations for organizations occur in the following periods:

```r
table( d$tax_year ) %>% 
  kbl( col.names=c("YEAR","N") ) %>%
  kable_styling( 
    bootstrap_options = "striped", 
    full_width = F, 
    position = "left" )
```

<table class="table table-striped" style="width: auto !important; ">
 <thead>
  <tr>
   <th style="text-align:left;"> YEAR </th>
   <th style="text-align:right;"> N </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2007 </td>
   <td style="text-align:right;"> 25087 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008 </td>
   <td style="text-align:right;"> 26965 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009 </td>
   <td style="text-align:right;"> 42551 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010 </td>
   <td style="text-align:right;"> 28993 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011 </td>
   <td style="text-align:right;"> 32475 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012 </td>
   <td style="text-align:right;"> 31902 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013 </td>
   <td style="text-align:right;"> 37477 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014 </td>
   <td style="text-align:right;"> 41687 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015 </td>
   <td style="text-align:right;"> 36650 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016 </td>
   <td style="text-align:right;"> 42544 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 44675 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 </td>
   <td style="text-align:right;"> 49168 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2019 </td>
   <td style="text-align:right;"> 55926 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2020 </td>
   <td style="text-align:right;"> 97757 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2021 </td>
   <td style="text-align:right;"> 270745 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2022 </td>
   <td style="text-align:right;"> 459302 </td>
  </tr>
</tbody>
</table>


<br>
<br>
<hr>
<br>
<br>
