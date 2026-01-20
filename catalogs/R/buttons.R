# =============================================================================
# NCCS Catalog Button Generators
# Functions for creating HTML buttons for catalog tables
# =============================================================================

#' Create HTML button link
#'
#' Generates HTML anchor tag with button styling for catalog tables.
#'
#' @param url Character scalar. The URL for the button link.
#' @param button_name Character scalar. Button type: "download", "profile", "download_alt".
#' @return Character scalar. HTML anchor tag with button class.
#' @examples
#' make_button("https://example.com/file.csv", "download")
#' # Returns: "<a href='https://example.com/file.csv' class='button'> DOWNLOAD </a>"
#' @export
make_button <- function(url, button_name) {
  validate_button_name(button_name)

  template <- BUTTON_TEMPLATES[[button_name]]

  button <- paste0(
    "<a href='",
    url,
    "'",
    template
  )

  return(button)
}

#' Create HTML buttons for multiple URLs
#'
#' Vectorized version of make_button for generating buttons from URL vectors.
#'
#' @param urls Character vector. URLs for button links.
#' @param button_name Character scalar. Button type: "download", "profile", "download_alt".
#' @return Character vector. HTML anchor tags with button classes.
#' @export
make_buttons <- function(urls, button_name) {
  validate_button_name(button_name)

  if (length(urls) == 0) {
    return(character(0))
  }

  buttons <- vapply(urls, function(url) {
    make_button(url, button_name)
  }, character(1), USE.NAMES = FALSE)

  return(buttons)
}

#' Create download button from S3 path
#'
#' Convenience function that builds the S3 URL and creates the download button.
#'
#' @param path Character scalar. S3 object key.
#' @param series Character scalar. Data series name (for efile vs standard).
#' @return Character scalar. HTML download button.
#' @export
make_download_button <- function(path, series = "core") {
  url <- get_download_url(path, series)
  make_button(url, "download")
}

#' Create profile button from S3 path
#'
#' Convenience function that builds the archive URL and creates the profile button.
#'
#' @param path Character scalar. S3 object key.
#' @param series Character scalar. Data series name.
#' @param check_exists Logical. Whether to verify URL exists.
#' @return Character scalar. HTML profile button.
#' @export
make_profile_button <- function(path, series, check_exists = TRUE) {
  url <- get_profile_url(path, series, check_exists = check_exists)
  make_button(url, "profile")
}

#' Create download buttons for multiple paths
#'
#' Generates download buttons for a vector of S3 paths.
#'
#' @param paths Character vector. S3 object keys.
#' @param series Character scalar. Data series name.
#' @return Character vector. HTML download buttons.
#' @export
make_download_buttons <- function(paths, series = "core") {
  validate_paths(paths)

  urls <- if (series == "efile") {
    build_efile_urls(paths)
  } else {
    build_s3_urls(paths)
  }

  make_buttons(urls, "download")
}

#' Create profile buttons for multiple paths
#'
#' Generates profile/data dictionary buttons for a vector of S3 paths.
#'
#' @param paths Character vector. S3 object keys.
#' @param series Character scalar. Data series name.
#' @param check_exists Logical. Whether to verify URLs exist.
#' @return Character vector. HTML profile buttons.
#' @export
make_profile_buttons <- function(paths, series, check_exists = TRUE) {
  validate_paths(paths)
  validate_series(series)

  config <- SERIES_CONFIG[[series]]

  if (is.null(config) || !isTRUE(config$has_profile)) {
    # Return buttons pointing to unavailable page
    urls <- rep(UNAVAILABLE_DD_URL, length(paths))
    return(make_buttons(urls, "profile"))
  }

  if (series == "soi") {
    urls <- build_soi_archive_urls(paths, check_exists = check_exists)
  } else {
    urls <- build_archive_urls(series, paths, check_exists = check_exists)
  }

  make_buttons(urls, "profile")
}

#' Create efile download button with alternate styling
#'
#' Creates a download button using the alternate button style for efile tables.
#'
#' @param path Character scalar. Efile S3 object key.
#' @return Character scalar. HTML download button with alternate styling.
#' @export
make_efile_button <- function(path) {
  url <- build_efile_urls(path)
  make_button(url, "download_alt")
}

#' Create efile download buttons for multiple paths
#'
#' @param paths Character vector. Efile S3 object keys.
#' @return Character vector. HTML download buttons with alternate styling.
#' @export
make_efile_buttons <- function(paths) {
  validate_paths(paths)

  urls <- build_efile_urls(paths)
  make_buttons(urls, "download_alt")
}
