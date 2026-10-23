# Unit tests for catalogs/R/efile_helpers.R
# Offline: uses a synthetic count file and a small synthetic concordance, so
# no S3 or GitHub access is needed.
#   Rscript catalogs/tests/test-efile-helpers.R

library(testthat)

# Locate helpers regardless of working directory
find_helpers <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
  if (length(file_arg) > 0 && nzchar(file_arg)) {
    return(file.path(dirname(dirname(normalizePath(file_arg[1]))), "R", "efile_helpers.R"))
  }
  for (cand in c("catalogs/R/efile_helpers.R", "R/efile_helpers.R", "../R/efile_helpers.R")) {
    if (file.exists(cand)) return(normalizePath(cand))
  }
  stop("Could not locate efile_helpers.R")
}
source(find_helpers())

cc <- list(
  forms = data.frame(
    form_id = c("F990", "SCHED-A", "F990PF"),
    title = c("Form 990 / 990-EZ", "Schedule A", "Form 990-PF"),
    sort_order = 1:3, stringsAsFactors = FALSE
  ),
  parts = data.frame(
    part_id = c("F9-P00", "F9-P08", "SA-P01", "PF-P01"),
    form_id = c("F990", "F990", "SCHED-A", "F990PF"),
    title = c("Heading", "Part VIII - Revenue", "Part I", "Part I - Revenue"),
    sort_order = c(1, 9, 20, 40), stringsAsFactors = FALSE
  ),
  tables = data.frame(
    table_id = c("F9-P00-T00-HEADER", "F9-P08-T00-REVENUE", "F9-P08-T01-REVENUE-PROGRAMS",
                 "SA-P01-T00-PUBLIC-CHARITY-STATUS", "PF-P01-T00-REVENUE-EXPENSE"),
    cardinality = c("ONE", "ONE", "MANY", "ONE", "ONE"),
    title = "", sort_order = 1:5, stringsAsFactors = FALSE
  ),
  version = "test"
)

counts <- data.frame(
  year = c(2023L, 2024L, 2025L, 2023L, 2024L, 2025L, 2024L, 2024L),
  table = c(rep("F9-P00-T00-HEADER", 3), rep("F9-P08-T01-REVENUE-PROGRAMS", 3),
            "SA-P01-T00-PUBLIC-CHARITY-STATUS", "SD-P07-T01-INVESTMENTS-OTH-EQUITY"),
  rows_990 = c(10, 20, 5, 30, 40, 0, 7, 3),
  rows_990ez = c(4, 6, 1, 0, 0, 0, 0, 0),
  rows_tot = c(14, 26, 6, 30, 40, 0, 7, 3)
)

test_that("releases are complete and have one current release per form", {
  expect_false(any(duplicated(EFILE_RELEASES$id)))
  expect_equal(sum(EFILE_RELEASES$status == "Current" & EFILE_RELEASES$form == "990"), 1)
  expect_equal(sum(EFILE_RELEASES$status == "Current" & EFILE_RELEASES$form == "990PF"), 1)
  expect_equal(efile_label(efile_release("pf_v3_1")), "efilepf_v3_1")
  expect_error(efile_release("v9_9"))
})

test_that("zero-row table-years are dropped", {
  expect_equal(nrow(efile_nonempty(counts)), 7)
})

test_that("table metadata groups by form and part, with fallbacks", {
  m <- efile_table_meta(counts$table, cc)
  expect_equal(m$table[1], "F9-P00-T00-HEADER")
  expect_equal(m$cardinality[m$table == "F9-P08-T01-REVENUE-PROGRAMS"], "MANY")
  # Not in the concordance: form from the prefix, cardinality from T-number
  old <- m[m$table == "SD-P07-T01-INVESTMENTS-OTH-EQUITY", ]
  expect_equal(old$form_id, "SCHED-D")
  expect_equal(old$cardinality, "MANY")
  expect_false(old$in_concordance)
})

test_that("990-PF pages list the shared header tables first", {
  m <- efile_table_meta(c("PF-P01-T00-REVENUE-EXPENSE", "F9-P00-T00-HEADER"), cc, "990PF")
  expect_equal(m$table[1], "F9-P00-T00-HEADER")
  expect_match(m$form_title[1], "Shared")
})

