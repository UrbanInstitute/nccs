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
build_core_year_section <- function(manifest, form_type, n_recent = 5) {
  rows <- filter_core_manifest(manifest)
  yf <- extract_core_year_form(rows$Key)
  rows$year      <- yf$year
  rows$form_type <- yf$form_type
  rows$artifact  <- classify_core_artifact(rows$Key)
  rows <- rows[!is.na(rows$year) & rows$form_type == form_type, , drop = FALSE]
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
    qr_row   <- pick(y, "quality")
    if (is.null(csv_row)) return(NULL)

    download <- paste0("<a href='", csv_row$URL, "'>Download</a>")
    dictionary <- if (!is.null(dict_row)) {
      paste0("<a href='", dict_row$URL, "'>Dictionary</a>")
    } else {
      "&mdash;"
    }
    quality_report <- if (!is.null(qr_row)) {
      paste0("<a href='", qr_row$URL, "'>Quality report</a>")
    } else {
      "&mdash;"
    }
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
