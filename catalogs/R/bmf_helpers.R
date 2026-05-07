# =============================================================================
# BMF catalog helpers
# Path-based parsers and URL builders for the BMF S3 layout:
#   master/bmf/                      -> Master BMF (state-sliced + headline)
#   geocoding/master/merged/         -> Master BMF with lat/lon
#   processed/bmf/YYYY_MM/           -> Transformed monthly BMF (2023-06+)
#   processed/bmf-legacy/YYYY_MM/    -> Harmonized legacy monthly BMF (1989-2022)
#   legacy/bmf/                      -> Raw NCCS 501CX-NONPROFIT-PX vintages
#
# Per-month quality reports:
#   https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/bmf_YYYY_MM_quality_report.html
#
# Per-vintage raw legacy data dictionaries (PROFILE):
#   https://urbaninstitute.github.io/nccs-legacy/dictionary/bmf/bmf_archive_html/<filename-without-.csv>
# =============================================================================

BMF_QUALITY_REPORT_URL <-
  "https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/bmf_%s_%s_quality_report.html"

#' Extract YYYY and MM from an S3 key that contains a /YYYY_MM/ path segment.
#' Returns a data.frame with character columns `year` and `month`. Non-matching
#' keys yield NA in both columns.
extract_bmf_year_month <- function(keys) {
  m <- stringr::str_match(keys, "/(\\d{4})_(\\d{2})/")
  data.frame(
    year  = m[, 2],
    month = m[, 3],
    stringsAsFactors = FALSE
  )
}

#' Try to extract a 2-letter US state code from a Master BMF key.
#' Looks for the most common conventions in order. Returns NA if none match.
extract_bmf_state <- function(keys) {
  patterns <- c(
    "_BMF_([A-Z]{2})\\.csv$",
    "_BMF_([A-Z]{2})_",
    "_([A-Z]{2})\\.csv$",
    "BMF[_-]([A-Z]{2})\\b"
  )
  out <- rep(NA_character_, length(keys))
  for (p in patterns) {
    miss <- is.na(out)
    if (!any(miss)) break
    m <- stringr::str_match(keys[miss], p)
    out[miss] <- m[, 2]
  }
  out
}

#' Build a quality-report URL for a (year, month) pair. Vectorized.
#' Returns NA where either input is NA so callers can render a dash instead.
build_quality_report_url <- function(year, month) {
  ifelse(
    is.na(year) | is.na(month),
    NA_character_,
    sprintf(BMF_QUALITY_REPORT_URL, year, month)
  )
}

#' Render an HTML <a> tag for a quality report. NA URL -> em dash placeholder.
make_quality_report_links <- function(urls) {
  ifelse(
    is.na(urls),
    "&mdash;",
    paste0("<a href='", urls, "' class='button2'> QUALITY REPORT </a>")
  )
}

#' Build a Master BMF section (one row per state, left-joined to a name map).
#'
#' @param manifest data.frame from AWS-BMF.csv (must have `source`, `Key`,
#'   `URL`, `Size`).
#' @param state_mapping named character vector: abbreviation -> full name.
#' @return data.frame with columns: download, size, state.
build_master_section <- function(manifest, state_mapping) {
  master <- manifest[manifest$source == "master", , drop = FALSE]
  master$state_abbr <- extract_bmf_state(master$Key)

  lookup <- data.frame(
    state_abbr = names(state_mapping),
    state      = unname(state_mapping),
    stringsAsFactors = FALSE
  )

  out <- merge(lookup, master, by = "state_abbr", all.x = TRUE, sort = FALSE)
  out <- out[match(names(state_mapping), out$state_abbr), , drop = FALSE]

  out$download <- ifelse(
    is.na(out$URL),
    "&mdash;",
    paste0("<a href='", out$URL, "' class='button'> DOWNLOAD </a>")
  )
  out$size <- ifelse(
    is.na(out$Size),
    "&mdash;",
    paste0(round(out$Size / 1e6, 1), " mb")
  )

  out[, c("download", "size", "state")]
}

