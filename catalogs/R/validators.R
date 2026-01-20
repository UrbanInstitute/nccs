# =============================================================================
# NCCS Catalog Validators
# Input validation functions with informative error messages
# =============================================================================

#' Validate series name
#'
#' @param series Character scalar. Name of the data series.
#' @return TRUE if valid, otherwise stops with error
#' @export
validate_series <- function(series) {
  if (is.null(series) || length(series) != 1) {
    stop("'series' must be a single character value, not NULL or vector")
  }

  if (!series %in% VALID_SERIES) {
    stop(sprintf(
      "Invalid series '%s'. Must be one of: %s",
      series,
      paste(VALID_SERIES, collapse = ", ")
    ))
  }


  invisible(TRUE)
}

#' Validate tax scope
#'
#' @param tscope Character scalar. Tax exemption type.
#' @param allow_null Logical. Whether NULL is allowed.
#' @return TRUE if valid, otherwise stops with error
#' @export
validate_tscope <- function(tscope, allow_null = TRUE) {
  if (is.null(tscope)) {
    if (allow_null) {
      return(invisible(TRUE))
    } else {
      stop("'tscope' is required and cannot be NULL")
    }
  }

  if (length(tscope) != 1) {
    stop("'tscope' must be a single character value")
  }

  if (!tscope %in% VALID_TSCOPE) {
    stop(sprintf(
      "Invalid tscope '%s'. Must be one of: %s",
      tscope,
      paste(VALID_TSCOPE, collapse = ", ")
    ))
  }

  invisible(TRUE)
}

#' Validate form scope
#'
#' @param fscope Character scalar. Form type.
#' @param allow_null Logical. Whether NULL is allowed.
#' @return TRUE if valid, otherwise stops with error
#' @export
validate_fscope <- function(fscope, allow_null = TRUE) {
  if (is.null(fscope)) {
    if (allow_null) {
      return(invisible(TRUE))
    } else {
      stop("'fscope' is required and cannot be NULL")
    }
  }

  if (length(fscope) != 1) {
    stop("'fscope' must be a single character value")
  }

  if (!fscope %in% VALID_FSCOPE) {
    stop(sprintf(
      "Invalid fscope '%s'. Must be one of: %s",
      fscope,
      paste(VALID_FSCOPE, collapse = ", ")
    ))
  }

  invisible(TRUE)
}

#' Validate paths vector
#'
#' @param paths Character vector. S3 object keys.
#' @return TRUE if valid, otherwise stops with error
#' @export
validate_paths <- function(paths) {
  if (is.null(paths)) {
    stop("'paths' cannot be NULL")
  }

  if (!is.character(paths)) {
    stop("'paths' must be a character vector")
  }

  if (length(paths) == 0) {
    warning("'paths' is empty - no files will be processed")
  }

  invisible(TRUE)
}

#' Validate S3 catalog data frame
#'
#' @param s3_catalog Data frame. Must contain 'Key' and 'Size' columns.
#' @return TRUE if valid, otherwise stops with error
#' @export
validate_s3_catalog <- function(s3_catalog) {
  if (is.null(s3_catalog)) {
    stop("'s3_catalog' cannot be NULL")
  }

  if (!is.data.frame(s3_catalog)) {
    stop("'s3_catalog' must be a data.frame")
  }

  required_cols <- c("Key", "Size")
  missing_cols <- setdiff(required_cols, names(s3_catalog))

  if (length(missing_cols) > 0) {
    stop(sprintf(
      "'s3_catalog' is missing required columns: %s",
      paste(missing_cols, collapse = ", ")
    ))
  }

  invisible(TRUE)
}

#' Validate button name
#'
#' @param button_name Character scalar. Button type.
#' @return TRUE if valid, otherwise stops with error
#' @export
validate_button_name <- function(button_name) {
  valid_buttons <- names(BUTTON_TEMPLATES)

  if (is.null(button_name) || length(button_name) != 1) {
    stop("'button_name' must be a single character value")
  }

  if (!button_name %in% valid_buttons) {
    stop(sprintf(
      "Invalid button_name '%s'. Must be one of: %s",
      button_name,
      paste(valid_buttons, collapse = ", ")
    ))
  }

  invisible(TRUE)
}

#' Validate that required parameters are provided for scoped series
#'
#' @param series Character scalar. Series name.
#' @param tscope Character scalar or NULL. Tax scope.
#' @param fscope Character scalar or NULL. Form scope.
#' @return TRUE if valid, otherwise stops with error
#' @export
validate_scoped_params <- function(series, tscope, fscope) {
  config <- SERIES_CONFIG[[series]]

  if (is.null(config)) {
    # Series not in config, skip validation
    return(invisible(TRUE))
  }

  if (isTRUE(config$scoped)) {
    if (is.null(tscope)) {
      stop(sprintf(
        "Series '%s' requires 'tscope' parameter (one of: %s)",
        series,
        paste(VALID_TSCOPE, collapse = ", ")
      ))
    }
    if (is.null(fscope)) {
      stop(sprintf(
        "Series '%s' requires 'fscope' parameter (one of: %s)",
        series,
        paste(VALID_FSCOPE, collapse = ", ")
      ))
    }
  }

  invisible(TRUE)
}
