################## Script Header ###############################################
# Title: Internal data download script
# Description: This script downloads datasets used internally by the 
# nccs.urban.org website
# Programmer: Thiyaghessan [tpoongundranar@urban.org]
# Date Created: 2025-05-30
# Date Modified: 2025-05-30
# Details
# (1) - NTEE-NAICS Crosswalk
################################################################################

# (1) - NTEE-NAICS Crosswalk

ntee1_df <- readr::read_csv("https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/mission-taxonomies/main/NTEE/all-ntee-original.csv") 
ntee1_df <- ntee1_df |>
  dplyr::rename(
    NTEE_IRS = ntee,
    Definition = description,
    Details = definition
  )

ntee_naics_xwalk <- readr::read_csv("https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/mission-taxonomies/refs/heads/main/NAICS/ntee-naics-crosswalk.csv")
ntee_naics_xwalk <- ntee_naics_xwalk |>
  dplyr::select(NTEECC, NAICS) |>
  dplyr::rename(NTEE_IRS = NTEECC) |>
  tidylog::left_join(ntee1_df, by = "NTEE_IRS")

readr::write_csv(ntee_naics_xwalk, "data-raw/NTEE-NAICS-XWALK.csv")