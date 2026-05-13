---
title: NCCS Core Series
date: 2024-07-23
description: A panel of nonprofit organizations derived from annual IRS Form 990 filings, spanning 1990 to present.
categories:
  - 990
  - financial-trends
  - nonprofits
featured: true
featuredOrder: 1
primaryCtaUrl: "../../catalogs/catalog-core.html"
primaryCtaText: Data Catalog
primaryCtaCaption:
primaryLinks:
  - text: "Processing Guide"
    href: "https://urbaninstitute.github.io/nccs-data-core/"
    icon: article
  - text: "Quality Reports"
    href: "https://urbaninstitute.github.io/nccs-data-core/12-quality-reports.html"
    icon: chart-bar
author:
- id: jlecy
- id: thiya
citation:
  author: "Jesse Lecy"
  citationDate: "2024"
  container-title: "NCCS Core Series"
---

The NCCS Core Data Series is a panel of nonprofit organizations derived from annual IRS Form 990 filings. It is the flagship product for tracking nonprofit financials, governance, and program activity over time, and serves as a primary research dataset alongside the [Business Master File](bmf.html).

<div style="display: flex; flex-wrap: wrap; gap: 1rem; margin: 2rem 0; padding: 1.5rem; background: #f5f5f5; border-radius: 4px;">
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">1990&ndash;2024</div>
    <div style="font-size: 0.85rem; color: #555;">coverage span</div>
  </div>
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">4</div>
    <div style="font-size: 0.85rem; color: #555;">form-type variants</div>
  </div>
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">100+</div>
    <div style="font-size: 0.85rem; color: #555;">annual datasets</div>
  </div>
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">{{ site.time | date: "%Y-%m-%d" }}</div>
    <div style="font-size: 0.85rem; color: #555;">last verified</div>
  </div>
</div>

Need to download specific files? **[Browse the Core Data Catalog &rarr;](../../catalogs/catalog-core.html)**

## What's in (and what's missing from) the Core Series

The Core Series harmonizes annual Form 990 filings into year-by-form-type files with stable variable names. Each year/file pools 501(c)(3) charities and all other 501(c) types into a single product. Use the `is_501c3` column (boolean, `TRUE` for 501(c)(3) public charities) to filter when needed; the raw `subsection_cd` is also available for finer-grained 501(c) subclassification.

Files are organized by **filing form** rather than organization type. The four products are:

- **990** — full-form filers (the larger nonprofits, with the richest variable set)
- **990EZ** — short-form filers (mid-sized nonprofits, fewer disclosed variables)
- **990 Combined** — 990 and 990EZ filers stacked together using the shared variable subset
- **990PF** — private foundations (a separate filing form with its own variables)

The Core Series does **not** include 990N ePostcard filers — the smallest nonprofits (gross receipts < \$50k) that file a minimal information return. These organizations make up a large share of the registered nonprofit population but disclose almost no financial or programmatic detail. If they are relevant to your research, consult the [990N Postcard dataset](postcard.html) separately.

Other scope notes:

- The `is_501c3` column (boolean) distinguishes 501(c)(3) public charities from all other 501(c) types within each file; filter on this rather than expecting separate files. `subsection_cd` is also available for finer 501(c) subclass breakdowns.
- Data dictionaries are **per year, per form type**. The variable set evolves with the underlying 990 form, so dictionary files are not interchangeable across years.
- Variables in the Core Series are financial and governance fields disclosed on the 990 itself. For organizational attributes like NTEE code, 501c type, or address, merge against the [Business Master File](bmf.html) using EIN.

## Which dataset should I use?

| If you need... | Use | Where to get it |
|:---|:---|:---|
| Full Form 990 filers, max variables | **990** | [Catalog &rarr; 990](../../catalogs/catalog-core.html#section-990) |
| Short-form (990EZ) filers only | **990EZ** | [Catalog &rarr; 990EZ](../../catalogs/catalog-core.html#section-990ez) |
| The broadest 990 + 990EZ population per year | **990 Combined** | [Catalog &rarr; 990 Combined](../../catalogs/catalog-core.html#section-990combined) |
| Private foundations | **990PF** | [Catalog &rarr; 990PF](../../catalogs/catalog-core.html#section-990pf) |

Each catalog section exposes the underlying S3 prefix for programmatic access and links per-year dictionaries and quality reports.

## Documentation & support

**Primary sources**

- [IRS Form 990 series](https://www.irs.gov/forms-pubs/about-form-990) — the upstream IRS filing forms (990, 990EZ, 990PF) and their published instructions.
- [Nonprofit Open Data Collective concordance file](https://github.com/Nonprofit-Open-Data-Collective/irs-efile-master-concordance-file) — the variable-name harmonization mapping that underlies Core Series naming.

**NCCS resources**

- [Core Data Catalog](../../catalogs/catalog-core.html) — every published file with downloads, dictionaries, and quality reports.
- [CORE Pipeline Guide](https://urbaninstitute.github.io/nccs-data-core/) — architecture, harmonization logic, known upstream-IRS data quirks, and per-year/per-form quality reports.
- [Business Master File](bmf.html) — merge organizational attributes (NTEE, 501c type, address, lat/lon) onto Core rows via EIN.
- [Census Crosswalk](census.html) — aggregate Core data to tracts, counties, or metro areas using standard FIPS codes.
- [Sector in Brief dashboard](https://nccs-urban.shinyapps.io/sector-in-brief/) — request full panels with BMF attributes pre-joined.
- [Contact / Get Help](https://nccs.urban.org/nccs/contact/) — questions, corrections, data requests.
