# =============================================================================
# NCCS Efile Catalog Helpers
# Shared by catalog-efile-*.qmd (Form 990 / 990-EZ) and catalog-efilepf-*.qmd
# (Form 990-PF). Table and part metadata come from the concordance990 package;
# the table-year manifest and row counts come from the COUNT-OF-ROWS file that
# ships with each release on S3.
# =============================================================================

EFILE_S3 <- "https://nccs-efile.s3.us-east-1.amazonaws.com/"
NODC_SITE <- "https://nonprofit-open-data-collective.github.io/"
CC_SITE <- paste0(NODC_SITE, "concordance990/")
CC_RAW <- "https://raw.githubusercontent.com/Nonprofit-Open-Data-Collective/concordance990/main/inst/extdata/src/"

# -----------------------------------------------------------------------------
# Releases
# -----------------------------------------------------------------------------

#' Every efile release NCCS has published, oldest first.
#'
#' `count_file` is an S3 key, or a path relative to catalogs/ when the release
#' shipped without one (efilepf_v2_3: counts read from the parquet footers).
EFILE_RELEASES <- data.frame(
  id = c("v1", "v2_0", "v2_1", "v2_2", "v2_3", "v3_1", "pf_v2_3", "pf_v3_1"),
  version = c("v1", "v2_0", "v2_1", "v2_2", "v2_3", "v3_1", "v2_3", "v3_1"),
  form = c(rep("990", 6), "990PF", "990PF"),
  prefix = c(
    "parsed/", "public/efile_v2_0/", "public/efile_v2_1/", "public/efile_v2_2/",
    "public/efile_v2_3/", "public/efile_v3_1/", "public/efilepf_v2_3/",
    "public/efilepf_v3_1/"
  ),
  published = c(
    "2023-03-21", "2025-03-22", "2025-10-28", "2026-08-11",
    "2026-10-07", "2026-10-09", "2026-10-07", "2026-10-09"
  ),
  status = c(
    "Archived", "Archived", "Archived", "Interim", "Interim", "Current",
    "Interim", "Current"
  ),
  page = c(
    "catalog-efile.html", "catalog-efile-v2.html", "catalog-efile-v2_1.html",
    "catalog-efile-v2_2.html", "catalog-efile-v2_3.html",
    "catalog-efile-v3_1.html", "catalog-efilepf-v2_3.html",
    "catalog-efilepf-v3_1.html"
  ),
  count_file = c(
    NA,
    "public/efile_v2_0/COUNT-OF-ROWS-BY-TABLE-AND-FORMTYPE.CSV",
    "public/efile_v2_1/COUNT-OF-ROWS-BY-TABLE-AND-FORMTYPE-EFILE_V2_1.CSV",
    "public/efile_v2_2/COUNT-OF-ROWS-BY-TABLE-AND-FORMTYPE-EFILE_V2_2.CSV",
    "public/efile_v2_3/COUNT-OF-ROWS-BY-TABLE-AND-FORMTYPE-EFILE_V2_3.CSV",
    "public/efile_v3_1/COUNT-OF-ROWS-BY-TABLE-AND-FORMTYPE-EFILE_V3_1.CSV",
    "efile/ROW-COUNTS-EFILEPF_V2_3.csv",
    "public/efilepf_v3_1/COUNT-OF-ROWS-BY-TABLE-AND-FORMTYPE-EFILEPF_V3_1.CSV"
  ),
  notes = c(
    NA, NA, NA, NA, NA,
    "public/efile_v3_1/RELEASE-NOTES-EFILE_V3_1.md",
    NA,
    "public/efilepf_v3_1/RELEASE-NOTES-EFILEPF_V3_1.md"
  ),
  stringsAsFactors = FALSE
)

#' Look up one release by id ("v3_1", "pf_v3_1", ...).
efile_release <- function(id) {
  r <- EFILE_RELEASES[EFILE_RELEASES$id == id, ]
  if (nrow(r) != 1) stop("Unknown efile release: ", id)
  as.list(r)
}

#' The current release for a form family.
efile_current <- function(form = "990") {
  r <- EFILE_RELEASES[EFILE_RELEASES$form == form & EFILE_RELEASES$status == "Current", ]
  as.list(r[nrow(r), ])
}

efile_label <- function(rel) {
  db <- if (rel$form == "990PF") "efilepf" else "efile"
  paste0(db, "_", rel$version)
}

