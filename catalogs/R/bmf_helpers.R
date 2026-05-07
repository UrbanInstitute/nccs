# =============================================================================
# BMF catalog helpers
# Path-based parsers and URL builders for the new BMF S3 layout:
#   master/bmf/                      -> Master BMF (state-sliced)
#   processed/bmf/YYYY_MM/           -> Processed BMF, monthly
#   processed/bmf-legacy/YYYY_MM/    -> Legacy BMF, monthly
#
# Quality reports are hosted on a sibling Pages site and templated by month:
#   https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/bmf_YYYY_MM_quality_report.html
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
