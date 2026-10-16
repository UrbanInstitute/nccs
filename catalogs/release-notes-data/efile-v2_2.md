# NCCS E-File Release Note — efile_v2_2

**Released:** 2026-08-11 · **Location:** `s3://nccs-efile/public/efile_v2_2/`
· **Producer:** NODC (`ef2`) · **Documented by:** NCCS

**What changed:** this build adds approximately 500,000 late-arriving
filings for tax years 2022-2024 and introduces tax year 2024
coverage. **It is purely additive**: NCCS verification compared all
677,121 full-990 filings shared between v2_1 and v2_2 on the
government-grants field and found zero value revisions — previously
published numbers do not restate. Per-year full-990 deltas: TY2022
+1,057 filings; TY2023 +25,732; TY2024 new (~78K and growing as
filings arrive). Table coverage is identical to v2_1 (1,794 files,
same table set).

**For users:** analyses built on v2_1 remain valid as published.
Recent-year totals (especially TY2023-24) will increase when
recomputed on v2_2 because coverage improved, not because data was
corrected. v2_1 remains available at its existing path.

**Known quirks:** the folder carries a row-count summary file named
`...EFILE_V2_1.CSV` (comparison table / stale name — clarification
pending); the SUMMARY table contains ~2M duplicate 990-EZ rows with
NULL expenses (dedup on OBJECTID before joins).

**Verification:** NCCS crosscheck 2026-08-11 (OBJECTID-level join of
shared filings, grants field). Method available on request.
