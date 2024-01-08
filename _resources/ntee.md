---
title: National Taxonomy of Exempt Entities (NTEE) Codes
description: IRS Activity Codes Used to Categorize Nonprofits
featured: true
featuredOrder: 1
type: project
layout: project
project-name: ntee
categories:
  - metadata
abstract: "National Taxonomy of Exempt Entities (NTEE) system was developed by NCCS and is used by the IRS to classify nonprofit organizations according to their missions and program activities. An updated version of the taxonomy called NTEEV2 (NTEE Version 2.0) is described below. While the NTEE is the official classification designation of the IRS, some other systems are described below. For example, Candid has developed the Philanthropic Classification System (PCS) in order to have a single taxonomy that can be used to classify both nonprofits and grants. It includes some new mission areas as well as 'population/beneficiary' codes to indicate the type of population served, and 'auspice' codes to indicate religious or governmental affiliation. Similarly, the North American Industry Classification System (NAICS) is a more generic taxonomy of industries used broadly for economic analysis. Crosswalks between the NTEE and other taxonomies are provided below when available."
primaryLinks:
  - text: Overview of NTEE and NTEEV2
    href: https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEEV2/README.md
  - text: NTEE Category Descriptions
    href: https://urbaninstitute.github.io/nccs-legacy/ntee/ntee.html
  - text: History of NTEE Codes
    href: https://urbaninstitute.github.io/nccs-legacy/ntee/ntee-history.html
  - text: Convenient Two-Page NTEE Cheatsheet (old codes)
    href: https://github.com/Nonprofit-Open-Data-Collective/machine_learning_mission_codes/raw/master/docs/assets/NTEE_Two_Page_2005.pdf
  - text: Using NTEE Codes within the <b>nccsdata</b> Package
    href: https://urbaninstitute.github.io/nccs/stories/nccsdata-ntee/
---


## NTEE Version 2.0

The original NTEE codes combined mission groups with organizational type, making them confusing at times. 

The new format makes organizational type explicit and includes the higher-level industry code for convenience. 

```
Old:   B29            (charter school)
New:   EDU-B29-RG     (RG = "regular" or non-specialized nonprofit)

Old:   B01            (advocacy broadly for the education sector)
New:   EDU-B00-AA     (AA = advocacy organization) 

Old:   B0129          (advocacy specifically for charter schools)
New:   EDU-B29-AA
```
  
![](https://raw.githubusercontent.com/UrbanInstitute/nccs/main/public/img/resources/ntee-v1-vs-v2.png)


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

These will be the same as the traditional NTEE codes except specialty organizations (x01-x19) are replaced with zeroes (x00) and the common codes (01-19) have been recoded as organizational types (see below). 

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

<br>
<hr>
<br>

## Additional Taxonomies

The NTEE replaced the original IRS Activity Code taxonomy that was used until 1995. NCCS developed an [IRS Activity Code to NTEE Crosswalk](https://github.com/Nonprofit-Open-Data-Collective/irs-exempt-org-business-master-file#activity-codes) that was used to standardize codes for existing nonprofits.  

Some examples of alternative taxonomies include: 

* Candid's [Philanthropy Classification System (PCS)](https://taxonomy.candid.org/resources/downloads) [[**crosswalk**](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/tree/main/PCS)]
* Foundation Center Grant Taxonomy ([See "subjects" in the PCS](https://taxonomy.candid.org/subjects/))  
* ICNPO Codes [[Overview](http://asauk.org.uk/wp-content/uploads/2018/02/CNP_WP19_1996.pdf)] 
* CLASSIEfier [[Link](https://www.ourcommunity.com.au/general/general_article.jsp?articleid=7593)] 
* North American Industry Classification System (NAICS) [[Overview](https://www.census.gov/naics/)] [[**crosswalk**](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/tree/main/NAICS)]




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






