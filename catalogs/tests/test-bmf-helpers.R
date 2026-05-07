# Unit tests for catalogs/R/bmf_helpers.R
# Exercises the new BMF catalog logic against a synthetic manifest that
# mirrors the new S3 layout:
#   master/bmf/...
#   processed/bmf/YYYY_MM/...
#   processed/bmf-legacy/YYYY_MM/...

library(testthat)
library(stringr)

# Locate helpers regardless of working directory
find_helpers <- function() {
  # 1. Rscript: parse --file= from commandArgs
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
  if (length(file_arg) > 0 && nzchar(file_arg)) {
    return(file.path(dirname(dirname(normalizePath(file_arg[1]))), "R", "bmf_helpers.R"))
  }
  # 2. source(): sys.frame
  ofile <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  if (!is.null(ofile) && nzchar(ofile)) {
    return(file.path(dirname(dirname(normalizePath(ofile))), "R", "bmf_helpers.R"))
  }
  # 3. Fallback: assume cwd is nccs/ or catalogs/ or catalogs/tests/
  for (cand in c("catalogs/R/bmf_helpers.R", "R/bmf_helpers.R", "../R/bmf_helpers.R")) {
    if (file.exists(cand)) return(normalizePath(cand))
  }
  stop("Could not locate bmf_helpers.R")
}
source(find_helpers())

# -----------------------------------------------------------------------------
# Synthetic manifest fixture
# -----------------------------------------------------------------------------

make_fixture <- function() {
  rows <- list(
    # Master: state-sliced
    list(source = "master", Key = "master/bmf/BMF_MASTER_CA.csv", Size = 50e6),
    list(source = "master", Key = "master/bmf/BMF_MASTER_NY.csv", Size = 60e6),
    list(source = "master", Key = "master/bmf/BMF_MASTER_TX.csv", Size = 55e6),
    list(source = "master", Key = "master/bmf/BMF_MASTER.csv",     Size = 1300e6),  # no state suffix
    # Geocoded master
    list(source = "geocoded", Key = "geocoding/master/merged/bmf_master_geocoded.parquet", Size = 1500e6),
    # Processed: monthly
    list(source = "processed", Key = "processed/bmf/2026_01/BMF.csv", Size = 200e6),
    list(source = "processed", Key = "processed/bmf/2025_12/BMF.csv", Size = 198e6),
    list(source = "processed", Key = "processed/bmf/2025_06/BMF.csv", Size = 195e6),
    # Legacy: monthly
    list(source = "legacy", Key = "processed/bmf-legacy/2024_03/BMF.csv", Size = 180e6),
    list(source = "legacy", Key = "processed/bmf-legacy/2023_11/BMF.csv", Size = 175e6),
    # Raw legacy
    list(source = "raw_legacy", Key = "legacy/bmf/BMF-1989-06-501CX-NONPROFIT-PX.csv", Size = 80e6),
    list(source = "raw_legacy", Key = "legacy/bmf/BMF-2010-04-501CX-NONPROFIT-PX.csv", Size = 120e6),
    # Junk row that shouldn't pollute output
    list(source = "processed", Key = "processed/bmf/README.txt", Size = 1e3)
  )
  df <- do.call(rbind, lapply(rows, as.data.frame, stringsAsFactors = FALSE))
  df$URL <- paste0("https://nccsdata.s3.us-east-1.amazonaws.com/", df$Key)
  df
}

state_mapping_min <- c(
  "CA" = "California",
  "NY" = "New York",
  "TX" = "Texas",
  "WY" = "Wyoming"   # intentionally absent from the fixture -> tests dash render
)

# =============================================================================
# extract_bmf_year_month
# =============================================================================

test_that("extract_bmf_year_month parses /YYYY_MM/ segment", {
  keys <- c(
    "processed/bmf/2026_01/BMF.csv",
    "processed/bmf-legacy/2023_11/BMF.csv",
    "master/bmf/BMF_MASTER.csv",
    "processed/bmf/README.txt"
  )
  out <- extract_bmf_year_month(keys)
  expect_equal(out$year,  c("2026", "2023", NA, NA))
  expect_equal(out$month, c("01",   "11",   NA, NA))
})

test_that("extract_bmf_year_month tolerates empty input", {
  out <- extract_bmf_year_month(character(0))
  expect_equal(nrow(out), 0)
})

# =============================================================================
# extract_bmf_state
# =============================================================================

test_that("extract_bmf_state handles common naming conventions", {
  keys <- c(
    "master/bmf/BMF_MASTER_CA.csv",  # _BMF_..._XX.csv variant
    "harmonized/bmf/unified/2024-12-25_BMF_NY.csv",
    "master/bmf/BMF-TX.csv",
    "master/bmf/BMF_MASTER.csv",     # no state code
    "master/bmf/random.csv"
  )
  out <- extract_bmf_state(keys)
  expect_equal(out, c("CA", "NY", "TX", NA, NA))
})

# =============================================================================
# build_quality_report_url
# =============================================================================

test_that("build_quality_report_url templates correctly and is NA-safe", {
  urls <- build_quality_report_url(c("2026", "2023", NA), c("01", "11", "05"))
  expect_equal(
    urls,
    c(
      "https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/bmf_2026_01_quality_report.html",
      "https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/bmf_2023_11_quality_report.html",
      NA
    )
  )
})

test_that("make_quality_report_links renders dash for NA", {
  links <- make_quality_report_links(c(
    "https://example.com/r1.html",
    NA
  ))
  expect_match(links[1], "QUALITY REPORT")
  expect_match(links[1], "class='button2'")
  expect_equal(links[2], "&mdash;")
})

