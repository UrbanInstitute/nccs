# =============================================================================
# Core catalog helpers
# Path-based parsers and URL builders for the Core S3 layout:
#   processed/core/{YYYY}/{FORM_TYPE}/
#     core_{YYYY}_{FORM_TYPE}.csv             -> the data
#     core_{YYYY}_{FORM_TYPE}_dictionary.csv  -> per-year data dictionary
#     core_{YYYY}_{FORM_TYPE}_quality.html    -> per-year HTML quality report
#
# Form types: "990", "990ez", "990combined", "990pf".
# =============================================================================

CORE_FORM_TYPES <- c("990", "990ez", "990combined", "990pf")

# Quality reports are published on the nccs-data-core Pages site. The S3
# copies are gzipped HTML and not directly browsable, so always link the
# Pages-site URL.
CORE_QUALITY_REPORT_URL <-
  "https://urbaninstitute.github.io/nccs-data-core/quality-reports/%s/%s/core_%s_%s_quality.html"

build_core_quality_url <- function(year, form_type) {
  ifelse(
    is.na(year) | is.na(form_type),
    NA_character_,
    sprintf(CORE_QUALITY_REPORT_URL, year, form_type, year, form_type)
  )
}

#' Filter a full nccsdata manifest down to processed/core/ rows.
filter_core_manifest <- function(manifest) {
  manifest[grepl("^processed/core/", manifest$Key), , drop = FALSE]
}

#' Parse `processed/core/{YYYY}/{FORM_TYPE}/...` into a data.frame with
#' character columns `year` and `form_type`. Non-matching keys yield NA.
extract_core_year_form <- function(keys) {
  m <- stringr::str_match(keys, "^processed/core/(\\d{4})/([^/]+)/")
  data.frame(
    year      = m[, 2],
    form_type = m[, 3],
    stringsAsFactors = FALSE
  )
}

#' Classify a Core S3 key as "data", "dictionary", "quality", or "other".
classify_core_artifact <- function(keys) {
  base <- basename(keys)
  ifelse(grepl("_dictionary\\.csv$", base, ignore.case = TRUE), "dictionary",
  ifelse(grepl("_quality\\.html$",   base, ignore.case = TRUE), "quality",
  ifelse(grepl("\\.csv$",            base, ignore.case = TRUE), "data",
         "other")))
}

#' Build the per-form-type yearly download table.
#'
#' One row per year, with separate columns for the data file, dictionary, and
#' quality report. Multiple artifact files in the same /YYYY/FORM_TYPE/ prefix
#' (data CSV, dictionary CSV, quality HTML) are collapsed into a single row.
#'
#' @param manifest data.frame from AWS-NCCSDATA.csv (must have Key, URL, Size).
#' @param form_type one of CORE_FORM_TYPES.
#' @param n_recent number of most-recent years to return; pass NA for all.
#' @param min_size_bytes drop years whose data CSV is smaller than this. The
#'   new pipeline writes near-empty placeholder files for the earliest years
#'   (mostly pre-2008): they are listed in the manifest but have no analytic
#'   value. The default cutoff (300 KB) excludes those without hiding sparse
#'   but legitimate mid-series releases (e.g. 990PF 2017 at ~0.4 MB).
build_core_year_section <- function(manifest, form_type, n_recent = 5,
                                    min_size_bytes = 3e5) {
  rows <- filter_core_manifest(manifest)
  yf <- extract_core_year_form(rows$Key)
  rows$year      <- yf$year
  rows$form_type <- yf$form_type
  rows$artifact  <- classify_core_artifact(rows$Key)
  rows <- rows[!is.na(rows$year) & rows$form_type == form_type, , drop = FALSE]

  # Drop years whose data CSV is below the size cutoff (placeholder/empty).
  small_years <- unique(rows$year[rows$artifact == "data" &
                                    !is.na(rows$Size) &
                                    rows$Size < min_size_bytes])
  rows <- rows[!(rows$year %in% small_years), , drop = FALSE]
  if (nrow(rows) == 0) {
    return(data.frame(
      year = character(0), download = character(0), dictionary = character(0),
      quality_report = character(0), size = character(0),
      stringsAsFactors = FALSE
    ))
  }

  years <- sort(unique(rows$year), decreasing = TRUE)

  pick <- function(y, type) {
    sel <- rows[rows$year == y & rows$artifact == type, , drop = FALSE]
    if (nrow(sel) == 0) return(NULL)
    sel[1, , drop = FALSE]
  }

  out_rows <- lapply(years, function(y) {
    csv_row  <- pick(y, "data")
    dict_row <- pick(y, "dictionary")
    if (is.null(csv_row)) return(NULL)

    download <- paste0("<a href='", csv_row$URL, "'>Download</a>")
    dictionary <- if (!is.null(dict_row)) {
      paste0("<a href='", dict_row$URL, "'>Dictionary</a>")
    } else {
      "&mdash;"
    }
    quality_report <- paste0(
      "<a href='", build_core_quality_url(y, form_type), "'>Quality report</a>"
    )
    size <- paste0(round(csv_row$Size / 1e6, 1), " mb")

    data.frame(
      year           = y,
      download       = download,
      dictionary     = dictionary,
      quality_report = quality_report,
      size           = size,
      stringsAsFactors = FALSE
    )
  })
  out_rows <- out_rows[!vapply(out_rows, is.null, logical(1))]
  if (length(out_rows) == 0) {
    return(data.frame(
      year = character(0), download = character(0), dictionary = character(0),
      quality_report = character(0), size = character(0),
      stringsAsFactors = FALSE
    ))
  }
  out <- do.call(rbind, out_rows)
  if (!is.na(n_recent)) out <- head(out, n_recent)
  rownames(out) <- NULL
  out
}

