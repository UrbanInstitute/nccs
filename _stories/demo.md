---
title: nccsdata Package Demo
date: 2023-08-28
description: This story demos three functions from the nccsdata package.
featured: false
format: gfm
featuredOrder: 1
type: methods
categories:
  - R packages
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

## Package Demo: nccsdata

This demo covers three functions the analyst can use from the nccsdata
package; ntee_preview(), preview_meta(), and get_data().

The first function is ntee_preview(). The analyst can use this function
to retrieve the exact codes and descriptions associated with various
Industry Groups, Industry, Division, Subdivision and Organization type.
In this first sample, the analyst looks for information on all art and
education nonprofits with a “A” and “B” industry label. The function
returns a dataset containing the ntee codes associated with these
nonprofits and their associated descriptions.

``` r
dt <- nccsdata::ntee_preview(ntee.group = c("ART", "EDU"),
                             ntee.code = c("Axx", "B"),
                             ntee.orgtype = "all")
```

    Collecting Matching Industry Groups

    Collecting Matching Industry Division and Subdivisions

    Collecting Matching Organization Types

``` r
head(dt) %>%
  knitr::kable()
```

| old.code | new.code   | type.org | broad.category | major.group | univ  | hosp  | two.digit | further.category | division.subdivision | broad.category.description | major.group.description    | code.name                         | division.subdivision.description    | keywords                                                    | further.category.desciption                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | ntee2.code |
|:---------|:-----------|:---------|:---------------|:------------|:------|:------|:----------|-----------------:|:---------------------|:---------------------------|:---------------------------|:----------------------------------|:------------------------------------|:------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|
| A01      | AA-ART-A00 | AA       | ART            | A           | FALSE | FALSE | 1         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Alliances & Advocacy              | Alliance/Advocacy Organizations     | Arts Alliances, Arts Coalitions, Lobbying, Public Awareness |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ART-A00-AA |
| A0161    | AA-ART-A61 | AA       | ART            | A           | FALSE | FALSE | 1         |               61 | 61                   | Arts, Culture & Humanities | Arts, Culture & Humanities | NA                                | Alliance/Advocacy Organizations     | NA                                                          | Providing support to organizations that operate facilities including theaters for the performing arts.                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | ART-A61-AA |
| A02      | MT-ART-A00 | MT       | ART            | A           | FALSE | FALSE | 2         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Management & Technical Assistance | Management and Technical Assistance | Professional Continuing Education                           |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | ART-A00-MT |
| A0226    | MT-ART-A26 | MT       | ART            | A           | FALSE | FALSE | 2         |               26 | 26                   | Arts, Culture & Humanities | Arts, Culture & Humanities | NA                                | Management and Technical Assistance | NA                                                          | Providing support to organizations that foster, nurture and sustain artistic excellence and create a climate in which the arts and humanities may flourish in a community.                                                                                                                                                                                                                                                                                                                                                                                                      | ART-A26-MT |
| A0254    | MT-ART-A54 | MT       | ART            | A           | FALSE | FALSE | 2         |               54 | 54                   | Arts, Culture & Humanities | Arts, Culture & Humanities | NA                                | Management and Technical Assistance | NA                                                          | Providing support to organizations that acquire, preserve, research and exhibit collections of objects including documents, tools, implements and furnishings that have significance in helping to interpret or understand the past. History museums may specialize in a specific era such as early Greece or Rome, a particular geographical region such as California or Appalachia, a particular ethnic or cultural group such as Native Americans or a specific subject area such as costumes; and may contain items created or used by contemporary or historical figures. | ART-A54-MT |
| A0261    | MT-ART-A61 | MT       | ART            | A           | FALSE | FALSE | 2         |               61 | 61                   | Arts, Culture & Humanities | Arts, Culture & Humanities | NA                                | Management and Technical Assistance | NA                                                          | Providing support to organizations that operate facilities including theaters for the performing arts.                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | ART-A61-MT |

The analyst can then save the outputs to a .csv file or use them in
downstream analysis.

In this second example, the analyst wants to view ntee information for
healthcare nonprofits, specifically those involved in general health
care, and mental health and crisis intervention.

``` r
output <- nccsdata::ntee_preview(ntee.group = c("HEL"),
                       ntee.code = c("E", "F"),
                       ntee.orgtype = "all",
                       visualize = FALSE)
```

    Collecting Matching Industry Groups

    Collecting Matching Industry Division and Subdivisions

    Collecting Matching Organization Types

``` r
head(output) %>%
  knitr::kable()
```