#' Build a monthly BMF section (processed or legacy).
#' Returns a data.frame sorted with the most recent month first.
#'
#' @param manifest data.frame from AWS-BMF.csv.
#' @param source_name "processed" or "legacy".
build_monthly_section <- function(manifest, source_name) {
  rows <- manifest[manifest$source == source_name, , drop = FALSE]
  if (nrow(rows) == 0) return(rows)

  ym <- extract_bmf_year_month(rows$Key)
  rows$year  <- ym$year
  rows$month <- ym$month

  rows <- rows[!is.na(rows$year) & !is.na(rows$month), , drop = FALSE]
  if (nrow(rows) == 0) return(rows)

  rows$download <- paste0("<a href='", rows$URL, "' class='button'> DOWNLOAD </a>")
  rows$quality_report <- make_quality_report_links(
    build_quality_report_url(rows$year, rows$month)
  )
  rows$size <- paste0(round(rows$Size / 1e6, 1), " mb")

  rows <- rows[order(rows$year, rows$month, decreasing = TRUE), , drop = FALSE]
  rows[, c("year", "month", "download", "quality_report", "size")]
}

#' Build a combined monthly BMF section that interleaves the transformed
#' (2023-06+) and harmonized legacy (1989-2022) products into a single
#' chronologically sorted table. Each row tags its `era`.
#'
#' @param manifest data.frame from AWS-BMF.csv.
#' @param n_recent Number of most-recent rows to return; pass NA for all.
build_combined_monthly_section <- function(manifest, n_recent = 5) {
  proc <- manifest[manifest$source == "processed", , drop = FALSE]
  leg  <- manifest[manifest$source == "legacy",    , drop = FALSE]
  rows <- rbind(
    cbind(proc, era = "Transformed"),
    cbind(leg,  era = "Harmonized legacy")
  )
  if (nrow(rows) == 0) return(rows)

  ym <- extract_bmf_year_month(rows$Key)
  rows$year  <- ym$year
  rows$month <- ym$month
  rows <- rows[!is.na(rows$year) & !is.na(rows$month), , drop = FALSE]
  if (nrow(rows) == 0) return(rows)

  rows$download <- paste0("<a href='", rows$URL, "' class='button'> DOWNLOAD </a>")
  rows$quality_report <- make_quality_report_links(
    build_quality_report_url(rows$year, rows$month)
  )
  rows$size <- paste0(round(rows$Size / 1e6, 1), " mb")

  rows <- rows[order(rows$year, rows$month, decreasing = TRUE), , drop = FALSE]
  if (!is.na(n_recent)) rows <- head(rows, n_recent)
  rows[, c("year", "month", "era", "download", "quality_report", "size")]
}

#' Build a single-row table for the geocoded Master BMF variant.
#' Returns NULL if no geocoded rows are present in the manifest.
build_geocoded_master_row <- function(manifest) {
  rows <- manifest[manifest$source == "geocoded", , drop = FALSE]
  if (nrow(rows) == 0) return(NULL)
  rows$download <- paste0("<a href='", rows$URL, "' class='button'> DOWNLOAD </a>")
  rows$size <- paste0(round(rows$Size / 1e6, 1), " mb")
  rows$file <- basename(rows$Key)
  rows[, c("file", "download", "size")]
}

