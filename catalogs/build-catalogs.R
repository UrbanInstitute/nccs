# =============================================================================
# NCCS Catalog Build Script
# Entry point for building data catalog tables
# =============================================================================
#
# This script loads the refactored catalog modules and demonstrates usage.
# The main functions are defined in R/ subdirectory modules.
#
# Usage:
#   source("build-catalogs.R")
#   catalog <- construct_catalog(d, series = "core", tscope = "CHARITIES", fscope = "PC")
#
# =============================================================================

# Load required packages
library(dplyr)
library(stringr)
library(knitr)
library(kableExtra)

# Set the module directory path
nccs_catalog_dir <- file.path(getwd(), "R")

# Source all modules
source(file.path(nccs_catalog_dir, "nccs_catalog.R"))

# =============================================================================
# Example Usage (for reference)
# =============================================================================
#
# # Load S3 catalog data
# GH_RAW <- "https://raw.githubusercontent.com/UrbanInstitute/nccs/main/catalogs/"
# d <- read.csv(paste0(GH_RAW, "AWS-NCCSDATA.csv"))
#
# # Build Core catalog for 501c3 Charities, PC scope
# core_catalog <- construct_catalog(
#   s3_catalog = d,
#   series = "core",
#   tscope = "CHARITIES",
#   fscope = "PC",
#   np_type = "501C3-CHARITIES"
# )
#
# # Build BMF catalog
# bmf_catalog <- construct_catalog(
#   s3_catalog = d,
#   series = "bmf"
# )
#
# # Build SOI Microdata catalog
# soi_catalog <- construct_catalog(
#   s3_catalog = d,
#   series = "soi",
#   tscope = "CHARITIES",
#   fscope = "PC",
#   np_type = "501C3-CHARITIES"
# )
#
# # Render as HTML table
# catalog %>%
#   knitr::kable(
#     escape = FALSE,
#     col.names = c("Download Link", "Data Dictionary", "Size", "Year", "Type", "Scope")
#   ) %>%
#   kableExtra::kable_styling()
#
# =============================================================================
