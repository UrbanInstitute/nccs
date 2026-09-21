---
title: NTEE Codes and NAICS Crosswalk
date: 2026-09-21
description: Every NTEE code the IRS assigns, with descriptions and the matching NAICS industry, as one downloadable table.
categories:
  - metadata
  - crosswalks
featured: false
primaryCtaUrl: "https://nccsdata.s3.amazonaws.com/lookups/bmf/latest/ntee_code.csv"
primaryCtaCaption: 'CSV, one row per code &middot; <a href="https://nccsdata.s3.amazonaws.com/lookups/bmf/latest/_manifest.json">Manifest</a>'
primaryLinks:
  - text: "Browse the table"
    href: "../../widgets/ntee_tables/ntee-naics_table.html"
    icon: search
  - text: "NTEE guide"
    href: "../../resources/ntee/"
    icon: article
  - text: "All lookup tables"
    href: "https://nccsdata.s3.amazonaws.com/lookups/bmf/latest/_manifest.json"
    icon: database
citation:
  author: "National Center for Charitable Statistics"
  citationDate: "2026"
  container-title: "NCCS BMF lookup tables: NTEE codes"
---

The National Taxonomy of Exempt Entities (NTEE) is the classification system the IRS uses to describe what a nonprofit does. This table lists every NTEE code the IRS assigns, one row per code, with:

- **Code** and the **major group** it belongs to (A through Z).
- A **short description** in the IRS's own words, and a **longer description** where one exists.
- The closest **NAICS industry** (2022 edition), for anyone linking nonprofit data to economic statistics.

It is the same lookup table the NCCS data pipeline uses to label the [Business Master File](../bmf/), so the codes here match the codes in the data. Codes the IRS has retired stay in the table because older files still carry them. The table is refreshed whenever the IRS changes its list, and checked against the IRS list every January. The browsable table reads the current file each time it is opened, so it never lags behind the download.

## Columns

| Column | Meaning |
|---|---|
| `ntee_code` | Three-character NTEE code, for example `B29`. |
| `naics_code` | NAICS 2022 industry code, or `UNDEFINED` for `Z99` (unknown). |
| `ntee_code_definition` | Short description, IRS wording. |
| `ntee_code_description` | Longer description. Blank for the newest IRS codes. |
| `effective_date` | Date the row was last changed, as `YYYYMMDD`. |

## Related tables

The same folder on S3 holds the other decoder tables the pipeline uses, such as major groups (`ntee_code_major_group.csv`), NTEE version 2 subsectors, subsection codes, and foundation codes. The manifest lists every file with its row count and checksum.

For the history of the taxonomy, the NTEE version 2 format, and advice for nonprofits choosing a code, see the [NTEE guide](../../resources/ntee/).
