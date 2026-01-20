# =============================================================================
# NCCS Catalog Builders
# Series-specific catalog construction functions
# =============================================================================

#' Build catalog data frame for any series
#'
#' Main entry point for catalog construction. Routes to series-specific builders.
#'
#' @param s3_catalog Data frame. Must contain 'Key' and 'Size' columns.
#' @param series Character scalar. Data series name.
#' @param tscope Character scalar or NULL. Tax scope (required for scoped series).
#' @param fscope Character scalar or NULL. Form scope (required for scoped series).
#' @param np_type Character scalar or NULL. Nonprofit type label for table column.
#' @param check_urls Logical. Whether to verify archive URLs exist. Default: TRUE.
#' @return Data frame. Catalog table ready for rendering.
#' @export
construct_catalog <- function(s3_catalog,
                               series,
                               tscope = NULL,
                               fscope = NULL,
                               np_type = NULL,
                               check_urls = TRUE) {
  # Validate inputs
  validate_s3_catalog(s3_catalog)
  validate_series(series)
  validate_scoped_params(series, tscope, fscope)

  # Get paths from catalog
  paths <- s3_catalog$Key

  # Filter paths for this series
  filtered_paths <- filter_paths(
    series = series,
    paths = paths,
    tscope = tscope,
    fscope = fscope
  )

  if (length(filtered_paths) == 0) {
    warning(sprintf("No files found for series '%s'", series))
    return(data.frame())
  }

  # Get file sizes
  sizes <- get_file_sizes(s3_catalog, filtered_paths)

  # Dispatch to series-specific builder
  catalog <- switch(series,
    "bmf" = build_bmf_catalog(filtered_paths, sizes, check_urls),
    "core" = build_core_catalog(filtered_paths, sizes, np_type, fscope, check_urls),
    "misc" = build_misc_catalog(filtered_paths, sizes, check_urls),
    "soi" = build_soi_catalog(filtered_paths, sizes, np_type, fscope, check_urls),
    "revocations" = build_revocations_catalog(filtered_paths, sizes),
    "census-crosswalk" = build_census_catalog(filtered_paths, sizes),
    "efile" = build_efile_catalog(filtered_paths, sizes),
    # Default fallback
    build_generic_catalog(filtered_paths, sizes, series, check_urls)
  )

  return(catalog)
}

#' Get file sizes for paths
#'
#' Extracts and formats file sizes from S3 catalog.
#'
#' @param s3_catalog Data frame. S3 catalog with Key and Size columns.
#' @param paths Character vector. Paths to get sizes for.
#' @return Character vector. Formatted file sizes.
#' @keywords internal
get_file_sizes <- function(s3_catalog, paths) {
  sizes <- s3_catalog$Size[match(paths, s3_catalog$Key)]
  format_file_size(sizes)
}

# =============================================================================
# Series-Specific Builders
# =============================================================================

#' Build BMF catalog
#' @keywords internal
build_bmf_catalog <- function(paths, sizes, check_urls = TRUE) {
  download_buttons <- make_download_buttons(paths, "bmf")
  profile_buttons <- make_profile_buttons(paths, "bmf", check_exists = check_urls)

  catalog <- data.frame(
    download_buttons = download_buttons,
    profile_buttons = profile_buttons,
    size = sizes,
    YEAR = extract_year(paths),
    MONTH = extract_month(paths),
    stringsAsFactors = FALSE
  )

  return(catalog)
}

#' Build Core catalog
#' @keywords internal
build_core_catalog <- function(paths, sizes, np_type, fscope, check_urls = TRUE) {
  download_buttons <- make_download_buttons(paths, "core")
  profile_buttons <- make_profile_buttons(paths, "core", check_exists = check_urls)

  catalog <- data.frame(
    download_buttons = download_buttons,
    profile_buttons = profile_buttons,
    size = sizes,
    YEAR = extract_year(paths),
    NP_TYPE = np_type,
    FORM_SCOPE = fscope,
    stringsAsFactors = FALSE
  )

  return(catalog)
}

#' Build Misc/Supplemental catalog
#' @keywords internal
build_misc_catalog <- function(paths, sizes, check_urls = TRUE) {
  download_buttons <- make_download_buttons(paths, "misc")
  profile_buttons <- make_profile_buttons(paths, "misc", check_exists = check_urls)

  catalog <- data.frame(
    download_buttons = download_buttons,
    profile_buttons = profile_buttons,
    size = sizes,
    stringsAsFactors = FALSE
  )

  return(catalog)
}

#' Build SOI Microdata catalog
#' @keywords internal
build_soi_catalog <- function(paths, sizes, np_type, fscope, check_urls = TRUE) {
  download_buttons <- make_download_buttons(paths, "soi")
  profile_buttons <- make_profile_buttons(paths, "soi", check_exists = check_urls)

  catalog <- data.frame(
    download_buttons = download_buttons,
    profile_buttons = profile_buttons,
    size = sizes,
    YEAR = extract_year(paths),
    NP_TYPE = np_type,
    FORM_SCOPE = fscope,
    stringsAsFactors = FALSE
  )

  return(catalog)
}

