# End-to-end render check.
# Copies catalog-bmf.qmd + R/ helpers into a tempdir, writes a synthetic
# AWS-BMF.csv there, runs `quarto render`, and asserts on the rendered HTML.
# Renders in a tempdir so the real catalogs/ directory is never touched.

suppressPackageStartupMessages(library(stringr))

resolve_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  hits <- args[grepl("^--file=", args)]
  if (length(hits)) return(dirname(normalizePath(sub("^--file=", "", hits[1]))))
  frame_file <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  if (!is.null(frame_file) && nzchar(frame_file)) return(dirname(normalizePath(frame_file)))
  getwd()
}

script_dir   <- resolve_script_dir()
catalogs_dir <- normalizePath(file.path(script_dir, ".."))

work <- tempfile("bmf-render-")
dir.create(work)
on.exit(unlink(work, recursive = TRUE), add = TRUE)

# Stage the qmd, the helpers it sources, and the shared Quarto config/styles
file.copy(file.path(catalogs_dir, "catalog-bmf.qmd"), work)
file.copy(file.path(catalogs_dir, "_quarto.yml"),     work)
dir.create(file.path(work, "R"))
file.copy(file.path(catalogs_dir, "R", "bmf_helpers.R"), file.path(work, "R"))
dir.create(file.path(work, "styles"))
file.copy(file.path(catalogs_dir, "styles", "catalog.css"), file.path(work, "styles"))

# Synthetic manifest
fixture <- data.frame(
  source = c("master","master","master",
             "unified","unified",
             "geocoded",
             "processed","processed","processed",
             "processed","processed","processed",
             "legacy","legacy","legacy","legacy",
             "raw_legacy","raw_legacy"),
  Prefix = c(rep("master/bmf/", 3),
             rep("unified/bmf/", 2),
             "geocoding/master/merged/",
             rep("processed/bmf/", 6),
             rep("processed/bmf-legacy/", 4),
             rep("legacy/bmf/", 2)),
  Key = c(
    "master/bmf/BMF_MASTER_CA.csv",
    "master/bmf/BMF_MASTER_NY.csv",
    "master/bmf/BMF_MASTER_TX.csv",
    "unified/bmf/bmf_unified.csv",
    "unified/bmf/bmf_unified_data_dictionary.csv",
    "geocoding/master/merged/bmf_master_geocoded.parquet",
    # 2026-01 monthly (data + dict + qr)
    "processed/bmf/2026_01/bmf_2026_01_processed.csv",
    "processed/bmf/2026_01/bmf_2026_01_data_dictionary.csv",
    "processed/bmf/2026_01/bmf_2026_01_quality_report.json",
    # 2025-12 monthly (data + dict + qr)
    "processed/bmf/2025_12/bmf_2025_12_processed.csv",
    "processed/bmf/2025_12/bmf_2025_12_data_dictionary.csv",
    "processed/bmf/2025_12/bmf_2025_12_quality_report.json",
    # 2024-03 legacy monthly (data + dict + qr)
    "processed/bmf-legacy/2024_03/bmf_legacy_2024_03_processed.csv",
    "processed/bmf-legacy/2024_03/bmf_legacy_2024_03_data_dictionary.csv",
    "processed/bmf-legacy/2024_03/bmf_legacy_2024_03_quality_report.json",
    # 2023-11 legacy monthly (data only)
    "processed/bmf-legacy/2023_11/bmf_legacy_2023_11_processed.csv",
    "legacy/bmf/BMF-1989-06-501CX-NONPROFIT-PX.csv",
    "legacy/bmf/BMF-2010-04-501CX-NONPROFIT-PX.csv"
  ),
  Size = c(50e6, 60e6, 55e6, 1300e6, 9e3, 1500e6,
           200e6, 7e3, 100e3,
           198e6, 7e3, 100e3,
           180e6, 4e3, 90e3,
           175e6,
           80e6, 120e6),
  stringsAsFactors = FALSE
)
fixture$URL <- paste0("https://nccsdata.s3.us-east-1.amazonaws.com/", fixture$Key)
write.csv(fixture, file.path(work, "AWS-BMF.csv"), row.names = FALSE)

cat("Rendering catalog-bmf.qmd in", work, "\n")
prev_wd <- getwd()
setwd(work)
on.exit(setwd(prev_wd), add = TRUE)
status <- system2(
  "quarto",
  args = c("render", "catalog-bmf.qmd"),
  stdout = TRUE, stderr = TRUE
)
attr_status <- attr(status, "status")
if (!is.null(attr_status) && attr_status != 0) {
  cat(paste(status, collapse = "\n"), "\n")
  stop("quarto render failed")
}

html_path <- file.path(work, "catalog-bmf.html")
stopifnot(file.exists(html_path))
html <- paste(readLines(html_path, warn = FALSE), collapse = "\n")

check <- function(condition, msg) {
  if (!isTRUE(condition)) stop("ASSERTION FAILED: ", msg)
  cat("  ok: ", msg, "\n", sep = "")
}

check(grepl("Which dataset should I use?", html, fixed = TRUE),
      "Hero decision section heading present")
