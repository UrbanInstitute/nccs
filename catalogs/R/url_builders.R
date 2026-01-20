# =============================================================================
# NCCS Catalog URL Builders
# Functions for constructing S3 and archive URLs
# =============================================================================

#' Build S3 download URLs from paths
#'
#' Constructs full S3 URLs for direct file downloads.
#'
#' @param paths Character vector. S3 object keys.
#' @param base_url Character scalar. S3 bucket base URL (uses default if NULL).
#' @return Character vector. Full S3 URLs.
#' @examples
#' build_s3_urls(c("legacy/core/CORE-2019-PC.csv"))
#' # Returns: "https://nccsdata.s3.us-east-1.amazonaws.com/legacy/core/CORE-2019-PC.csv"
#' @export
build_s3_urls <- function(paths, base_url = NULL) {
  validate_paths(paths)

  if (is.null(base_url)) {
    base_url <- S3_BASE_URL
  }

  # Ensure base URL ends with /
  if (!grepl("/$", base_url)) {
    base_url <- paste0(base_url, "/")
  }

  urls <- paste0(base_url, paths)

  return(urls)
}

#' Build S3 efile URLs from paths
#'
#' Constructs full S3 URLs for efile data downloads.
#'
#' @param paths Character vector. Efile S3 object keys.
#' @param base_url Character scalar. S3 efile bucket base URL (uses default if NULL).
#' @return Character vector. Full S3 URLs for efile data.
#' @export
build_efile_urls <- function(paths, base_url = NULL) {
  validate_paths(paths)

  if (is.null(base_url)) {
    base_url <- S3_EFILE_BASE_URL
  }

  # Ensure base URL ends with /
  if (!grepl("/$", base_url)) {
    base_url <- paste0(base_url, "/")
  }

  urls <- paste0(base_url, paths)

  return(urls)
}

#' Build archive (data dictionary) URLs
#'
#' Constructs URLs to archived data dictionary pages on nccs-legacy.
#' Falls back to unavailable page if URL doesn't exist.
#'
#' @param series Character scalar. Data series name.
#' @param paths Character vector. S3 object keys.
#' @param check_exists Logical. Whether to verify URLs exist (slower but accurate).
#' @return Character vector. Archive URLs.
#' @export
build_archive_urls <- function(series, paths, check_exists = TRUE) {
  validate_series(series)
  validate_paths(paths)

  # Get the prefix pattern for this series
  prefix_pattern <- LEGACY_PATH_PREFIXES[[series]]

  if (is.null(prefix_pattern)) {
    # Series doesn't have archive URLs
    return(rep(UNAVAILABLE_DD_URL, length(paths)))
  }

  # Build base archive URL
  base_url <- sprintf(
    "%sdictionary/%s/%s_archive_html/",
    LEGACY_BASE_URL,
    series,
    series
  )

  # Strip prefix and extension to get file name
  file_names <- gsub(prefix_pattern, "", paths)
  file_names <- gsub("\\.csv$", "", file_names)

  # Construct archive URLs
  archive_urls <- paste0(base_url, file_names)

  # Optionally verify URLs exist
  if (check_exists) {
    archive_urls <- verify_archive_urls(archive_urls)
  }

  return(archive_urls)
}

#' Verify archive URLs exist
#'
#' Checks if archive URLs are accessible, replacing non-existent
#' URLs with the unavailable data dictionary page.
#'
#' @param urls Character vector. URLs to verify.
#' @return Character vector. Verified URLs (unavailable page for 404s).
#' @keywords internal
verify_archive_urls <- function(urls) {
  verified <- vapply(urls, function(url) {
    tryCatch(
      {
        if (RCurl::url.exists(url)) {
          url
        } else {
          UNAVAILABLE_DD_URL
        }
      },
      error = function(e) {
        UNAVAILABLE_DD_URL
      }
    )
  }, character(1), USE.NAMES = FALSE)

  return(verified)
}

#' Build legacy SOI archive URLs
#'
#' Constructs URLs to SOI microdata dictionary pages.
#'
#' @param paths Character vector. SOI S3 object keys.
#' @param check_exists Logical. Whether to verify URLs exist.
#' @return Character vector. SOI archive URLs.
#' @export
build_soi_archive_urls <- function(paths, check_exists = TRUE) {
  validate_paths(paths)

  base_url <- sprintf(
    "%sdictionary/soi/soi_archive_html/",
    LEGACY_BASE_URL
  )

  # Strip SOI-specific prefix and extension
  file_names <- gsub(LEGACY_PATH_PREFIXES$soi, "", paths)
  file_names <- gsub("\\.csv$", "", file_names)

  archive_urls <- paste0(base_url, file_names)

  if (check_exists) {
    archive_urls <- verify_archive_urls(archive_urls)
  }

  return(archive_urls)
}

#' Get download URL for a single path
#'
#' Returns the appropriate download URL based on series type.
#'
#' @param path Character scalar. Single S3 object key.
#' @param series Character scalar. Data series name.
#' @return Character scalar. Download URL.
#' @export
get_download_url <- function(path, series) {
  validate_series(series)

  if (series == "efile") {
    return(build_efile_urls(path))
  } else {
    return(build_s3_urls(path))
  }
}

#' Get profile/dictionary URL for a single path
#'
#' Returns the appropriate profile URL based on series type.
#'
#' @param path Character scalar. Single S3 object key.
#' @param series Character scalar. Data series name.
#' @param check_exists Logical. Whether to verify URL exists.
#' @return Character scalar. Profile URL.
#' @export
get_profile_url <- function(path, series, check_exists = TRUE) {
  validate_series(series)

  config <- SERIES_CONFIG[[series]]

  if (is.null(config) || !isTRUE(config$has_profile)) {
    return(UNAVAILABLE_DD_URL)
  }

  if (series == "soi") {
    return(build_soi_archive_urls(path, check_exists = check_exists))
  } else {
    return(build_archive_urls(series, path, check_exists = check_exists))
  }
}