| old.code | new.code   | type.org | broad.category | major.group | univ  | hosp  | two.digit | further.category | division.subdivision | broad.category.description | major.group.description   | code.name            | division.subdivision.description | keywords                                                                                      | further.category.desciption                                                                                                                                                                                                                                                                                                                                                                                             | ntee2.code |
|:---------|:-----------|:---------|:---------------|:------------|:------|:------|:----------|-----------------:|:---------------------|:---------------------------|:--------------------------|:---------------------|:---------------------------------|:----------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|
| E01      | AA-HEL-E00 | AA       | HEL            | E           | FALSE | FALSE | 1         |               NA | 0                    | Health, Non-Hospital       | Health Care, Non-Hospital | Alliances & Advocacy | Alliance/Advocacy Organizations  | Health Care Alliances, Health Care Reform, Health Care Coalitions, Lobbying, Public Awareness |                                                                                                                                                                                                                                                                                                                                                                                                                         | HEL-E00-AA |
| E0121    | AA-HEL-E21 | AA       | HEL            | E           | FALSE | FALSE | 1         |               21 | 21                   | Health, Non-Hospital       | Health Care, Non-Hospital | NA                   | Alliance/Advocacy Organizations  | NA                                                                                            | Providing support to multihospital health care systems that have two or more hospitals owned, leased, sponsored, or managed by a central organization. Also includes parent companies of diversified single hospital systems that provide comprehensive management and support services for the hospital. (rev. 9/2005)                                                                                                 | HEL-E21-AA |
| E0122    | AA-HEL-E22 | AA       | HEL            | E           | FALSE | FALSE | 1         |               22 | 22                   | Health, Non-Hospital       | Health Care, Non-Hospital | NA                   | Alliance/Advocacy Organizations  | NA                                                                                            | Providing support to health care facilities that are licensed to operate twenty-four hours per day and offer diagnostic and treatment services as well as emergency and critical care services for people who have illnesses or injuries which require immediate, short-term intervention.                                                                                                                              | HEL-E22-AA |
| E0131    | AA-HEL-E31 | AA       | HEL            | E           | FALSE | FALSE | 1         |               31 | 31                   | Health, Non-Hospital       | Health Care, Non-Hospital | NA                   | Alliance/Advocacy Organizations  | NA                                                                                            | Providing support to organizations that provide both health care services and underwrite health and medical insurance. Also included are medical groups which provide health care for HMO members on a contract with the HMO and physician practice groups generally associated with teaching, research, and public hospitals.                                                                                          | HEL-E31-AA |
| E0132    | AA-HEL-E32 | AA       | HEL            | E           | FALSE | FALSE | 1         |               32 | 32                   | Health, Non-Hospital       | Health Care, Non-Hospital | NA                   | Alliance/Advocacy Organizations  | NA                                                                                            | Providing support to outpatient facilities, many previously known as free clinics, established by the community rather than a hospital which provide basic medical care including physical examinations, immunizations, family planning, nutrition assistance and diagnosis and treatment of common ailments. Services are available on an ability-to-pay basis and target low-income and indigent community residents. | HEL-E32-AA |
| E0170    | AA-HEL-E70 | AA       | HEL            | E           | FALSE | FALSE | 1         |               70 | 70                   | Health, Non-Hospital       | Health Care, Non-Hospital | NA                   | Alliance/Advocacy Organizations  | NA                                                                                            | Providing support to organizations that inform the public of health and safety hazards and measures for furthering the early detection, treatment or rehabilitation of people who have an illness, injury or disability.                                                                                                                                                                                                | HEL-E70-AA |

If the analyst wants an interactive widget to use for browsing the
dataset, they can set the argument visualize = TRUE.

The second function included in the package is preview_meta(). This
function visualizes geographic metadata retrieved from US census
datasets that the analyst can use to filter nonprofits by geography. In
this first example, the analyst wants to preview information associated
with cbsa codes from New York and Maryland.

``` r
output <- nccsdata::preview_meta("cbsa",
                                 visual = FALSE,
                                 within = c("NY", "MD"))
head(output) %>%
  knitr::kable()
```

| metro.census.cbsa.geoid | metro.div.geoid | metro.census.csa.geoid | metro.census.cbsa.name                      | metro.micro.name              | metro.div.name       | metro.census.csa.name                          | census.county.name  | state.census.name | state.censu.geoid | census.county.geoid | census.centrout.name | state.census.abbr |
|------------------------:|----------------:|-----------------------:|:--------------------------------------------|:------------------------------|:---------------------|:-----------------------------------------------|:--------------------|:------------------|------------------:|--------------------:|:---------------------|:------------------|
|                   19060 |              NA |                     NA | Cumberland, MD-WV                           | Micropolitan Statistical Area |                      |                                                | Allegany County     | Maryland          |                24 |                   1 | Central              | MD                |
|                   12580 |              NA |                    548 | Baltimore-Columbia-Towson, MD               | Metropolitan Statistical Area |                      | Washington-Baltimore-Arlington, DC-MD-VA-WV-PA | Anne Arundel County | Maryland          |                24 |                   3 | Central              | MD                |
|                   12580 |              NA |                    548 | Baltimore-Columbia-Towson, MD               | Metropolitan Statistical Area |                      | Washington-Baltimore-Arlington, DC-MD-VA-WV-PA | Baltimore County    | Maryland          |                24 |                   5 | Central              | MD                |
|                   30500 |              NA |                    548 | Lexington Park, MD                          | Metropolitan Statistical Area |                      | Washington-Baltimore-Arlington, DC-MD-VA-WV-PA | Calvert County      | Maryland          |                24 |                   9 | Central              | MD                |
|                   12580 |              NA |                    548 | Baltimore-Columbia-Towson, MD               | Metropolitan Statistical Area |                      | Washington-Baltimore-Arlington, DC-MD-VA-WV-PA | Carroll County      | Maryland          |                24 |                  13 | Outlying             | MD                |
|                   37980 |           48864 |                    428 | Philadelphia-Camden-Wilmington, PA-NJ-DE-MD | Metropolitan Statistical Area | Wilmington, DE-MD-NJ | Philadelphia-Reading-Camden, PA-NJ-DE-MD       | Cecil County        | Maryland          |                24 |                  15 | Central              | MD                |

