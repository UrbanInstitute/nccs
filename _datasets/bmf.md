---
title: Business Master File (BMF)
date: 2026-02-04
description: All active organizations that have been granted nonprofit status by the IRS.
categories:
  - BMF
featured: true
featuredOrder: 2
primaryCtaUrl: "../../catalogs/catalog-bmf.html"
primaryCtaCaption: "Data catalog containing downloadable files"
citation:
  author: "Thiyaghessan Poongundranar"
  citationDate: "2026"
  container-title: "NCCS BMF"
  doi:
primaryLinks:
  - text: "BMF Data Guide"
    href: "https://urbaninstitute.github.io/nccs-data-bmf/index.html"
    icon: article
---

## What is the Business Master File?

The IRS Business Master File (BMF) is a comprehensive registry of tax-exempt organizations in the United States. Updated monthly by the IRS, it serves as the authoritative record of organizations that have been granted tax-exempt status and remain in compliance with federal filing requirements.

The BMF includes organizations across all tax-exempt categories, including:

-   **501(c)(3)** — Charitable organizations, foundations, and religious entities
-   **501(c)(4)** — Social welfare organizations and civic leagues
-   **501(c)(6)** — Business leagues, chambers of commerce, and trade associations
-   **501(c)(7)** — Social clubs
-   **527** — Political organizations, including political action committees (PACs)