test_that("URLs follow the S3 layout and dictionary anchors", {
  rel <- efile_release("v3_1")
  expect_equal(efile_file_url(rel, "F9-P08-T00-REVENUE", 2023, "parquet"),
               paste0(EFILE_S3, "public/efile_v3_1/F9-P08-T00-REVENUE-2023.parquet"))
  expect_match(efile_table_dictionary_url("F9-P08-T00-REVENUE"), "data-dictionary-990.html#f9-p08-t00-revenue$")
  expect_match(efile_table_dictionary_url("PF-P01-T00-REVENUE-EXPENSE", "990PF"), "990pf.html#pf-p01")
  expect_false(grepl("#", efile_table_dictionary_url("X", "990", FALSE)))
})

test_that("snippets skip the partial year and use the right functions", {
  yrs <- efile_snippet_years(2009:2025, 2025)
  expect_equal(c(yrs$first, yrs$last), c(2020, 2024))
  expect_equal(efile_snippet_years(2025, 2025)$last, 2025)

  s <- efile_snippet("F9-P08-T00-REVENUE", "ONE", "990", yrs)
  expect_match(s, "panelize\\( tables = \"F9-P08-T00-REVENUE\"")
  expect_match(s, "years = 2020:2024")
  expect_false(grepl("include_many|download_tables|data_source", s))
  s <- efile_snippet("PF-P15-T01-SUPPLEMENTARY-INFO-GRANT-PAID", "MANY", "990PF", yrs)
  expect_false(grepl("panelize_pf", s))
  expect_match(s, "include_many = TRUE")
  expect_match(s, "data_source\\( form = \"990PF\" \\)")
})

test_that("the pin note names the page's release", {
  expect_match(efile_pin_note(efile_release("v3_1")), "data_source\\( version = \"v3_1\" \\)")
  expect_match(efile_pin_note(efile_release("pf_v2_3")),
               "data_source\\( version = \"v2_3\", form = \"990PF\" \\)")
})

test_that("table sections carry name-year, CSV and Parquet links", {
  rel <- efile_release("v3_1")
  cn <- efile_nonempty(counts)
  m <- efile_table_meta(cn$table, cc)
  html <- efile_table_sections(cn, m, rel)
  expect_match(html, "F9-P08-T01-REVENUE-PROGRAMS-2024")
  expect_match(html, "F9-P08-T01-REVENUE-PROGRAMS-2024.CSV")
  expect_match(html, "F9-P08-T01-REVENUE-PROGRAMS-2024.parquet")
  expect_false(grepl("F9-P08-T01-REVENUE-PROGRAMS-2025", html))
  toc <- efile_toc(m, c("about" = "About"))
  expect_match(toc, "href='#f9-p08'")
  expect_match(toc, "href='#about'")
})

test_that("frozen release metadata is read, subset and validated", {
  rel <- data.frame(id = "test", form = "990", stringsAsFactors = FALSE)
  m <- efile_table_meta(counts$table, cc)
  m$concordance_ref <- "test-ref"
  path <- tempfile(fileext = ".csv")
  utils::write.csv(m, path, row.names = FALSE)
  got <- efile_release_meta(rel, c("F9-P00-T00-HEADER", "SA-P01-T00-PUBLIC-CHARITY-STATUS"), path)
  expect_equal(got$table, c("F9-P00-T00-HEADER", "SA-P01-T00-PUBLIC-CHARITY-STATUS"))
  expect_equal(attr(got, "concordance_ref"), "test-ref")
  expect_false("concordance_ref" %in% names(got))
  expect_error(efile_release_meta(rel, c("F9-P00-T00-HEADER", "SZ-P01-T00-NEW"), path), "lacks 1 table")
  expect_error(efile_release_meta(rel, "F9-P00-T00-HEADER", tempfile()), "No frozen")
})

test_that("blank title columns in a frozen file stay blank, never NA", {
  rel <- data.frame(id = "test", form = "990", stringsAsFactors = FALSE)
  m <- efile_table_meta(counts$table, cc)
  m$table_title <- ""   # entirely blank column, as in the real frozen files
  m$concordance_ref <- "test-ref"
  path <- tempfile(fileext = ".csv")
  utils::write.csv(m, path, row.names = FALSE)
  got <- efile_release_meta(rel, "F9-P00-T00-HEADER", path)
  expect_identical(got$table_title, "")
  expect_false(anyNA(got$part_title))
  sec <- efile_table_section(counts[counts$table == "F9-P00-T00-HEADER", ],
                             got[got$table == "F9-P00-T00-HEADER", ],
                             efile_release("v3_1"), partial_year = 2025, snippet = FALSE)
  expect_false(grepl("ef-table-title", sec))
})

test_that("every release has a concordance ref", {
  expect_true(all(nzchar(EFILE_RELEASES$concordance_ref)))
})