# -----------------------------------------------------------------------------
# Manifest and row counts
# -----------------------------------------------------------------------------

#' Read a release's row-count file as a manifest: one row per published
#' table-year file, with columns year, table, rows_tot and the per-form counts.
efile_counts <- function(rel) {
  f <- rel$count_file
  if (is.na(f)) return(NULL)
  src <- if (file.exists(f)) f else paste0(EFILE_S3, f)
  d <- data.table::fread(src, showProgress = FALSE)
  d <- as.data.frame(d)
  if ("NumRowsTot" %in% names(d)) {
    # efile_v2_0 layout: Year, Table (with -YYYY), FormType, NumRows, NumRowsTot
    d <- data.frame(
      year = d$Year,
      table = sub("-[0-9]{4}$", "", d$Table),
      rows_tot = d$NumRowsTot
    )
    d <- unique(d)
  }
  d$year <- as.integer(d$year)
  d[order(d$table, -d$year), ]
}

#' Table-years with data. Zero-row table-years are published as empty files
#' (header only) and are left out of the catalog listings.
efile_nonempty <- function(counts) {
  counts[counts$rows_tot > 0, ]
}

#' Filings per tax year, by return type, from a release's header table.
efile_filings <- function(counts) {
  h <- counts[counts$table == "F9-P00-T00-HEADER", ]
  keep <- intersect(c("year", "rows_990", "rows_990ez", "rows_990pf", "rows_tot"), names(h))
  h <- h[order(h$year), keep]
  h
}

# -----------------------------------------------------------------------------
# Concordance metadata (forms, parts, tables)
# -----------------------------------------------------------------------------

#' Read the concordance990 component tables, from the installed package when
#' available and from GitHub otherwise.
efile_concordance <- function() {
  src <- system.file("extdata", "src", package = "concordance990")
  rd <- function(f) {
    p <- file.path(src, f)
    if (nzchar(src) && file.exists(p)) utils::read.csv(p, stringsAsFactors = FALSE)
    else utils::read.csv(paste0(CC_RAW, f), stringsAsFactors = FALSE)
  }
  ver <- tryCatch(as.character(utils::packageVersion("concordance990")),
                  error = function(e) "main")
  list(
    forms = rd("forms.csv"),
    parts = rd("parts.csv"),
    tables = rd("tables.csv"),
    version = ver
  )
}

# Two-letter table prefix -> concordance form_id, for tables the current
# concordance no longer lists (renamed tables in older releases).
EFILE_PREFIX_FORM <- c(
  F9 = "F990", PF = "F990PF",
  setNames(paste0("SCHED-", LETTERS), paste0("S", LETTERS))
)

#' One row per table: form, part, cardinality and sort keys.
efile_table_meta <- function(tables, cc, form = "990") {
  tables <- unique(tables)
  m <- data.frame(table = tables, part_id = substr(tables, 1, 6),
                  stringsAsFactors = FALSE)

  tt <- cc$tables[, c("table_id", "cardinality", "title", "sort_order")]
  names(tt) <- c("table", "cardinality", "table_title", "table_sort")
  m <- merge(m, tt, by = "table", all.x = TRUE)

  pp <- cc$parts[, c("part_id", "form_id", "title", "sort_order")]
  names(pp) <- c("part_id", "form_id", "part_title", "part_sort")
  m <- merge(m, pp, by = "part_id", all.x = TRUE)

  ff <- cc$forms[, c("form_id", "title", "sort_order")]
  names(ff) <- c("form_id", "form_title", "form_sort")

  miss <- is.na(m$form_id)
  m$form_id[miss] <- unname(EFILE_PREFIX_FORM[substr(m$table[miss], 1, 2)])
  m$part_title[is.na(m$part_title)] <- "Other tables"
  m <- merge(m, ff, by = "form_id", all.x = TRUE)

  m$in_concordance <- !is.na(m$cardinality)
  m$cardinality[!m$in_concordance] <-
    ifelse(grepl("-T00-", m$table[!m$in_concordance]), "ONE", "MANY")
  m$table_sort[is.na(m$table_sort)] <- 9999
  m$table_title[is.na(m$table_title)] <- ""

  # The 990-PF database carries the shared Form 990 header and signature
  # tables; list them first under their own heading.
  if (form == "990PF") {
    shared <- m$form_id == "F990"
    m$form_title[shared] <- "Shared tables (every e-filed return)"
    m$form_sort[shared] <- 0
  }

  m[order(m$form_sort, m$part_id, m$table_sort, m$table), ]
}