The output allows the analyst to understand which cbsa codes and
metropolitan area names are present within these states.

In the second example, the analyst previews geographic metadata from the
census tract dataset from Chico, California.

``` r
output <- nccsdata::preview_meta("tract",
                                 visual = FALSE,
                                 within = c("Chico, CA"))
head(output) %>%
  knitr::kable()
```

| metro.census.cbsa.geoid | metro.div.geoid | metro.census.csa.geoid | metro.census.cbsa.name | metro.micro.name              | metro.div.name | metro.census.csa.name | census.county.name | state.census.name | state.censu.geoid | census.county.geoid | census.centrout.name | state.census.abbr |
|------------------------:|----------------:|-----------------------:|:-----------------------|:------------------------------|:---------------|:----------------------|:-------------------|:------------------|------------------:|--------------------:|:---------------------|:------------------|
|                   17020 |              NA |                     NA | Chico, CA              | Metropolitan Statistical Area |                |                       | Butte County       | California        |                 6 |                   7 | Central              | CA                |

The analyst can now view which county names are associated with Chico
and can use the information for downstream analysis.

In this example, the analyst previews data from the census block dataset
for Acadia Parish and Cook County. Note that the analyst does not
provide the state associated with these territories. Rather, the
function returns all rows from the block dataset where either Acadia
Parish or Cook County is mentioned.

``` r
output <- nccsdata::preview_meta("block",
                                 visual = FALSE,
                                 within = c("Acadia Parish", "Cook County"))
head(output) %>%
  knitr::kable()
```

| metro.census.cbsa.geoid | metro.div.geoid | metro.census.csa.geoid | metro.census.cbsa.name          | metro.micro.name              | metro.div.name                    | metro.census.csa.name              | census.county.name | state.census.name | state.censu.geoid | census.county.geoid | census.centrout.name | state.census.abbr |
|------------------------:|----------------:|-----------------------:|:--------------------------------|:------------------------------|:----------------------------------|:-----------------------------------|:-------------------|:------------------|------------------:|--------------------:|:---------------------|:------------------|
|                   16980 |           16984 |                    176 | Chicago-Naperville-Elgin, IL-IN | Metropolitan Statistical Area | Chicago-Naperville-Schaumburg, IL | Chicago-Naperville, IL-IN-WI       | Cook County        | Illinois          |                17 |                  31 | Central              | IL                |
|                   29180 |              NA |                    318 | Lafayette, LA                   | Metropolitan Statistical Area |                                   | Lafayette-New Iberia-Opelousas, LA | Acadia Parish      | Louisiana         |                22 |                   1 | Outlying             | LA                |

The third function is get_data(). With this function the analyst can
combine ntee data, census data and data from the business master files
to create custom datasets. In this example the analyst retrieves
information from all art and education nonprofits in New York, and links
it with census tract information.

``` r
dt <- nccsdata::get_data(ntee.level1 = c("ART", "EDU"),
                   ntee.level2 = "all",
                   geo.state = "NY",
                   geo.level = "tract")
```

    Collecting Matching Industry Groups

    Collecting Matching Industry Division and Subdivisions

    Collecting Matching Organization Types

``` r
head(dt) %>%
  knitr::kable()
```

