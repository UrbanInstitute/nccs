# =============================================================================
# NCCS Catalog Configuration
# Centralized constants, URLs, and regex patterns
# =============================================================================

# -----------------------------------------------------------------------------
# Base URLs
# -----------------------------------------------------------------------------

#' S3 bucket base URL for NCCS data
S3_BASE_URL <- Sys.getenv(

  "NCCS_S3_URL",
  unset = "https://nccsdata.s3.us-east-1.amazonaws.com/"
)

#' S3 bucket base URL for NCCS efile data
S3_EFILE_BASE_URL <- Sys.getenv(

  "NCCS_EFILE_S3_URL",
  unset = "https://nccs-efile.s3.us-east-1.amazonaws.com/"
)

#' Legacy archive base URL
LEGACY_BASE_URL <- "https://urbaninstitute.github.io/nccs-legacy/"

#' URL for unavailable data dictionary pages
UNAVAILABLE_DD_URL <- "https://urbaninstitute.github.io/nccs/catalogs/dd_unavailable.html"

# -----------------------------------------------------------------------------
# Valid Values
# -----------------------------------------------------------------------------

#' Valid data series names
VALID_SERIES <- c(

  "core",
  "bmf",
  "misc",

  "soi",
  "efile",
  "revocations",
  "census-crosswalk"
)

#' Valid tax scope values (tscope)
#' @details
#' - CHARITIES: 501c3 nonprofit organizations
#' - NONPROFIT: All other 501c type organizations besides 501c3
#' - PRIVFOUND: 501c3 private foundations
VALID_TSCOPE <- c("CHARITIES", "NONPROFIT", "PRIVFOUND")

#' Valid form scope values (fscope)
#' @details
#' - PZ: 990 + 990EZ filers
#' - PC: 990 filers only
#' - PF: 990PF private foundations
#' - EZ: 990EZ filers only
VALID_FSCOPE <- c("PZ", "PC", "PF", "EZ")

# -----------------------------------------------------------------------------
# Regex Patterns for File Path Matching
# -----------------------------------------------------------------------------

#' Regex patterns for matching S3 object keys by series
SERIES_PATTERNS <- list(
  bmf = "BMF-.*-PX",
  core = "CORE-[0-9]{4}-501C[0-9A-Z]-",
  misc = "SUPPLEMENTAL-CORE.*",
  soi = "SOI-MICRODATA-[0-9]{4}-501C[0-9A-Z]-",
  revocations = "REVOCATIONS",
  census_crosswalk = "BLOCKX\\.csv|TRACTX\\.csv",
  efile = "\\.csv$"
)

#' Patterns for extracting path prefixes to remove when building archive URLs
LEGACY_PATH_PREFIXES <- list(
  core = "legacy/core/",
  bmf = "legacy/bmf/",
  misc = "legacy/misc/",
  soi = "legacy/soi-micro/[0-9]{4}/"
)

# -----------------------------------------------------------------------------
# Series Configuration
# Metadata about each series for catalog building
# -----------------------------------------------------------------------------

#' Configuration for each data series
#' @field pattern Regex pattern to match files
#' @field has_profile Whether series has profile/data dictionary links
#' @field has_year Whether series includes year metadata
#' @field has_month Whether series includes month metadata
#' @field scoped Whether series uses tscope/fscope filtering
SERIES_CONFIG <- list(
  bmf = list(
    pattern = SERIES_PATTERNS$bmf,
    has_profile = TRUE,
    has_year = TRUE,
    has_month = TRUE,
    scoped = FALSE
  ),
  core = list(
    pattern = SERIES_PATTERNS$core,
    has_profile = TRUE,
    has_year = TRUE,
    has_month = FALSE,
    scoped = TRUE
  ),
  misc = list(
    pattern = SERIES_PATTERNS$misc,
    has_profile = TRUE,
    has_year = FALSE,
    has_month = FALSE,
    scoped = FALSE
  ),
  soi = list(
    pattern = SERIES_PATTERNS$soi,
    has_profile = TRUE,
    has_year = TRUE,
    has_month = FALSE,
    scoped = TRUE
  ),
  revocations = list(
    pattern = SERIES_PATTERNS$revocations,
    has_profile = FALSE,
    has_year = TRUE,
    has_month = TRUE,
    scoped = FALSE
  ),
  `census-crosswalk` = list(
    pattern = SERIES_PATTERNS$census_crosswalk,
    has_profile = FALSE,
    has_year = FALSE,
    has_month = FALSE,
    scoped = FALSE
  )
)

# -----------------------------------------------------------------------------
# HTML Templates
# -----------------------------------------------------------------------------

#' HTML templates for catalog buttons
BUTTON_TEMPLATES <- list(
  download = " class='button'> DOWNLOAD </a>",
  profile = " class='button2'> PROFILE </a>",
  download_alt = " class='button3'> DOWNLOAD </a>"
)

# -----------------------------------------------------------------------------
# Extraction Patterns
# -----------------------------------------------------------------------------

#' Pattern for extracting 4-digit years (1900-2099)
YEAR_PATTERN <- "\\b(19|20)\\d{2}\\b"

#' Pattern for extracting 2-digit months (01-12)
MONTH_PATTERN <- "\\b(0[1-9]|1[0-2])\\b"

#' Pattern for extracting efile years (format: -YYYY-)
EFILE_YEAR_PATTERN <- "-[0-9]{4}\\."

#' Pattern for extracting form scope from paths
FSCOPE_PATTERN <- "-P[CXZ]{1}\\b"

#' Pattern for extracting RDB table cardinality
CARDINALITY_PATTERN <- "-T[0-9]{2}-"
