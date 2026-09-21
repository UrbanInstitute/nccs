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
abstract: "The National Taxonomy of Exempt Entities (NTEE) is the code system the IRS uses to say what a nonprofit does. NCCS helped create it and publishes the full code list, a searchable table, and a version reformatted for analysis (NTEE version 2)."
primaryLinks:
  - text: Browse and search all NTEE codes
    href: "../../datasets/ntee/browse/"
  - text: Download the code list (CSV)
    href: "../../datasets/ntee/"
  - text: NTEE version 2 category descriptions
    href: "../../widgets/ntee_tables/ntee_descriptions.html"
---


## What an NTEE code is

Every organization the IRS recognizes as tax-exempt gets one NTEE code, three characters such as `B29` (charter schools). The first letter is the major group (B is education), the rest is the specific activity. The code is descriptive: it helps researchers and regulators group organizations for statistics. It is not a licence, and it does not limit what an organization may do. Many nonprofits work across several categories, and the code captures only one.

The IRS assigns the code when an organization applies for exemption, and it maintains the official list. NCCS helped design the taxonomy and keeps the reference copy used in our data, but **we cannot assign or change an organization's code**.

## For nonprofits

> **NCCS does not assign, correct, or change NTEE codes.** The IRS assigns the code when it approves an organization's exemption and is the only body that can change it. If your organization's code is wrong or missing, contact the IRS as described below; NCCS cannot act on it, and we are not responsible for codes that are incorrect in IRS records or in the data we publish from them.

**Finding your code.** It is in the IRS [Exempt Organizations Business Master File](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf), or [search our table](../../datasets/ntee/browse/) to read what each code means.

**Choosing a code** when you apply for exemption: [browse the full list](../../datasets/ntee/browse/), which is kept in step with the IRS's own list. Pick the code that best describes your main activity; there is no penalty for a near miss, and it can be changed later. (The two-page summary sheet NCCS published in 2005 predates the codes the IRS has added since and is no longer linked here.)

**Changing your code.** Send a written request to the IRS Correspondence Unit with the code you have, the code you want, and the reason. The procedure is in [Publication 557](https://www.irs.gov/pub/irs-pdf/p557.pdf); an [example IRS response](https://www.irs.gov/pub/irs-wd/13-0005.pdf) shows what to expect.

```
Internal Revenue Service
Attn: Correspondence Unit
P.O. Box 2508, Room 6403
Cincinnati, Ohio 45201
```

## For data users

**The code list.** NCCS publishes the full list with descriptions and a crosswalk to NAICS industry codes as a [downloadable table](../../datasets/ntee/), checked against the IRS list every January. The [searchable version](../../datasets/ntee/browse/) reads the same file.

**NTEE version 2.** NCCS data files carry the code in a second, three-part form built for analysis: `INDUSTRY-CODE-TYPE`, for example `EDU-B29-RG`. The industry part groups the 26 letters into 12 broad sectors; the middle part is the original code; the type part says whether the organization is a regular nonprofit (`RG`) or a support organization such as an advocacy group (`AA`) or a fundraiser (`MS`, `MM`). The original codes mixed those support roles into the digits (`B01` was advocacy for education), which made grouping awkward.

```
Old:   B29            (charter school)
New:   EDU-B29-RG     (RG = regular nonprofit)

Old:   B01            (advocacy for the education sector)
New:   EDU-B00-AA     (AA = advocacy organization)

Old:   B0129          (advocacy specifically for charter schools)
New:   EDU-B29-AA
```

![](https://raw.githubusercontent.com/UrbanInstitute/nccs/main/public/img/resources/ntee-v1-vs-v2.png)

<details>
<summary>Industry groups, organization types, and the conversion rules</summary>

**Industry groups (first part)**

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

**Organization types (last part)**

```
RG - Regular Nonprofit
AA - Alliance/Advocacy Organizations (formerly 01)
MT - Management and Technical Assistance (formerly 02)
PA - Professional Societies/Associations (formerly 03)
RP - Research Institutes and/or Public Policy Analysis (formerly 05)
MS - Monetary Support - Single Organization (formerly 11)
MM - Monetary Support - Multiple Organizations (formerly 12)
NS - Nonmonetary Support Not Elsewhere Classified (formerly 19)
```

The middle part is the original code, except that specialty codes `x01` to `x19` become `x00` and their meaning moves to the type part. Full rules and code: [conversion methodology](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEEV2/README.md). Category descriptions: [web version](../../widgets/ntee_tables/ntee_descriptions.html), [printable](../../widgets/ntee_tables/ntee_descriptions_printable.html), [CSV](../../widgets/ntee_tables/nteev2-descriptions.csv), [CSV in tidy format](../../widgets/ntee_tables/nteev2-descriptions-tidy-format.csv). Worked example: [sampling by NTEE category with the nccsdata package](../../stories/nccsdata-ntee/).

</details>

**How accurate are the codes?** Roughly one organization in four carries a code that is incomplete or off the mark. Older organizations were coded by a crosswalk from the IRS activity codes that preceded NTEE; newer ones are coded from a Form 1023 that may describe the mission thinly; and missions change over time. The codes are reliable for aggregate statistics and should be used with care for any single organization. In NCCS BMF files the `NTEE_IRS` column is the official IRS value; `NTEE_NCCS` carries corrections NCCS staff have made over the years. Treat `NTEE_IRS` as the source of truth and `NTEE_NCCS` as a supplement. A [short history of the codes](https://urbaninstitute.github.io/nccs-legacy/ntee/ntee-history.html) explains how the system came about.

## Other taxonomies

* [IRS activity codes](https://github.com/Nonprofit-Open-Data-Collective/irs-exempt-org-business-master-file#activity-codes), the system NTEE replaced in 1995, with the crosswalk used to assign NTEE codes to older organizations.
* [NAICS](https://www.census.gov/naics/), the industry classification used across economic statistics; every NTEE code in [our table](../../datasets/ntee/browse/) carries its closest NAICS match.
* Candid's [Philanthropy Classification System](https://taxonomy.candid.org/resources/downloads), which also covers grants and populations served ([crosswalk](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/tree/main/PCS)).
* [ICNPO](http://asauk.org.uk/wp-content/uploads/2018/02/CNP_WP19_1996.pdf), the international classification of nonprofit organizations.

<details>
<summary>Reading list</summary>

### On the evolution of mission taxonomies 

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



### Recent computational work

**2025** Kim, J. Y., de Vries, M., & Han, H. (2025). MapAgora, civic opportunity datasets for the study of American local politics and public policy. Scientific Data, 12(1), 1162. [ [PDF](https://www.nature.com/articles/s41597-025-05353-6.pdf) ]

**2024** de Vries, M., Kim, J. Y., & Han, H. (2024). The unequal landscape of civic opportunity in America. Nature Human Behaviour, 8(2), 256-263.

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

**2006** Rupasingha, A., Goetz, S. J., & Freshwater, D. (2006). The production of social capital in US counties. The journal of socio-economics, 35(1), 83-101.

</details>
