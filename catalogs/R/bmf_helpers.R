# =============================================================================
# BMF catalog helpers
# Path-based parsers and URL builders for the BMF S3 layout:
#   unified/bmf/                     -> Unified BMF, plain (headline); renamed
#                                        from "Master BMF" 2026-07-01 (ADR 0037)
#   master/bmf/                      -> Superseded plain path (state-sliced +
#                                        headline, old convention); reachable
#                                        through 2026-09-28, then archived
#   geocoding/bmf-master/merged/     -> Master BMF with lat/lon (NOT renamed
#                                        by ADR 0037 — geocoded extension)
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
    paste0("<a href='", urls, "'>Quality report</a>")
  )
}

#' Build a Master BMF section (one row per state, left-joined to a name map).
#'
#' @param manifest data.frame from AWS-BMF.csv (must have `source`, `Key`,
#'   `URL`, `Size`).
#' @param state_mapping named character vector: abbreviation -> full name.
#' @return data.frame with columns: download, size, state.
build_master_section <- function(manifest, state_mapping) {
  master <- manifest[manifest$source %in% c("master", "state_mart"), , drop = FALSE]
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
    paste0("<a href='", out$URL, "'>Download</a>")
  )
  out$size <- ifelse(
    is.na(out$Size),
    "&mdash;",
    paste0(round(out$Size / 1e6, 1), " mb")
  )

  out[, c("download", "size", "state")]
}

#' Classify a monthly BMF S3 key into one of: "data_csv", "data_parquet",
#' "dictionary", "quality_report_json", "other". Used to collapse multiple
#' artifact files in the same /YYYY_MM/ prefix into a single catalog row.
classify_bmf_artifact <- function(keys) {
  base <- basename(keys)
  ifelse(grepl("_data_dictionary\\.csv$",   base, ignore.case = TRUE), "dictionary",
  ifelse(grepl("_quality_report\\.json$",   base, ignore.case = TRUE), "quality_report_json",
  ifelse(grepl("_processed\\.parquet$",     base, ignore.case = TRUE), "data_parquet",
  ifelse(grepl("_processed\\.csv$",         base, ignore.case = TRUE), "data_csv",
  ifelse(grepl("\\.csv$",                   base, ignore.case = TRUE), "data_csv",
         "other")))))
}

#' Build a combined monthly BMF section that interleaves the transformed
#' (2023-06+) and harmonized legacy (1989-2022) products into a single
#' chronologically sorted table — one row per (year, month, era), with
#' separate columns for the data file, dictionary, and HTML quality report.
#'
#' Multiple artifact files in the same /YYYY_MM/ prefix (data CSV, parquet,
#' dictionary CSV, quality_report.json) are collapsed into a single row.
#' The data download links the CSV (canonical format); the dictionary and
#' quality report are derived from sibling files in the same prefix.
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
  if (nrow(rows) == 0) {
    return(data.frame(
      year = character(0), month = character(0), era = character(0),
      download = character(0), dictionary = character(0),
      quality_report = character(0), size = character(0),
      stringsAsFactors = FALSE
    ))
  }

  ym <- extract_bmf_year_month(rows$Key)
  rows$year  <- ym$year
  rows$month <- ym$month
  rows <- rows[!is.na(rows$year) & !is.na(rows$month), , drop = FALSE]
  rows$artifact <- classify_bmf_artifact(rows$Key)

  # Group keys
  rows$group <- paste(rows$year, rows$month, rows$era, sep = "|")
  groups <- unique(rows$group)

  pick <- function(g, type) {
    sel <- rows[rows$group == g & rows$artifact == type, , drop = FALSE]
    if (nrow(sel) == 0) return(NULL)
    sel[1, , drop = FALSE]
  }

  out_rows <- lapply(groups, function(g) {
    csv_row    <- pick(g, "data_csv")
    dict_row   <- pick(g, "dictionary")
    parts      <- strsplit(g, "\\|", perl = TRUE)[[1]]

    # Drop groups that have no actual data file (e.g. only a dictionary
    # uploaded so far) — there's nothing to download.
    if (is.null(csv_row)) return(NULL)

    download <- paste0("<a href='", csv_row$URL, "'>Download</a>")
    dictionary <- if (!is.null(dict_row)) {
      paste0("<a href='", dict_row$URL, "'>Dictionary</a>")
    } else {
      "&mdash;"
    }
    quality_report <- make_quality_report_links(
      build_quality_report_url(parts[1], parts[2])
    )
    size <- paste0(round(csv_row$Size / 1e6, 1), " mb")

    data.frame(
      year           = parts[1],
      month          = parts[2],
      era            = parts[3],
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
      year = character(0), month = character(0), era = character(0),
      download = character(0), dictionary = character(0),
      quality_report = character(0), size = character(0),
      stringsAsFactors = FALSE
    ))
  }
  out <- do.call(rbind, out_rows)

  out <- out[order(out$year, out$month, decreasing = TRUE), , drop = FALSE]
  if (!is.na(n_recent)) out <- head(out, n_recent)
  rownames(out) <- NULL
  out
}