|       EIN | NAME                                      | SEC_NAME                | RULEDATE | SUBSECCD | FNDNCD | FRCD | NTEECC | NTEEFINAL | ntee2.code |  NAICS | LEVEL1 | LEVEL2 | LEVEL3 | LEVEL4 | FILER | ZFILER | OUTREAS | OUTNCCS | TAXPER | ACCPER | INCOME | ASSETS | CTAXPER | CFINSRC | CTOTREV | CASSETS | ADDRESS                 | CITY          | state.census.abbr.x |  ZIP5 | Match_addr                                     | Longitude | Latitude | Addr_type     | Score | block.census.geoid | tract.census.geoid | old.code | new.code   | type.org | broad.category | major.group | univ  | hosp  | two.digit | further.category | division.subdivision | broad.category.description | major.group.description    | code.name                             | division.subdivision.description    | keywords                                                    | further.category.desciption | county.census.geoid | puma.census.geoid | state.census.geoid | state.census.name | metro.census.cbsa.geoid | metro.census.cbsa.name                                                      | metro.census.csa.geoid | metro.census.csa.name                                             | region.woodard.nation | region.woodard.culture | region.census.main | region.census.division | state.census.abbr.y |
|----------:|:------------------------------------------|:------------------------|---------:|---------:|-------:|-----:|:-------|:----------|:-----------|-------:|:-------|:-------|:-------|:-------|:------|:-------|:--------|:--------|-------:|-------:|-------:|-------:|--------:|:--------|--------:|--------:|:------------------------|:--------------|:--------------------|------:|:-----------------------------------------------|----------:|---------:|:--------------|------:|:-------------------|:-------------------|:---------|:-----------|:---------|:---------------|:------------|:------|:------|:----------|-----------------:|:---------------------|:---------------------------|:---------------------------|:--------------------------------------|:------------------------------------|:------------------------------------------------------------|:----------------------------|--------------------:|------------------:|-------------------:|:------------------|------------------------:|:----------------------------------------------------------------------------|-----------------------:|:------------------------------------------------------------------|:----------------------|:-----------------------|:-------------------|:-----------------------|:--------------------|
| 880962563 | UNAPOLOGETIC MINISTRIES INC               | NA                      |   202203 |        3 |     NA |   20 | A01    | A01       | ART-A00-AA |     NA | PC     | O      | AR     | A      | N     | N      | NA      | IN      |     NA |     NA |     NA |     NA |      NA | NA      |      NA |      NA | 34 E MAIN ST SUITE 265  | SMITHTOWN     | NY                  | 11787 | 34 E Main St, Smithtown, New York, 11787       | -73.19191 | 40.85554 | StreetAddress | 100.0 | 361031349043008    | 36103134904        | A01      | AA-ART-A00 | AA       | ART            | A           | FALSE | FALSE | 1         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Alliances & Advocacy                  | Alliance/Advocacy Organizations     | Arts Alliances, Arts Coalitions, Lobbying, Public Awareness |                             |               36103 |              3303 |                 36 | New York          |                   35620 | New York-Northern New Jersey-Long Island, NY-NJ-PA Metropolitan Statistical |                    408 | New York-Newark-Bridgeport, NY-NJ-CT-PA Combined Statistical Area | YANKEEDOM             | Urban Burbs            | Northeast          | Middle Atlantic        | NY                  |
| 421755544 | LUM SAI-HO BENEVOLENT ASSOCIATION INC     | NA                      |   202002 |        3 |     NA |   20 | A01    | A01       | ART-A00-AA |     NA | PC     | O      | AR     | A      | Y     | Y      | NA      | IN      | 202112 |     12 |      0 |      0 |      NA | NA      |      NA |      NA | 47 ST JAMES PL BASEMENT | NEW YORK      | NY                  | 10038 | 47 St James Pl, New York, New York, 10038      | -73.99871 | 40.71259 | PointAddress  | 100.0 | 360610027001006    | 36061002700        | A01      | AA-ART-A00 | AA       | ART            | A           | FALSE | FALSE | 1         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Alliances & Advocacy                  | Alliance/Advocacy Organizations     | Arts Alliances, Arts Coalitions, Lobbying, Public Awareness |                             |               36061 |              3809 |                 36 | New York          |                   35620 | New York-Northern New Jersey-Long Island, NY-NJ-PA Metropolitan Statistical |                    408 | New York-Newark-Bridgeport, NY-NJ-CT-PA Combined Statistical Area | YANKEEDOM             | Big Cities             | Northeast          | Middle Atlantic        | NY                  |
| 113583117 | EBENEZER CHRISTIAN CENTER INC             | NA                      |   201707 |        3 |     NA |   20 | A01    | A01       | ART-A00-AA |     NA | PC     | O      | AR     | A      | Y     | Y      | NA      | IN      | 202112 |     12 |      0 |      0 |      NA | NA      |      NA |      NA | 1819 PROSPECT PL APT 1  | BROOKLYN      | NY                  | 11233 | 1819 Prospect Pl, Brooklyn, New York, 11233    | -73.91617 | 40.67272 | PointAddress  | 100.0 | 360470363003000    | 36047036300        | A01      | AA-ART-A00 | AA       | ART            | A           | FALSE | FALSE | 1         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Alliances & Advocacy                  | Alliance/Advocacy Organizations     | Arts Alliances, Arts Coalitions, Lobbying, Public Awareness |                             |               36047 |              4007 |                 36 | New York          |                   35620 | New York-Northern New Jersey-Long Island, NY-NJ-PA Metropolitan Statistical |                    408 | New York-Newark-Bridgeport, NY-NJ-CT-PA Combined Statistical Area | YANKEEDOM             | Big Cities             | Northeast          | Middle Atlantic        | NY                  |
| 871962827 | MUSIC WORKERS ALLIANCE INC                | SHEARMAN & STERLING LLP |   202205 |        3 |     NA |   10 | A01    | A01       | ART-A00-AA |     NA | PC     | O      | AR     | A      | N     | N      | NA      | IN      |     NA |     NA |     NA |     NA |      NA | NA      |      NA |      NA | 500C GRAND ST APT GE    | NEW YORK      | NY                  | 10002 | 500C Grand St, New York, New York, 10002       | -73.98326 | 40.71498 | StreetAddress | 100.0 | 360610012002005    | 36061001200        | A01      | AA-ART-A00 | AA       | ART            | A           | FALSE | FALSE | 1         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Alliances & Advocacy                  | Alliance/Advocacy Organizations     | Arts Alliances, Arts Coalitions, Lobbying, Public Awareness |                             |               36061 |              3809 |                 36 | New York          |                   35620 | New York-Northern New Jersey-Long Island, NY-NJ-PA Metropolitan Statistical |                    408 | New York-Newark-Bridgeport, NY-NJ-CT-PA Combined Statistical Area | YANKEEDOM             | Big Cities             | Northeast          | Middle Atlantic        | NY                  |
| 455615795 | A MIDSUMMER NIGHTS DREAM                  | NA                      |   201605 |        3 |     16 |   20 | A01    | A01       | ART-A00-AA | 813319 | PC     | O      | AR     | A      | Y     | Y      | NA      | IN      | 202106 |      6 |      0 |      0 |      NA | NA      |      NA |      NA | 6 DUSTY TRL             | SARATOGA SPGS | NY                  | 12866 | 6 Dusty Trl, Saratoga Springs, New York, 12866 | -73.71882 | 43.10737 | PointAddress  |  99.9 | 360910607011024    | 36091060701        | A01      | AA-ART-A00 | AA       | ART            | A           | FALSE | FALSE | 1         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Alliances & Advocacy                  | Alliance/Advocacy Organizations     | Arts Alliances, Arts Coalitions, Lobbying, Public Awareness |                             |               36091 |              1802 |                 36 | New York          |                   10580 | Albany-Schenectady-Troy, NY Metropolitan Statistical Area                   |                    104 | Albany-Schenectady-Amsterdam, NY Combined Statistical Area        | YANKEEDOM             | Exurbs                 | Northeast          | Middle Atlantic        | NY                  |
| 862069627 | NEW YORK ASSOCIATION OF ENDOCRINOLOGY INC | NA                      |   202111 |        3 |     NA |    1 | A03    | A03       | ART-A00-PA |     NA | PC     | O      | AR     | A      | N     | N      | NA      | IN      |     NA |     NA |     NA |     NA |      NA | NA      |      NA |      NA | 6080 JERICHO TPKE       | COMMACK       | NY                  | 11725 | 6080 Jericho Tpke, Commack, New York, 11725    | -73.30515 | 40.84128 | PointAddress  | 100.0 | 361031121032000    | 36103112103        | A03      | PA-ART-A00 | PA       | ART            | A           | FALSE | FALSE | 3         |               NA | 0                    | Arts, Culture & Humanities | Arts, Culture & Humanities | Professional Societies & Associations | Professional Societies/Associations |                                                             |                             |               36103 |              3302 |                 36 | New York          |                   35620 | New York-Northern New Jersey-Long Island, NY-NJ-PA Metropolitan Statistical |                    408 | New York-Newark-Bridgeport, NY-NJ-CT-PA Combined Statistical Area | YANKEEDOM             | Urban Burbs            | Northeast          | Middle Atlantic        | NY                  |

