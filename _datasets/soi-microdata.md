
---
title: SOI Exempt Organizations Microdata
date: 2023-05-27
description: The statistics of nonprofit charitable and other tax-exempt organizations produced by the Statistics of Income (SOI) Division.
categories:
  - 990
  - SOI
  - sampling
featured: false
# featuredOrder: 1
primaryCtaUrl: "../../catalogs/catalog-soi-microdata.html"
primaryCtaCaption: "Available 1990-2019"
primaryLinks:
  - text: "GitHub Page"
    href: "[https://urbaninstitute.github.io/nccsdata/reference/index.html](https://github.com/Nonprofit-Open-Data-Collective/irs-990-soi-study-microdata-sample)"
author:
- id: jlecy
citation: 
  author: "Jesse Lecy"
  citationDate: "2023"
  container-title: "Why Use SOI Microdata?"
  doi: 10.5555/xxxxxxxxxxx
---

## SOI Microdata

The Statistics of Income (SOI) Division of the IRS is responsible for "making statistics collected from income tax returns and information returns available to other government agencies and the general public."

Each year they build a representative sample of the nonprofit sector (the microdata files here), and use it to produce a variety of reports and statistics: 

https://www.irs.gov/statistics/soi-tax-stats-charities-and-other-tax-exempt-organizations-statistics

*"The samples include Internal Revenue Code section 501(c)(3) organizations and section 501(c)(4)–(9) organizations. Sampling rates ranged from 1 percent for small-asset classes to 100 percent for large-asset classes. Microdata records contain information on balance sheets and income statements, as well as weights (to estimate the population), for each organization."*

## Sampling framework: 

https://www.irs.gov/statistics/soi-tax-stats-exempt-organizations-study-data-sources-and-limitations

The statistics of nonprofit charitable and other tax-exempt organizations produced by the Statistics of Income (SOI) Division are based on a sample of Forms 990, Return of Organization Exempt From Income Tax, and Forms 990-EZ, Short Form Return of Organization Exempt From Income Tax filed with the Internal Revenue Service for a given tax year. The sample does not include private foundations, which are required to file Form 990-PF. Most churches and certain other types of religious organizations are also excluded from the samples because they were not required to file Form 990 or Form 990-EZ. Recent samples include only those returns with average receipts of more than $25,000, the filing current threshold.

Beginning with Tax Year 1988, the sample design has been split into two parts: the first sampling frame contains all returns filed by organizations exempt under Internal Revenue Code (IRC) section 501(c)(3); the second sampling frame comprises a pool of all returns filed by organizations exempt under IRC sections 501(c)(4) through (9). Organizations tax-exempt under other IRC sections are excluded from the sample frames. The two samples are classified into strata based on the size of end-of-year total assets, with each stratum sampled at a different rate. The exempt organization sample is designed to provide reliable estimates of total assets and total revenue. To accomplish this, 100 percent of returns filed for section 501(c)(3) organizations with total assets of $50 million or more are included in the sample, since these organizations represent the vast majority of financial activity. (One-hundred percent of the section 501(c)(4)-(9) organizations with assets of $10 million or more are included in the sample.) The remaining population is randomly selected for the sample at various rates, ranging from about 1 percent to less than 100 percent, depending on asset size. (For a historical list of exempt organization study sample and population counts, see the table at the end of this section.)

For a given tax year, SOI's population estimates differ slightly from the actual population of Forms 990 and 990-EZ returns that post to the IRS Business Master File during the two-year sampling period. This results from sample code changes and the effects of returns that are “rejected” from the sample as part of the editing process. Examples of returns present on the Master file but rejected from the SOI sample include: certain returns that report an incorrect subsection code, returns filed for an incorrect tax year, and duplicate filings by a single organization.

The data presented are obtained from returns as originally filed with IRS. In most cases, changes made to the original return because of administrative processing or audit procedures are not captured in the statistics. Changes made based on taxpayer amendment are captured, if available. The data are subjected to comprehensive testing and correction procedures in order to ensure statistical reliability and validity. A general discussion of the reliability of estimates based on samples, methods for evaluating both the magnitude of sampling and non-sampling error, and the precision of sample estimates can be found in the general Appendix of the most recent SOI Bulletin.