# -----------------------------------------------------------------------------
# URLs and small HTML pieces
# -----------------------------------------------------------------------------

efile_dictionary <- function(form = "990", type = c("html", "pdf")) {
  type <- match.arg(type)
  slug <- if (form == "990PF") "data-dictionary-990pf" else "data-dictionary-990"
  if (type == "html") paste0(CC_SITE, "articles/", slug, ".html")
  else paste0(CC_SITE, "print/", slug, ".pdf")
}

efile_table_dictionary_url <- function(table, form = "990", in_concordance = TRUE) {
  base <- efile_dictionary(form, "html")
  ifelse(in_concordance, paste0(base, "#", tolower(table)), base)
}

efile_file_url <- function(rel, table, year, ext = c("CSV", "parquet")) {
  ext <- match.arg(ext)
  paste0(EFILE_S3, rel$prefix, table, "-", year, ".", ext)
}

html_escape <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  gsub(">", "&gt;", x, fixed = TRUE)
}

fmt_n <- function(x) format(x, big.mark = ",", scientific = FALSE, trim = TRUE)

cardinality_badge <- function(cardinality) {
  if (cardinality == "ONE") {
    "<span class='ef-badge ef-badge--one' title='One row per filing'>1:1</span>"
  } else {
    "<span class='ef-badge ef-badge--many' title='Many rows per filing'>1:M</span>"
  }
}

#' The R packages that build and use the efile tables (sidebar and About
#' section).
EFILE_PACKAGES <- data.frame(
  pkg = c("ef2", "concordance990", "panel990", "fiscal", "governance",
          "peopleparser", "titleclassifier"),
  desc = c(
    "Parses IRS 990 e-file XML into the relational tables published here.",
    "The Master Concordance: maps XML xpaths to variables and tables; holds the data dictionaries.",
    "Downloads efile tables and builds longitudinal panels, with BMF fields attached.",
    "Fiscal health accounting metrics from 990 data.",
    "Governance scores for nonprofits from Part VI.",
    "Splits officer and director names into parts and infers gender.",
    "Classifies officer titles into standard roles."
  ),
  stringsAsFactors = FALSE
)

efile_package_list <- function() {
  items <- sprintf(
    "<li><a class='chip chip--pkg' href='%s%s/' target='_blank'>%s</a> <span>%s</span></li>",
    NODC_SITE, EFILE_PACKAGES$pkg, EFILE_PACKAGES$pkg, EFILE_PACKAGES$desc
  )
  paste0("<ul class='ef-pkgs'>\n", paste(items, collapse = "\n"), "\n</ul>\n")
}

efile_dictionary_buttons <- function(forms = c("990", "990PF")) {
  lab <- c("990" = "Form 990 / 990-EZ", "990PF" = "Form 990-PF")
  rows <- vapply(forms, function(f) {
    sprintf(
      "<div class='ef-dict'><span class='ef-dict-label'>%s</span><a class='chip chip--html' href='%s' target='_blank'>Data dictionary (HTML)</a><a class='chip chip--pdf' href='%s' target='_blank'>Data dictionary (PDF)</a></div>",
      lab[[f]], efile_dictionary(f, "html"), efile_dictionary(f, "pdf")
    )
  }, character(1))
  paste(rows, collapse = "\n")
}

efile_banner <- function(rel) {
  cur <- efile_current(rel$form)
  db <- if (rel$form == "990PF") "990-PF" else "990 / 990-EZ"
  kind <- if (rel$status == "Interim") {
    "an interim build that was not a full public release. It is kept so that analyses run on it can be reproduced."
  } else {
    "a previous public release, kept so that analyses run on it can be reproduced."
  }
  sprintf(
    "<div class='ef-banner'><strong>Superseded.</strong> This page lists <code>%s</code>, %s The current %s release is <a href='%s'><code>%s</code></a>.</div>",
    efile_label(rel), kind, db, cur$page, efile_label(cur)
  )
}

# -----------------------------------------------------------------------------
# Code snippets
# -----------------------------------------------------------------------------

#' The tax years used in a table's snippet: up to five years ending at the
#' latest year with rows, skipping the release's newest (partial) tax year when
#' an earlier one exists.
efile_snippet_years <- function(years, partial_year) {
  years <- sort(unique(years))
  full <- years[years < partial_year]
  last <- if (length(full)) max(full) else max(years)
  span <- years[years <= last]
  first <- span[max(1, length(span) - 4)]
  list(first = first, last = last)
}

