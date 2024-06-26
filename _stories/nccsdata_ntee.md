---
title: "nccsdata Part 2: NTEE Codes"
date: 2023-11-03
description: "Part 2 of 4 data stories covering the nccsdata R package. This story focuses on parsing NTEE codes."
featured: true
featuredOrder: 3
primaryCtaUrl: https://urbaninstitute.github.io/nccsdata
primaryCtaText: Package Website
format: gfm
type: methods
categories:
  - R packages
author:
  - id: thiya
citation: 
  container-title: National Center for Charitable Statistics
  volume: 1
  issue: 1
links:
  - header: Data Stories in this series
    links:
    - text: "Part 1: Downloading Data"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata/
      icon: article
    - text: "Part 2: NTEE Codes"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata-ntee/
      icon: article
    - text: "Part 3: Geographic Filters"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata-geo/
      icon: article
    - text: "Part 4: Summarising Data"
      href: https://urbaninstitute.github.io/nccs/stories/nccsdata-summary/
      icon: article
  - header: Package Files
    links:
    - text: Github Repository
      href: https://github.com/UrbanInstitute/nccsdata
      icon: github
    - text: Package Reference
      href: https://urbaninstitute.github.io/nccsdata/reference/index.html
      icon: link
    - text: Relevant Vignette
      href: https://urbaninstitute.github.io/nccsdata/articles/ntee.html
      icon: article
---

## Introduction