#' Build a single-row table for the geocoded Master BMF variant.
#' Returns NULL if no geocoded rows are present in the manifest.
build_geocoded_master_row <- function(manifest) {
  rows <- manifest[manifest$source == "geocoded", , drop = FALSE]
  if (nrow(rows) == 0) return(NULL)
  rows$download <- paste0("<a href='", rows$URL, "'>Download</a>")
  rows$size <- paste0(round(rows$Size / 1e6, 1), " mb")
  rows$file <- basename(rows$Key)
  rows[, c("file", "download", "size")]
}

#' Build the headline BMF table — one row per variant (geocoded first,
#' then plain Unified BMF), with columns for download, data dictionary, and
#' quality report.
#'
#' The dictionary URL is derived from the manifest by finding the
#' `bmf_unified_data_dictionary.csv` sibling under `unified/bmf/` (the plain
#' variant, renamed from "Master BMF" 2026-07-01 per ADR 0037) or the
#' `bmf_master_geocoded_data_dictionary.csv` sibling under
#' `geocoding/bmf-master/merged/` (the geocoded variant, not renamed). The
#' quality report prefers a rendered HTML sibling in the manifest itself
#' (e.g. `bmf_unified_quality_report.html`, the ADR 0014 per-build artifact);
#' `quality_report_url` is only a fallback for variants that don't publish
#' one (the geocoded pipeline currently only emits the JSON variant).
#'
#' @param manifest data.frame from AWS-BMF.csv.
#' @param quality_report_url Fallback URL when a variant has no HTML quality
#'   report sibling in the manifest. Points at the producer's pre-rename Pages
#'   slug (`bmf_master_quality_report.html`) until nccs-data-bmf renames its
#'   docs to match ADR 0037.
build_master_headline_table <- function(
  manifest,
  quality_report_url =
    "https://urbaninstitute.github.io/nccs-data-bmf/quality-reports/bmf_master_quality_report.html"
) {
  geocoded <- manifest[manifest$source == "geocoded", , drop = FALSE]
  master   <- manifest[manifest$source == "unified", , drop = FALSE]

  # Pick a single headline data CSV + matching dictionary/quality-report URLs
  # out of a manifest subset. Returns a 1-row data.frame or NULL.
  pick_variant <- function(rows, dict_pattern) {
    if (nrow(rows) == 0) return(NULL)
    is_dict     <- grepl(dict_pattern, basename(rows$Key), ignore.case = TRUE)
    is_qr_html  <- grepl("_quality_report\\.html$", basename(rows$Key), ignore.case = TRUE)
    is_qr_json  <- grepl("_quality_report\\.json$", basename(rows$Key), ignore.case = TRUE)
    is_manifest <- grepl("^_manifest\\.json$", basename(rows$Key), ignore.case = TRUE)
    is_state    <- !is.na(extract_bmf_state(rows$Key))
    headline    <- rows[!is_dict & !is_qr_html & !is_qr_json & !is_manifest & !is_state, , drop = FALSE]
    headline    <- headline[order(!grepl("\\.csv$", headline$Key)), , drop = FALSE]
    if (nrow(headline) == 0) return(NULL)

    dict_rows <- rows[is_dict, , drop = FALSE]
    dict_url  <- if (nrow(dict_rows) > 0) dict_rows$URL[1] else NA_character_

    qr_rows  <- rows[is_qr_html, , drop = FALSE]
    qr_url   <- if (nrow(qr_rows) > 0) qr_rows$URL[1] else NA_character_

    data.frame(
      URL  = headline$URL[1],
      Size = headline$Size[1],
      dict = dict_url,
      qr   = qr_url,
      stringsAsFactors = FALSE
    )
  }

  rows <- list()
  geo_row <- pick_variant(geocoded, "bmf_master_geocoded_data_dictionary\\.csv$")
  if (!is.null(geo_row)) {
    rows[[length(rows) + 1L]] <- cbind(variant = "Master BMF (geocoded)", geo_row)
  }
  plain_row <- pick_variant(master, "bmf_unified_data_dictionary\\.csv$")
  if (!is.null(plain_row)) {
    rows[[length(rows) + 1L]] <- cbind(variant = "Unified BMF", plain_row)
  }
  if (length(rows) == 0) return(NULL)
  out <- do.call(rbind, rows)

  out$download <- paste0("<a href='", out$URL, "'>Download</a>")
  out$dictionary <- ifelse(
    is.na(out$dict),
    "&mdash;",
    paste0("<a href='", out$dict, "'>Dictionary</a>")
  )
  out$quality_report <- paste0(
    "<a href='", ifelse(is.na(out$qr), quality_report_url, out$qr), "'>Quality report</a>"
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

  rows$download <- paste0("<a href='", rows$URL, "'>Download</a>")
  rows$profile  <- ifelse(
    has_profile,
    paste0("<a href='", profile_url, "'>Profile</a>"),
    "&mdash;"
  )
  rows$size <- paste0(round(rows$Size / 1e6, 1), " mb")

  # Sort by vintage; rows without a parseable date sink to the bottom
  ord <- order(is.na(rows$year), rows$year, rows$month, decreasing = c(FALSE, TRUE, TRUE),
               method = "radix")
  rows <- rows[ord, , drop = FALSE]
  rows[, c("year", "month", "file", "download", "profile", "size")]
}
