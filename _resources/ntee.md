---
title: National Taxonomy of Exempt Entities (NTEE) Codes
description: IRS Activity Codes Used to Categorize Nonprofits
featured: true
featuredOrder: 2
type: project
layout: project
project-name: ntee
categories:
  - metadata
abstract: "National Taxonomy of Exempt Entities (NTEE) system was developed by NCCS and is used by the IRS to classify nonprofit organizations according to their missions and program activities. An updated version of the taxonomy called NTEEV2 (NTEE Version 2.0) is described below. While the NTEE is the official classification designation of the IRS, some other systems are described below. For example, Candid has developed the Philanthropic Classification System (PCS) in order to have a single taxonomy that can be used to classify both nonprofits and grants. It includes some new mission areas as well as 'population/beneficiary' codes to indicate the type of population served, and 'auspice' codes to indicate religious or governmental affiliation. Similarly, the North American Industry Classification System (NAICS) is a more generic taxonomy of industries used broadly for economic analysis. Crosswalks between the NTEE and other taxonomies are provided below when available."
primaryLinks:
  - text: NTEE Category Descriptions (IRS Version)
    href: "https://urbaninstitute.github.io/nccs-legacy/ntee/ntee.html"
  - text: Convenient Two-Page NTEE Cheatsheet (IRS Version)
    href: "../../pubs/ntee-two-page-2005.pdf"
  - text: Overview of NTEE (IRS Version) vs NTEEV2 (Data User) Revisions
    href: https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEEV2/README.md
  - text: NTEEV2 Category Descriptions (NCCS Data User Version)
    href: "../../widgets/ntee_tables/ntee_descriptions.html"  
  - text: NTEE Codes within the nccsdata R Package
    href: https://urbaninstitute.github.io/nccs/stories/nccsdata-ntee/

---





# For Nonprofits 

Nonprofits are assigned an NTEE code during the application process for tax-exempt status. The IRS issues and maintains the official database of NTEE codes. You can look up your official NTEE code in the [IRS 990 Business Master File](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf). 

Please note that the NCCS was involved in the creation of the NTEE system, but **we do not make initial assignment of codes** nor do we **have the ability to make an official update to IRS records**.

## Selecting Your NTEE Code

If you are in the process of filing for tax-exempt status and you need to select your NTEE category you will find the following resources helpful: 

