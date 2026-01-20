# Tests for NCCS Catalog extraction functions
# Tests the refactored R/ modules

library(testthat)
library(stringr)

# Source the refactored modules
test_dir <- dirname(sys.frame(1)$ofile)
if (is.null(test_dir)) test_dir <- getwd()
nccs_catalog_dir <- file.path(dirname(test_dir), "R")
source(file.path(nccs_catalog_dir, "config.R"))
source(file.path(nccs_catalog_dir, "validators.R"))
source(file.path(nccs_catalog_dir, "extractors.R"))
source(file.path(nccs_catalog_dir, "url_builders.R"))
source(file.path(nccs_catalog_dir, "buttons.R"))

# =============================================================================
# extract_year() tests
# =============================================================================

test_that("extract_year extracts 4-digit years correctly", {
  paths <- c(
    "legacy/core/CORE-2019-501C3-CHARITIES-PC.csv",
    "legacy/bmf/BMF-2020-01-PX.csv",
    "legacy/soi-micro/2018/SOI-MICRODATA-2018-501C3-NONPROFIT-PZ.csv"
  )
  result <- extract_year(paths)
  expect_equal(result, c("2019", "2020", "2018"))
})

test_that("extract_year handles paths without years", {
  paths <- c("README.md", "data.csv")
  result <- extract_year(paths)
  expect_true(all(is.na(result)))
})

test_that("extract_year only matches years 1900-2099", {
  paths <- c(
    "data-2025.csv",  # Valid
    "data-1850.csv",  # Invalid (before 1900)
    "data-2150.csv"   # Invalid (after 2099)
  )
  result <- extract_year(paths)
  expect_equal(result[1], "2025")
  expect_true(is.na(result[2]))
  expect_true(is.na(result[3]))
})

# =============================================================================
# extract_month() tests
# =============================================================================

test_that("extract_month extracts 2-digit months correctly", {
  paths <- c(
    "BMF-2020-01-PX.csv",
    "BMF-2020-06-PX.csv",
    "BMF-2020-12-PX.csv"
  )
  result <- extract_month(paths)
  expect_equal(result, c("01", "06", "12"))
})

test_that("extract_month handles paths without months", {
  paths <- c("CORE-2019-501C3-CHARITIES-PC.csv")
  result <- extract_month(paths)
  expect_true(is.na(result))
})

# =============================================================================
# filter_paths() tests
# =============================================================================

test_that("filter_paths filters BMF paths correctly", {
  paths <- c(
    "legacy/bmf/BMF-2020-01-PX.csv",
    "legacy/bmf/BMF-2020-06-PX.csv",
    "legacy/core/CORE-2019-501C3-CHARITIES-PC.csv",
    "README.md"
  )
  result <- filter_paths("bmf", paths)
  expect_length(result, 2)
  expect_true(all(grepl("BMF", result)))
})

test_that("filter_paths filters CORE paths with scope", {
  paths <- c(
    "legacy/core/CORE-2019-501C3-CHARITIES-PC.csv",
    "legacy/core/CORE-2019-501C3-CHARITIES-PZ.csv",
    "legacy/core/CORE-2019-501C3-NONPROFIT-PC.csv",
    "legacy/bmf/BMF-2020-01-PX.csv"
  )
  result <- filter_paths("core", paths, tscope = "CHARITIES", fscope = "PC")
  expect_length(result, 1)
  expect_match(result, "CHARITIES-PC")
})

test_that("filter_paths filters census-crosswalk paths", {
  paths <- c(
    "census/BLOCKX.csv",
    "census/TRACTX.csv",
    "other/data.csv"
  )
  result <- filter_paths("census-crosswalk", paths)
  expect_length(result, 2)
})

test_that("filter_paths filters revocations paths", {
  paths <- c(
    "raw/revocations/REVOCATIONS-LOG-2020-01.csv",
    "raw/revocations/REVOCATIONS-ORG-2020-01.csv",
    "other/data.csv"
  )
  result <- filter_paths("revocations", paths)
  expect_length(result, 2)
  expect_true(all(grepl("REVOCATIONS", result)))
})

# =============================================================================
# build_s3_urls() tests
# =============================================================================

