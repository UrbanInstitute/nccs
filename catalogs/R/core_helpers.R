# =============================================================================
# Core catalog helpers
#
# Three S3 tiers are now published, all under s3://nccsdata:
#   processed_merged/core/{YYYY}/{FORM_TYPE}/    -- 1987-2024, merged panel
#   processed/core/{YYYY}/{FORM_TYPE}/           -- 2012-2024, SOI-current
#   processed_legacy/core/{YYYY}/{FORM_TYPE}/    -- 1987-2011, legacy NCCS
#
# Each partition contains both CSV and Parquet for the data file and the data
# dictionary, e.g.:
#     core_{YYYY}_{FORM_TYPE}.csv
#     core_{YYYY}_{FORM_TYPE}.parquet
#     core_{YYYY}_{FORM_TYPE}_dictionary.csv
#     core_{YYYY}_{FORM_TYPE}_dictionary.parquet
#
# Quality reports are HTML pages served from GitHub Pages, NOT from S3. Each
# tier has its own URL prefix (see CORE_QUALITY_REPORT_URL).
#
# Form types: "990", "990ez", "990combined", "990pf". The merged and legacy
# tiers publish only "990combined" and "990pf".
# =============================================================================

CORE_FORM_TYPES <- c("990", "990ez", "990combined", "990pf")

CORE_TIERS <- c(
  merged = "processed_merged/core",
  soi    = "processed/core",
  legacy = "processed_legacy/core"
)

# Forms published in each tier.
CORE_TIER_FORMS <- list(
  merged = c("990combined", "990pf"),
  soi    = c("990", "990ez", "990combined", "990pf"),
  legacy = c("990combined", "990pf")
)

# Per-tier slug inside the Pages-site quality-report URL. SOI-current has no
# tier slug (reports live at the root quality-reports/ path).
CORE_QUALITY_TIER_SLUG <- c(merged = "merged/", soi = "", legacy = "legacy/")

CORE_QUALITY_REPORT_URL <-
  "https://urbaninstitute.github.io/nccs-data-core/quality-reports/%s%s/%s/core_%s_%s_quality.html"

build_core_quality_url <- function(year, form_type, tier = "soi") {
  slug <- CORE_QUALITY_TIER_SLUG[[tier]]
  ifelse(
    is.na(year) | is.na(form_type),
    NA_character_,
    sprintf(CORE_QUALITY_REPORT_URL, slug, year, form_type, year, form_type)
  )
}

#' Filter a full nccsdata manifest down to one tier's rows.
filter_core_manifest <- function(manifest, tier = "soi") {
  prefix <- paste0("^", CORE_TIERS[[tier]], "/")
  manifest[grepl(prefix, manifest$Key), , drop = FALSE]
}

#' Parse `{tier_prefix}/{YYYY}/{FORM_TYPE}/...` keys into year + form_type.
extract_core_year_form <- function(keys, tier = "soi") {
  pattern <- paste0("^", CORE_TIERS[[tier]], "/(\\d{4})/([^/]+)/")
  m <- stringr::str_match(keys, pattern)
  data.frame(
    year      = m[, 2],
    form_type = m[, 3],
    stringsAsFactors = FALSE
  )
}

#' Classify a Core S3 key as one of: "data_csv", "data_parquet",
#' "dictionary_csv", "dictionary_parquet", "quality", "other".
classify_core_artifact <- function(keys) {
  base <- basename(keys)
  ifelse(grepl("_dictionary\\.csv$",     base, ignore.case = TRUE), "dictionary_csv",
  ifelse(grepl("_dictionary\\.parquet$", base, ignore.case = TRUE), "dictionary_parquet",
  ifelse(grepl("_quality\\.html$",       base, ignore.case = TRUE), "quality",
  ifelse(grepl("\\.parquet$",            base, ignore.case = TRUE), "data_parquet",
  ifelse(grepl("\\.csv$",                base, ignore.case = TRUE), "data_csv",
         "other")))))
}

# Known IRS-side coverage gaps where partitions exist but are mostly empty
# (late-filer spillover only). Cells are marked with a stripe + dagger in the
# rendered table so analysts don't treat them as normal coverage.
#   - SOI 990PF 2017-2019: IRS never published those year extracts.
#   - Legacy 990PF 1993:   CORE-1993-...-PF.csv missing from legacy bucket.
#   - Merged inherits the union.
CORE_GAP_YEARS <- list(
  soi    = list("990pf" = c("2017", "2018", "2019")),
  legacy = list("990pf" = c("1993")),
  merged = list("990pf" = c("1993", "2017", "2018", "2019"))
)

