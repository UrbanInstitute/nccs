---
title: >-
  E-filed 990s are up 1.5x since 2015, and 60k+ new public charities have grown
  into the full Form 990
date: 2026-07-24T00:00:00.000Z
description: >-
  How many 990s were e-filed for tax year 2015 versus 2023, and how many public
  charities founded 2015-2023 have filed a full Form 990, from canonical
  IRS/NCCS data.
format: gfm
type: analysis
categories:
  - efile
  - trends
author:
  - id: thiya
citation:
  container-title: National Center for Charitable Statistics
  volume: 1
  issue: 1
  note: >-
    E-file v2.1 990/990-EZ headers (efile_v2_1@2009-2024); BMF master
    (geocoded, rolling@2026-07-24). Full provenance in _pins.csv of
    nccs-data-requests/requests/2026-07-efile-growth-new-charities.
knitr:
  opts_chunk:
    dev: png
---


## The ask

> 1.  How many 990s were e-filed in tax year 2015 versus tax year 2023?
> 2.  How many new public charities, eligible for filing the full Form
>     990, were founded between 2015 and 2023?

(Requester identity and the verbatim ask are in the gitignored
`_private.md`.)

## Data & method

Two canonical artifacts, joined on `EIN2`:

- **E-file Form 990 header tables**
  (`s3://nccs-efile/public/efile_v2_1/`, `F9-P00-T00-HEADER-{year}.CSV`,
  all 16 published tax years 2009-2024). One row per e-filed 990 or
  990-EZ. Two fields matter beyond identity: `RETURN_TYPE` distinguishes
  the full 990 from the 990-EZ, and `F9_00_YEAR_FORMATION` is the
  organization’s founding year as self-reported on the return, a field
  the BMF does not carry (the BMF has only the IRS *ruling* date, which
  lags founding).
- **Geocoded unified BMF** (via `nccsdata::nccs_read`), which supplies
  public-charity status: `org_type = "public_charity"` is the package’s
  canonical cut (501(c)(3), foundation code not private-foundation).

Conventions this analysis follows:

- **Everything is by tax year.** NCCS deliberately re-partitions IRS
  calendar-year files by tax year during harmonization; all counts below
  are tax-year counts.
- **Form type and tax year are taken from the `RETURN_TYPE` and
  `TAX_YEAR` columns on every row**, never inferred from a file’s name.
  The read helper carries a `file_year` column so the render itself
  verifies the partitioning (see the check below).
- “Eligible for filing the full 990” is proxied by *demonstrated*
  filing: an EIN counts if it filed at least one full Form 990 (not EZ)
  in tax years 2015-2024. A threshold-based alternative (receipts \>=
  \$200k or assets \>= \$500k in the current BMF) is reported as a
  sensitivity check.

Partitioning check on this render: 5,675,704 header rows scanned, **0
rows** where the in-column `TAX_YEAR` disagrees with the file-name year;
`RETURN_TYPE` values present: 990, 990EZ.

## Findings

### Q1: E-filed 990s by tax year

``` r
q1 <- hdr |>
  count(TAX_YEAR, RETURN_TYPE) |>
  group_by(TAX_YEAR) |>
  summarise(
    `Full 990` = sum(n[RETURN_TYPE == "990"]),
    `990-EZ`   = sum(n[RETURN_TYPE == "990EZ"]),
    Total      = sum(n),
    .groups = "drop"
  ) |>
  arrange(TAX_YEAR)
knitr::kable(q1 |> mutate(across(-TAX_YEAR, fmt)), align = "lrrr")
```

| TAX_YEAR | Full 990 |  990-EZ |   Total |
|:---------|---------:|--------:|--------:|
| 2009     |   33,311 |  15,470 |  48,781 |
| 2010     |  123,025 |  63,326 | 186,351 |
| 2011     |  159,504 |  82,048 | 241,552 |
| 2012     |  179,688 |  93,750 | 273,438 |
| 2013     |  198,855 | 104,375 | 303,230 |
| 2014     |  218,619 | 116,417 | 335,036 |
| 2015     |  233,519 | 124,894 | 358,413 |
| 2016     |  243,903 | 130,484 | 374,387 |
| 2017     |  261,612 | 139,144 | 400,756 |
| 2018     |  271,442 | 149,384 | 420,826 |
| 2019     |  284,515 | 152,688 | 437,203 |
| 2020     |  343,789 | 171,890 | 515,679 |
| 2021     |  336,513 | 202,725 | 539,238 |
| 2022     |  348,027 | 205,527 | 553,554 |
| 2023     |  329,036 | 198,728 | 527,764 |
| 2024     |   78,815 |  80,681 | 159,496 |

**Tax year 2015: 358,413 e-filed returns. Tax year 2023: 527,764**,
about 1.5x. Two structural notes: e-filing was optional before tax year
2021 (the Taxpayer First Act mandate), so early years reflect e-file
adoption rather than all filings, while 2023 is near-complete; and tax
year 2024 is still accruing. This table covers the 990 and 990-EZ; the
990-PF and 990-N are separate products.

### Q2: New public charities that grew into the full 990

``` r
founders <- hdr |>
  filter(
    RETURN_TYPE == "990",
    !is.na(F9_00_YEAR_FORMATION),
    F9_00_YEAR_FORMATION >= 2015, F9_00_YEAR_FORMATION <= 2023,
    F9_00_YEAR_FORMATION <= TAX_YEAR   # formation cannot postdate the tax year
  ) |>
  group_by(EIN2) |>
  summarise(formation_year = min(F9_00_YEAR_FORMATION), .groups = "drop")

new_pc <- founders |> semi_join(pc, by = "EIN2")

knitr::kable(
  new_pc |> count(formation_year, name = "Public charities") |>
    mutate(`Public charities` = fmt(`Public charities`)),
  align = "lr"
)
```