test_that("build_s3_urls creates valid S3 URLs", {
  paths <- c("legacy/core/data.csv", "legacy/bmf/data.csv")
  result <- build_s3_urls(paths)

  expect_length(result, 2)
  expect_true(all(grepl("^https://nccsdata.s3.us-east-1.amazonaws.com/", result)))
  expect_match(result[1], "legacy/core/data.csv$")
})

test_that("build_s3_urls accepts custom base URL", {
  paths <- c("data.csv")
  result <- build_s3_urls(paths, base_url = "https://custom.s3.amazonaws.com/")

  expect_match(result, "^https://custom.s3.amazonaws.com/")
})

# =============================================================================
# make_buttons() tests
# =============================================================================

test_that("make_buttons creates download button HTML", {
  urls <- c("https://example.com/data.csv")
  result <- make_buttons(urls, "download")

  expect_match(result, "<a href='")
  expect_match(result, "class='button'")
  expect_match(result, "DOWNLOAD")
})

test_that("make_buttons creates profile button HTML", {
  urls <- c("https://example.com/profile")
  result <- make_buttons(urls, "profile")

  expect_match(result, "class='button2'")
  expect_match(result, "PROFILE")
})

test_that("make_buttons handles empty vector", {
  urls <- character(0)
  result <- make_buttons(urls, "download")
  expect_length(result, 0)
})

# =============================================================================
# Validator tests
# =============================================================================

test_that("validate_series rejects invalid series", {
  expect_error(validate_series("invalid"), "Invalid series")
  expect_error(validate_series(NULL), "must be a single character")
  expect_error(validate_series(c("core", "bmf")), "must be a single character")
})

test_that("validate_series accepts valid series", {
  expect_true(validate_series("core"))
  expect_true(validate_series("bmf"))
  expect_true(validate_series("soi"))
})

test_that("validate_tscope rejects invalid values", {
  expect_error(validate_tscope("INVALID"), "Invalid tscope")
})

test_that("validate_tscope accepts valid values", {
  expect_true(validate_tscope("CHARITIES"))
  expect_true(validate_tscope("NONPROFIT"))
  expect_true(validate_tscope("PRIVFOUND"))
  expect_true(validate_tscope(NULL))  # NULL allowed by default
})

test_that("validate_fscope rejects invalid values", {
  expect_error(validate_fscope("INVALID"), "Invalid fscope")
})

test_that("validate_fscope accepts valid values", {
  expect_true(validate_fscope("PC"))
  expect_true(validate_fscope("PZ"))
  expect_true(validate_fscope("PF"))
  expect_true(validate_fscope("EZ"))
})

test_that("validate_scoped_params requires scope for scoped series", {
  expect_error(
    validate_scoped_params("core", NULL, "PC"),
    "requires 'tscope'"
  )
  expect_error(
    validate_scoped_params("core", "CHARITIES", NULL),
    "requires 'fscope'"
  )
})

test_that("validate_scoped_params passes for non-scoped series", {
  expect_true(validate_scoped_params("bmf", NULL, NULL))
  expect_true(validate_scoped_params("revocations", NULL, NULL))
})

# =============================================================================
# Efile extractor tests
# =============================================================================

test_that("extract_efile_year extracts year from efile paths", {
  paths <- c(
    "parsed/F9-P00-T00-HEADER-2009.csv",
    "parsed/F9-P01-T01-EXPENSES-2015.csv"
  )
  result <- extract_efile_year(paths)
  expect_equal(result, c("2009", "2015"))
})

test_that("extract_efile_names extracts table names", {
  paths <- c(
    "parsed/F9-P00-T00-HEADER-2009.csv",
    "parsed/F9-P01-T01-EXPENSES-2015.csv"
  )
  result <- extract_efile_names(paths)
  expect_equal(result, c("F9-P00-T00-HEADER", "F9-P01-T01-EXPENSES"))
})

test_that("extract_cardinality determines 1:1 vs 1:M", {
  paths <- c(
    "parsed/F9-P00-T00-HEADER-2009.csv",   # T00 = 1:1
    "parsed/F9-P01-T01-EXPENSES-2015.csv"  # T01 = 1:M
  )
  result <- extract_cardinality(paths)
  expect_equal(result, c("1:1", "1:M"))
})