#' Build the headline Master BMF table — one row per variant (geocoded first,
#' then plain), with columns for download, data dictionary, and quality report.
#' Replaces the stacked CTA buttons with a compact tabular view. Returns a data
#' frame with columns: variant, download, dictionary, quality_report, size.
#'
#' @param manifest data.frame from AWS-BMF.csv.
#' @param dictionary_url URL to the harmonized data dictionary used by both
#'   variants.
#' @param quality_report_url URL to the master quality report used by both
#'   variants.
build_master_headline_table <- function(manifest,
                                        dictionary_url,
                                        quality_report_url) {
  geocoded <- manifest[manifest$source == "geocoded", , drop = FALSE]
  master   <- manifest[manifest$source == "master", , drop = FALSE]

  # Headline plain file is the unsuffixed bmf_master.csv (no state code).
  headline_plain <- master[is.na(extract_bmf_state(master$Key)) &
                             grepl("(?i)bmf_master(\\.csv|\\.parquet)?$",
                                   basename(master$Key), perl = TRUE),
                           , drop = FALSE]

  rows <- list()
  if (nrow(geocoded) > 0) {
    rows[[length(rows) + 1L]] <- data.frame(
      variant = "Master BMF (geocoded)",
      URL     = geocoded$URL[1],
      Size    = geocoded$Size[1],
      stringsAsFactors = FALSE
    )
  }
  if (nrow(headline_plain) > 0) {
    rows[[length(rows) + 1L]] <- data.frame(
      variant = "Master BMF",
      URL     = headline_plain$URL[1],
      Size    = headline_plain$Size[1],
      stringsAsFactors = FALSE
    )
  }
  if (length(rows) == 0) return(NULL)
  out <- do.call(rbind, rows)

  out$download <- paste0("<a href='", out$URL, "' class='button'> DOWNLOAD </a>")
  out$dictionary <- paste0(
    "<a href='", dictionary_url, "' class='button2'> DICTIONARY </a>"
  )
  out$quality_report <- paste0(
    "<a href='", quality_report_url, "' class='button2'> QUALITY REPORT </a>"
  )
  out$size <- paste0(round(out$Size / 1e6, 1), " mb")

  out[, c("variant", "download", "dictionary", "quality_report", "size")]
}

#' Build the raw legacy BMF section. PROFILE URLs are derived from the data
#' filename: strip `.csv`, prepend the legacy dictionary base URL. Returns rows
#' sorted by vintage descending (most recent first). Files whose PROFILE page
#' does not exist render an em-dash for the dictionary cell.
#'
#' @param manifest data.frame from AWS-BMF.csv.
#' @param missing_profiles optional character vector of filename stems whose
#'   PROFILE page is known to be unavailable. Defaults to none — the catalog
#'   page renders a button for every row.
build_raw_legacy_section <- function(manifest, missing_profiles = character(0)) {
  rows <- manifest[manifest$source == "raw_legacy", , drop = FALSE]
  if (nrow(rows) == 0) return(rows)

  # Only data CSVs (skip dictionaries or other artifacts that may live in the same prefix)
  rows <- rows[grepl("\\.csv$", rows$Key, ignore.case = TRUE), , drop = FALSE]
  if (nrow(rows) == 0) return(rows)

  rows$file <- basename(rows$Key)
  ym <- stringr::str_match(rows$file, "BMF-(\\d{4})-(\\d{2})-")
  rows$year  <- ym[, 2]
  rows$month <- ym[, 3]

  stem <- sub("\\.csv$", "", rows$file, ignore.case = TRUE)
  profile_url <- paste0(
    "https://urbaninstitute.github.io/nccs-legacy/dictionary/bmf/bmf_archive_html/",
    stem
  )
  has_profile <- !(stem %in% missing_profiles)

  rows$download <- paste0("<a href='", rows$URL, "' class='button'> DOWNLOAD </a>")
  rows$profile  <- ifelse(
    has_profile,
    paste0("<a href='", profile_url, "' class='button2'> PROFILE </a>"),
    "&mdash;"
  )
  rows$size <- paste0(round(rows$Size / 1e6, 1), " mb")

  # Sort by vintage; rows without a parseable date sink to the bottom
  ord <- order(is.na(rows$year), rows$year, rows$month, decreasing = c(FALSE, TRUE, TRUE),
               method = "radix")
  rows <- rows[ord, , drop = FALSE]
  rows[, c("year", "month", "file", "download", "profile", "size")]
}