#' Build the per-form-type yearly download table for one tier.
#'
#' Each row collapses the four sibling artifacts (data CSV + parquet,
#' dictionary CSV + parquet) into one row, plus the per-partition quality
#' report URL.
#'
#' @param manifest data.frame from AWS-NCCSDATA.csv (must have Key, URL, Size).
#' @param form_type one of CORE_FORM_TYPES.
#' @param tier one of names(CORE_TIERS): "merged" (default), "soi", "legacy".
#' @param n_recent number of most-recent years to return; NA for all.
#' @param min_size_bytes drop years whose data CSV is below this size. The
#'   pipeline writes near-empty placeholder files for some early years; the
#'   default (300 KB) excludes those without hiding legitimate sparse years.
#'   The known IRS-side gap years (CORE_GAP_YEARS) are kept and visually
#'   flagged via the .core-gap-mark CSS hook.
build_core_year_section <- function(manifest, form_type, tier = "merged",
                                    n_recent = 5, min_size_bytes = 3e5,
                                    gap_years = CORE_GAP_YEARS) {
  rows <- filter_core_manifest(manifest, tier)
  yf <- extract_core_year_form(rows$Key, tier)
  rows$year      <- yf$year
  rows$form_type <- yf$form_type
  rows$artifact  <- classify_core_artifact(rows$Key)
  rows <- rows[!is.na(rows$year) & rows$form_type == form_type, , drop = FALSE]

  gaps <- gap_years[[tier]][[form_type]]
  if (is.null(gaps)) gaps <- character(0)

  # Drop years whose data CSV is below the size cutoff -- except known gap
  # years, which we keep and flag.
  small_years <- unique(rows$year[rows$artifact == "data_csv" &
                                    !is.na(rows$Size) &
                                    rows$Size < min_size_bytes])
  small_years <- setdiff(small_years, gaps)
  rows <- rows[!(rows$year %in% small_years), , drop = FALSE]

  empty <- data.frame(
    year = character(0), data = character(0), dictionary = character(0),
    quality_report = character(0), size = character(0),
    stringsAsFactors = FALSE
  )
  if (nrow(rows) == 0) return(empty)

  years <- sort(unique(rows$year), decreasing = TRUE)

  pick <- function(y, type) {
    sel <- rows[rows$year == y & rows$artifact == type, , drop = FALSE]
    if (nrow(sel) == 0) return(NULL)
    sel[1, , drop = FALSE]
  }

  link_pair <- function(csv_row, parquet_row, csv_label, parquet_label) {
    parts <- character(0)
    if (!is.null(csv_row)) {
      parts <- c(parts, sprintf("<a href='%s'>%s</a>", csv_row$URL, csv_label))
    }
    if (!is.null(parquet_row)) {
      parts <- c(parts, sprintf("<a href='%s'>%s</a>", parquet_row$URL, parquet_label))
    }
    if (length(parts) == 0) return("&mdash;")
    paste(parts, collapse = " &middot; ")
  }

  out_rows <- lapply(years, function(y) {
    csv_row     <- pick(y, "data_csv")
    parquet_row <- pick(y, "data_parquet")
    dict_csv    <- pick(y, "dictionary_csv")
    dict_par    <- pick(y, "dictionary_parquet")
    if (is.null(csv_row) && is.null(parquet_row)) return(NULL)

    is_gap <- y %in% gaps
    year_cell <- if (is_gap) {
      sprintf("<span class='core-gap-mark'>%s</span>", y)
    } else {
      y
    }
    size_row <- if (!is.null(csv_row)) csv_row else parquet_row
    size <- paste0(round(size_row$Size / 1e6, 1), " mb")

    data.frame(
      year           = year_cell,
      data           = link_pair(csv_row, parquet_row, "CSV", "Parquet"),
      dictionary     = link_pair(dict_csv, dict_par, "CSV", "Parquet"),
      quality_report = sprintf(
        "<a href='%s'>Quality report</a>",
        build_core_quality_url(y, form_type, tier)
      ),
      size           = size,
      stringsAsFactors = FALSE
    )
  })
  out_rows <- out_rows[!vapply(out_rows, is.null, logical(1))]
  if (length(out_rows) == 0) return(empty)
  out <- do.call(rbind, out_rows)
  if (!is.na(n_recent)) out <- head(out, n_recent)
  rownames(out) <- NULL
  out
}

#' Render a per-year table built by build_core_year_section().
render_year_table <- function(df) {
  knitr::kable(
    df,
    escape    = FALSE,
    col.names = c("Year", "Data", "Dictionary", "Quality Report", "Size"),
    format    = "html",
    row.names = FALSE,
    align     = c("l", "l", "l", "l", "r")
  ) |>
    kableExtra::kable_styling()
}