| formation_year | Public charities |
|:---------------|-----------------:|
| 2015           |            8,208 |
| 2016           |            8,074 |
| 2017           |            7,940 |
| 2018           |            7,720 |
| 2019           |            7,590 |
| 2020           |            7,146 |
| 2021           |            6,638 |
| 2022           |            5,271 |
| 2023           |            3,239 |

**61,826 public charities** founded 2015-2023 have filed at least one
full Form 990 (of 70,668 full-990 filers reporting those formation years
across all subsections).

Sensitivity and cross-checks:

- Restricting to explicit 170(b)(1)(A) / 509(a) foundation codes
  (dropping orgs whose foundation code is missing or in suspense) gives
  61,074.
- The BMF-only alternative: 657,426 public charities have IRS *ruling*
  years 2015-2023, of which 57,888 currently meet the statutory full-990
  thresholds (receipts \>= \$200k or assets \>= \$500k). Two independent
  definitions land in the same range, which is reassuring.

### How much of the e-file growth is new organizations?

The anticipated follow-up: did full-990 e-filers grow because new
charities formed, or because existing charities were not e-filing in
2015?

``` r
new_by_ty <- hdr |>
  filter(
    RETURN_TYPE == "990",
    !is.na(F9_00_YEAR_FORMATION),
    F9_00_YEAR_FORMATION >= 2015, F9_00_YEAR_FORMATION <= 2023,
    F9_00_YEAR_FORMATION <= TAX_YEAR
  ) |>
  distinct(TAX_YEAR, EIN2)

decomp <- hdr |>
  filter(RETURN_TYPE == "990") |>
  count(TAX_YEAR, name = "full_990_filers") |>
  left_join(
    new_by_ty |> count(TAX_YEAR, name = "founded_2015_plus"),
    by = "TAX_YEAR"
  ) |>
  left_join(
    new_by_ty |> semi_join(pc, by = "EIN2") |>
      count(TAX_YEAR, name = "of_which_public_charities"),
    by = "TAX_YEAR"
  ) |>
  mutate(founded_pre_2015 = full_990_filers - founded_2015_plus) |>
  filter(TAX_YEAR >= 2015, TAX_YEAR <= 2023)

knitr::kable(decomp |> mutate(across(-TAX_YEAR, fmt)), align = "lrrrr")
```

| TAX_YEAR | full_990_filers | founded_2015_plus | of_which_public_charities | founded_pre_2015 |
|:---|---:|---:|---:|---:|
| 2015 | 233,519 | 1,627 | 1,392 | 231,892 |
| 2016 | 243,903 | 4,769 | 4,053 | 239,134 |
| 2017 | 261,612 | 8,846 | 7,647 | 252,766 |
| 2018 | 271,442 | 13,902 | 11,951 | 257,540 |
| 2019 | 284,515 | 19,689 | 17,174 | 264,826 |
| 2020 | 343,789 | 28,327 | 24,516 | 315,462 |
| 2021 | 336,513 | 37,231 | 32,747 | 299,282 |
| 2022 | 348,027 | 45,667 | 40,379 | 302,360 |
| 2023 | 329,036 | 50,216 | 44,695 | 278,820 |

Between TY2015 and TY2023 the annual count of full-990 e-filers rose by
95,517. Organizations founded in 2015 or later account for 48,589 of
that increase (50,216 of TY2023’s filers, versus 1,627 in TY2015);
organizations founded before 2015 account for the remaining 46,928.
Roughly half and half.

The coverage context reframes both halves: per the published e-file
catalog, only about **68% of 990/990-EZ filings were electronic in tax
year 2015**, rising to essentially 100% by 2023 (see the
paper-vs-electronic table in
[catalog-efile-v2_1](https://urbaninstitute.github.io/nccs/catalogs/catalog-efile-v2_1.html)).
Adjusting TY2015’s 358,413 e-filed returns for the missing paper share
implies a total filing volume close to TY2023’s 527,764. Total
990/990-EZ filing volume was therefore roughly flat: the pre-2015
organizations in the table above are mostly *newly visible* rather than
newly filing, and the new organizations are largely replacing
organizations that dissolved.

## Takeaways

- E-filed 990/990-EZ volume grew ~1.5x from tax year 2015 to 2023, with
  the mandate visible as a step in 2020-2021. Coverage-adjusted (68%
  electronic in 2015 vs ~100% in 2023), total filing volume was roughly
  flat: the growth in *visible* filers is predominantly the e-file
  mandate.
- Roughly 60-62k public charities founded since 2015 have already grown
  into the full Form 990. The count tapers for recent cohorts
  (2022-2023) purely from filing lag: young orgs have not yet filed
  their first 990.
- Of the growth in annual full-990 e-filers, about half is organizations
  founded 2015+ entering the data and half is pre-2015 organizations
  becoming newly visible; with flat total volume, new entrants largely
  replace dissolved organizations rather than expanding the total.
- Formation year is self-reported on the return; rows where it postdates
  the tax year are dropped as misreports.
- Orgs that only ever paper-filed (possible before tax year 2021) or
  only filed the EZ/N despite full-990 size are not counted, so the
  e-file-based number is a floor.

------------------------------------------------------------------------

*Reproducibility: this story reads the vintages pinned in `_pins.csv`;
rerun from those pins to reproduce. First render downloads ~3.7 GB of
e-file headers into the gitignored `data/` cache; later renders are
fast. See ADR 0024 / 0025 in `nccs-contracts`.*
