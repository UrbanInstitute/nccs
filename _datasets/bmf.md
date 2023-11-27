---
title: Business Master File (BMF)
date: 2023-05-28
description: All active organizations that have been granted nonprofit status by the IRS.
categories:
  - BMF
  - sample-framework
  - metadata
featured: true
featuredOrder: 2
primaryCtaUrl: "../../catalogs/catalog-bmf.html"
primaryLinks:
  - text: "R Package"
    href: "https://urbaninstitute.github.io/nccsdata/"
    icon: r
citation: 
  author: "Jesse Lecy"
  citationDate: "2023"
  container-title: "NCCS Legacy BMF Series"
  doi:
---

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

|VARIABLE  | DEFINITION |
|:---------|:---|
|EIN       |Employer identification number |
|SEC_NAME  |Secondary organization name |
|FRCD      |Filing requirements code. The 1st 2 characters indicate the requirements for 990/990-EZ forms. The 3rd character = 1 if a 990-PF is required or 0 if not. |
|SUBSECCD  |IRS subsection code (03=501(c)(3), etc.) |
|TAXPER    |Ending date for tax period of financial data. Core files for 1997 on are in "yyyymm" format (199412=Dec. 1994). Earlier years use 2-digit year ("9412"). |
|ASSETS    |Total assets (end of year) from most recent Form 990 |
|INCOME    |Gross receipts from most recently filed Form 990 |
|NAME      |Organization name |
|ADDRESS   |Address |
|CITY      |City |
|STATE     |State |
|NTEEFINAL |NTEE Code |
|NAICS     |NAICS Code |
|ZIP5      |First 5 digits of zip code |
|RULEDATE  |Ruling date: year and month of IRS ruling or determination letter recognizing orgs exempt status (YYYYMM) |
|FIPS      |2-digit State + 3-digit County FIPS code (Federal Information Processing Standard). See also U.S. Census Bureau State & County QuickFacts. |
|FNDNCD    |Reason for & type of 501(c)(3) exempt status including codes for operating and grantmaking foundations, and broad type of public charity |
|PMSA      |Primary Metropolitan Statistical Area |
|MSA_NECH  |Metropolitan Statistical Area (NCCS file) |
|CASSETS   |Total Assets (Book Value at end of year) from most recent Form 990 (Part IV, line 59(B) on Form 990; Part II, line 25(B) on Form 990-EZ; or Part II, line 16(b) on Form 990-PF) |
|CFINSRC   |Source of financial data added by NCCS (primarily the most recent Form 990 filing as of BMF date from NCCS Core files) |
|CTAXPER   |Ending date for tax period of NCCS financial data in yyyymm format |
|CTOTREV   |Total Revenue from most recent Form 990 (Part I, line 12 on Form 990; Part I, line 9 on Form 990-EZ; or Part I, line 12(a) on Form 990-PF) |
|ACCPER    |Accounting period |
|RANDNUM   |Random number between 0 and 1 used for creating samples |
|NTEECC    |NTEECC classification |
|NTEE1     |NTEE major group (A-Z) |
|LEVEL4    |NTEE-CC Major Group |
|LEVEL1    |Public charity or private foundation? |
|NTMAJ10   |10 NTEE major groups |
|MAJGRPB   |Major NTEE group plus hospitals and higher education |
|LEVEL3    |Major NTEE category |
|LEVEL2    |Reporting public charity groups |
|NTMAJ12   |12 NTEE major groups: ntmaj10 plus higher education (BH) and hospitals (EH) |
|NTMAJ5    |Major subsector (5) |
|FILER     |Filed 990 return (Form 990, Form 990-EZ, Form 990-PF, or Form 990-N) within 24 months of BMF file? (Y/N) |
|ZFILER    |Filed 990 return with zero income and assets within 24 months of BMF file? (Y/N) - Beginning 2008, over 95% of 'zero filers' (ZFiler=Y) filed Form 990-N (e-Postcard) for tax years ending on or after December 31, 2007. |
|OUTREAS   |Reason why out of scope |
|OUTNCCS   |Out-of-scope (IN/OUT) (see OUTREAS doc. for details) |
