---
title: Payroll Taxes
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
    - text: Data
      href: #
      icon: download
    - text: Script
      href: #
      icon: download
  - header: Publications
    links:
    - text: Report
      href: #
      icon: download
---

The nonprofit sector is persistently striving to measure its scale of
activities to better understand its impact as well as convey the scale
of the work to key stakeholders to highlight societal benefits. Clear
ways of measuring activities can help engage policymakers and donors to
ensure support for the work is sustained.

How does one measure the size of the nonprofit sector? Researchers and
advocates commonly use counts of nonprofits, revenues, assets, and
program expenses. The mobilization of human resources, both paid and
volunteer, is perhaps a more salient measure of the depth of engagement
within communities but is has historically been a harder statistic to
generate due to limited reporting requirements (nonprofits report
estimates of employees on the 990 forms but they are not required to
differentiate part-time and full-time employees and the information has
not been systematically digitized until recently). Partnerships with the
Quarterly Census of Employment and Wages have helped more precisely
measure the size of the nonprofit workforce but estimates are currently
only updated every five years.

A less common but perhaps more accurate approach to measuring employment
levels is through payroll tax disclosures. Although most nonprofits are
exempt from federal income taxes they are still required to pay federal
payroll taxes. Taxes are levied for both part and full-time employees,
meaning the aggregate level of payroll taxes can be used to estimate the
number of full-time equivalent workers employed by the sector.

This data story estimates the amount of payroll taxes the nonprofit
sector contributes annually, in 2023 dollars.

To replicate our methodology, please see the tutorial at the end.

### Estimating the payroll taxes the nonprofit sector contributes annually

To estimate the payroll taxes that the nonprofit sector contributes
annually, we use 2019, 2020, and 2021 IRS Form 990 data extracts,
available at
<https://www.irs.gov/statistics/soi-tax-stats-annual-extract-of-tax-exempt-organization-financial-data>.
We use 3 years of data extracts since there can be a 2-year lag in the
data.

**What is the Form 990 series?**

The Internal Revenue Service (IRS) requires tax-exempt nonprofits to
file annual returns.

- Private foundations must file Form 990-PF.
- Most nonprofits that aren’t private foundations must file Form 990,
  990-EZ, or 990-N.
  - Those with gross receipts \>= \$200K or total assets \>= \$500K must
    file Form 990.
  - Those with gross receipts \<\$200K and total assets \<\$500K can
    file Form 990-EZ.
  - Those with gross receipts \<=\$50K can file Form 990-N.
- Some nonprofits, such as churches, do not have to file annual returns.
  See
  <https://www.irs.gov/charities-non-profits/annual-exempt-organization-return-who-must-file>.

**What does Form 990 series tell us about the amount of payroll taxes
that nonprofits pay?**

***Larger nonprofits*** The Form 990 collects data on the amount of
payroll taxes that larger nonprofits (i.e., those with gross receipts
\>= \$200K or total assets \>= \$500K) contribute (**\$55B in 2019**).

***Private foundations*** The Form 990-PF does not collect data on the
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

***Smaller nonprofits*** The Form 990-EZ does not collect data on the
amount of payroll taxes that smaller nonprofits (i.e., those with gross
receipts \<\$200K and total assets \<\$500K) contribute It does collect
data on the amount that smaller nonprofits spend on salaries and
benefits, but the IRS’s Form 990-EZ data extracts exclude these data.
Therefore, we are unable to estimate the amount of payroll taxes that
smaller nonprofits contribute.

***Smallest nonprofits*** The Form 990-N does not collect data on the
amount of payroll taxes that the smallest nonprofits (i.e., those with
gross receipts \<=\$50K) contribute, nor does it collect data on the
amount that these nonprofits spend on salaries and benefits. Therefore,
we are unable to estimate the amount of payroll taxes that the smallest
nonprofits contribute.

***Nonprofits not required to file annual returns*** We are also unable
to estimate the amount of payroll taxes that nonprofits that are not
required to file annual returns contribute.