The resultant dataset filters and combines information on non-profits,
their respective organization types, industry groups and divisions, and
census data including the names of the counties they operate in and the
relevant cbsa codes. The analyst can save this dataset for further
analysis.

In this example, the analyst retrieves information on all Healthcare and
Education nonprofits with a “B”, “E” and “F” Industry label from
California and Maryland, and links them together with census block data.

``` r
dt <- nccsdata::get_data(ntee.level1 = c("HEL", "EDU"),
                   ntee.level2 = c("B", "E", "F"),
                   geo.state = c("CA", "MD"),
                   geo.level = "block")
```

    Warning in !ntee.level1 == "all" | !ntee.level2 == "all": longer object length
    is not a multiple of shorter object length

    Collecting Matching Industry Groups

    Collecting Matching Industry Division and Subdivisions

    Collecting Matching Organization Types

``` r
head(dt) %>%
  knitr::kable()
```

|       EIN | NAME                                            | SEC_NAME | RULEDATE | SUBSECCD | FNDNCD | FRCD | NTEECC | NTEEFINAL | ntee2.code |  NAICS | LEVEL1 | LEVEL2 | LEVEL3 | LEVEL4 | FILER | ZFILER | OUTREAS | OUTNCCS | TAXPER | ACCPER | INCOME |  ASSETS | CTAXPER | CFINSRC             | CTOTREV | CASSETS | ADDRESS                 | CITY        | state.census.abbr |  ZIP5 | Match_addr                                              |  Longitude | Latitude | Addr_type    | Score | block.census.geoid | tract.census.geoid.x | old.code | new.code   | type.org | broad.category | major.group | univ  | hosp  | two.digit | further.category | division.subdivision | broad.category.description | major.group.description   | code.name            | division.subdivision.description | keywords                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | further.category.desciption                                                                                                                                                                                                                                                            | tract.census.geoid.y | zcta.census.geoid | place.census.geoid | county.census.geoid | vtd.census.geoid | urbanrural.census.geoid | urbanrural.nces.geoid |
|----------:|:------------------------------------------------|:---------|---------:|---------:|-------:|-----:|:-------|:----------|:-----------|-------:|:-------|:-------|:-------|:-------|:------|:-------|:--------|:--------|-------:|-------:|-------:|--------:|--------:|:--------------------|--------:|--------:|:------------------------|:------------|:------------------|------:|:--------------------------------------------------------|-----------:|---------:|:-------------|------:|:-------------------|:---------------------|:---------|:-----------|:---------|:---------------|:------------|:------|:------|:----------|-----------------:|:---------------------|:---------------------------|:--------------------------|:---------------------|:---------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------:|------------------:|-------------------:|--------------------:|:-----------------|------------------------:|----------------------:|
| 814287227 | PRINCE GEORGES LEADERSHIP ACTION NETWORK INC    | NA       |   201911 |        3 |     NA |   10 | B01    | B01       | EDU-B00-AA |     NA | PC     | O      | ED     | B      | Y     | N      | NA      | IN      | 202105 |      5 | 210170 |  141304 |      NA | NA                  |      NA |      NA | 6117 SEABROOK RD        | LANHAM      | MD                | 20706 | 6117 Seabrook Road, Lanham, Maryland, 20706             |  -76.84251 | 38.97024 | PointAddress |   100 | 240338036072003    | 24033803607          | B01      | AA-EDU-B00 | AA       | EDU            | B           | FALSE | FALSE | 1         |               NA | 0                    | Education, Non-University  | Education, Non-Univeristy | Alliances & Advocacy | Alliance/Advocacy Organizations  | Academic Freedom, Curriculum Reform, Education Advocacy, Education Alliances, Education Coalitions, Education Reform, Educational Intermediaries, Educational Reform, First Steps Educational Initiatives, LEFs, Lobbying, Local Education Foundations, Local Education Funds, Multiculturalism in Education, Public Awareness, School Accountability, School Busing, School Choice, School Funding Advocacy, School Reform, School Safety Advocacy, Smart Start Initiatives |                                                                                                                                                                                                                                                                                        |                    0 |             20706 |            2445550 |               24033 | 20-008           |                   92242 |                    21 |
| 611781345 | BALTIMORE CITY CHILDCARE COALITION INCORPORATED | NA       |   201701 |        3 |     NA |   20 | B01    | B01       | EDU-B00-AA |     NA | PC     | O      | ED     | B      | N     | N      | NA      | IN      | 201912 |     12 |   6720 |    6646 |      NA | NA                  |      NA |      NA | 7009 CONCORD RD         | PIKESVILLE  | MD                | 21208 | 7009 Concord Rd, Pikesville, Maryland, 21208            |  -76.71662 | 39.35979 | PointAddress |   100 | 240054034024003    | 24005403402          | B01      | AA-EDU-B00 | AA       | EDU            | B           | FALSE | FALSE | 1         |               NA | 0                    | Education, Non-University  | Education, Non-Univeristy | Alliances & Advocacy | Alliance/Advocacy Organizations  | Academic Freedom, Curriculum Reform, Education Advocacy, Education Alliances, Education Coalitions, Education Reform, Educational Intermediaries, Educational Reform, First Steps Educational Initiatives, LEFs, Lobbying, Local Education Foundations, Local Education Funds, Multiculturalism in Education, Public Awareness, School Accountability, School Busing, School Choice, School Funding Advocacy, School Reform, School Safety Advocacy, Smart Start Initiatives |                                                                                                                                                                                                                                                                                        |                    0 |             21208 |            2461400 |               24005 | 03-002           |                    4843 |                    21 |
| 464535180 | WISE READERS TO LEADERS                         | NA       |   201408 |        3 |     15 |   10 | B01    | B01       | EDU-B00-AA | 813319 | PC     | O      | ED     | B      | Y     | N      | NA      | IN      | 202012 |     12 | 849810 | 1293231 |  201812 | 19eoextract990.xlsx |  587494 |  828502 | 15500 STEPHEN S WISE DR | LOS ANGELES | CA                | 90077 | 15500 Stephen S Wise Dr, Los Angeles, California, 90077 | -118.46955 | 34.12803 | PointAddress |   100 | 060372622001000    | 06037262200          | B01      | AA-EDU-B00 | AA       | EDU            | B           | FALSE | FALSE | 1         |               NA | 0                    | Education, Non-University  | Education, Non-Univeristy | Alliances & Advocacy | Alliance/Advocacy Organizations  | Academic Freedom, Curriculum Reform, Education Advocacy, Education Alliances, Education Coalitions, Education Reform, Educational Intermediaries, Educational Reform, First Steps Educational Initiatives, LEFs, Lobbying, Local Education Foundations, Local Education Funds, Multiculturalism in Education, Public Awareness, School Accountability, School Busing, School Choice, School Funding Advocacy, School Reform, School Safety Advocacy, Smart Start Initiatives |                                                                                                                                                                                                                                                                                        |                    0 |                NA |                 NA |                  NA | NA               |                      NA |                    NA |
| 872943251 | METAL MANIACS ROBOTICS                          | NA       |   202201 |        3 |     NA |   20 | B01    | B01       | EDU-B00-AA |     NA | PC     | O      | ED     | B      | N     | N      | NA      | IN      |     NA |     NA |     NA |      NA |      NA | NA                  |      NA |      NA | 568 HALL ST             | FOLSOM      | CA                | 95630 | 568 Hall St, Folsom, California, 95630                  | -121.15381 | 38.65933 | PointAddress |   100 | 060670085082005    | 06067008508          | B01      | AA-EDU-B00 | AA       | EDU            | B           | FALSE | FALSE | 1         |               NA | 0                    | Education, Non-University  | Education, Non-Univeristy | Alliances & Advocacy | Alliance/Advocacy Organizations  | Academic Freedom, Curriculum Reform, Education Advocacy, Education Alliances, Education Coalitions, Education Reform, Educational Intermediaries, Educational Reform, First Steps Educational Initiatives, LEFs, Lobbying, Local Education Foundations, Local Education Funds, Multiculturalism in Education, Public Awareness, School Accountability, School Busing, School Choice, School Funding Advocacy, School Reform, School Safety Advocacy, Smart Start Initiatives |                                                                                                                                                                                                                                                                                        |                    0 |                NA |                 NA |                  NA | NA               |                      NA |                    NA |
| 680397723 | RIPARIAN EDUCATION ALLIANCE                     | NA       |   199702 |        3 |     15 |   20 | B01    | B01       | EDU-B00-AA | 813319 | PC     | O      | ED     | B      | Y     | Y      | NA      | IN      | 202112 |     12 |      0 |       0 |      NA | NA                  |      NA |      NA | PO BOX 91               | BAYSIDE     | CA                | 95524 | 95524, Bayside, California                              | -124.06093 | 40.84485 | Postal       |    98 | 060230009002007    | 06023000900          | B01      | AA-EDU-B00 | AA       | EDU            | B           | FALSE | FALSE | 1         |               NA | 0                    | Education, Non-University  | Education, Non-Univeristy | Alliances & Advocacy | Alliance/Advocacy Organizations  | Academic Freedom, Curriculum Reform, Education Advocacy, Education Alliances, Education Coalitions, Education Reform, Educational Intermediaries, Educational Reform, First Steps Educational Initiatives, LEFs, Lobbying, Local Education Foundations, Local Education Funds, Multiculturalism in Education, Public Awareness, School Accountability, School Busing, School Choice, School Funding Advocacy, School Reform, School Safety Advocacy, Smart Start Initiatives |                                                                                                                                                                                                                                                                                        |                    0 |                NA |                 NA |                  NA | NA               |                      NA |                    NA |
| 203560363 | ALLIANCE FOR CAREER AND EDUCATION INC           | NA       |   202001 |        3 |     15 |   20 | B013   | B0130     | EDU-B30-AA | 813319 | PC     | O      | ED     | B      | N     | N      | NA      | IN      |     NA |     NA |     NA |      NA |      NA | NA                  |      NA |      NA | 4804 GRAND BEND DR      | CATONSVILLE | MD                | 21228 | 4804 Grand Bend Dr, Catonsville, Maryland, 21228        |  -76.70180 | 39.26465 | PointAddress |   100 | 240054001001014    | 24005400100          | B0130    | AA-EDU-B30 | AA       | EDU            | B           | FALSE | FALSE | 1         |               30 | 30                   | Education, Non-University  | Education, Non-Univeristy | NA                   | Alliance/Advocacy Organizations  | NA                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Providing support to separately organized trade high schools or vocational centers that provide formal preparation for semiskilled, skilled, technical or professional occupations for high-school-aged students and, in some cases, adults who want to develop skills for employment. |                    0 |             21228 |            2414125 |               24005 | 01-015           |                    4843 |                    21 |