In part 2 of this 4-part series on the
[`nccsdata`](https://urbaninstitute.github.io/nccsdata/) package, we
explore and query National Taxonomy of Exempt Entities (NTEE) codes
using the
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
and
[`parse_ntee()`](https://urbaninstitute.github.io/nccsdata/reference/parse_ntee.html)
functions.

## NTEE Code Structure

The NTEEV2 code system is an evolution of the original NTEE code system,
a classification system used by the IRS and NCCS for nonprofit
organizations. For all of the NTEE codes, refer to this [comprehensive
overview](https://github.com/Nonprofit-Open-Data-Collective/mission-taxonomies/blob/main/NTEE-disaggregated/README.md#NTEEV2-format).

This new NTEE system can be organized into 5 levels.

<span class="image placeholder"
original-image-src="nccsdata/NTEEV2-structure.png"
original-image-title=""></span>

The NTEEV2 codes are structured in three parts:

1.  Level 1: Industry Group
2.  Level 2-4: Major Group, Division and Subdivision
3.  Level 5: Organization Type

These parts are separated by a hyphen, and all NTEEV2 codes must contain
all three parts (or five levels) in sequence.

### Level 1: Industry Groups

The Industry Group is represented by three letters. The 10 options are:

| Industry Group |          Description           |
|:--------------:|:------------------------------:|
|      ART       |   Arts, Culture & Humanities   |
|      EDU       |           Education            |
|      ENV       |    Environment and Animals     |
|      HEL       |             Health             |
|      HMS       |         Human Services         |
|      IFA       | International, Foreign Affairs |
|      PSB       |    Public, Societal Benefit    |
|      REL       |        Religion Related        |
|      MMB       |   Mutual/Membership Benefit    |
|      UNU       |     Unknown, Unclassified      |
|      UNI       |           University           |
|      HOS       |            Hospital            |

Each group represents a broad category that the entire spectrum of
nonprofits can be comprehensively sorted into.

### Level 2: Major Group

The Major Group is represented as one letter. The 26 options are:

| Major Group Label |                     Description                     |
|:-----------------:|:---------------------------------------------------:|
|         A         |             Arts, Culture & Humanities              |
|         B         |                      Education                      |
|         C         |                     Environment                     |
|         D         |                   Animal-Related                    |
|         E         |                     Health Care                     |
|         F         |         Mental Health & Crisis Intervention         |
|         G         | Voluntary Health Associations & Medical Disciplines |
|         H         |                  Medical Research                   |
|         I         |                Crime & Legal-Related                |
|         J         |                     Employment                      |
|         K         |            Food, Agriculture & Nutrition            |
|         L         |                  Housing & Shelter                  |
|         M         |    Public Safety, Disaster Preparedness & Relief    |
|         N         |                 Recreation & Sports                 |
|         O         |                  Youth Development                  |
|         P         |                   Human Services                    |
|         Q         | International, Foreign Affairs & National Security  |
|         R         |       Civil Rights, Social Action & Advocacy        |
|         S         |      Community Improvement & Capacity Building      |
|         T         | Philanthropy, Voluntarism & Grantmaking Foundations |
|         U         |                Science & Technology                 |
|         V         |                   Social Science                    |
|         W         |              Public & Societal Benefit              |
|         X         |                  Religion-Related                   |
|         Y         |             Mutual & Membership Benefit             |
|         Z         |                       Unknown                       |

These offer a more detailed subclassification that builds on the
Industry Group classification framework.

### Level 3 and 4: Division and Subdivision

Levels 3 and 4 consist of alphanumeric values that reference additional
subclassifications corresponding to the Industry Group—Major Group
combinations above. There are too many for a simple table and will be
explored with
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
in the upcoming sections.

### Level 5: Organization Type

Level 5 references the type of organization represented by two letters.
The options are:

| Organization Type |                      Description                      |
|:-----------------:|:-----------------------------------------------------:|
|        RG         |                   Regular Nonprofit                   |
|        AA         |            Alliance/Advocacy Organizations            |
|        MT         |          Management and Technical Assistance          |
|        PA         |          Professional Societies/Associations          |
|        RP         |   Research Institutes and/or Public Policy Analysis   |
|        MS         |        Monetary Support - Single Organization         |
|        MM         |       Monetary Support - Multiple Organizations       |
|        NS         | Nonmonetary Support Not Elsewhere Classified (N.E.C.) |

## Retrieving NTEE Code Descriptions with [`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)

[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
provides descriptions for full codes when the *ntee* argument is
provided any of the 5 levels above. A sample output is provided below:

``` r
ntee_preview( ntee = "UNI" )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  UNI: University
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          B40: 
#> 
#>          Providing support to educational institutions that provide
#>          opportunities for individuals to acquire a higher level of knowledge,
#>          skills and specialization in their chosen area of interest in a formal
#>          school setting. Use this code for higher education institutions not
#>          specified below.
#> 
#>          B41: 
#> 
#>          Providing support to postsecondary educational institutions, known
#>          alternatively as community colleges or junior colleges and commonly
#>          organized into two-year programs, that offer instruction that has been
#>          adapted in content, level and schedule to meet the needs of the
#>          community in which they are located. Community or junior colleges award
#>          an Associates in Arts (A.A.) certificate.
#> 
#>          B42: 
#> 
#>          Providing support to educational institutions that offer college level
#>          courses of study that may lead to the customary bachelor of arts or
#>          science degree.
#> 
#>          B43: 
#> 
#>          Providing support to postsecondary educational institutions that offer
#>          postgraduate study at masters or doctorate levels in addition to an
#>          undergraduate program for people who meet entry level requirements and
#>          are interested in an advanced education. Some institutions of
#>          university status are known as colleges or institutes.
#> 
#>          B50: 
#> 
#>          Providing support to separately incorporated postsecondary educational
#>          institutions provide opportunities for people who have completed their
#>          undergraduate education to receive advanced, postgraduate training in a
#>          professional field leading to a masters degree or doctorate.
#> 
#>  End of Preview
```

In the above code snippet,
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
prints out the descriptions of all NTEE codes belonging to the “UNI”
(University) Industry Group. The function outputs are nested in the
following order:

- Industry Group (Level 1)
  - Organization Type (Level 5)
    - Major Group, Division and Subdivision (Levels 2-4)

*ntee* takes arguments belonging to **any** of the 3 parts or 5 levels
above and returns **all** matching NTEE codes. For example, the below
code snippet returns all NTEE codes belonging to either the University
Industry Group (UNI) or A25 Level 2-4 classification.

``` r
ntee_preview( ntee = c( "UNI","A25" ) )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  ART: Arts, Culture & Humanities
#> 
#>      PA: Professional Societies/Associations
#> 
#>          A25: 
#> 
#>          Providing support to organizations that provide informal arts
#>          educational programming and/or instruction but do not grant diplomas or
#>          degrees; or which offer services regarding the arts to educational
#>          institutions or to public entities involved in education.
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          A25: 
#> 
#>          Providing support to organizations that provide informal arts
#>          educational programming and/or instruction but do not grant diplomas or
#>          degrees; or which offer services regarding the arts to educational
#>          institutions or to public entities involved in education.
#> 
#>  UNI: University
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          B40: 
#> 
#>          Providing support to educational institutions that provide
#>          opportunities for individuals to acquire a higher level of knowledge,
#>          skills and specialization in their chosen area of interest in a formal
#>          school setting. Use this code for higher education institutions not
#>          specified below.
#> 
#>          B41: 
#> 
#>          Providing support to postsecondary educational institutions, known
#>          alternatively as community colleges or junior colleges and commonly
#>          organized into two-year programs, that offer instruction that has been
#>          adapted in content, level and schedule to meet the needs of the
#>          community in which they are located. Community or junior colleges award
#>          an Associates in Arts (A.A.) certificate.
#> 
#>          B42: 
#> 
#>          Providing support to educational institutions that offer college level
#>          courses of study that may lead to the customary bachelor of arts or
#>          science degree.
#> 
#>          B43: 
#> 
#>          Providing support to postsecondary educational institutions that offer
#>          postgraduate study at masters or doctorate levels in addition to an
#>          undergraduate program for people who meet entry level requirements and
#>          are interested in an advanced education. Some institutions of
#>          university status are known as colleges or institutes.
#> 
#>          B50: 
#> 
#>          Providing support to separately incorporated postsecondary educational
#>          institutions provide opportunities for people who have completed their
#>          undergraduate education to receive advanced, postgraduate training in a
#>          professional field leading to a masters degree or doctorate.
#> 
#>  End of Preview
```

You can also preview specific NTEE codes with the *ntee* argument as
shown here:

``` r
ntee_preview( ntee = c("ART-A61-AA",
                       "ART-A54-MT" ))
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  ART: Arts, Culture & Humanities
#> 
#>      AA: Alliance/Advocacy Organizations
#> 
#>          A61: 
#> 
#>          Providing support to organizations that operate facilities including
#>          theaters for the performing arts.
#> 
#>      MT: Management and Technical Assistance
#> 
#>          A54: 
#> 
#>          Providing support to organizations that acquire, preserve, research and
#>          exhibit collections of objects including documents, tools, implements
#>          and furnishings that have significance in helping to interpret or
#>          understand the past. History museums may specialize in a specific era
#>          such as early Greece or Rome, a particular geographical region such as
#>          California or Appalachia, a particular ethnic or cultural group such as
#>          Native Americans or a specific subject area such as costumes; and may
#>          contain items created or used by contemporary or historical figures.
#> 
#>  End of Preview
```

[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
automatically structures the output to avoid repeating Industry Groups
or Organization Types.

For Major Group, Division and Subdivision (Level 2-4),
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
accepts placeholder arguments denoted by the letter *x* (case
insensitive). For example, *ntee = B2x* will provide a preview for all
NTEE codes with a *B* at Level 2 and *2* at Level 3. This allows the
user to narrow their search to specific levels. Examples are provided
below:

``` r
ntee_preview( ntee = "Uxx" )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  PSB: Public, Societal Benefit
#> 
#>      AA: Alliance/Advocacy Organizations
#> 
#>          U00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>      MM: Monetary Support - Multiple Organizations
#> 
#>          U00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>      MS: Monetary Support - Single Organization
#> 
#>          U00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>      MT: Management and Technical Assistance
#> 
#>          U00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          U40: 
#> 
#>          Providing support to organizations that conduct research in the area of
#>          science which applies mathematical and scientific principles to the
#>          solution of practical problems for the benefit of society.
#> 
#>      NS: Nonmonetary Support Not Elsewhere Classified (N.E.C.)
#> 
#>          U00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          U21: 
#> 
#>          Providing support to organizations that support or conduct research in
#>          the area of science that studies the oceans and associated phenomena
#>          including the land/ water and water/atmospheric boundaries.
#> 
#>      PA: Professional Societies/Associations
#> 
#>          U00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          U20: 
#> 
#>          Providing support to organizations that focus broadly on scientific
#>          research and inquiry or which engage in interdisciplinary science
#>          activities.
#> 
#>          U30: 
#> 
#>          Providing support to organizations that conduct research in the
#>          physical and earth sciences, i.e., the area of science that studies
#>          inanimate objects, processes of matter and energy and associated
#>          phenomena. Use this code for organizations that conduct research that
#>          broadly covers the physical and earth sciences or for those that
#>          address areas of scientific study not specified below.
#> 
#>          U33: 
#> 
#>          Providing support to organizations that conduct research in chemistry,
#>          the science which addresses the composition and behavior of matter
#>          including its micro- and macro-structure, the processes of chemical
#>          change and the theoretical description and laboratory simulation of
#>          these phenomena.
#> 
#>          U40: 
#> 
#>          Providing support to organizations that conduct research in the area of
#>          science which applies mathematical and scientific principles to the
#>          solution of practical problems for the benefit of society.
#> 
#>          U42: 
#> 
#>          Providing support to organizations that conduct research in the field
#>          of engineering in which mathematical and scientific principles are
#>          applied to solve a wide variety of practical problems in industry,
#>          social organization, public works and commerce.
#> 
#>          U50: 
#> 
#>          Providing support to organizations that conduct research in the
#>          sciences which analyze the structure, function, growth, origin,
#>          evolution or distribution of living organisms and their relations to
#>          their natural environments.
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          U20: 
#> 
#>          Providing support to organizations that focus broadly on scientific
#>          research and inquiry or which engage in interdisciplinary science
#>          activities.
#> 
#>          U21: 
#> 
#>          Providing support to organizations that support or conduct research in
#>          the area of science that studies the oceans and associated phenomena
#>          including the land/ water and water/atmospheric boundaries.
#> 
#>          U30: 
#> 
#>          Providing support to organizations that conduct research in the
#>          physical and earth sciences, i.e., the area of science that studies
#>          inanimate objects, processes of matter and energy and associated
#>          phenomena. Use this code for organizations that conduct research that
#>          broadly covers the physical and earth sciences or for those that
#>          address areas of scientific study not specified below.
#> 
#>          U31: 
#> 
#>          Organizations that conduct research in astronomy, the physical science
#>          that addresses matter and energy in the universe using observational
#>          techniques such as spectroscopy, photometry, interferometry, radio
#>          astronomy and optical astronomy.
#> 
#>          U33: 
#> 
#>          Providing support to organizations that conduct research in chemistry,
#>          the science which addresses the composition and behavior of matter
#>          including its micro- and macro-structure, the processes of chemical
#>          change and the theoretical description and laboratory simulation of
#>          these phenomena.
#> 
#>          U34: 
#> 
#>          Organizations that conduct research in mathematics, the science which
#>          addresses quantities, magnitudes, forms and their relationships using
#>          symbolic logic and language.
#> 
#>          U36: 
#> 
#>          Organizations that conduct research in the area of science that studies
#>          the earth; the forces acting upon it; and the behavior of the solids,
#>          liquids and gases comprising it.
#> 
#>          U40: 
#> 
#>          Providing support to organizations that conduct research in the area of
#>          science which applies mathematical and scientific principles to the
#>          solution of practical problems for the benefit of society.
#> 
#>          U41: 
#> 
#>          Organizations that conduct research in the area of science that
#>          addresses the study of data and information storage and processing
#>          systems including hardware, software, basic design principles, user
#>          requirements analysis and related economic and policy issues.
#> 
#>          U42: 
#> 
#>          Providing support to organizations that conduct research in the field
#>          of engineering in which mathematical and scientific principles are
#>          applied to solve a wide variety of practical problems in industry,
#>          social organization, public works and commerce.
#> 
#>          U50: 
#> 
#>          Providing support to organizations that conduct research in the
#>          sciences which analyze the structure, function, growth, origin,
#>          evolution or distribution of living organisms and their relations to
#>          their natural environments.
#> 
#>          U99: 
#> 
#>          Use this code for organizations that clearly provide science and
#>          technology research services where the major purpose is unclear enough
#>          that a more specific code cannot be accurately assigned.
#> 
#>      RP: Research Institutes and/or Public Policy Analysis
#> 
#>          U00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          U40: 
#> 
#>          Providing support to organizations that conduct research in the area of
#>          science which applies mathematical and scientific principles to the
#>          solution of practical problems for the benefit of society.
#> 
#>          U50: 
#> 
#>          Providing support to organizations that conduct research in the
#>          sciences which analyze the structure, function, growth, origin,
#>          evolution or distribution of living organisms and their relations to
#>          their natural environments.
#> 
#>  End of Preview
```

``` r
ntee_preview( ntee = "H3x" )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  HEL: Health, Non-Hospital
#> 
#>      MM: Monetary Support - Multiple Organizations
#> 
#>          H30: 
#> 
#>          Providing support to organizations that conduct research which can be
#>          used to improve the prevention, diagnosis and treatment of cancer. Use
#>          this code for organizations whose research focuses on a wide variety of
#>          forms of cancer.
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          H30: 
#> 
#>          Providing support to organizations that conduct research which can be
#>          used to improve the prevention, diagnosis and treatment of cancer. Use
#>          this code for organizations whose research focuses on a wide variety of
#>          forms of cancer.
#> 
#>          H32: 
#> 
#>          Organizations that conduct research which can be used to improve the
#>          prevention, diagnosis and treatment of breast cancer.
#> 
#>  End of Preview
```

``` r
ntee_preview( ntee = "B2x" )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  EDU: Education, Non-University
#> 
#>      AA: Alliance/Advocacy Organizations
#> 
#>          B20: 
#> 
#>          Providing support to preschool, elementary and secondary schools that
#>          provide a formal education for children and adolescents in kindergarten
#>          or first grade through grade twelve.
#> 
#>          B21: 
#> 
#>          Providing support to separately organized preschools or nursery schools
#>          and/or kindergartens which provide foundation-level learning for
#>          children (usually age two through five and four and one half or five
#>          respectively) prior to entering the formal school setting.
#> 
#>          B29: 
#> 
#>          Providing support to schools run independently of the traditional
#>          public school system but receiving public funding and operating by a
#>          charter.  This performance contract details the schools mission,
#>          program, goals, students served, method of assessment, and ways to
#>          measure success.
#> 
#>      MM: Monetary Support - Multiple Organizations
#> 
#>          B20: 
#> 
#>          Providing support to preschool, elementary and secondary schools that
#>          provide a formal education for children and adolescents in kindergarten
#>          or first grade through grade twelve.
#> 
#>      MS: Monetary Support - Single Organization
#> 
#>          B20: 
#> 
#>          Providing support to preschool, elementary and secondary schools that
#>          provide a formal education for children and adolescents in kindergarten
#>          or first grade through grade twelve.
#> 
#>          B25: 
#> 
#>          Providing support to schools comprising any span of grades beginning
#>          with the next grade following an elementary school and ending at or
#>          below grade 12. Includes junior high schools or intermediate schools
#>          and high schools which provide formal instruction for students who want
#>          to prepare further education at the college level or for employment
#>          following graduation.
#> 
#>          B29: 
#> 
#>          Providing support to schools run independently of the traditional
#>          public school system but receiving public funding and operating by a
#>          charter.  This performance contract details the schools mission,
#>          program, goals, students served, method of assessment, and ways to
#>          measure success.
#> 
#>      MT: Management and Technical Assistance
#> 
#>          B20: 
#> 
#>          Providing support to preschool, elementary and secondary schools that
#>          provide a formal education for children and adolescents in kindergarten
#>          or first grade through grade twelve.
#> 
#>      NS: Nonmonetary Support Not Elsewhere Classified (N.E.C.)
#> 
#>          B20: 
#> 
#>          Providing support to preschool, elementary and secondary schools that
#>          provide a formal education for children and adolescents in kindergarten
#>          or first grade through grade twelve.
#> 
#>          B21: 
#> 
#>          Providing support to separately organized preschools or nursery schools
#>          and/or kindergartens which provide foundation-level learning for
#>          children (usually age two through five and four and one half or five
#>          respectively) prior to entering the formal school setting.
#> 
#>          B25: 
#> 
#>          Providing support to schools comprising any span of grades beginning
#>          with the next grade following an elementary school and ending at or
#>          below grade 12. Includes junior high schools or intermediate schools
#>          and high schools which provide formal instruction for students who want
#>          to prepare further education at the college level or for employment
#>          following graduation.
#> 
#>      PA: Professional Societies/Associations
#> 
#>          B20: 
#> 
#>          Providing support to preschool, elementary and secondary schools that
#>          provide a formal education for children and adolescents in kindergarten
#>          or first grade through grade twelve.
#> 
#>          B25: 
#> 
#>          Providing support to schools comprising any span of grades beginning
#>          with the next grade following an elementary school and ending at or
#>          below grade 12. Includes junior high schools or intermediate schools
#>          and high schools which provide formal instruction for students who want
#>          to prepare further education at the college level or for employment
#>          following graduation.
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          B20: 
#> 
#>          Providing support to preschool, elementary and secondary schools that
#>          provide a formal education for children and adolescents in kindergarten
#>          or first grade through grade twelve.
#> 
#>          B21: 
#> 
#>          Providing support to separately organized preschools or nursery schools
#>          and/or kindergartens which provide foundation-level learning for
#>          children (usually age two through five and four and one half or five
#>          respectively) prior to entering the formal school setting.
#> 
#>          B24: 
#> 
#>          Schools classified as elementary by state and local practice and
#>          composed of any span of grades not above grade eight. Includes
#>          preschools and kindergartens if they are an integral part of an
#>          elementary school or a regularly established school system.
#> 
#>          B25: 
#> 
#>          Providing support to schools comprising any span of grades beginning
#>          with the next grade following an elementary school and ending at or
#>          below grade 12. Includes junior high schools or intermediate schools
#>          and high schools which provide formal instruction for students who want
#>          to prepare further education at the college level or for employment
#>          following graduation.
#> 
#>          B28: 
#> 
#>          Organizations that provide educational services including special
#>          placement and individualized programming, instruction and support
#>          services for children and youth who are gifted or have disabilities and
#>          require appropriately modified curricula, teaching methodologies and
#>          instructional materials in order to learn.
#> 
#>          B29: 
#> 
#>          Providing support to schools run independently of the traditional
#>          public school system but receiving public funding and operating by a
#>          charter.  This performance contract details the schools mission,
#>          program, goals, students served, method of assessment, and ways to
#>          measure success.
#> 
#>  End of Preview
```

Once you are familiar with each level, you can leverage the following
additional arguments from
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html):

- `ntee.group` : Industry Group (Level 1)
- `ntee.code` : Major Group, Division and Subdivision (Level 2 - 4)
- `ntee.orgtype` : Organization Type (Level 5)

For *ntee.code*, placeholder arguments are supported as well.

``` r
ntee_preview( ntee.group = "UNI",
              ntee.code = "Cxx" )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  ENV: Environment and Animals
#> 
#>      AA: Alliance/Advocacy Organizations
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>          C50: 
#> 
#>          Providing support to organizations that enhance the aesthetic
#>          characteristics of the built environment by acquiring and preserving
#>          open spaces for public enjoyment; planting trees, flowers and shrubs in
#>          public places; conducting recycling and roadside cleanup campaigns; and
#>          engaging in other environmental beautification activities.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>      MM: Monetary Support - Multiple Organizations
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>          C36: 
#> 
#>          Providing support to organizations involved with forest lands and the
#>          protection of the nations forests from insects, disease, fire, erosion,
#>          air pollution and other destructive forces.
#> 
#>      MS: Monetary Support - Single Organization
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C40: 
#> 
#>          Providing support to organizations that are involved in the cultivation
#>          of plant life for a variety of purposes.
#> 
#>          C42: 
#> 
#>          Providing support to organizations that provide organized opportunities
#>          for individuals to pursue their interest in ornamental plants, flowers,
#>          trees, shrubs, house plants, herbs, garden fruits and vegetables or
#>          other species of plants.
#> 
#>          C50: 
#> 
#>          Providing support to organizations that enhance the aesthetic
#>          characteristics of the built environment by acquiring and preserving
#>          open spaces for public enjoyment; planting trees, flowers and shrubs in
#>          public places; conducting recycling and roadside cleanup campaigns; and
#>          engaging in other environmental beautification activities.
#> 
#>      MT: Management and Technical Assistance
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>      NS: Nonmonetary Support Not Elsewhere Classified (N.E.C.)
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>      PA: Professional Societies/Associations
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C36: 
#> 
#>          Providing support to organizations involved with forest lands and the
#>          protection of the nations forests from insects, disease, fire, erosion,
#>          air pollution and other destructive forces.
#> 
#>          C40: 
#> 
#>          Providing support to organizations that are involved in the cultivation
#>          of plant life for a variety of purposes.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C27: 
#> 
#>          Organizations that collect and process paper, aluminum, glass, and
#>          other materials that can be recycled and reused.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C34: 
#> 
#>          Organizations that preserve and protect endangered land resources from
#>          indiscriminate development, destruction or decay and which manage the
#>          utilization of renewable and nonrenewable resources to ensure ongoing
#>          availability. Included are conservation of the nations forests,
#>          rangeland, vegetation, deserts, wild and scenic rivers and other
#>          wilderness areas and open land spaces; and reestablishment of areas
#>          that have been devastated by destructive activities such as strip
#>          mining or other destructive activities.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>          C36: 
#> 
#>          Providing support to organizations involved with forest lands and the
#>          protection of the nations forests from insects, disease, fire, erosion,
#>          air pollution and other destructive forces.
#> 
#>          C40: 
#> 
#>          Providing support to organizations that are involved in the cultivation
#>          of plant life for a variety of purposes.
#> 
#>          C41: 
#> 
#>          Organizations that plant, maintain and display for public study and
#>          enjoyment collections of flowers, trees, shrubs and ground cover, some
#>          of which are rare and exotic.
#> 
#>          C42: 
#> 
#>          Providing support to organizations that provide organized opportunities
#>          for individuals to pursue their interest in ornamental plants, flowers,
#>          trees, shrubs, house plants, herbs, garden fruits and vegetables or
#>          other species of plants.
#> 
#>          C50: 
#> 
#>          Providing support to organizations that enhance the aesthetic
#>          characteristics of the built environment by acquiring and preserving
#>          open spaces for public enjoyment; planting trees, flowers and shrubs in
#>          public places; conducting recycling and roadside cleanup campaigns; and
#>          engaging in other environmental beautification activities.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>          C99: 
#> 
#>          Use this code for organizations that clearly provide environmental
#>          quality services where the major purpose is unclear enough that a more
#>          specific code cannot be accurately assigned.
#> 
#>      RP: Research Institutes and/or Public Policy Analysis
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>  UNI: University
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          B40: 
#> 
#>          Providing support to educational institutions that provide
#>          opportunities for individuals to acquire a higher level of knowledge,
#>          skills and specialization in their chosen area of interest in a formal
#>          school setting. Use this code for higher education institutions not
#>          specified below.
#> 
#>          B41: 
#> 
#>          Providing support to postsecondary educational institutions, known
#>          alternatively as community colleges or junior colleges and commonly
#>          organized into two-year programs, that offer instruction that has been
#>          adapted in content, level and schedule to meet the needs of the
#>          community in which they are located. Community or junior colleges award
#>          an Associates in Arts (A.A.) certificate.
#> 
#>          B42: 
#> 
#>          Providing support to educational institutions that offer college level
#>          courses of study that may lead to the customary bachelor of arts or
#>          science degree.
#> 
#>          B43: 
#> 
#>          Providing support to postsecondary educational institutions that offer
#>          postgraduate study at masters or doctorate levels in addition to an
#>          undergraduate program for people who meet entry level requirements and
#>          are interested in an advanced education. Some institutions of
#>          university status are known as colleges or institutes.
#> 
#>          B50: 
#> 
#>          Providing support to separately incorporated postsecondary educational
#>          institutions provide opportunities for people who have completed their
#>          undergraduate education to receive advanced, postgraduate training in a
#>          professional field leading to a masters degree or doctorate.
#> 
#>  End of Preview
```

For any combination of *ntee* arguments, *preview_ntee* returns **all**
codes that match **any** of the specified arguments. Thus, in the above
example NTEE codes for both *UNI* and *CXX* were displayed.

## Returning to get_data()

The same set of *ntee* arguments used by *preview_ntee()* are also used
by
[`get_data()`](https://urbaninstitute.github.io/nccsdata/reference/get_data.html).
The code snippet below downloads core data from the year 2015 for all
non-profits that file both full 990s and 990EZs, filtering for
nonprofits belonging to the *Education* Industry Group.

``` r
core <- 
  get_data( dsname = "core",
            time = "2015",
            scope.orgtype = "NONPROFIT",
            scope.formtype = "PZ",
            ntee.group = "EDU" )
```

## Retrieve Complete NTEEV2 Codes

[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
also offers an invisible return feature, allowing users to save the
complete set of NTEEV2 codes being previewed in a character vector. This
can be achieved by assigning the output of
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
to a variable name.

``` r
ntee_preview( ntee.group = "UNI",
              ntee.code = "Cxx"   )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> 
#> 
#>  ENV: Environment and Animals
#> 
#>      AA: Alliance/Advocacy Organizations
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>          C50: 
#> 
#>          Providing support to organizations that enhance the aesthetic
#>          characteristics of the built environment by acquiring and preserving
#>          open spaces for public enjoyment; planting trees, flowers and shrubs in
#>          public places; conducting recycling and roadside cleanup campaigns; and
#>          engaging in other environmental beautification activities.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>      MM: Monetary Support - Multiple Organizations
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>          C36: 
#> 
#>          Providing support to organizations involved with forest lands and the
#>          protection of the nations forests from insects, disease, fire, erosion,
#>          air pollution and other destructive forces.
#> 
#>      MS: Monetary Support - Single Organization
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C40: 
#> 
#>          Providing support to organizations that are involved in the cultivation
#>          of plant life for a variety of purposes.
#> 
#>          C42: 
#> 
#>          Providing support to organizations that provide organized opportunities
#>          for individuals to pursue their interest in ornamental plants, flowers,
#>          trees, shrubs, house plants, herbs, garden fruits and vegetables or
#>          other species of plants.
#> 
#>          C50: 
#> 
#>          Providing support to organizations that enhance the aesthetic
#>          characteristics of the built environment by acquiring and preserving
#>          open spaces for public enjoyment; planting trees, flowers and shrubs in
#>          public places; conducting recycling and roadside cleanup campaigns; and
#>          engaging in other environmental beautification activities.
#> 
#>      MT: Management and Technical Assistance
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>      NS: Nonmonetary Support Not Elsewhere Classified (N.E.C.)
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>      PA: Professional Societies/Associations
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C36: 
#> 
#>          Providing support to organizations involved with forest lands and the
#>          protection of the nations forests from insects, disease, fire, erosion,
#>          air pollution and other destructive forces.
#> 
#>          C40: 
#> 
#>          Providing support to organizations that are involved in the cultivation
#>          of plant life for a variety of purposes.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C27: 
#> 
#>          Organizations that collect and process paper, aluminum, glass, and
#>          other materials that can be recycled and reused.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C32: 
#> 
#>          Providing support to organizations that preserve and protect water
#>          resources from indiscriminate waste and ensure that the supply of
#>          quality water is adequate to meet the needs of the public, agriculture
#>          and industry. Also included are organizations that preserve and manage
#>          coastal lands including shorelines, coastal waters and lands extending
#>          inland from the shore which affect coastal waters; bays, lakes, rivers,
#>          wetlands, estuaries, watersheds and other aquatic habitats.
#> 
#>          C34: 
#> 
#>          Organizations that preserve and protect endangered land resources from
#>          indiscriminate development, destruction or decay and which manage the
#>          utilization of renewable and nonrenewable resources to ensure ongoing
#>          availability. Included are conservation of the nations forests,
#>          rangeland, vegetation, deserts, wild and scenic rivers and other
#>          wilderness areas and open land spaces; and reestablishment of areas
#>          that have been devastated by destructive activities such as strip
#>          mining or other destructive activities.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>          C36: 
#> 
#>          Providing support to organizations involved with forest lands and the
#>          protection of the nations forests from insects, disease, fire, erosion,
#>          air pollution and other destructive forces.
#> 
#>          C40: 
#> 
#>          Providing support to organizations that are involved in the cultivation
#>          of plant life for a variety of purposes.
#> 
#>          C41: 
#> 
#>          Organizations that plant, maintain and display for public study and
#>          enjoyment collections of flowers, trees, shrubs and ground cover, some
#>          of which are rare and exotic.
#> 
#>          C42: 
#> 
#>          Providing support to organizations that provide organized opportunities
#>          for individuals to pursue their interest in ornamental plants, flowers,
#>          trees, shrubs, house plants, herbs, garden fruits and vegetables or
#>          other species of plants.
#> 
#>          C50: 
#> 
#>          Providing support to organizations that enhance the aesthetic
#>          characteristics of the built environment by acquiring and preserving
#>          open spaces for public enjoyment; planting trees, flowers and shrubs in
#>          public places; conducting recycling and roadside cleanup campaigns; and
#>          engaging in other environmental beautification activities.
#> 
#>          C60: 
#> 
#>          Providing support to organizations such as nature centers that provide
#>          informal classes which acquaint participants with particular aspects of
#>          their environment and increase their understanding of and appreciation
#>          for ecological balance.
#> 
#>          C99: 
#> 
#>          Use this code for organizations that clearly provide environmental
#>          quality services where the major purpose is unclear enough that a more
#>          specific code cannot be accurately assigned.
#> 
#>      RP: Research Institutes and/or Public Policy Analysis
#> 
#>          C00: 
#> 
#>          Alliance/Advocacy Organizations
#> 
#>          C20: 
#> 
#>          Providing support to organizations which seek to ensure that
#>          communities have a clean and healthful environment that is free from
#>          air and water pollution, pesticides and other hazardous substances,
#>          damaging radiation and excessive levels of noise.
#> 
#>          C30: 
#> 
#>          Providing support to organizations that protect our natural resources
#>          from abuse, neglect, waste or exploitation and preserve their
#>          availability for future generations.
#> 
#>          C35: 
#> 
#>          Providing support to organizations that conserve existing energy
#>          resources, ensure efficient use of available energy and develop new
#>          energy resources while protecting the quality of the environment.
#> 
#>  UNI: University
#> 
#>      RG: Organizations that promote, produce or provide access to a variety of
#>          arts experiences encompassing the visual, media or performing arts.
#> 
#>          B40: 
#> 
#>          Providing support to educational institutions that provide
#>          opportunities for individuals to acquire a higher level of knowledge,
#>          skills and specialization in their chosen area of interest in a formal
#>          school setting. Use this code for higher education institutions not
#>          specified below.
#> 
#>          B41: 
#> 
#>          Providing support to postsecondary educational institutions, known
#>          alternatively as community colleges or junior colleges and commonly
#>          organized into two-year programs, that offer instruction that has been
#>          adapted in content, level and schedule to meet the needs of the
#>          community in which they are located. Community or junior colleges award
#>          an Associates in Arts (A.A.) certificate.
#> 
#>          B42: 
#> 
#>          Providing support to educational institutions that offer college level
#>          courses of study that may lead to the customary bachelor of arts or
#>          science degree.
#> 
#>          B43: 
#> 
#>          Providing support to postsecondary educational institutions that offer
#>          postgraduate study at masters or doctorate levels in addition to an
#>          undergraduate program for people who meet entry level requirements and
#>          are interested in an advanced education. Some institutions of
#>          university status are known as colleges or institutes.
#> 
#>          B50: 
#> 
#>          Providing support to separately incorporated postsecondary educational
#>          institutions provide opportunities for people who have completed their
#>          undergraduate education to receive advanced, postgraduate training in a
#>          professional field leading to a masters degree or doctorate.
#> 
#>  End of Preview
```

## Alternative Methods to Retrieve Complete NTEEV2 Codes

A second function,
[`parse_ntee()`](https://urbaninstitute.github.io/nccsdata/reference/parse_ntee.html),
can also be used to extract complete NTEE codes.

[`parse_ntee()`](https://urbaninstitute.github.io/nccsdata/reference/parse_ntee.html)
only accepts the following arguments:

- `ntee.group`: Industry Group (Level 1)
- `ntee.code`: Major Group, Division and Subdivision (Level 2 - 4)
- `ntee.orgtype`: Organization Type (Level 5)

Use *all* to include all levels for that specific argument. For example,
to retrieve complete NTEE codes for Universities, use:

``` r
parse_ntee( ntee.group   = c("UNI"),
            ntee.code    = "all",
            ntee.orgtype = "all" )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> [1] "UNI-B40-RG" "UNI-B41-RG" "UNI-B42-RG" "UNI-B43-RG" "UNI-B50-RG"
```

Similar to
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html),
[`parse_ntee()`](https://urbaninstitute.github.io/nccsdata/reference/parse_ntee.html)
accepts placeholder arguments.

``` r
parse_ntee( ntee.group   = "all",
            ntee.code    = "A2x",
            ntee.orgtype = "all"  )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#>  [1] "ART-A26-MT" "ART-A20-PA" "ART-A25-PA" "ART-A20-MS" "ART-A26-MM"
#>  [6] "ART-A20-NS" "ART-A20-RG" "ART-A23-RG" "ART-A24-RG" "ART-A25-RG"
#> [11] "ART-A26-RG" "ART-A27-RG"
```

However,
[`parse_ntee()`](https://urbaninstitute.github.io/nccsdata/reference/parse_ntee.html)
differs from
[`ntee_preview()`](https://urbaninstitute.github.io/nccsdata/reference/ntee_preview.html)
in that it only returns NTEE codes that meet all filters.

``` r
parse_ntee( ntee.group   = "HEL",
            ntee.code    = "A2x",
            ntee.orgtype = "all"  )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> character(0)
```

Since there are no NTEE codes with structure *HEL-A2X-XXX*,
[`parse_ntee()`](https://urbaninstitute.github.io/nccsdata/reference/parse_ntee.html)
does not return any results. Including *“ART”* in *ntee.group*, as shown
below, returns valid codes since there are NTEE codes with the
*ART-A2X-XXX* structure:

``` r
parse_ntee( ntee.group   = c("HEL","ART"),
            ntee.code    = "A2x",
            ntee.orgtype = "all"   )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#>  [1] "ART-A26-MT" "ART-A20-PA" "ART-A25-PA" "ART-A20-MS" "ART-A26-MM"
#>  [6] "ART-A20-NS" "ART-A20-RG" "ART-A23-RG" "ART-A24-RG" "ART-A25-RG"
#> [11] "ART-A26-RG" "ART-A27-RG"
```

Therefore, *parse_ntee* can be used to identify specific codes, which
can then be fed into *get_data* to filter downloaded data by specific
codes, as shown below:

``` r
ART_A2X_codes <- 
  parse_ntee( ntee.group = c("HEL","ART"),
              ntee.code = "A2x",
              ntee.orgtype = "all" )
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types

core_2015_arta2x <- 
  get_data( dsname = "core",
            time = "2015",
            scope.orgtype = "NONPROFIT",
            scope.formtype = "PZ",
            ntee = ART_A2X_codes )
#> Valid inputs detected. Retrieving data.
#> Collecting Matching Industry Groups
#> Collecting Matching Industry Division and Subdivisions
#> Collecting Matching Organization Types
#> Downloading core data
#> Requested files have a total size of 115 MB. Proceed
#>                       with download? Enter Y/N (Yes/no/cancel)
#> Core data downloaded
```

## Conclusion

Understanding NTEE codes is crucial for constructing datasets that
target specific nonprofits. When leveraged correctly, the NTEE taxonomy
is a useful and powerful framework for structuring research projects
involving NCCS data.