| Tax Year | Forms 990 processed between: | Sample count 501(c)(3) | Population count 501(c)(3) | Sample count 501(c)(4)-(9) | Population count 501(c)(4)-(9) |
| -------- | ---------------------------- | ---------------------- | -------------------------- | -------------------------- | ------------------------------ |
| 1990     | Jan. 1, 1991 - Dec. 31, 1992 | 12,076                 | 145,455                    | 11,404                     | 100,982                        |
| 1991     | Jan. 1, 1992 - Dec. 31, 1993 | 10,811                 | 152,119                    | 9,438                      | 101,211                        |
| 1992     | Jan. 1, 1993 - Dec. 31, 1994 | 11,461                 | 160,629                    | 9,800                      | 102,777                        |
| 1993     | Jan. 1, 1994 - Dec. 31, 1995 | 11,882                 | 167,765                    | 8,146                      | 102,841                        |
| 1994     | Jan. 1, 1995 - Dec. 31, 1996 | 11,131                 | 176,621                    | 8,526                      | 104,140                        |
| 1995     | Jan. 1, 1996 - Dec. 31, 1997 | 11,925                 | 184,629                    | 8,800                      | 104,726                        |
| 1996     | Jan. 1, 1997 - Dec. 31, 1998 | 12,912                 | 194,580                    | n.a.                       | n.a.                           |
| 1997     | Jan. 1, 1998 - Dec. 31, 1999 | 13,757                 | 202,620                    | 9,513                      | 105,784                        |
| 1998     | Jan. 1, 1999 - Dec. 31, 2000 | 14,653                 | 211,305                    | 9,795                      | 105,635                        |
| 1999     | Jan. 1, 2000 - Dec. 31, 2001 | 15,051                 | 214,644                    | 9,895                      | 104,526                        |
| 2000     | Jan. 1, 2001 - Dec. 31, 2002 | 16,353                 | 233,816                    | 10,237                     | 106,180                        |
| 2001     | Jan. 1, 2002 - Dec. 31, 2003 | 17,003                 | 244,129                    | 10,393                     | 107,321                        |
| 2002     | Jan. 1, 2003 - Dec. 31, 2004 | 17,569                 | 255,732                    | 10,483                     | 108,296                        |
| 2003     | Jan. 1, 2004 - Dec. 31, 2005 | 14,415                 | 267,490                    | 6,494                      | 109,799                        |
| 2004     | Jan. 1, 2005 - Dec. 31, 2006 | 15,070                 | 279,415                    | 6,669                      | 111,010                        |
| 2005     | Jan. 1, 2006 - Dec. 31, 2007 | 15,862                 | 290,094                    | 6,890                      | 112,128                        |
| 2006     | Jan. 1, 2007 - Dec. 31, 2008 | 16,872                 | 305,133                    | 7,237                      | 114,564                        |
| 2007     | Jan. 1, 2008 - Dec. 31, 2009 | 16,042                 | 316,370                    | 6,555                      | 117,157                        |
| 2008     | Jan. 1, 2009 - Dec. 31, 2010 | 15,708                 | 317,865                    | 6,450                      | 117,782                        |
| 2009     | Jan. 1, 2010 - Dec. 31, 2011 | 17,300                 | 323,473                    | 6,592                      | 118,652                        |
| 2010     | Jan. 1, 2011 - Dec. 31, 2012 | 14,415                 | 272,980                    | 6,411                      | 94,945                         |
| 2011     | Jan. 1, 2012 - Dec. 31, 2013 | 14,678                 | 276,896                    | 6,486                      | 94,505                         |
| 2012     | Jan. 1, 2013 - Dec. 31, 2014 | 15,210                 | 281,999                    | 6,698                      | 94,642                         |

* [[2013](https://www.irs.gov/statistics/soi-tax-stats-2013-charities-and-other-tax-exempt-organizations-microdata-files)]
* [[2014](https://www.irs.gov/statistics/soi-tax-stats-2014-charities-and-other-tax-exempt-organizations-microdata-files)]
* [[2015](https://www.irs.gov/statistics/soi-tax-stats-2015-charities-and-other-tax-exempt-organizations-microdata-files)]
* [[2016](https://www.irs.gov/statistics/soi-tax-stats-2016-charities-and-other-tax-exempt-organizations-microdata-files)]
* [[2017](https://www.irs.gov/statistics/soi-tax-stats-2017-charities-and-other-tax-exempt-organizations-microdata-files)]
* [[2018](https://www.irs.gov/statistics/soi-tax-stats-2018-charities-and-other-tax-exempt-organizations-microdata-files)]
* [[2019](https://www.irs.gov/statistics/soi-tax-stats-2019-charities-and-other-tax-exempt-organizations-microdata-files)]


## Microdata files in ASCII format: 

https://www.irs.gov/statistics/soi-tax-stats-charities-and-other-tax-exempt-organizations-statistics

## Study meta-data: 

https://www.irs.gov/statistics/soi-tax-stats-charities-other-tax-exempt-organizations-study-metadata
