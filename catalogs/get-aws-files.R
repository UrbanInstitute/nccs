# =============================================================================
# NCCS S3 manifest builder
# =============================================================================
#
# Lists objects in the public NCCS S3 buckets and writes CSV manifests that
# the catalog .qmd pages render against.
#
# Credentials: this script needs s3:ListBucket on `nccsdata` (and `nccs-efile`
# for the efile target). Run it locally with your SSO profile — there is no
# CI automation. The aws.s3 R package reads credentials from environment
# variables, so configure SSO once with the AWS CLI v2:
#
#     aws configure sso                                          # one-time
#     aws sso login --profile <your-profile>                     # daily refresh
#     eval "$(aws configure export-credentials --profile <your-profile> --format env)"
#     export AWS_DEFAULT_REGION=us-east-1
#
# See catalogs/README.md (top) for the full monthly refresh procedure.
#
# Usage (run from the `nccs/` project root):
#   Rscript catalogs/get-aws-files.R              # refresh all manifests
#   Rscript catalogs/get-aws-files.R bmf          # refresh BMF manifest only
# =============================================================================

suppressPackageStartupMessages({
  library(aws.s3)
  library(data.table)
})

S3_BASE         <- "https://nccsdata.s3.us-east-1.amazonaws.com/"
S3_EFILE_BASE   <- "https://nccs-efile.s3.us-east-1.amazonaws.com/"
KEEP_COLS       <- c("Key", "LastModified", "ETag", "Size", "StorageClass", "Bucket")

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

#' List a single S3 prefix and return a tidy data.frame.
#'
#' Credentials are read from env vars and passed explicitly to `get_bucket`.
#' Newer aws.s3 builds don't always auto-detect AWS_SESSION_TOKEN, which
#' silently falls back to anonymous and returns only public-listable keys.
list_prefix <- function(bucket, prefix) {
  message(sprintf("  listing s3://%s/%s", bucket, prefix))
  buck <- aws.s3::get_bucket(
    bucket        = bucket,
    prefix        = prefix,
    max           = Inf,
    key           = Sys.getenv("AWS_ACCESS_KEY_ID"),
    secret        = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
    session_token = Sys.getenv("AWS_SESSION_TOKEN"),
    region        = Sys.getenv("AWS_DEFAULT_REGION", "us-east-1")
  )
  if (length(buck) == 0) {
    return(data.frame())
  }
  dt <- data.table::rbindlist(buck, fill = TRUE) |> as.data.frame()
  dt <- unique(dt[, intersect(KEEP_COLS, names(dt)), drop = FALSE])
  dt
}

#' Add SizeMB and URL columns to a manifest.
decorate <- function(dt, base_url) {
  if (nrow(dt) == 0) return(dt)
  dt$SizeMB <- paste0(as.character(round(dt$Size / 1e6, 1)), " mb")
  dt$URL    <- paste0(base_url, dt$Key)
  dt
}

# -----------------------------------------------------------------------------
# BMF manifest (new layout)
#
# Source folders, all in the public `nccsdata` bucket:
#   unified/bmf/                       -- Unified BMF, plain (renamed from
#                                         "Master BMF" 2026-07-01, ADR 0037)
#   master/bmf/                       -- Superseded plain path; reachable
#                                         through 2026-09-28, then archived
#                                         (non-silent supersession, ADR 0037)
#   master/bmf/state_marts/csv/       -- Per-state geocoded marts (CSV); NOT
#                                         renamed by ADR 0037
#   geocoding/bmf-master/merged/      -- Master BMF with lat/lon; NOT renamed
#                                         by ADR 0037 (geocoded extension)
#   processed/bmf/YYYY_MM/            -- monthly transformed BMF (2023-06+)
#   processed/bmf-legacy/YYYY_MM/     -- monthly harmonized legacy BMF (1989-2022)
#   legacy/bmf/                       -- raw NCCS 501CX-NONPROFIT-PX vintages
#
# Output: catalogs/AWS-BMF.csv with an extra `source` column tagging each row.
# -----------------------------------------------------------------------------

build_bmf_manifest <- function(out_path = "catalogs/AWS-BMF.csv") {
  message("Building BMF manifest")
  sources <- list(
    unified    = "unified/bmf/",
    master     = "master/bmf/",
    state_mart = "master/bmf/state_marts/csv/",
    geocoded   = "geocoding/bmf-master/merged/",
    processed  = "processed/bmf/",
    legacy     = "processed/bmf-legacy/",
    raw_legacy = "legacy/bmf/"
  )

  parts <- lapply(names(sources), function(src) {
    dt <- list_prefix("nccsdata", sources[[src]])
    if (nrow(dt) == 0) {
      warning(sprintf("No objects under prefix '%s'", sources[[src]]), call. = FALSE)
      return(dt)
    }
    dt$source <- src
    dt$Prefix <- sources[[src]]
    dt
  })

  parts <- parts[vapply(parts, nrow, integer(1)) > 0]
  if (length(parts) == 0) stop("No BMF objects found in any source prefix")

  manifest <- data.table::rbindlist(parts, fill = TRUE) |> as.data.frame()
  manifest <- decorate(manifest, S3_BASE)

  # Stable column order
  cols <- c("source", "Prefix", "Key", "LastModified", "ETag",
            "Size", "SizeMB", "StorageClass", "Bucket", "URL")
  manifest <- manifest[, intersect(cols, names(manifest))]

  dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
  write.csv(manifest, out_path, row.names = FALSE)
  message(sprintf("Wrote %d rows to %s", nrow(manifest), out_path))
  invisible(manifest)
}

# -----------------------------------------------------------------------------
# Full NCCSDATA manifest (kept for non-BMF catalogs: core, soi, revocations, etc.)
# -----------------------------------------------------------------------------

build_nccsdata_manifest <- function(out_path = "catalogs/AWS-NCCSDATA.csv") {
  message("Building full nccsdata manifest")
  dt <- list_prefix("nccsdata", "")
  dt <- decorate(dt, S3_BASE)
  dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
  write.csv(dt, out_path, row.names = FALSE)
  message(sprintf("Wrote %d rows to %s", nrow(dt), out_path))
  invisible(dt)
}

# -----------------------------------------------------------------------------
# EFILE manifest
# -----------------------------------------------------------------------------

build_efile_manifest <- function(out_path = "catalogs/AWS-NCCS-EFILE-V2.csv") {
  message("Building nccs-efile manifest")
  dt <- list_prefix("nccs-efile", "public")
  dt <- decorate(dt, S3_EFILE_BASE)
  dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
  write.csv(dt, out_path, row.names = FALSE)
  message(sprintf("Wrote %d rows to %s", nrow(dt), out_path))
  invisible(dt)
}

# -----------------------------------------------------------------------------
# Entry point
# -----------------------------------------------------------------------------

main <- function(args = commandArgs(trailingOnly = TRUE)) {
  target <- if (length(args) == 0) "all" else tolower(args[1])
  switch(target,
    "bmf"      = build_bmf_manifest(),
    "nccsdata" = build_nccsdata_manifest(),
    "efile"    = build_efile_manifest(),
    "all"      = {
      build_nccsdata_manifest()
      build_bmf_manifest()
      build_efile_manifest()
    },
    stop(sprintf("Unknown target '%s'. Use one of: bmf, nccsdata, efile, all.", target))
  )
}

if (sys.nframe() == 0) {
  main()
}