***Total*** Adding the amount of payroll taxes that larger nonprofits
contributed in 2019 to the estimated amount of payroll taxes that
private foundations contributed in 2019 and adjusting 18.85% for
inflation (per <https://salaryinflation.com/>), **we estimate that the
nonprofit sector contributes \$66B annually in payroll taxes.** Although
this is a conservative estimate of payroll taxes, it demonstrates the
huge size and economic contributions of the nonprofit sector.

``` r
# TUTORIAL

# This tutorial uses 2019, 2020, and 2021 IRS Form 990 data extracts, available
# at
# https://www.irs.gov/statistics/soi-tax-stats-annual-extract-of-tax-exempt-organization-financial-data, 
# to estimate the annual amount of payroll taxes that nonprofits pay.

# We use 3 years of data extracts since there can be a 2-year lag in the data.

# What is the Form 990 series?
#
# The Internal Revenue Service (IRS) requires tax-exempt nonprofits to file
# annual returns.
#
#   Private foundations must file Form 990-PF.
#
#   Most nonprofits that aren't private foundations must file Form 990,
#   990-EZ, or 990-N.
#
#     Those with gross receipts >= $200K or total assets >= $500K must file
#     Form 990.
#
#     Those with gross receipts <$200K and total assets <$500K can file
#     Form 990-EZ.
#
#     Those with gross receipts <=$50K can file Form 990-N.
#
#   Some nonprofits, such as churches, do not have to file annual returns.
#   See
#   https://www.irs.gov/charities-non-profits/annual-exempt-organization-return-who-must-file.

# What does Form 990 series tell us about the amount of payroll taxes that
# nonprofits pay?
#
# Larger nonprofits
# The Form 990 collects data on the amount of payroll taxes that larger 
# nonprofits (i.e., those with gross receipts >= $200K or total 
# assets >= $500K) contribute.
#
# Private foundations
# The Form 990-PF does not collect data on the amount of payroll taxes that 
# private foundations contribute However, it does collect data on the amount 
# that private foundations spend on salaries and benefits ($3B). The Form 990 
# collects this data for larger nonprofits, as well. Therefore, we can divide 
# the amount of payroll taxes that larger nonprofits contribute by the amount 
# that larger nonprofits spend on payroll taxes to calculate a payroll 
# tax/salaries and benefits ratio (5.75%). We can then apply that ratio to the 
# salaries and benefits data from the Form 990-PF to estimate the amount of 
# payroll taxes that private foundations contribute.
#
# However, the IRS’s Form 990-PF data extract only includes the columns with 
# data on “compensation of officers, directors, trustees, etc.” and “pension 
# plans, employee benefits;” it excludes the column with data on “other 
# employee salaries and wages.” Therefore, we will underestimate the amount of 
# payroll taxes that private foundations contribute. Additionally, the IRS does 
# not provide a data extract for the 2019 Form 990-PF file. This creates a 
# further underestimation of the amount of payroll taxes that private 
# foundations contribute.
#
# Smaller nonprofits
# The Form 990-EZ does not collect data on the amount of payroll taxes that 
# smaller nonprofits (i.e., those with gross receipts <$200K and total
# assets <$500K) contribute It does collect data on the amount that smaller 
# nonprofits spend on salaries and benefits, but the IRS’s Form 990-EZ data 
# extracts exclude these data. Therefore, we are unable to estimate the amount 
# of payroll taxes that smaller nonprofits contribute.
#
# Smallest nonprofits
# The Form 990-N does not collect data on the amount of payroll taxes that the 
# smallest nonprofits (i.e., those with gross receipts <=$50K) contribute, nor 
# does it collect data on the amount that these nonprofits spend on salaries 
# and benefits. Therefore, we are unable to estimate the amount of payroll 
# taxes that the smallest nonprofits contribute.
#
# Nonprofits that don't file annual returns
# We are also unable to estimate the amount of payroll taxes that nonprofits 
# that are not required to file annual returns contribute.

# Below, we walk through our process of reading, cleaning, and analyzing the
# Form 990 and 990-PF datasets to estimate the amount of payroll taxes that 
# nonprofits pay.

# READ THE DATASETS ####

# We read the 2021 Form 990 and Form 990-PF Extracts, the 2020 Form 990 and
# Form 990-PF Extracts, and the 2019 Form 990 Extract. The IRS does not provide
# the 2019 Form 990-PF Extract.

# Download the files you want to use, convert them to csvs, and read them.

soi.2021 <- read.csv(
  "https://urbanorg.box.com/shared/static/q6r3bviyidwioxab5qygvfiqgldrnx0x.csv" )
soi.pf.2021 <- read.csv(
  "https://urbanorg.box.com/shared/static/h51re368fls4zjojjewxqfk59tzfmpjv.csv" )
soi.2020 <- read.csv(
  "https://urbanorg.box.com/shared/static/qvzbroegxaz6fs2zgdt8vdc76wcb0owq.csv" )
soi.pf.2020 <- read.csv(
  "https://urbanorg.box.com/shared/static/qhzpgenehsgg9dcn4lgm26huxnnxjo2b.csv" )
soi.2019 <- read.csv(
  "https://urbanorg.box.com/shared/static/kgonjv86e1fob90rdk12burnsc0ces3s.csv" )

# CLEAN THE DATASETS ####

# To clean the data, we need to:
#
# Step 1: Examine the tax periods in the datasets
#
# Step 2: Subset the datasets so they only include tax period 2019
#
# Step 3: Prepare the datasets for combining
#
# Step 4: Combine the datasets
#
# Step 5: Check the combined datasets for duplicate EINs
#
# Step 6: Remove duplicate EINs from the combined datasets

# Step 1: Examine the tax periods in the datasets

# Because we're using 2019 data to estimate payroll taxes, we only want to keep
# data from tax period 2019 in the datasets.

# Let's see what tax periods are currently included in the datasets.
```