* [Two-Page List of All NTEE Categories](https://nccs.urban.org/nccs/pubs/ntee-two-page-2005.pdf)
* [Full Descriptions of All NTEE Categories (IRS Version)](https://urbaninstitute.github.io/nccs-legacy/ntee/ntee.html)

## Appropriate Uses of NTEE Codes

The National Taxonomy of Exempt Entities (NTEE) is a _**descriptive**_ taxonomy that helps regulators and researchers aggregate data for statistical analysis. While certain nonprofit characteristics like the assigned 501(c) subsection code can have significant binding implications such as whether a donation can be treated as tax-deductible (501c3 public charities) or NOT (most other 501c types). The NTEE classification, on the other hand, should not be used as a limiting factor by funders or other institutional actors. The NTEE is often not precise and many nonprofits have missions that span multiple NTEE categories. It is NOT recommended to ever eliminate nonprofits from funding considerations because of their NTEE code or assume that their NTEE category captures their full range of activities. 

## Modifying NTEE Codes

Instructions for requesting an NTEE change are available in [Publication 557](https://www.irs.gov/pub/irs-pdf/p557.pdf), the IRS handbook of rules for tax-exempt organizations.  A recent excerpt (as of January 2024) states:

> _**Organizations that wish to modify or obtain a National Taxonomy of Exempt Entities (NTEE) Code** should send a written request to the Correspondence Unit with the relevant facts, including the Code currently assigned, if any, and
the requested Code, as well as who selected the currently assigned Code initially, if known._

> _The Correspondence Unit will refer to EO Determinations, if necessary, and will notify the organization if a form or user fee is required to make the requested change. The written request must be sent or faxed to:_

```
Internal Revenue Service
Attn: Correspondence Unit
P.O. Box 2508, Room 6403
Cincinnati, Ohio 45201
```

> _Express and Overnight Delivery:_

```
Internal Revenue Service
Attn: Correspondence Unit
500 Main Street, Room 6403
Cincinnati, Ohio 45202
```

[**Example Response Letter from the IRS**](https://www.irs.gov/pub/irs-wd/13-0005.pdf)  

<br>
<hr>
<br>


# For NCCS Data Users

## NTEE Version 2.0 (NTEEV2)

A newly reformatted version of the NTEE codes have been added to NCCS data files. NTEE-V2 contains the same information as the original but in a format that is better suited for analytics. The original NTEE codes combined mission groups with organizational type, making them confusing at times. The also required frequent cross-referencing of NTEE major group letters with industry labels, making them more difficult to interpret.   

The new version uses a 3-part "tidy" format that makes the organizational type an explicit level and includes the higher-level industry code for convenience. 

```
Old:   B29            (charter school)
New:   EDU-B29-RG     (RG = "regular" or non-specialized nonprofit)

Old:   B01            (advocacy broadly for the education sector)
New:   EDU-B00-AA     (AA = advocacy organization) 

Old:   B0129          (advocacy specifically for charter schools)
New:   EDU-B29-AA
```
  
![](https://raw.githubusercontent.com/UrbanInstitute/nccs/main/public/img/resources/ntee-v1-vs-v2.png)

![](../../_stories/nccsdata/ntee2-structure.png)

**Industry Group Definitions XXX-xxx-xx**

```
ART - Arts, Culture, and Humanities (A)
EDU - Education (B minus universities)
ENV - Environment and Animals (C,D)
HEL - Health (E,F,G,H minus hospitals)
HMS - Human Services (I,J,K,L,M,N,O,P)
IFA - International, Foreign Affairs (Q)
PSB - Public, Societal Benefit (R,S,T,U,V,W)
REL - Religion Related (X)
MMB - Mutual/Membership Benefit (Y)
UNU - Unknown, Unclassified (Z)
UNI - Universities (B40, B41, B42, B43, and B50)
HOS - Hospitals (E20, E21, E22, and E24)
```

**Major Group and Divisions xxx-XXX-xxx**

These will be the same as the traditional NTEE codes except specialty organizations (x01-x19) are replaced with zeroes (x00) and the common codes (01-19) have been recoded as organizational types. 

```
B  EDUCATION                                   (MAJOR GROUP)
+--  B20 ELEMENTARY AND SECONDARY SCHOOLS      (division)
¦ +--B21 Preschools                            (subdivision)
¦ +--B24 Primary & Elementary Schools
¦ +--B25 Secondary & High Schools
¦ +--B28 Special Education
¦ +--B29 Charter School
```

**Organizational Type xxx-xxx-XX**

```
RG - Regular Nonprofit  
AA - Alliance/Advocacy Organizations (*formerly 01*) 
MT - Management and Technical Assistance (*formerly 02*) 
PA - Professional Societies/Associations (*formerly 03*) 
RP - Research Institutes and/or Public Policy Analysis (*formerly 05*) 
MS - Monetary Support - Single Organization (*formerly 11*) 
MM - Monetary Support - Multiple Organizations (*formerly 12*) 
NS - Nonmonetary Support Not Elsewhere Classified (N.E.C.) (*formerly 19*) 
```

![](../../_stories/nccsdata/nteev2-example.png)

<br> 

[**CATEGORY DESCRIPTIONS**](https://nccs.urban.org/nccs/widgets/ntee_tables/ntee_descriptions.html) {[**printable version**](https://nccs.urban.org/nccs/widgets/ntee_tables/ntee_descriptions_printable.html)}

[Interactive Sampling from NTEE Categories with the **nccsdata Package**](https://urbaninstitute.github.io/nccs/stories/nccsdata-ntee/) 

<br>
<hr>
<br> 

## Machine Readable NTEE Files 

[Download CSV of NTEE Category Descriptions](https://nccs.urban.org/nccs/widgets/ntee_tables/nteev2-descriptions.csv) 

[Download CSV of NTEE Category Descriptions in Tidy Format](https://nccs.urban.org/nccs/widgets/ntee_tables/nteev2-descriptions-tidy-format.csv) 

<br>
<hr>
<br>

## A Note on the Appropriate Use and Accuracy of NTEE Codes

NTEE codes are intended to be descriptive rather than prescriptive. This means they serve the purpose of grouping organizations based on types of activities but do not constitute an official designation that restricts nonprofit activities.

**Where Do NTEE Codes Come From?**

New nonprofits either receive an assigned or choose their own single NTEE category when submitting a 1023 or 1023EZ application. For older nonprofits that existed before the NTEE System's creation, the IRS originally assigned three Nonprofit Activity Codes. NTEE codes were retrospectively assigned to these organizations using a [crosswalk of Activity Codes to NTEE Categories](https://github.com/Nonprofit-Open-Data-Collective/irs-exempt-org-business-master-file?tab=readme-ov-file#activity-codes).

[A Brief History of NTEE Codes](https://urbaninstitute.github.io/nccs-legacy/ntee/ntee-history.html)  

[A Helpful Blog by Instrumentl](https://www.instrumentl.com/blog/ntee-codes-for-nonprofits)  

**Are NTEE Codes Accurate?**

Nonprofit missions can be likened to the career paths of individuals. Just as young adults have evolving career goals shaped by experience, feedback, and self-awareness, emerging nonprofits undergo a similar evolution in their program missions. While some individuals commit their entire careers to a single profession, such as becoming a doctor or teacher, most people navigate non-linear career paths, exploring diverse interests early on and specializing later based on initial successes.

Likewise, many nonprofits adopt missions that span multiple NTEE (National Taxonomy of Exempt Entities) categories, particularly resource centers or organizations orchestrating integrated programs to address service gaps. Missions naturally transform over time, with nonprofits potentially taking on roles in policymaking, advocacy, fundraising, or grantmaking as they gain prominence.

Assigning NTEE categories poses challenges. IRS officers may categorize an organization based on an incomplete understanding of its mission, relying on limited information from Form 1023 applications. The crosswalk used to generate NTEE codes from IRS Activity Codes for older organizations has also proven imperfect.

Consequently, we estimate that approximately 25% of organizations in the data have incomplete or inaccurate NTEE category assignments. While NTEE information contributes significantly to aggregate data, using it for individual organizations is not recommended without additional context, as it may not capture the dynamic nature of nonprofit missions and the challenges in achieving accurate categorization.

If you are using the NCCS BMF files, you will notice there are two NTEE variables: **NTEE_IRS** and **NTEE_NCCS**. The NTEE_IRS variable will be the same as the NTEE code that appears in the official IRS BMF database. The NTEE_NCCS variable is meant to be a slightly more accurate version of the NTEE based upon manual updates made by NCCS staff over time. The NTEE_IRS version should be treated as the official version and the NTEE_NCCS version used for research purposes primarily. See above if you are a nonprofit that has questions about officially changing your NTEE designation.  

<br>
<hr>
<br>

## Additional Mission Taxonomies

The NTEE replaced the original IRS Activity Code taxonomy that was used until 1995. NCCS developed an [IRS Activity Code to NTEE Crosswalk](https://github.com/Nonprofit-Open-Data-Collective/irs-exempt-org-business-master-file#activity-codes) that was used to standardize codes for existing nonprofits.  

Some examples of alternative taxonomies include: 

* Candid's [Philanthropy Classification System (PCS)](https://taxonomy.candid.org/resources/downloads) [[**crosswalk**](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/tree/main/PCS)]
* Foundation Center Grant Taxonomy ([See "subjects" in the PCS](https://taxonomy.candid.org/subjects/))  
* ICNPO Codes [[Overview](http://asauk.org.uk/wp-content/uploads/2018/02/CNP_WP19_1996.pdf)] 
* CLASSIEfier [[Link](https://www.ourcommunity.com.au/general/general_article.jsp?articleid=7593)] 
* North American Industry Classification System (NAICS) [[Overview](https://www.census.gov/naics/)] [[**crosswalk**](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/tree/main/NAICS)]

<br>
<hr>
<br>

## Useful Citations on the Evolution of Mission Taxonomies 

**1990:** Herman, R. D. (1990). Methodological Issues in Studying the Effectiveness of Nongovernmental and Nonprofit Organizations. Nonprofit and Voluntary Sector Quarterly, 19(3), 293–306. https://doi.org/10.1177/089976409001900309

**1992:** Smith, B. (1992). The Use of Standard Industrial Classification (SIC) Codes to Classify Activities of Nonprofit Tax-Exempt Organizations.

**1992:** Salamon, Lester & K. Anheier, Helmut. (1992). In search of the non-profit sector II: The problem of classification. Voluntas. 3. 267-309. 10.1007/BF01397460.

**1994:** Grønbjerg, K. A. (1994). Using NTEE to classify non-profit organisations: an assessment of human service and regional applications. Voluntas: International Journal of Voluntary and Nonprofit Organizations, 5(3), 301-328.

**1996:** Salamon, Lester M. and Helmut K. Anheier. "The International Classification of Nonprofit Organizations: ICNPO-Revision 1, 1996." Working Papers of the Johns Hopkins Comparative Nonprofit Sector Project, no. 19. Baltimore: The Johns Hopkins Institute for Policy Studies, 1996. [DOWNLOAD](http://asauk.org.uk/wp-content/uploads/2018/02/CNP_WP19_1996.pdf)

**1996:** Froelich, K. A., & Knoepfle, T. W. (1996). Internal revenue service 990 data: Fact or fiction?. Nonprofit and Voluntary Sector Quarterly, 25(1), 40-52. 

**1998:** Boris, E., & Mosher-Williams, R. (1998). Nonprofit advocacy organizations: Assessing the definitions, classifications, and data. Nonprofit and Voluntary Sector Quarterly, 27(4), 488-506. 

**2002:** Salamon, L. M., & Dewees, S. (2002). In search of the nonprofit sector. The American Behavioral Scientist, 45(11), 1716. 

**2006:** Boris, E. T., & Steuerle, C. E. (2006). Scope and dimensions of the nonprofit sector. The nonprofit sector: A research handbook, 66-88. 

**2013:** Barman, Emily. (2013). Classificatory Struggles in the Nonprofit Sector: The Formation of the National Taxonomy of Exempt Entities, 1969—1987. Social Science History. 37. 103-141. 10.2307/23361114.

**2018:** Berlan, D. (2018). Understanding nonprofit missions as dynamic and interpretative conceptions.
Nonprofit Management & Leadership, 28(3), 413-422.

**2019:** Jones, Deondre’. IRS Activity Codes. Published January 22, 2019. https://nccs.urban.org/publication/irs-activity-codes

**2020:** Plummer, S., Hughes, M. M., & Smith, J. (2020). The challenges of organizational classification: A research note. Social Currents, 7(1), 3-10.



## More Recent Computational Work

**2023:** Jones, M., McCabe, E., & Olson, R. (2023). Identifying essential nonprofits with a novel NLP Method. Nonprofit Management and Leadership, 33(3), 661-674.

**2023:** Han, B., Ho, B., & Xia, Z. (2023). Political ideology of nonprofit organizations. Social Science Quarterly, 104(6), 1207-1221.

**2023:** Chen, H., & Zhang, R. (2023). Identifying nonprofits by scaling mission and activity with word embedding. VOLUNTAS: International Journal of Voluntary and Nonprofit Organizations, 34(1), 39-51. 

**2022:** Ren, C., & Bloemraad, I. (2022). New Methods and the Study of Vulnerable Groups: Using Machine Learning to Identify Immigrant-Oriented Nonprofit Organizations. Socius, 8, 23780231221076992. [ [PDF](https://journals.sagepub.com/doi/pdf/10.1177/23780231221076992) ]

**2021:** Ashley, S. & Boyd, C. (2021) Addressing Racial Funding Gaps in the Nonprofit Sector Requires New Data Approaches. [ [Urban Institute Blog](https://www.urban.org/urban-wire/addressing-racial-funding-gaps-nonprofit-sector-requires-new-data-approaches) ] [ [Racial Equity Analytics Lab](https://www.urban.org/racial-equity-analytics-lab) ]

**2021:** LePere-Schloop, M. (2021). Nonprofit role classification using mission descriptions and supervised machine learning. Nonprofit and Voluntary Sector Quarterly, 08997640211057393.

**2021:** Ma, J. (2021). Automated Coding Using Machine Learning and Remapping the US Nonprofit Sector: A Guide and Benchmark. Nonprofit and Voluntary Sector Quarterly, 50(3), 662-687.

**2021:** Messamore, A., & Paxton, P. (2021). Surviving Victimization: How Service and Advocacy Organizations Describe Traumatic Experiences, 1998–2016. Social Currents, 8(1), 3-24.

**2021:** Santamarina, F. J., Lecy, J. D., & van Holm, E. J. (2021). How to Code a Million Missions: Developing Bespoke Nonprofit Activity Codes Using Machine Learning Algorithms. VOLUNTAS: International Journal of Voluntary and Nonprofit Organizations, 1-10. [ [CODE](https://fjsantam.github.io/bespoke-npo-taxonomies/) ]

**2019:** Paxton, P., Velasco, K., & Ressler, R. (2019a). Form 990 Mission Glossary v.1. Ann Arbor, MI: Inter-university Consortium for Political and Social Research.

**2019:** Paxton, P., Velasco, K., & Ressler, R. (2019b). Form 990 Mission Stemmer v.1. Ann Arbor, MI: Inter-university Consortium for Political and Social Research.

**2019:** Lecy, J., Ashley, S. & Santamarina, F. (2019). “Do Nonprofit Missions Vary by the Political Ideology of Supporting Communities? Some Preliminary Results.” *Public Performance and Management Review.*  [ [PDF](https://github.com/Nonprofit-Open-Data-Collective/machine_learning_mission_codes/raw/master/docs/papers/Lecy%20Ashley%20Santamarina%20-%20PPMR%202019.pdf) ]