The IRS recognizes [over 30 categories of tax-exempt organizations](https://www.irs.gov/charities-non-profits/types-of-tax-exempt-organizations); the above represent the most common in nonprofit research.

For each organization, the BMF contains identifying information (name, address, EIN), filing status, and the IRS forms associated with their tax-exempt designation.

### The BMF as a Research Framework

The BMF functions as the primary sampling frame for nonprofit research, containing the universe of organizations with recognized federal tax-exempt status. However, it does not capture all nonprofit activity. The following are excluded:

-   Organizations incorporated as nonprofits at the state level that have not applied for federal tax-exempt recognition
-   Churches and religious organizations that exercise tax-exempt status without seeking formal IRS recognition
-   Unincorporated civic groups, social movements, and organizations operating under fiscal sponsorship arrangements
-   501(c)(4) organizations that self-declare intent to operate via Form 8976 rather than completing the formal IRS application process

Understanding these scope limitations is essential when using the BMF for research design or policy analysis.

## Available Datasets

NCCS provides BMF data in several formats to support different research needs. All files are available through the [BMF Data Catalog](https://nccs.urban.org/nccs/catalogs/catalog-bmf.html).

### Transformed BMF

The Transformed BMF applies standardized cleaning and validation to monthly IRS releases. Each file includes:

-   Standardized column names and data types
-   Quality flags identifying potential data issues
-   Documentation of all transformations applied

**Use when:** You need current BMF data with consistent formatting and documented quality checks.

**Coverage:** Current with latest IRS releases

**Documentation:** [Processing pipeline and data dictionary](https://urbaninstitute.github.io/nccs-data-bmf/)

**Source code:** [GitHub repository](https://github.com/UrbanInstitute/nccs-data-bmf)

### Unified BMF

The Unified BMF consolidates all historical BMF releases into a single file, with one row per organization that has ever held tax-exempt status. This enables longitudinal analysis without merging multiple annual files.

Features include:

-   `ORG_YEAR_FIRST` and `ORG_YEAR_LAST` variables tracking when organizations entered and exited the BMF
-   Most recent address geocoded to Census block
-   FIPS codes at block, tract, county, and state levels for merging with Census data
-   Metropolitan area codes using current CBSA definitions

**Use when:** You need to track organizations over time, build historical sampling frames, or link nonprofit data to Census geographies.

**Coverage:** 1989 through mid-2025 (update pending)

**Access:** [Public S3 Link](https://nccsdata.s3.us-east-1.amazonaws.com/bmf/unified/v1.2/UNIFIED_BMF_V1.2.csv)

**Related resources:** [NCCS Census Crosswalk](https://nccs.urban.org/nccs/datasets/census/) for aggregating to additional geographic levels

### Raw BMF Archives

NCCS archives unmodified monthly BMF files as released by the IRS on their [Exempt Organizations Business Master File Extract](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf) page. These files use the IRS's original schema and [data dictionary](https://www.irs.gov/pub/irs-soi/eo-info.pdf).

**Use when:** You need to replicate analysis built on raw IRS files from a specific point in time, or require data exactly as the IRS published it.

**Coverage:** June 2023 to present (monthly snapshots)

**Format:** `YYYY-MM-BMF.csv`

**Access:** Files are available from the public `nccsdata` S3 bucket at: `https://nccsdata.s3.us-east-1.amazonaws.com/raw/bmf/{filename}`

Example: [2023-06-BMF.csv](https://nccsdata.s3.us-east-1.amazonaws.com/raw/bmf/2023-06-BMF.csv)

### Legacy BMFs

Historical BMF files produced by NCCS between 1989 and 2022. These files retain their original schemas, which vary across years. Data dictionaries are available for most but not all years.

**Use when:** You need to replicate historical NCCS analyses or require BMF data in its original pre-transformation format.

**Coverage:** 1989–2022

**Note:** Column names are not standardized across files. For longitudinal work, consider the Unified BMF or wait for the forthcoming Harmonized Legacy BMFs.

## In Development

The following datasets are currently in progress. Expected timelines are estimates and subject to change.

### Harmonized Legacy BMFs

The Legacy BMF files (1989–2022) use inconsistent column names and schemas across years, making longitudinal analysis difficult. The Harmonized Legacy BMFs will standardize these files to align with the Transformed BMF schema, enabling seamless merging across the full 1989–present time series.

**Expected:** Q1 2026

### Metadata Tables

Organizational attributes in the BMF—such as name, address, and NTEE code—can change over time. Currently, only the most recent value is retained. The Metadata Tables will track these changes using a slowly changing dimension (SCD Type 2) structure, preserving the full history of:

-   Organization names
-   Addresses
-   NTEE classifications

This will support research on organizational relocation, rebranding, and mission drift.

**Expected:** Q1 2026

### Unified BMF v2.0

An updated Unified BMF that:

-   Incorporates BMF releases through late 2025
-   Adopts column names consistent with the Transformed BMF schema
-   Rebuilds the processing pipeline for compatibility with current infrastructure

This replaces the current Unified BMF, which uses a legacy architecture and covers data only through mid-2025.

**Expected:** Q1 2026

## Release Status

| Dataset                |  Status   | Last Updated | Expected | Coverage             | Documentation                                                         |
|:-----------------------|:---------:|:------------:|:--------:|:---------------------|:----------------------------------------------------------------------|
| Transformed BMF        | Available |   Ongoing    |    —     | Current IRS releases | [Pipeline docs](https://urbaninstitute.github.io/nccs-data-bmf/)      |
| Raw BMF Archives       | Available |   Ongoing    |    —     | June 2023–present    | [IRS data dictionary](https://www.irs.gov/pub/irs-soi/eo-info.pdf)    |
| Unified BMF            | Available |   Mid-2025   |    —     | 1989–mid-2025        | [Data catalog](https://nccs.urban.org/nccs/catalogs/catalog-bmf.html) |
| Legacy BMFs            | Archived  |      —       |    —     | 1989–2022            | [Data catalog](https://nccs.urban.org/nccs/catalogs/catalog-bmf.html) |
| Harmonized Legacy BMFs |  Planned  |      —       | Q1 2026  | 1989–2022            | TBD                                                                   |
| Metadata Tables        |  Planned  |      —       | Q1 2026  | 1989–present         | TBD                                                                   |
| Unified BMF v2.0       |  Planned  |      —       | Q1 2026  | 1989–late 2025       | TBD                                                                   |

## Contact

Users are encouraged to submit any questions and comments regarding this data set on our [contact page](https://nccs.urban.org/nccs/contact/).
