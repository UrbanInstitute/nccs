# =============================================================================
# NCCS Catalog Package
# Main entry point - sources all module files
# =============================================================================
#
# This file loads all NCCS catalog functions in the correct dependency order.
# Source this file to get access to all catalog building functionality.
#
# Usage:
#   source("R/nccs_catalog.R")
#   catalog <- construct_catalog(s3_catalog, series = "core", tscope = "CHARITIES", fscope = "PC")
#
# =============================================================================

# Get the directory containing this file
nccs_catalog_dir <- if (exists("nccs_catalog_dir")) {
  nccs_catalog_dir
} else {
  # Default to R/ subdirectory of current working directory
  "R"
}

# Helper to source files from the R directory
source_module <- function(filename) {
  filepath <- file.path(nccs_catalog_dir, filename)
  if (file.exists(filepath)) {
    source(filepath, local = FALSE)
  } else {
    # Try relative to this file's location
    alt_path <- file.path(dirname(sys.frame(1)$ofile), filename)
    if (file.exists(alt_path)) {
      source(alt_path, local = FALSE)
    } else {
      stop(sprintf("Cannot find module file: %s", filename))
    }
  }
}

# =============================================================================
# Load Required Packages
# =============================================================================

required_packages <- c("dplyr", "stringr", "RCurl")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    warning(sprintf("Package '%s' is required but not installed.", pkg))
  }
}

# =============================================================================
# Source Modules in Dependency Order
# =============================================================================

# 1. Configuration (no dependencies)
source_module("config.R")

# 2. Validators (depends on config for valid values)
source_module("validators.R")

# 3. Extractors (depends on config for patterns, validators)
source_module("extractors.R")

# 4. URL Builders (depends on config for base URLs, validators)
source_module("url_builders.R")

# 5. Buttons (depends on config for templates, validators, url_builders)
source_module("buttons.R")

# 6. Catalog Builders (depends on all above)
source_module("catalog_builders.R")

# =============================================================================
# Package Info
# =============================================================================

cat("NCCS Catalog Functions loaded successfully.\n")
cat("Available functions:\n")
cat("  - construct_catalog()      : Build catalog for any series\n")
cat("  - filter_paths()           : Filter S3 paths by series\n")
cat("  - build_s3_urls()          : Create S3 download URLs\n")
cat("  - make_download_buttons()  : Create HTML download buttons\n")
cat("  - make_profile_buttons()   : Create HTML profile buttons\n")
cat("\n")
