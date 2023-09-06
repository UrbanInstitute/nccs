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
  - id: hm
  - id: jdl
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

It’s often important for the nonprofit sector to convey its size to
policymakers. The sector needs to demonstrate its importance and
contributions in order to receive government support.

But how do you measure the size of the nonprofit sector? Researchers and
advocates often cite the number of nonprofits, their revenue, their
assets, their expenses, the percentage they contribute to the GDP, or
the percentage of workers they employ.

Another, much less common, way to measure the size of the nonprofit
sector is by the amount it contributes in payroll taxes. Although many
nonprofits are exempt from federal income taxes, they still contribute a
large sum of tax revenue via payroll taxes.

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

# Install the packages you'll need to create the tables.
# If you already have these packages, you only need to load the libraries.
install.packages( "knitr" )
install.packages( "dplyr" )
library( knitr )
library( dplyr )

# Pull the 4-digit years from the tax_pd columns.
soi.2021$year <- substr( as.character( soi.2021$tax_pd ), 1, 4)
soi.pf.2021$year <- substr( as.character( soi.pf.2021$TAX_PRD ), 1, 4)
soi.2020$year <- substr( as.character( soi.2020$tax_pd ), 1, 4)
soi.pf.2020$year <- substr( as.character( soi.pf.2020$TAX_PRD ), 1, 4)
soi.2019$year <- substr( as.character( soi.2019$tax_pd ), 1, 4)

# Generate tables to see which tax periods are in the datasets.
soi.2021 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2021 Form 990 Dataset" )

soi.pf.2021 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2021 Form 990-PF Dataset" )

soi.2020 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2020 Form 990 Dataset" )

soi.pf.2020 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2020 Form 990-PF Dataset" )

soi.2019 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2019 Form 990 Dataset" )

# Step 2: Subset the datasets so they only include tax year 2019

# Since the datasets currently contain tax periods 1980-2021, we need to subset
# them so they only include tax period 2019.
soi.2021.subset <- subset( soi.2021, year=="2019" )
soi.pf.2021.subset <- subset( soi.pf.2021, year=="2019" )
soi.2020.subset <- subset( soi.2020, year=="2019" )
soi.pf.2020.subset <- subset( soi.pf.2020, year=="2019" )
soi.2019.subset <- subset( soi.2019, year=="2019" )

# We generate tables again to make sure we did this correctly.
soi.2021.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2021 Form 990 Dataset" )

soi.pf.2021.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2021 Form 990-PF Dataset" )

soi.2020.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2020 Form 990 Dataset" )

soi.pf.2020.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2020 Form 990-PF Dataset" )

soi.2019.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2019 Form 990 Dataset" )

# Step 3: Prepare the datasets for combining

# We first make the names of all of the columns lowercase. R is case-sensitive,
# so if one dataset uses uppercase letters for a column name and another
# dataset uses lowercase letters for a column name, it will not recognize them
# as the same column. As a result, it will not combine the columns.
names( soi.2021.subset ) <- tolower( names( soi.2021.subset ) )
names( soi.2020.subset ) <- tolower( names( soi.2020.subset ) )
names( soi.2019.subset ) <- tolower( names( soi.2019.subset ) )
names( soi.pf.2021.subset ) <- tolower( names( soi.pf.2021.subset ) )
names( soi.pf.2020.subset ) <- tolower( names( soi.pf.2020.subset ) )

# Then, we subset the datasets so they only include the columns we plan to
# use in the analysis. We do this because some of the other columns are named
# inconsistently across datasets, which will create errors if we try to combine
# them.

# We're only going to use the following columns:
#
# Form 990 Columns
#
#| Column            | Description                                      | Location in Form 990 |
#|-------------------|--------------------------------------------------|----------------------|
#| ein               | Employer Identification Number                   | Header               |
#| payrolltx         | Payroll taxes                                    | 990 Core_Pt IX-10(A) |
#| compnsatncurrofcr | Compensation of current officers, directors, etc | 990 Core_Pt IX-5(A)  |
#| compnsatnandothr  | Compensation of disqualified persons             | 990 Core_Pt IX-6(A)  |
#| othrsalwages      | Other salaries and wages                         | 990 Core_Pt IX-7(A)  |
#| pensionplancontrb | Pension plan contributions                       | 990 Core_Pt IX-8(A)  |
#| othremplyeebenef  | Other employee benefits                          | 990 Core_Pt IX-9(A)  |
#
# Form 990-PF Columns
#
#| Column         | Description                      | Location in Form 990    |
#|----------------|----------------------------------|-------------------------|
#| ein            | Employer Identification Number   | Header                  |
#| compofficers   | Compensation of officers         | 990-PF Pt I-13, col (a) |
#| pensplemplbenf | Pension plans, employee benefits | 990-PF Pt I-15, col (a) |

# Subset the datasets to only include the columns we'll use.
soi.2021.subset2 <- 
  soi.2021.subset %>%
  subset( select=c( ein, payrolltx, compnsatncurrofcr, 
                    compnsatnandothr, othrsalwages, 
                    pensionplancontrb, othremplyeebenef ) )

