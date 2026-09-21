################## Script Header ###############################################
# Title: Internal data download script
# Description: This script builds datasets used internally by the
# nccs.urban.org website.
# Programmer: Thiyaghessan [tpoongundranar@urban.org]
# Date Created: 2025-05-30
# Date Modified: 2026-09-21
# Details
# (1) - NTEE-NAICS Crosswalk
################################################################################

# ---------------------------------------------------------------------------
# (1) - NTEE-NAICS Crosswalk
# ---------------------------------------------------------------------------
#
# Two sources are combined:
#
#   * The Nonprofit Open Data Collective's NTEE-NAICS crosswalk and its NTEE
#     description table. These carry the long "Details" text and the NAICS
#     match for every code that existed when the crosswalk was written.
#
#   * The IRS's own NTEE code list (Instructions for Form 1023, Appendix D),
#     kept in the nccs-data-bmf repository. The IRS added 24 codes in 2021
#     that the NODC crosswalk never picked up. Those codes are appended here
#     with a NAICS match taken from the NAICS 2022 industry whose title the
#     IRS reused as the code description. They have no long "Details" text
#     because the IRS publishes none.
#
# The IRS list is the source of truth for WHICH codes exist (nccs-contracts
# BACKLOG Z25). Codes the IRS has retired stay in the table, marked as such,
# because organizations in the IRS data still carry them.

# --- NODC description table --------------------------------------------------

nodc_description_url <- paste0(
  "https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/",
  "mission-taxonomies/main/NTEE/all-ntee-original.csv"
)

nodc_descriptions <- readr::read_csv(nodc_description_url, show_col_types = FALSE) |>
  dplyr::rename(
    NTEE_IRS   = ntee,
    Definition = description,
    Details    = definition
  )

# --- NODC NTEE-NAICS crosswalk ----------------------------------------------

nodc_crosswalk_url <- paste0(
  "https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/",
  "mission-taxonomies/refs/heads/main/NAICS/ntee-naics-crosswalk.csv"
)

nodc_crosswalk <- readr::read_csv(
  nodc_crosswalk_url,
  col_types = readr::cols(.default = readr::col_character())
) |>
  dplyr::select(NTEECC, NAICS) |>
  dplyr::rename(NTEE_IRS = NTEECC) |>
  dplyr::left_join(nodc_descriptions, by = "NTEE_IRS")

# --- IRS code list (source of truth for which codes exist) ------------------

irs_code_list_url <- paste0(
  "https://raw.githubusercontent.com/UrbanInstitute/nccs-data-bmf/main/",
  "data/lookup/irs_ntee_codes.csv"
)

irs_code_list <- readr::read_csv(irs_code_list_url, show_col_types = FALSE)

# NAICS 2022 codes for the IRS codes the NODC crosswalk lacks. Each IRS
# description is the title of one NAICS industry, so the match is by title.
naics_for_newer_irs_codes <- tibble::tribble(
  ~NTEE_IRS, ~NAICS,
  "E6A", "456110",   # Pharmacies & Drug Retailers
  "K2A", "111219",   # Other Vegetable (except Potato) & Melon Farming
  "K2B", "115112",   # Soil Preparation, Planting, & Cultivating
  "K2C", "312130",   # Wineries
  "K6A", "445240",   # Meat Retailers
  "K6B", "445292",   # Confectionery & Nut Retailers
  "K6C", "722320",   # Caterers
  "K6D", "722330",   # Mobile Food Services
  "K6E", "722410",   # Drinking Places (Alcoholic Beverages)
  "K6F", "722515",   # Snack & Nonalcoholic Beverage Bars
  "K90", "722513",   # Limited-Service Restaurants
  "K91", "445110",   # Supermarkets & Other Grocery Retailers (except Convenience)
  "K92", "445131",   # Convenience Retailers
  "K93", "445230",   # Fruit & Vegetable Retailers
  "K94", "445298",   # All Other Specialty Food Retailers
  "K95", "456191",   # Food (Health) Supplement Retailers
  "K96", "455211",   # Warehouse Clubs & Supercenters
  "K97", "722310",   # Food Service Contractors
  "K98", "722511",   # Full-Service Restaurants
  "L4A", "721110",   # Hotels (except Casino Hotels) & Motels
  "L4B", "721191",   # Bed-and-Breakfast Inns
  "N2A", "721211",   # RV (Recreational Vehicle) Parks & Campgrounds
  "N2B", "721214",   # Recreational & Vacation Camps (except Campgrounds)
  "P7A", "623210"    # Residential Intellectual & Developmental Disability Facilities
)

irs_codes_missing_from_nodc <- irs_code_list |>
  dplyr::filter(!ntee_code %in% nodc_crosswalk$NTEE_IRS) |>
  dplyr::transmute(
    NTEE_IRS   = ntee_code,
    Definition = description,
    Details    = NA_character_
  ) |>
  dplyr::left_join(naics_for_newer_irs_codes, by = "NTEE_IRS")

irs_codes_without_naics <- irs_codes_missing_from_nodc |>
  dplyr::filter(is.na(NAICS)) |>
  dplyr::pull(NTEE_IRS)

if (length(irs_codes_without_naics) > 0) {
  stop(
    "IRS codes with no NAICS match in naics_for_newer_irs_codes: ",
    paste(irs_codes_without_naics, collapse = ", ")
  )
}

# --- Codes the IRS has retired ----------------------------------------------

# P72 is not in the current IRS list but organizations still carry it. The
# NODC description table has no text for it, so the name comes from the
# NODC crosswalk's own NAME column.
retired_code_note <- " <i>(Retired by the IRS; still present in IRS data)</i>"

retired_code_names <- tibble::tribble(
  ~NTEE_IRS, ~retired_definition,
  "P72", paste0("Half-Way House (Short-Term Residential Care)", retired_code_note)
)

# --- Combine and write -------------------------------------------------------

ntee_naics_xwalk <- nodc_crosswalk |>
  dplyr::bind_rows(irs_codes_missing_from_nodc) |>
  dplyr::left_join(retired_code_names, by = "NTEE_IRS") |>
  dplyr::mutate(
    Definition = dplyr::coalesce(Definition, retired_definition)
  ) |>
  dplyr::select(NTEE_IRS, NAICS, Definition, Details)

# The file has always been written with Windows line endings; keep that so
# the diff shows only the rows that changed.
readr::write_csv(ntee_naics_xwalk, "data-raw/NTEE-NAICS-XWALK.csv", eol = "\r\n")
