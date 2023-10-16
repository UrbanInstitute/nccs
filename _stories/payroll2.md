---
title: Payroll Taxes V2
date: 2023-08-28
description: This data story outlines the process for estimating the amount of payroll taxes nonprofits pay annually.
featured: true
featuredOrder: 1
type: methods
categories:
  - SOI extracts
  - payroll tax
author:
  - id: hmartin
  - id: jlecy
citation: 
  container-title: National Center for Charitable Statistics
  volume: 1
  issue: 1
  doi: 10.5555/12345678
links:
  - header: Replication Files
    links:  
    - text: Data + Code
      href: https://tinyurl.com/ylydvtj9
      icon: download
    - text: Code
      href: https://raw.githubusercontent.com/UrbanInstitute/nccs-recipes/main/vignettes/payroll.R
      icon: link
  - header: In Context 
    links:
    - text: Nonprofit Infrastructure Coalition 
      href: https://independentsector.org/wp-content/uploads/2023/04/nic-agenda-2023.pdf
      icon: download
---

The nonprofit sector must persistently track programs and activities in
order to measure societal benefits and convey impact to key
stakeholders. This research note introduces an uncommon but useful
approach to measuring sector size though payroll tax information
disclosed on IRS form 990s.

Researchers commonly use counts of nonprofits or total program expenses
to measure sector size. Alternatively payroll captures the mobilization
of human resources, a complementary way to convey the depth of
engagement within communities.

Historically, payroll data has been a difficult to acquire. Partnerships
between nonprofit scholars and the Bureau of Labor Statistics have
resulted in new methodologies for using the Quarterly Census of
Employment and Wages to measure the size of the nonprofit workforce, but
QCEW data on nonprofits is currently only updated once every five years.
Payroll tax information on 990 forms is more accessible and timely.

Although nonprofits are exempt from many types of taxes they are still
required to pay federal payroll taxes. These include a 6.2% Social
Security tax and 1.45% for Medicare. Taxes are levied for both part and
full-time employees. The aggregate level of payroll taxes paid by the
sector can be used as a proxy for the number of full-time equivalent
workers employed by the sector.

We estimate that nonprofits currently pay approximately \$66 billion per
year in payroll taxes. See the full data vignette for details about how
we arrive at this estimate.

<br> 

<a class="btn -tertiary " href="https://urbaninstitute.github.io/nccs-recipes/vignettes/payroll.html" target="_blank">
DATA VIGNETTE </a>

<br>
<hr>
<br>

### Form 990 Data

We estimate the payroll taxes that the nonprofit sector contributes
annually using 2019 IRS 990 data, the most recent full year of available
data at the time the analysis was conducted.

Three years of IRS 990 data extracts must be utilized to capture a
single full year of data since there can be a 2-year lag in returns,
resulting in an idiosyncratic data aggregation challenge. Form 990 data
is compiled from the 2019, 2020, and 2021 Statistics of Income Extract
files available through the IRS:
<https://www.irs.gov/statistics/soi-tax-stats-annual-extract-of-tax-exempt-organization-financial-data>.

### Sampling Considerations

Data availability varies greatly by the size of the nonprofit. Larger
nonprofits are required to file the full Form 990, which requires
significant disclosures on programs and finances. Medium-sized
nonprofits file a more compact version of the form called the 990EZ, and
small nonprofits are only required to report that they remain active by
filing Form 990N. Private foundations utilize the 990-PF. Payroll
information disclosures vary by the type of form.

***Larger Nonprofits:*** The Form 990 collects data on the amount of
payroll taxes that larger nonprofits (i.e., those with gross receipts
\>= \$200K or total assets \>= \$500K) contribute (**\$55B in 2019**).

***Private foundations:*** The Form 990-PF does not collect data on the
amount of payroll taxes that private foundations contribute However, it
does collect data on the amount that private foundations spend on
salaries and benefits (\$3B). The Form 990 collects this data for larger
nonprofits, as well. Therefore, we can divide the amount of payroll
taxes that larger nonprofits contribute by the amount that larger
nonprofits spend on payroll taxes to calculate a payroll tax/salaries
and benefits ratio (5.75%). We can then apply that ratio to the salaries
and benefits data from the Form 990-PF to estimate the amount of payroll
taxes that private foundations contribute.

However, the IRS’s Form 990-PF data extract only includes the columns
with data on “compensation of officers, directors, trustees, etc.” and
“pension plans, employee benefits;” it excludes the column with data on
“other employee salaries and wages.” Therefore, we will underestimate
the amount of payroll taxes that private foundations contribute.
Additionally, the IRS does not provide a data extract for the 2019 Form
990-PF file. This creates a further underestimation of the amount of
payroll taxes that private foundations contribute (**estimated \$153M in
2019**).

***Smaller Nonprofits:*** The Form 990-EZ does not collect data on the
amount of payroll taxes that smaller nonprofits (i.e., those with gross
receipts \<\$200K and total assets \<\$500K) contribute It does collect
data on the amount that smaller nonprofits spend on salaries and
benefits, but the IRS’s Form 990-EZ data extracts exclude these data.
Therefore, we are unable to estimate the amount of payroll taxes that
smaller nonprofits contribute.

***Invisible Nonprofits:*** Some nonprofits, such as churches, do not
have to file annual returns. See
<https://www.irs.gov/charities-non-profits/annual-exempt-organization-return-who-must-file>.

The Form 990-N also does not collect any financial data from the
smallest nonprofits (i.e., those with gross receipts \<=\$50K), nor does
it collect data on the amount that these nonprofits spend on salaries
and benefits. Therefore, we are unable to estimate the amount of payroll
taxes that the smallest nonprofits contribute.

<br> <br>
<hr>

<br> <br>