# -----------------------------------------------------------------------------
# Legacy harmonized/core/ layout (deprecated; kept for reproducibility)
#
# Path shape:
#   harmonized/core/{PRODUCT}/marts/CORE-{YYYY}-{...}-HRMN[-V0].csv
# PRODUCT in: 501c3-pc, 501c3-pz, 501ce-pc, 501ce-pz, 501c3-pf
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Blank IRS forms archive (raw/core/forms/)
#
# Filenames: f<base>_<YYYY>.pdf for blank forms, i<base>_<YYYY>.pdf for
# instructions. Schedule B uses basename "990ezb" (IRS naming quirk).
# -----------------------------------------------------------------------------

CORE_MAIN_FORMS <- c(
  "990"   = "Form 990",
  "990ez" = "Form 990-EZ",
  "990pf" = "Form 990-PF"
)

CORE_SCHEDULES <- c(
  "990sa"  = "A", "990ezb" = "B", "990sc"  = "C", "990sd"  = "D",
  "990se"  = "E", "990sf"  = "F", "990sg"  = "G", "990sh"  = "H",
  "990si"  = "I", "990sj"  = "J", "990sk"  = "K", "990sl"  = "L",
  "990sm"  = "M", "990sn"  = "N", "990so"  = "O", "990sr"  = "R"
)

#' Build a year-by-form matrix of PDF links for the blank forms archive.
#'
#' Rows are years (most recent first); columns are form codes in the order
#' given by `form_codes`. Each cell is an HTML fragment containing two
#' single-letter links: F (blank form) and I (instructions). Cells are empty
#' where IRS did not publish that year/form combination.
#'
#' @param manifest data.frame from AWS-NCCSDATA.csv.
#' @param form_codes named character vector: basename -> column label.
build_forms_matrix <- function(manifest, form_codes) {
  rows <- manifest[grepl("^raw/core/forms/", manifest$Key) &
                     grepl("\\.pdf$", manifest$Key, ignore.case = TRUE), ,
                   drop = FALSE]
  if (nrow(rows) == 0) return(NULL)
  m <- stringr::str_match(basename(rows$Key), "^([fi])(.+)_(\\d{4})\\.pdf$")
  rows$kind <- m[, 2]
  rows$base <- m[, 3]
  rows$year <- m[, 4]
  rows <- rows[!is.na(rows$year) & rows$base %in% names(form_codes), ,
               drop = FALSE]
  if (nrow(rows) == 0) return(NULL)

  years <- sort(unique(rows$year), decreasing = TRUE)

  cell <- function(year, base) {
    sel_f <- rows[rows$year == year & rows$base == base & rows$kind == "f", ,
                  drop = FALSE]
    sel_i <- rows[rows$year == year & rows$base == base & rows$kind == "i", ,
                  drop = FALSE]
    parts <- character(0)
    if (nrow(sel_f) > 0) {
      parts <- c(parts, paste0("<a href='", sel_f$URL[1], "'>Form</a>"))
    }
    if (nrow(sel_i) > 0) {
      parts <- c(parts, paste0("<a href='", sel_i$URL[1], "'>Instr.</a>"))
    }
    if (length(parts) == 0) return("")
    paste(parts, collapse = "<br>")
  }

  mat <- vapply(
    names(form_codes),
    function(b) vapply(years, function(y) cell(y, b), character(1)),
    character(length(years))
  )
  if (is.null(dim(mat))) mat <- matrix(mat, ncol = length(form_codes))
  out <- data.frame(Year = years, mat, stringsAsFactors = FALSE,
                    check.names = FALSE)
  colnames(out) <- c("Year", unname(form_codes))
  out
}

#' Build a year-by-year download table for a single legacy product directory.
#'
#' @param manifest data.frame from AWS-NCCSDATA.csv.
#' @param product one of "501c3-pc", "501c3-pz", "501ce-pc", "501ce-pz",
#'   "501c3-pf".
build_legacy_core_section <- function(manifest, product) {
  prefix <- paste0("^harmonized/core/", product, "/marts/")
  rows <- manifest[grepl(prefix, manifest$Key) &
                     grepl("\\.csv$", manifest$Key, ignore.case = TRUE), ,
                   drop = FALSE]
  if (nrow(rows) == 0) {
    return(data.frame(
      year = character(0), download = character(0), size = character(0),
      stringsAsFactors = FALSE
    ))
  }
  rows$year <- stringr::str_match(basename(rows$Key), "CORE-(\\d{4})-")[, 2]
  rows <- rows[!is.na(rows$year), , drop = FALSE]
  rows <- rows[order(rows$year, decreasing = TRUE), , drop = FALSE]
  data.frame(
    year     = rows$year,
    download = paste0("<a href='", rows$URL, "'>Download</a>"),
    size     = paste0(round(rows$Size / 1e6, 1), " mb"),
    stringsAsFactors = FALSE
  )
}