#' panelize() call for one table. One-to-many tables need include_many = TRUE;
#' 990-PF tables are read through a 990PF source.
efile_snippet <- function(table, cardinality, form, yrs) {
  years <- if (yrs$first == yrs$last) yrs$last else paste0(yrs$first, ":", yrs$last)
  args <- c(
    sprintf("tables = \"%s\"", table),
    sprintf("years = %s", years),
    if (form == "990PF") "source = data_source( form = \"990PF\" )",
    if (cardinality != "ONE") "include_many = TRUE",
    "bmf = TRUE"
  )
  paste0(
    "library( panel990 )\n\n",
    sprintf("# Panel of tax years %s\n", sub(":", "-", years)),
    "# with BMF fields appended\n\n",
    "panel <- \n",
    "  panelize( ", paste(args, collapse = ",\n            "), " )\n\n",
    "df <- panel_data( panel )\n"
  )
}

#' Note on anchoring code to a release, shown above the table listings.
efile_pin_note <- function(rel) {
  src <- if (rel$form == "990PF") {
    sprintf("data_source( version = \"%s\", form = \"990PF\" )", rel$version)
  } else {
    sprintf("data_source( version = \"%s\" )", rel$version)
  }
  paste0(
    "::: {.ef-pin}\n",
    "**Anchor your code to a release.** `panelize()` reads the current release ",
    "(`efile_version()`) unless told otherwise, so the same code returns ",
    "different data after the next release. For reproducible results, name the ",
    "release explicitly:\n\n",
    "```r\n",
    "panel <- \n",
    sprintf("  panelize( tables = \"%s\",\n",
            if (rel$form == "990PF") "PF-P01-T00-REVENUE-EXPENSE" else "F9-P01-T00-SUMMARY"),
    "            years = 2020:2024,\n",
    "            source = ", src, ",\n",
    "            bmf = TRUE )\n",
    "```\n\n",
    "BMF fields come from the current NCCS master BMF. To fix those as well, ",
    "save the BMF once and pass the data frame or file path to `bmf =`.\n",
    ":::\n"
  )
}

# -----------------------------------------------------------------------------
# Table sections and table of contents
# -----------------------------------------------------------------------------

efile_table_section <- function(tbl, meta_row, rel, partial_year, snippet = TRUE) {
  tbl <- tbl[order(-tbl$year), ]
  name <- meta_row$table
  dd <- efile_table_dictionary_url(name, rel$form, meta_row$in_concordance)

  rows <- sprintf(
    "<tr><td>%s</td><td><code>%s-%s</code></td><td><a class='chip chip--csv' href='%s'>CSV</a></td><td><a class='chip chip--pq' href='%s'>Parquet</a></td><td class='num'>%s</td></tr>",
    tbl$year, name, tbl$year,
    efile_file_url(rel, name, tbl$year, "CSV"),
    efile_file_url(rel, name, tbl$year, "parquet"),
    fmt_n(tbl$rows_tot)
  )

  yr <- range(tbl$year)
  attrs <- paste0(
    "<p class='ef-attrs'>", cardinality_badge(meta_row$cardinality),
    if (meta_row$cardinality == "ONE") " one row per filing" else " many rows per filing",
    " <span class='sep'>&middot;</span> tax years ", yr[1], "&ndash;", yr[2],
    " <span class='sep'>&middot;</span> ", fmt_n(sum(tbl$rows_tot)), " rows",
    " <span class='sep'>&middot;</span> <a class='chip chip--html' href='", dd,
    "' target='_blank'>Data dictionary</a></p>"
  )
  title <- if (nzchar(meta_row$table_title)) {
    paste0("<p class='ef-table-title'>", html_escape(meta_row$table_title), "</p>")
  } else ""

  code <- ""
  if (snippet) {
    yrs <- efile_snippet_years(tbl$year[tbl$rows_tot > 0], partial_year)
    code <- paste0(
      "<details class='ef-code'><summary>Download with panel990</summary>",
      "<pre><code>",
      html_escape(efile_snippet(name, meta_row$cardinality, rel$form, yrs)),
      "</code></pre></details>"
    )
  }

  paste0(
    "<section class='ef-table' id='", tolower(name), "'>\n",
    "<h4>", name, "</h4>\n", attrs, "\n", title, "\n",
    "<div class='ef-files-wrap'><table class='ef-files'><thead><tr><th>Year</th><th>Table</th><th>CSV</th><th>Parquet</th><th class='num'>Rows</th></tr></thead><tbody>\n",
    paste(rows, collapse = "\n"),
    "\n</tbody></table></div>\n", code,
    "\n<a class='ef-top' href='#contents'>Back to contents</a>\n</section>\n"
  )
}

