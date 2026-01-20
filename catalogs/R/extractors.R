# =============================================================================
# NCCS Catalog Extractors
# Functions for extracting metadata from S3 object paths
# =============================================================================

#' Extract tax year from file paths
#'
#' Extracts 4-digit years (1900-2099) from S3 object key paths.
#'
#' @param paths Character vector. S3 object keys.
#' @return Character vector. Extracted years (NA where not found).
#' @examples
#' extract_year(c("CORE-2019-501C3-CHARITIES-PC.csv", "BMF-2020-01-PX.csv"))
#' # Returns: c("2019", "2020")
#' @export
extract_year <- function(paths) {
 validate_paths(paths)

  yyyy <- stringr::str_extract(paths, YEAR_PATTERN)
  # Clean up any stray hyphens (shouldn't happen with word boundary pattern)
  yyyy <- gsub("-", "", yyyy)

  return(yyyy)
}

#' Extract release month from file paths
#'
#' Extracts 2-digit months (01-12) from S3 object key paths.
#' Primarily used for BMF files which include release month.
#'
#' @param paths Character vector. S3 object keys.
#' @return Character vector. Extracted months (NA where not found).
#' @examples
#' extract_month(c("BMF-2020-01-PX.csv", "BMF-2020-06-PX.csv"))
#' # Returns: c("01", "06")
#' @export
extract_month <- function(paths) {
  validate_paths(paths)

  mm <- stringr::str_extract(paths, MONTH_PATTERN)
  mm <- gsub("-", "", mm)

  return(mm)
}

#' Extract year from efile paths
#'
#' Efile paths have a specific format: parsed/F9-P00-T00-HEADER-2009.csv
#'
#' @param paths Character vector. Efile S3 object keys.
#' @return Character vector. Extracted years.
#' @export
extract_efile_year <- function(paths) {
  validate_paths(paths)

  yyyy <- stringr::str_extract(paths, EFILE_YEAR_PATTERN)
  yyyy <- gsub("-", "", yyyy)
  yyyy <- gsub("\\.", "", yyyy)

  return(yyyy)
}

#' Extract table names from efile paths
#'
#' Removes path prefix and year suffix to get the table name.
#'
#' @param paths Character vector. Efile S3 object keys.
#' @return Character vector. Table names (e.g., "F9-P00-T00-HEADER").
#' @export
extract_efile_names <- function(paths) {
  validate_paths(paths)

  names <- gsub("parsed/", "", paths)
  names <- gsub("-[0-9]{4}\\.csv", "", names)

  return(names)
}

#' Extract RDB cardinality from efile paths
#'
#' Determines if a table is 1:1 or 1:M based on the T## component.
#' T00 = 1:1, T01+ = 1:M
#'
#' @param paths Character vector. Efile S3 object keys.
#' @return Character vector. Cardinality ("1:1" or "1:M").
#' @export
extract_cardinality <- function(paths) {
  validate_paths(paths)

  ttt <- stringr::str_extract(paths, CARDINALITY_PATTERN)
  ttt <- gsub("-", "", ttt)
  ttt <- gsub("^T", "", ttt)

  card <- ifelse(ttt == "00", "1:1", "1:M")

  return(card)
}

#' Extract form scope from file paths
#'
#' @param paths Character vector. S3 object keys.
#' @return Character vector. Form scope codes (PC, PZ, PF).
#' @export
extract_fscope <- function(paths) {
  validate_paths(paths)

  fscope <- stringr::str_extract(paths, FSCOPE_PATTERN)
  fscope <- gsub("^-|-$", "", fscope)

  return(as.character(fscope))
}

#' Calculate file size in MB
#'
#' Converts byte sizes to human-readable MB format.
#'
#' @param size_bytes Numeric vector. File sizes in bytes.
#' @param decimals Integer. Number of decimal places. Default: 1.
#' @return Character vector. Formatted sizes (e.g., "2.5 mb").
#' @export
format_file_size <- function(size_bytes, decimals = 1) {
  if (!is.numeric(size_bytes)) {
    stop("'size_bytes' must be numeric")
  }

  size_mb <- round(size_bytes / 1000000, decimals)
  formatted <- paste0(as.character(size_mb), " mb")

  return(formatted)
}

# =============================================================================
# Path Filtering Functions
# =============================================================================

#' Filter paths by series type
#'
#' Main dispatcher function that routes to series-specific filtering.
#'
#' @param series Character scalar. Data series name.
#' @param paths Character vector. S3 object keys to filter.
#' @param tscope Character scalar or NULL. Tax scope (for scoped series).
#' @param fscope Character scalar or NULL. Form scope (for scoped series).
#' @return Character vector. Filtered paths matching the series.
#' @export
filter_paths <- function(series, paths, tscope = NULL, fscope = NULL) {
  # Validate inputs
  validate_series(series)
  validate_paths(paths)
  validate_tscope(tscope)
  validate_fscope(fscope)
  validate_scoped_params(series, tscope, fscope)

  # Dispatch to series-specific filter
  result <- switch(series,
    "bmf" = filter_bmf_paths(paths),
    "core" = filter_core_paths(paths, tscope, fscope),
    "misc" = filter_misc_paths(paths),
    "soi" = filter_soi_paths(paths, tscope, fscope),
    "revocations" = filter_revocations_paths(paths),
    "census-crosswalk" = filter_census_paths(paths),
    "efile" = filter_efile_paths(paths),
    # Default: return empty
    character(0)
  )

  if (length(result) == 0) {
    warning(sprintf("No paths matched for series '%s'", series))
  }

  return(result)
}

#' Filter BMF paths
#' @keywords internal
filter_bmf_paths <- function(paths) {
  grep(SERIES_PATTERNS$bmf, paths, value = TRUE)
}

#' Filter Core paths with scope
#' @keywords internal
filter_core_paths <- function(paths, tscope, fscope) {
  pattern <- paste0(SERIES_PATTERNS$core, tscope)
  paths <- grep(pattern, paths, value = TRUE)
  paths <- grep(paste0("-", fscope, "\\.csv"), paths, value = TRUE)
  return(paths)
}

#' Filter Misc/Supplemental paths
#' @keywords internal
filter_misc_paths <- function(paths) {
  grep(SERIES_PATTERNS$misc, paths, value = TRUE)
}

#' Filter SOI Microdata paths with scope
#' @keywords internal
filter_soi_paths <- function(paths, tscope, fscope) {
  pattern <- paste0(SERIES_PATTERNS$soi, tscope)
  paths <- grep(pattern, paths, value = TRUE)
  paths <- grep(paste0("-", fscope, "\\b"), paths, value = TRUE)
  return(paths)
}

#' Filter Revocations paths
#' @keywords internal
filter_revocations_paths <- function(paths) {
  grep(SERIES_PATTERNS$revocations, paths, value = TRUE)
}

#' Filter Census crosswalk paths
#' @keywords internal
filter_census_paths <- function(paths) {
  grep(SERIES_PATTERNS$census_crosswalk, paths, value = TRUE)
}

#' Filter Efile paths (CSV files)
#' @keywords internal
filter_efile_paths <- function(paths) {
  grep(SERIES_PATTERNS$efile, paths, value = TRUE)
}