#' Build Revocations catalog
#'
#' Revocations has a special structure with LOG, ORG, and TABLE files.
#'
#' @keywords internal
build_revocations_catalog <- function(paths, sizes) {
  # Build S3 URLs
  urls <- build_s3_urls(paths)

  # Separate by file type
  log_urls <- grep("LOG", urls, value = TRUE)
  org_urls <- grep("ORG", urls, value = TRUE)
  table_urls <- grep("TABLE", urls, value = TRUE)

  # Create buttons for each type
  log_buttons <- make_buttons(log_urls, "download")
  org_buttons <- make_buttons(org_urls, "download")
  table_buttons <- make_buttons(table_urls, "download")

  # Extract dates from log paths
  log_paths <- grep("LOG", paths, value = TRUE)

  catalog <- data.frame(
    log_buttons = log_buttons,
    org_buttons = org_buttons,
    table_buttons = table_buttons,
    YEAR = extract_year(log_paths),
    MONTH = extract_month(log_paths),
    stringsAsFactors = FALSE
  )

  return(catalog)
}

#' Build Census crosswalk catalog
#' @keywords internal
build_census_catalog <- function(paths, sizes) {
  download_buttons <- make_download_buttons(paths, "census-crosswalk")

  catalog <- data.frame(
    download_buttons = download_buttons,
    size = sizes,
    stringsAsFactors = FALSE
  )

  return(catalog)
}

#' Build Efile catalog
#' @keywords internal
build_efile_catalog <- function(paths, sizes) {
  download_buttons <- make_efile_buttons(paths)

  catalog <- data.frame(
    download_buttons = download_buttons,
    size = sizes,
    TABLE_NAME = extract_efile_names(paths),
    YEAR = extract_efile_year(paths),
    CARDINALITY = extract_cardinality(paths),
    stringsAsFactors = FALSE
  )

  return(catalog)
}

#' Build generic catalog
#'
#' Fallback for series not explicitly handled.
#'
#' @keywords internal
build_generic_catalog <- function(paths, sizes, series, check_urls = TRUE) {
  download_buttons <- make_download_buttons(paths, series)

  config <- SERIES_CONFIG[[series]]

  if (!is.null(config) && isTRUE(config$has_profile)) {
    profile_buttons <- make_profile_buttons(paths, series, check_exists = check_urls)
    catalog <- data.frame(
      download_buttons = download_buttons,
      profile_buttons = profile_buttons,
      size = sizes,
      stringsAsFactors = FALSE
    )
  } else {
    catalog <- data.frame(
      download_buttons = download_buttons,
      size = sizes,
      stringsAsFactors = FALSE
    )
  }

  if (!is.null(config) && isTRUE(config$has_year)) {
    catalog$YEAR <- extract_year(paths)
  }

  if (!is.null(config) && isTRUE(config$has_month)) {
    catalog$MONTH <- extract_month(paths)
  }

  return(catalog)
}

# =============================================================================
# Specialized Catalog Functions
# =============================================================================

#' Build revocations catalog from URLs
#'
#' Alternative entry point using pre-built URLs instead of S3 catalog.
#'
#' @param urls Character vector. Full S3 URLs.
#' @return Data frame. Revocations catalog table.
#' @export
get_catalog_revocations <- function(urls) {
  series_urls <- grep("raw/revocations", urls, value = TRUE)

  log_urls <- grep("LOG", series_urls, value = TRUE)
  org_urls <- grep("ORG", series_urls, value = TRUE)
  table_urls <- grep("TABLE", series_urls, value = TRUE)

  log_buttons <- make_buttons(log_urls, "download")
  org_buttons <- make_buttons(org_urls, "download")
  table_buttons <- make_buttons(table_urls, "download")

  catalog <- data.frame(
    YEAR = extract_year(log_urls),
    MONTH = extract_month(log_urls),
    log_buttons = log_buttons,
    org_buttons = org_buttons,
    table_buttons = table_buttons,
    stringsAsFactors = FALSE
  )

  # Sort by year and month descending
  catalog <- catalog[order(-as.numeric(catalog$YEAR), -as.numeric(catalog$MONTH)), ]

  names(catalog) <- c(
    "Year",
    "Month",
    "Revoked Organizations",
    "Log of Revocations",
    "Number of Revocations"
  )

  return(catalog)
}

#' Build efile catalog table
#'
#' Creates a catalog table for efile data with table names and cardinality.
#'
#' @param s3_catalog Data frame. Efile S3 catalog with Key and Size columns.
#' @return Data frame. Efile catalog table.
#' @export
build_efile_table <- function(s3_catalog) {
  validate_s3_catalog(s3_catalog)

  paths <- filter_efile_paths(s3_catalog$Key)
  sizes <- get_file_sizes(s3_catalog, paths)

  build_efile_catalog(paths, sizes)
}