#' All table sections, grouped by form and part.
efile_table_sections <- function(counts, meta, rel, snippet = TRUE) {
  partial_year <- max(counts$year)
  out <- character(0)
  for (f in unique(meta$form_id)) {
    mf <- meta[meta$form_id == f, ]
    out <- c(out, sprintf("<h2 class='ef-form' id='form-%s'>%s</h2>\n",
                          tolower(f), html_escape(mf$form_title[1])))
    for (p in unique(mf$part_id)) {
      mp <- mf[mf$part_id == p, ]
      out <- c(out, sprintf(
        "<h3 class='ef-part' id='%s'><span class='n'>%s</span> %s</h3>\n",
        tolower(p), substr(p, 4, 6), html_escape(mp$part_title[1])
      ))
      for (i in seq_len(nrow(mp))) {
        tbl <- counts[counts$table == mp$table[i], ]
        out <- c(out, efile_table_section(tbl, mp[i, ], rel, partial_year,
                                          snippet))
      }
    }
  }
  paste(out, collapse = "\n")
}

#' Table of contents in the econometrics-archive style: a heading per form,
#' a row per part (left), and that part's tables (right).
#'
#' @param guide Named character vector of anchor -> label for the page's
#'   introductory sections, listed first.
efile_toc <- function(meta, guide = NULL) {
  out <- c("<nav class='contents' id='contents'>", "<h2>Contents</h2>")

  if (length(guide)) {
    items <- sprintf("<li><a class='it' href='#%s'>%s</a></li>", names(guide), guide)
    out <- c(out,
      "<ul class='toc'><li>",
      sprintf("<a class='toc-unit' href='#%s'><span class='n'>&sect;</span><span class='t'>About this release</span></a>", names(guide)[1]),
      "<ul class='toc-items toc-items--guide'>", items, "</ul>",
      "</li></ul>"
    )
  }

  for (f in unique(meta$form_id)) {
    mf <- meta[meta$form_id == f, ]
    out <- c(out,
      sprintf("<h3 class='toc-part'><a href='#form-%s'>%s</a></h3>",
              tolower(f), html_escape(mf$form_title[1])),
      "<ul class='toc'>")
    for (p in unique(mf$part_id)) {
      mp <- mf[mf$part_id == p, ]
      items <- sprintf(
        "<li><a class='it' href='#%s'>%s</a><span class='chips'>%s</span></li>",
        tolower(mp$table), mp$table,
        ifelse(mp$cardinality == "ONE",
               "<span class='chip chip--one'>1:1</span>",
               "<span class='chip chip--many'>1:M</span>")
      )
      out <- c(out,
        "<li>",
        sprintf("<a class='toc-unit' href='#%s'><span class='n'>%s</span><span class='t'>%s</span></a>",
                tolower(p), substr(p, 4, 6), html_escape(mp$part_title[1])),
        "<ul class='toc-items'>", items, "</ul>",
        "</li>")
    }
    out <- c(out, "</ul>")
  }
  paste(c(out, "</nav>"), collapse = "\n")
}

# -----------------------------------------------------------------------------
# Coverage, release notes and version history
# -----------------------------------------------------------------------------

#' Filings by tax year and return type across the current 990 and 990-PF
#' releases.
efile_coverage <- function(counts990, countspf) {
  a <- efile_filings(counts990)
  b <- efile_filings(countspf)
  d <- merge(a[, c("year", "rows_990", "rows_990ez")],
             data.frame(year = b$year, rows_990pf = b$rows_tot),
             by = "year", all = TRUE)
  d[is.na(d)] <- 0
  d$total <- d$rows_990 + d$rows_990ez + d$rows_990pf
  d[order(d$year), ]
}

efile_coverage_table <- function(cov) {
  out <- data.frame(
    `Tax year` = cov$year,
    `990` = fmt_n(cov$rows_990),
    `990-EZ` = fmt_n(cov$rows_990ez),
    `990-PF` = fmt_n(cov$rows_990pf),
    Total = fmt_n(cov$total),
    check.names = FALSE
  )
  knitr::kable(out, align = "lrrrr")
}