In addition to the 3 main functions covered there are 2 additional
helper functions that an analyst may find useful. The first is
parse_ntee() which returns the ntee codes for nonprofits that fall under
analyst specifications. In this example, the analyst retrieves the ntee
codes for non profits belonging to the Public Benefit and Relgious
Industry Groups.

``` r
nccsdata::parse_ntee(ntee.group = c("PSB", "REL"),
                     ntee.code = "all",
                     ntee.orgtype = "all")
```

    Collecting Matching Industry Groups

    Collecting Matching Industry Division and Subdivisions

    Collecting Matching Organization Types

      [1] "REL-X00-AA" "REL-X20-AA" "REL-X00-MT" "REL-X20-MT" "REL-X00-PA"
      [6] "REL-X20-PA" "REL-X00-RP" "REL-X20-RP" "REL-X00-MS" "REL-X20-MS"
     [11] "REL-X21-MS" "REL-X00-MM" "REL-X20-MM" "REL-X00-NS" "REL-X20-NS"
     [16] "REL-X21-NS" "REL-X20-RG" "REL-X21-RG" "REL-X22-RG" "REL-X30-RG"
     [21] "REL-X40-RG" "REL-X50-RG" "REL-X70-RG" "REL-X80-RG" "REL-X81-RG"
     [26] "REL-X82-RG" "REL-X83-RG" "REL-X84-RG" "REL-X90-RG" "REL-X99-RG"
     [31] "PSB-R00-AA" "PSB-R24-AA" "PSB-R28-AA" "PSB-R61-AA" "PSB-R62-AA"
     [36] "PSB-R00-MT" "PSB-R26-MT" "PSB-R00-PA" "PSB-R00-RP" "PSB-R00-MS"
     [41] "PSB-R00-MM" "PSB-R26-MM" "PSB-R00-NS" "PSB-R24-NS" "PSB-R20-RG"
     [46] "PSB-R21-RG" "PSB-R22-RG" "PSB-R23-RG" "PSB-R24-RG" "PSB-R25-RG"
     [51] "PSB-R26-RG" "PSB-R27-RG" "PSB-R28-RG" "PSB-R29-RG" "PSB-R30-RG"
     [56] "PSB-R40-RG" "PSB-R60-RG" "PSB-R61-RG" "PSB-R62-RG" "PSB-R63-RG"
     [61] "PSB-R65-RG" "PSB-R67-RG" "PSB-R99-RG" "PSB-S00-AA" "PSB-S20-AA"
     [66] "PSB-S21-AA" "PSB-S00-MT" "PSB-S40-MT" "PSB-S41-MT" "PSB-S00-PA"
     [71] "PSB-S20-PA" "PSB-S21-PA" "PSB-S41-PA" "PSB-S00-RP" "PSB-S00-MS"
     [76] "PSB-S20-MS" "PSB-S30-MS" "PSB-S00-MM" "PSB-S20-MM" "PSB-S21-MM"
     [81] "PSB-S22-MM" "PSB-S40-MM" "PSB-S00-NS" "PSB-S20-RG" "PSB-S21-RG"
     [86] "PSB-S22-RG" "PSB-S30-RG" "PSB-S31-RG" "PSB-S32-RG" "PSB-S40-RG"
     [91] "PSB-S41-RG" "PSB-S43-RG" "PSB-S46-RG" "PSB-S47-RG" "PSB-S50-RG"
     [96] "PSB-S80-RG" "PSB-S81-RG" "PSB-S82-RG" "PSB-S99-RG" "PSB-T00-AA"
    [101] "PSB-T00-MT" "PSB-T00-PA" "PSB-T30-PA" "PSB-T00-RP" "PSB-T00-MS"
    [106] "PSB-T31-MS" "PSB-T70-MS" "PSB-T00-MM" "PSB-T00-NS" "PSB-T20-RG"
    [111] "PSB-T21-RG" "PSB-T22-RG" "PSB-T23-RG" "PSB-T30-RG" "PSB-T31-RG"
    [116] "PSB-T40-RG" "PSB-T50-RG" "PSB-T70-RG" "PSB-T90-RG" "PSB-T99-RG"
    [121] "PSB-U00-AA" "PSB-U00-MT" "PSB-U40-MT" "PSB-U00-PA" "PSB-U20-PA"
    [126] "PSB-U30-PA" "PSB-U33-PA" "PSB-U40-PA" "PSB-U42-PA" "PSB-U50-PA"
    [131] "PSB-U00-RP" "PSB-U40-RP" "PSB-U50-RP" "PSB-U00-MS" "PSB-U00-MM"
    [136] "PSB-U00-NS" "PSB-U21-NS" "PSB-U20-RG" "PSB-U21-RG" "PSB-U30-RG"
    [141] "PSB-U31-RG" "PSB-U33-RG" "PSB-U34-RG" "PSB-U36-RG" "PSB-U40-RG"
    [146] "PSB-U41-RG" "PSB-U42-RG" "PSB-U50-RG" "PSB-U99-RG" "PSB-V00-AA"
    [151] "PSB-V30-AA" "PSB-V00-MT" "PSB-V00-PA" "PSB-V25-PA" "PSB-V00-RP"
    [156] "PSB-V00-MS" "PSB-V20-MS" "PSB-V00-MM" "PSB-V00-NS" "PSB-V20-RG"
    [161] "PSB-V21-RG" "PSB-V22-RG" "PSB-V23-RG" "PSB-V24-RG" "PSB-V25-RG"
    [166] "PSB-V26-RG" "PSB-V30-RG" "PSB-V31-RG" "PSB-V32-RG" "PSB-V33-RG"
    [171] "PSB-V34-RG" "PSB-V35-RG" "PSB-V36-RG" "PSB-V37-RG" "PSB-V99-RG"
    [176] "PSB-W00-AA" "PSB-W20-AA" "PSB-W61-AA" "PSB-W00-MT" "PSB-W20-MT"
    [181] "PSB-W00-PA" "PSB-W20-PA" "PSB-W40-PA" "PSB-W80-PA" "PSB-W90-PA"
    [186] "PSB-W00-RP" "PSB-W20-RP" "PSB-W00-MS" "PSB-W30-MS" "PSB-W70-MS"
    [191] "PSB-W00-MM" "PSB-W20-MM" "PSB-W30-MM" "PSB-W80-MM" "PSB-W00-NS"
    [196] "PSB-W20-NS" "PSB-W22-NS" "PSB-W30-NS" "PSB-W60-NS" "PSB-W20-RG"
    [201] "PSB-W22-RG" "PSB-W24-RG" "PSB-W30-RG" "PSB-W40-RG" "PSB-W50-RG"
    [206] "PSB-W60-RG" "PSB-W61-RG" "PSB-W70-RG" "PSB-W80-RG" "PSB-W90-RG"
    [211] "PSB-W99-RG"

