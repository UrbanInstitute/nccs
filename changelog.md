---
title: "Data Changelog"
description: Plain-language record of every change to the NCCS data sets on S3, newest first. Each entry is derived from a release note kept in the nccs-contracts repository.
layout: page
permalink: /changelog/
activeLink: /datasets/
---

This page records changes to the data sets NCCS publishes, newest first. Each entry summarizes a release note in the [nccs-contracts governance record](https://github.com/UrbanInstitute/nccs-contracts/tree/main/governance/release-notes), which is the authoritative source. Architecture decision records (ADRs) linked below give the full reasoning.

## 2026-09-15: NTEE-V2 code correction (Unified BMF and related files)

**Data sets:** Unified BMF (plain and geocoded), per-state marts, NTEE-resolved crosswalk, and every per-month and legacy processed BMF file.

**What changed:** the `nteev2_code` and `nteev2` columns. In the NTEE-V2 scheme, codes 01 to 19 in the last two digits describe organization type and belong in the suffix; the activity slot should read `x00`. Our pipeline repeated the type in both places (`B11` was published as `EDU-B11-MS` instead of `EDU-B00-MS`) on about 8.5% of Unified BMF rows. A second correction replaces stale values that came from monthly files processed before the June 2026 NTEE cleaner fix. Values are corrected in place; no columns or rows were added, renamed, or removed, and `nteev2_subsector` and `nteev2_org_type` are unchanged.

**What to do:** if you group or filter by `nteev2_code` or `nteev2`, re-download. The monthly processed files from June 2023 through May 2026 also receive the June 2026 cleaner correction for the first time, so on those files `ntee_code_clean`, `ntee_code_major_group`, `naics_code` and the definition columns change too, and a `nteev2_subsector_definition` column is added. Files for September and October 2024 are published for the first time.

**Version:** `2026_09`, git `dbf33ae` in every manifest. The previous geocoded build stays available at `geocoding/unified-bmf/v2026_07/`.

**Credit:** the defect was identified by Jesse Lecy, Nonprofit Open Data Collective. Reasoning and verification: [ADR 0048](https://github.com/UrbanInstitute/nccs-contracts/blob/main/decisions/0048-nteev2-specialty-code-x00-rule.md); release note [nteev2-x00-correction](https://github.com/UrbanInstitute/nccs-contracts/blob/main/governance/release-notes/nteev2-x00-correction.md).

## 2026-08-11: E-file release `efile_v2_2`

**Data sets:** IRS 990 e-file tables at `s3://nccs-efile/public/efile_v2_2/` (produced by the Nonprofit Open Data Collective, documented by NCCS).

**What changed:** about 500,000 late-arriving filings for tax years 2022 to 2024 were added, and tax year 2024 coverage begins. The change is purely additive. NCCS compared all 677,121 full-990 filings shared between v2_1 and v2_2 on the government-grants field and found no revised values. Per-year additions for full 990s: tax year 2022 plus 1,057 filings, tax year 2023 plus 25,732, tax year 2024 new (about 78,000 and growing). The table set is identical to v2_1.

**What to do:** analyses built on v2_1 remain valid. Recent-year totals rise when recomputed on v2_2 because coverage improved, not because values were corrected. v2_1 stays at its existing path. Two quirks: the folder carries a row-count summary file still named `...EFILE_V2_1.CSV`, and the SUMMARY table holds about 2 million duplicate 990-EZ rows with null expenses (deduplicate on `OBJECTID` before joining).

**Source:** release note [efile-v2_2](https://github.com/UrbanInstitute/nccs-contracts/blob/main/governance/release-notes/efile-v2_2.md).