check(grepl(">Unified BMF<", html),
      "Unified BMF section heading present")
check(grepl("Master BMF (geocoded)", html, fixed = TRUE),
      "Geocoded variant labeled in headline table (not renamed by ADR 0037)")
check(grepl("Dictionary", html, fixed = TRUE),
      "Headline table renders DICTIONARY button per row")
# Geocoded row appears before plain row in headline table.
# Use the geocoded *URL* (unique to the table) and the plain unified BMF URL
# instead of "Unified BMF" text (which also appears in the H2 heading).
pos_geo_url   <- regexpr("geocoding/master/merged/", html)
pos_plain_url <- regexpr("unified/bmf/bmf_unified\\.csv", html)
check(pos_geo_url > 0 && pos_plain_url > 0 && pos_geo_url < pos_plain_url,
      "Geocoded variant rendered before plain variant in headline table")
check(grepl(">Monthly BMF<", html),
      "Monthly BMF section heading present")
check(grepl("Raw Archives", html, fixed = TRUE),
      "Raw Archives section present")
check(grepl("Raw Legacy BMF", html, fixed = TRUE),
      "Raw Legacy subsection present")

check(grepl("BMF_MASTER_CA\\.csv", html), "California master URL rendered")
check(grepl("BMF_MASTER_NY\\.csv", html), "New York master URL rendered")
check(grepl("BMF_MASTER_TX\\.csv", html), "Texas master URL rendered")

check(grepl(">Wyoming<", html),
      "Wyoming row present even when no file exists (left-join filler)")

check(grepl("bmf_master_geocoded\\.parquet", html),
      "Geocoded master file linked")

check(grepl("bmf_2026_01_quality_report\\.html", html),
      "2026-01 quality report URL present")
# Harmonized legacy months publish their quality report under a different
# filename on the Pages site (bmf_legacy_YYYY_MM_... vs bmf_YYYY_MM_...) --
# an era-blind template 404s for every legacy month.
check(grepl("bmf_legacy_2024_03_quality_report\\.html", html),
      "2024-03 harmonized legacy quality report URL uses the legacy filename")
check(!grepl("bmf_2024_03_quality_report\\.html", html),
      "2024-03 legacy quality report is NOT linked with the era-blind (non-legacy) filename")

# Combined monthly table: should have an Era / Pipeline column tagging both eras
check(grepl(">Transformed<", html),
      "Combined monthly table tags Transformed era")
check(grepl(">Harmonized legacy<", html),
      "Combined monthly table tags Harmonized legacy era")

# Combined monthly table is capped to 5 most recent rows by default
pos_2026 <- regexpr("bmf_2026_01_processed\\.csv", html)
pos_2025_12 <- regexpr("bmf_2025_12_processed\\.csv", html)
check(pos_2026 > 0 && pos_2025_12 > 0 && pos_2026 < pos_2025_12,
      "Combined monthly table sorted descending (2026-01 before 2025-12)")

# One row per month: 2026-01's data CSV should appear exactly twice in the
# rendered page (once in Recent Releases, once in the full Browse Older
# Releases archive) — NOT three times like the per-artifact-row bug we fixed.
data_dl_count <- length(gregexpr("bmf_2026_01_processed\\.csv", html)[[1]])
check(data_dl_count == 2,
      "2026-01 appears as a single row in each monthly table (no 3x duplication)")

# Dictionary column links the dictionary CSV
check(grepl("bmf_2026_01_data_dictionary\\.csv", html),
      "Dictionary column links the per-month dictionary CSV")

# Months without a dictionary file render an em-dash, not a broken link
check(grepl("bmf_legacy_2023_11_processed\\.csv", html),
      "Legacy month without sibling dictionary still renders its data row")

# Raw legacy section: PROFILE buttons templated correctly, no .csv extension
check(grepl("BMF-2010-04-501CX-NONPROFIT-PX</a>", html) ||
      grepl("BMF-2010-04-501CX-NONPROFIT-PX'", html) ||
      grepl("nccs-legacy/dictionary/bmf/bmf_archive_html/BMF-2010-04-501CX-NONPROFIT-PX", html),
      "Raw legacy PROFILE URL templated from filename")
check(!grepl("nccs-legacy/dictionary/bmf/bmf_archive_html/BMF-2010-04-501CX-NONPROFIT-PX\\.csv", html),
      "Raw legacy PROFILE URL strips .csv extension")

check(grepl("Last verified:", html, fixed = TRUE),
      "Auto-stamped 'Last verified' footer present")

# The unified/bmf/bmf_unified.csv headline file lives at a different S3
# prefix (unified/bmf/) than the state-by-state slice table (master/bmf/
# state-suffixed files, e.g. BMF_MASTER_CA.csv) — it should appear exactly
# once, in the headline table only, and never bleed into the state table.
unified_links <- gregexpr("unified/bmf/bmf_unified\\.csv", html)[[1]]
unified_link_count <- if (length(unified_links) == 1 && unified_links[1] == -1L) 0L else length(unified_links)
check(unified_link_count == 1,
      "Unified BMF headline file appears once (in headline table) and not in state slices")

cat("\nAll render assertions passed.\n")