# -----------------------------------------------------------------------------
# Deprecated harmonized/core/ layout
#
# Path shape:
#   harmonized/core/{PRODUCT}/marts/CORE-{YYYY}-{...}-HRMN[-V0].csv
# PRODUCT in: 501c3-pc, 501c3-pz, 501ce-pc, 501ce-pz, 501c3-pf
#
# Superseded by the processed_legacy/ tier; kept for reproducibility of
# analyses built against the older five-product layout.
# -----------------------------------------------------------------------------

#' Build a year-by-year download table for a single deprecated legacy product.
build_legacy_core_section <- function(manifest, product) {
  prefix <- paste0("^harmonized/core/", product, "/marts/")
  rows <- manifest[grepl(prefix, manifest$Key) &
                     grepl("\\.csv$", manifest$Key, ignore.case = TRUE), ,
                   drop = FALSE]
  if (nrow(rows) == 0) {
    return(data.frame(
      year = character(0), download = character(0), size = character(0),
      stringsAsFactors = FALSE
    ))
  }
  rows$year <- stringr::str_match(basename(rows$Key), "CORE-(\\d{4})-")[, 2]
  rows <- rows[!is.na(rows$year), , drop = FALSE]
  rows <- rows[order(rows$year, decreasing = TRUE), , drop = FALSE]
  data.frame(
    year     = rows$year,
    download = paste0("<a href='", rows$URL, "'>Download</a>"),
    size     = paste0(round(rows$Size / 1e6, 1), " mb"),
    stringsAsFactors = FALSE
  )
}

# -----------------------------------------------------------------------------
# Blank IRS forms archive (raw/core/forms/)
#
# Filenames: f<base>_<YYYY>.pdf for blank forms, i<base>_<YYYY>.pdf for
# instructions. Schedule B uses basename "990ezb" (IRS naming quirk).
# -----------------------------------------------------------------------------

CORE_MAIN_FORMS <- c(
  "990"   = "Form 990",
  "990ez" = "Form 990-EZ",
  "990pf" = "Form 990-PF"
)

CORE_SCHEDULES <- c(
  "990sa"  = "A", "990ezb" = "B", "990sc"  = "C", "990sd"  = "D",
  "990se"  = "E", "990sf"  = "F", "990sg"  = "G", "990sh"  = "H",
  "990si"  = "I", "990sj"  = "J", "990sk"  = "K", "990sl"  = "L",
  "990sm"  = "M", "990sn"  = "N", "990so"  = "O", "990sr"  = "R"
)

#' Build a year-by-form matrix of PDF links for the blank forms archive.
build_forms_matrix <- function(manifest, form_codes, compact = FALSE) {
  label_f <- if (compact) "F" else "Form"
  label_i <- if (compact) "I" else "Instr."
  rows <- manifest[grepl("^raw/core/forms/", manifest$Key) &
                     grepl("\\.pdf$", manifest$Key, ignore.case = TRUE), ,
                   drop = FALSE]
  if (nrow(rows) == 0) return(NULL)
  m <- stringr::str_match(basename(rows$Key), "^([fi])(.+)_(\\d{4})\\.pdf$")
  rows$kind <- m[, 2]
  rows$base <- m[, 3]
  rows$year <- m[, 4]
  rows <- rows[!is.na(rows$year) & rows$base %in% names(form_codes), ,
               drop = FALSE]
  if (nrow(rows) == 0) return(NULL)

  years <- sort(unique(rows$year), decreasing = TRUE)

  cell <- function(year, base) {
    sel_f <- rows[rows$year == year & rows$base == base & rows$kind == "f", ,
                  drop = FALSE]
    sel_i <- rows[rows$year == year & rows$base == base & rows$kind == "i", ,
                  drop = FALSE]
    parts <- character(0)
    if (nrow(sel_f) > 0) {
      parts <- c(parts, paste0("<a href='", sel_f$URL[1], "' title='Form'>", label_f, "</a>"))
    }
    if (nrow(sel_i) > 0) {
      parts <- c(parts, paste0("<a href='", sel_i$URL[1], "' title='Instructions'>", label_i, "</a>"))
    }
    if (length(parts) == 0) return("")
    paste(parts, collapse = if (compact) "&nbsp;" else "<br>")
  }

  mat <- vapply(
    names(form_codes),
    function(b) vapply(years, function(y) cell(y, b), character(1)),
    character(length(years))
  )
  if (is.null(dim(mat))) mat <- matrix(mat, ncol = length(form_codes))
  out <- data.frame(Year = years, mat, stringsAsFactors = FALSE,
                    check.names = FALSE)
  colnames(out) <- c("Year", unname(form_codes))
  out
}