EFILE_FORM_COLORS <- c("990" = "#1696d2", "990-EZ" = "#eb6834", "990-PF" = "#1baf7a")

efile_coverage_plot <- function(cov) {
  long <- rbind(
    data.frame(year = cov$year, form = "990", n = cov$rows_990),
    data.frame(year = cov$year, form = "990-EZ", n = cov$rows_990ez),
    data.frame(year = cov$year, form = "990-PF", n = cov$rows_990pf)
  )
  long$form <- factor(long$form, levels = rev(names(EFILE_FORM_COLORS)))
  ggplot2::ggplot(long, ggplot2::aes(x = year, y = n, fill = form)) +
    ggplot2::geom_col(width = 0.72, color = "white", linewidth = 0.5) +
    ggplot2::scale_fill_manual(values = EFILE_FORM_COLORS,
                               breaks = names(EFILE_FORM_COLORS), name = NULL) +
    ggplot2::scale_y_continuous(labels = function(x) ifelse(x == 0, "0", paste0(x / 1000, "k")),
                                expand = ggplot2::expansion(mult = c(0, 0.04))) +
    ggplot2::scale_x_continuous(breaks = cov$year) +
    ggplot2::labs(x = "Tax year", y = "E-filed returns") +
    ggplot2::theme_minimal(base_size = 13) +
    ggplot2::theme(
      legend.position = "top",
      legend.justification = "left",
      panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_line(color = "#e4e6ea", linewidth = 0.4),
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, color = "#4d565f"),
      axis.text.y = ggplot2::element_text(color = "#4d565f"),
      axis.title = ggplot2::element_text(color = "#4d565f"),
      plot.background = ggplot2::element_rect(fill = "white", color = NA)
    )
}

#' Release notes from S3, with the H1 dropped and headings demoted so they sit
#' under the page's own section heading.
efile_release_notes <- function(rel) {
  if (is.na(rel$notes)) return("_No release notes were published with this release._\n")
  md <- tryCatch(readLines(paste0(EFILE_S3, rel$notes), warn = FALSE, encoding = "UTF-8"),
                 error = function(e) NULL)
  if (is.null(md)) return("_Release notes could not be retrieved._\n")
  md <- md[!grepl("^# ", md)]
  md <- sub("^(#{2,4}) ", "\\1## ", md)
  paste0(
    "::: {.ef-notes}\n",
    paste(md, collapse = "\n"),
    sprintf("\n\n[Release notes on S3](%s%s)\n:::\n", EFILE_S3, rel$notes)
  )
}

#' One row per release: dates, coverage and links.
efile_version_history <- function(current_id = NULL) {
  rows <- lapply(seq_len(nrow(EFILE_RELEASES)), function(i) {
    rel <- as.list(EFILE_RELEASES[i, ])
    cn <- tryCatch(efile_counts(rel), error = function(e) NULL)
    if (is.null(cn)) {
      yrs <- "&mdash;"; ntab <- "&mdash;"; nfil <- "&mdash;"
    } else {
      yrs <- paste0(min(cn$year), "&ndash;", max(cn$year))
      ntab <- length(unique(cn$table))
      nfil <- fmt_n(sum(cn$rows_tot[cn$table == "F9-P00-T00-HEADER"]))
    }
    here <- identical(rel$id, current_id)
    data.frame(
      Release = sprintf("<a href='%s'><code>%s</code></a>%s", rel$page, efile_label(rel),
                        if (here) " <span class='ef-here'>this page</span>" else ""),
      Returns = if (rel$form == "990PF") "990-PF" else "990, 990-EZ",
      Published = rel$published,
      Status = sprintf("<span class='ef-status ef-status--%s'>%s</span>",
                       tolower(rel$status), rel$status),
      `Tax years` = yrs,
      Tables = ntab,
      Filings = nfil,
      Notes = if (is.na(rel$notes)) "&mdash;"
              else sprintf("<a href='%s%s'>Release notes</a>", EFILE_S3, rel$notes),
      check.names = FALSE, stringsAsFactors = FALSE
    )
  })
  d <- do.call(rbind, rows)
  d <- d[order(d$Published, decreasing = TRUE), ]
  knitr::kable(d, format = "html", escape = FALSE, row.names = FALSE,
               table.attr = "class='ef-history'", align = "llllrrrl")
}