# =============================================================================
# build_master_section
# =============================================================================

test_that("build_master_section joins states and preserves order", {
  manifest <- make_fixture()
  out <- build_master_section(manifest, state_mapping_min)

  expect_equal(nrow(out), length(state_mapping_min))
  # Order matches state_mapping order
  expect_equal(out$state, unname(state_mapping_min))

  # Present states render a real download button
  expect_true(grepl("DOWNLOAD", out$download[out$state == "California"]))
  expect_match(out$size[out$state == "California"], "mb$")

  # Missing states render an em-dash, not a phantom row
  expect_equal(out$download[out$state == "Wyoming"], "&mdash;")
  expect_equal(out$size[out$state == "Wyoming"],     "&mdash;")
})

test_that("build_master_section ignores the no-state-code master file", {
  manifest <- make_fixture()
  out <- build_master_section(manifest, state_mapping_min)
  # The unsuffixed master/bmf/BMF_MASTER.csv must not contaminate state rows.
  expect_false(any(grepl("BMF_MASTER\\.csv'", out$download)))
})

# =============================================================================
# build_monthly_section
# =============================================================================

test_that("build_monthly_section returns sorted, decorated rows", {
  manifest <- make_fixture()
  out <- build_monthly_section(manifest, "processed")

  # 3 valid monthly rows (README.txt has no YYYY_MM segment so it's dropped)
  expect_equal(nrow(out), 3)

  # Sort: most recent first
  expect_equal(out$year,  c("2026", "2025", "2025"))
  expect_equal(out$month, c("01",   "12",   "06"))

  # Every row has buttons
  expect_true(all(grepl("DOWNLOAD", out$download)))
  expect_true(all(grepl("QUALITY REPORT", out$quality_report)))

  # Quality report URL templated correctly for the top row
  expect_match(out$quality_report[1], "bmf_2026_01_quality_report\\.html")
})

test_that("build_monthly_section is independent across sources", {
  manifest <- make_fixture()
  proc <- build_monthly_section(manifest, "processed")
  leg  <- build_monthly_section(manifest, "legacy")

  expect_false(any(grepl("bmf-legacy", proc$download)))
  expect_true(all(grepl("bmf-legacy", leg$download)))
  expect_equal(nrow(leg), 2)
})

test_that("build_monthly_section handles empty source", {
  manifest <- make_fixture()
  manifest <- manifest[manifest$source != "legacy", , drop = FALSE]
  out <- build_monthly_section(manifest, "legacy")
  expect_equal(nrow(out), 0)
})

# =============================================================================
# build_combined_monthly_section
# =============================================================================

test_that("build_combined_monthly_section interleaves transformed and harmonized legacy", {
  manifest <- make_fixture()
  out <- build_combined_monthly_section(manifest, n_recent = NA)

  # 3 processed + 2 legacy valid rows (README dropped)
  expect_equal(nrow(out), 5)

  # Sort: most recent first
  expect_equal(out$year[1],  "2026")
  expect_equal(out$month[1], "01")

  # Era column tags both pipelines
  expect_true("Transformed" %in% out$era)
  expect_true("Harmonized legacy" %in% out$era)
})

test_that("build_combined_monthly_section caps to n_recent", {
  manifest <- make_fixture()
  out <- build_combined_monthly_section(manifest, n_recent = 3)
  expect_equal(nrow(out), 3)
  # The cap takes the 3 most recent
  expect_equal(out$year, c("2026", "2025", "2025"))
})

# =============================================================================
# build_geocoded_master_row
# =============================================================================

test_that("build_geocoded_master_row returns one row when present", {
  manifest <- make_fixture()
  out <- build_geocoded_master_row(manifest)
  expect_equal(nrow(out), 1)
  expect_match(out$file[1], "geocoded")
  expect_match(out$download[1], "DOWNLOAD")
})

test_that("build_geocoded_master_row returns NULL when absent", {
  manifest <- make_fixture()
  manifest <- manifest[manifest$source != "geocoded", , drop = FALSE]
  out <- build_geocoded_master_row(manifest)
  expect_null(out)
})

# =============================================================================
# build_raw_legacy_section
# =============================================================================

test_that("build_raw_legacy_section parses vintage and templates PROFILE URL", {
  manifest <- make_fixture()
  out <- build_raw_legacy_section(manifest)

  expect_equal(nrow(out), 2)
  # Sorted descending
  expect_equal(out$year, c("2010", "1989"))
  expect_equal(out$month, c("04", "06"))

  # PROFILE URL templated from filename stem
  expect_match(out$profile[1], "BMF-2010-04-501CX-NONPROFIT-PX")
  expect_false(grepl("\\.csv", out$profile[1]))
  expect_match(out$profile[1], "class='button2'")
})

test_that("build_raw_legacy_section em-dashes missing profiles", {
  manifest <- make_fixture()
  out <- build_raw_legacy_section(
    manifest,
    missing_profiles = "BMF-1989-06-501CX-NONPROFIT-PX"
  )
  # 1989 row should now show em-dash
  row_1989 <- out[out$year == "1989", , drop = FALSE]
  expect_equal(row_1989$profile, "&mdash;")
  # 2010 row still has button
  row_2010 <- out[out$year == "2010", , drop = FALSE]
  expect_match(row_2010$profile, "PROFILE")
})

test_that("build_raw_legacy_section handles empty source", {
  manifest <- make_fixture()
  manifest <- manifest[manifest$source != "raw_legacy", , drop = FALSE]
  out <- build_raw_legacy_section(manifest)
  expect_equal(nrow(out), 0)
})
