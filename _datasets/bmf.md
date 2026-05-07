---
title: Business Master File (BMF)
date: 2026-02-04
description: The IRS registry of organizations exempt from federal income tax.
categories:
  - BMF
featured: true
featuredOrder: 2
primaryCtaUrl: "https://nccsdata.s3.amazonaws.com/master/bmf/bmf_master.csv"
primaryCtaCaption: "Master BMF"
primaryLinks:
  - text: "Data Catalog"
    href: "../../catalogs/catalog-bmf.html"
    icon: database
  - text: "Processing Guide"
    href: "https://urbaninstitute.github.io/nccs-data-bmf/index.html"
    icon: article
citation: 
  author: "Thiyaghessan Poongundranar"
  citationDate: "2026"
  container-title: "NCCS Master BMF"
  doi:
---

The Business Master File (BMF) is the IRS registry of organizations exempt from federal income tax. NCCS publishes the BMF in several harmonized forms; the **Master BMF** is the flagship product — one row per EIN spanning 1989 to present.

<div style="display: flex; flex-wrap: wrap; gap: 1rem; margin: 2rem 0; padding: 1.5rem; background: #f5f5f5; border-radius: 4px;">
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">~3.8 million</div>
    <div style="font-size: 0.85rem; color: #555;">organizations ever</div>
  </div>
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">~1.8 million</div>
    <div style="font-size: 0.85rem; color: #555;">currently active</div>
  </div>
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">1989&ndash;present</div>
    <div style="font-size: 0.85rem; color: #555;">coverage span</div>
  </div>
  <div style="flex: 1 1 160px; min-width: 140px;">
    <div style="font-size: 1.6rem; font-weight: 600; line-height: 1.1;">{{ site.time | date: "%Y-%m-%d" }}</div>
    <div style="font-size: 0.85rem; color: #555;">last verified</div>
  </div>
</div>

Need to download specific files? **[Browse the BMF Data Catalog &rarr;](../../catalogs/catalog-bmf.html)**

## What's in (and what's missing from) the BMF

The BMF functions as the primary sampling frame for nonprofit research, containing the universe of organizations with recognized federal tax-exempt status. The IRS recognizes [over 30 categories of tax-exempt organizations](https://www.irs.gov/charities-non-profits/types-of-tax-exempt-organizations); the most common in nonprofit research are:

- **501(c)(3)** — charitable organizations, foundations, and religious entities
- **501(c)(4)** — social welfare organizations and civic leagues
- **501(c)(6)** — business leagues, chambers of commerce, trade associations
- **501(c)(7)** — social clubs
- **527** — political organizations, including PACs

The BMF does **not** capture all nonprofit activity. Important exclusions:

- Organizations incorporated as nonprofits at the state level that have not applied for federal tax-exempt recognition
- Churches and religious organizations that exercise tax-exempt status without seeking formal IRS recognition
- Unincorporated civic groups, social movements, and organizations operating under fiscal sponsorship arrangements
- 501(c)(4) organizations that self-declare intent to operate via Form 8976 rather than completing the formal IRS application process

Understanding these scope limitations is essential when using the BMF for research design or policy analysis.

Source: [IRS Exempt Organizations BMF Extract](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf). Field definitions and processing rules follow [IRM 25.7.1](https://www.irs.gov/irm/part25/irm_25-007-001).

## Which dataset should I use?

| If you need... | Use | Where to get it |
|:---|:---|:---|
| One row per nonprofit, ever (1989–present) | **Master BMF** | [Catalog &rarr; Master BMF](../../catalogs/catalog-bmf.html#master-bmf) |
| A specific month's snapshot | **Monthly BMF** (transformed for 2023-06+, harmonized legacy for earlier) | [Catalog &rarr; Monthly BMF](../../catalogs/catalog-bmf.html#monthly-bmf) |
| The unmodified IRS or NCCS file | **Raw archives** (for replication only) | [Catalog &rarr; Raw Archives](../../catalogs/catalog-bmf.html#raw-archives) |

Each catalog section also exposes the underlying S3 prefix for programmatic access.

## Documentation & support

**Primary sources**

- [IRS Exempt Organizations BMF Extract](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf) — the upstream IRS data product, with the original schema and release cadence.
- [IRM 25.7.1 — Exempt Organizations Business Master File](https://www.irs.gov/irm/part25/irm_25-007-001) — the IRS Internal Revenue Manual chapter governing BMF maintenance, code definitions, and authoritative scope.

**NCCS resources**

- [Processing guide](https://urbaninstitute.github.io/nccs-data-bmf/index.html) — how NCCS cleans, harmonizes, and validates BMF data.
- [Quality reports index](https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/) — every per-month and per-product quality report.
- [Source repository](https://github.com/UrbanInstitute/nccs-data-bmf) — pipeline code and issue tracker.
- [Contact / Get Help](https://nccs.urban.org/nccs/contact/) — questions, corrections, data requests.