soi.2020.subset2 <- 
  soi.2020.subset %>%
  subset( select=c( ein, payrolltx, compnsatncurrofcr, 
                    compnsatnandothr, othrsalwages, 
                    pensionplancontrb, othremplyeebenef ) )

soi.2019.subset2 <- 
  soi.2019.subset %>%
  subset( select=c( ein, payrolltx, compnsatncurrofcr, 
                    compnsatnandothr, othrsalwages, 
                    pensionplancontrb, othremplyeebenef ) )

soi.pf.2021.subset2 <- 
  soi.pf.2021.subset %>%
  subset( select=c( ein, compofficers, pensplemplbenf ) )

soi.pf.2020.subset2 <- 
  soi.pf.2020.subset %>%
  subset( select=c( ein, compofficers, pensplemplbenf ) )

# Step 4: Combine the datasets

# Form 990 datasets
soi <- bind_rows( soi.2021.subset2, soi.2020.subset2, soi.2019.subset2 )

# Form 990-PF datasets.
soi.pf <- bind_rows( soi.pf.2021.subset2, soi.pf.2020.subset2 )

# Step 5: Check the combined datasets for duplicate EINs

# There might be some duplicate EINs in the combined datasets, because
# organizations could have submitted a return for tax year 2019 and an amended
# return for tax year 2019.

# Let's see if there are any duplicate EINs in either combined dataset.

# Identify the number of distinct EINs in the combined Form 990 dataset.
n_distinct( soi$ein )

# Identify the total number of records in the combined Form 990 dataset.
# If this number doesn't match the one above, there are duplicate EINs.
nrow( soi )

# Identify the number of distinct EINs in the combined Form 990-PF dataset.
n_distinct( soi.pf$ein )

# Identify the total number of records in the combined Form 990-PF dataset.
# If this number doesn't match the one above, there are duplicate EINs.
nrow( soi.pf )

# Step 6: Remove duplicate EINs from the combined datasets

# Since both combined datasets have duplicate EINs, let's remove those.

# Combined Form 990 dataset
soi.distinct <- soi %>% distinct( ein, .keep_all = TRUE )

# Combined Form 990-PF dataset
soi.pf.distinct <- soi.pf %>% distinct( ein, .keep_all = TRUE )

# ANALYZE THE DATASETS ####

# To analyze the datasets, we will:
#
# Step 1: Calculate the amount of payroll taxes that Form 990 filers pay
#
# Step 2: Calculate a payroll tax/salaries and benefits ratio for Form 990
# filers

# Step 3: Use the payroll tax/salaries and benefits ratio to estimate the amount
# of payroll taxes that Form 990-PF filers pay
#
# Step 4: Add the amount of payroll taxes that Form 990 filers pay to the
# estimated amount of payroll taxes that Form 990-PF filers pay
#
# Step 5: Adjust the estimate for inflation

# Step 1: Calculate the amount of payroll taxes that Form 990 filers pay

# To calculate the amount of payroll taxes that Form 990 filers pay, we simply
# sum the payrolltx column.
tax.990 <- sum( soi.distinct$payrolltx, na.rm = T )

# Step 2: Calculate a payroll tax/salaries and benefits ratio for Form 990
# filers

# To calculate the ratio, we divide the amount of payroll taxes that Form 990
# filers pay by the amount that Form 990 filers spend on salaries and benefits.

# Calculate the amount that Form 990 filers spend on salaries and benefits.
salaries.990 <- sum( soi.distinct$compnsatncurrofcr,
                     soi.distinct$compnsatnandothr,
                     soi.distinct$othrsalwages,
                     soi.distinct$pensionplancontrb,
                     soi.distinct$othremplyeebenef, na.rm = T )

# Divide the amount of payroll taxes that Form 990 filers pay
# by the amount that Form 990 filers spend on salaries and benefits.
ratio <- tax.990 / salaries.990

# Step 3: Use the payroll tax/salaries and benefits ratio to estimate the amount
# of payroll taxes that Form 990-PF filers pay

# Calculate the amount that Form 990-PF filers spend on salaries and benefits.
salaries.990.pf <- sum( soi.pf$compofficers, soi.pf$pensplemplbenf, na.rm = T )

# Estimate the amount of payroll taxes that Form 990-PF filers pay.
tax.990.pf <- ratio * salaries.990.pf

# Step 4: Add the amount of payroll taxes that Form 990 filers pay to the
# estimated amount of payroll taxes that Form 990-PF filers pay
tax.total <- tax.990 + tax.990.pf

# Step 5: Adjust the estimate for inflation
tax.total * 1.1885

# We estimate that nonprofits pay approximately $66 billion per year in payroll
# taxes. As we described at the beginning of this tutorial, this is a
# conservative estimate. It does not include the payroll taxes that Form 990-EZ
# or Form 990-N filers pay. It also does not include the payroll taxes that
# nonprofits that are not required to file annual returns pay. Further, it
# underestimates the payroll taxes that private foundations pay. This estimate
# is one way to demonstrate the size and economic contributions of the
# nonprofit sector.
```