The analyst can decide to narrow it down to only nonprofits that belong
to the Civil Rights, Social Action & Advocacy label (“R”).

``` r
nccsdata::parse_ntee(ntee.group = c("PSB", "REL"),
                     ntee.code = "R",
                     ntee.orgtype = "all")
```

    Collecting Matching Industry Groups

    Collecting Matching Industry Division and Subdivisions

    Collecting Matching Organization Types

     [1] "PSB-R00-AA" "PSB-R24-AA" "PSB-R28-AA" "PSB-R61-AA" "PSB-R62-AA"
     [6] "PSB-R00-MT" "PSB-R26-MT" "PSB-R00-PA" "PSB-R00-RP" "PSB-R00-MS"
    [11] "PSB-R00-MM" "PSB-R26-MM" "PSB-R00-NS" "PSB-R24-NS" "PSB-R20-RG"
    [16] "PSB-R21-RG" "PSB-R22-RG" "PSB-R23-RG" "PSB-R24-RG" "PSB-R25-RG"
    [21] "PSB-R26-RG" "PSB-R27-RG" "PSB-R28-RG" "PSB-R29-RG" "PSB-R30-RG"
    [26] "PSB-R40-RG" "PSB-R60-RG" "PSB-R61-RG" "PSB-R62-RG" "PSB-R63-RG"
    [31] "PSB-R65-RG" "PSB-R67-RG" "PSB-R99-RG"

In this output there were no ntee codes returned beginning with “REL”
because no religious nonprofits belong to the Civil Rights, Social
Action & Advocacy industry label.

The final helper function is parse_geo() that returns FIPS codes from
the census block or tract datasets that meet the analyst’s
specifications. In this example the analyst gets all FIPS codes from the
tract dataset from the state of Wyoming.

``` r
nccsdata::parse_geo(census.level = "TRACT",
                    state.census.name = "Wyoming")
```

    Objects in memory

           tract.census.geoid
        1:         1001020100
        2:         1001020200
        3:         1001020300
        4:         1001020400
        5:         1001020500
       ---                   
    74087:        78030960900
    74088:        78030961000
    74089:        78030961100
    74090:        78030961200
    74091:        78030990000
