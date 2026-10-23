# Freeze the table metadata (form, part, titles, cardinality, sort order) of
# each e-file release from the concordance990 ref it was labelled with.
#
#   Rscript catalogs/efile/make-efile-table-meta.R            # every release
#   Rscript catalogs/efile/make-efile-table-meta.R v3_1 pf_v3_1
#
# Writes catalogs/efile/TABLE-META-<id>.csv, read by efile_release_meta().
# Rerun for a release when its count file gains a table.
#
# The frozen v1 concordance (v2.0.0-baseline) carries no form, part or table
# titles; those were added in concordance990 2.0.0 (fix 18). Releases labelled
# with v1 therefore take table membership, cardinality and sort order from the
# baseline and fill blank titles from v2.0.0 by id.

setwd(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), ".."))
source("R/efile_helpers.R")

#' Fill blank or missing titles in `cc` from `donor`, matching on the id column.
fill_titles <- function(cc, donor) {
  fill <- function(a, b, id) {
    if (!"title" %in% names(a)) a$title <- NA_character_
    a$title <- as.character(a$title)
    blank <- is.na(a$title) | !nzchar(a$title)
    a$title[blank] <- b$title[match(a[[id]][blank], b[[id]])]
    a$title[is.na(a$title)] <- ""
    a
  }
  cc$forms <- fill(cc$forms, donor$forms, "form_id")
  cc$parts <- fill(cc$parts, donor$parts, "part_id")
  cc$tables <- fill(cc$tables, donor$tables, "table_id")
  cc
}

ids <- commandArgs(trailingOnly = TRUE)
if (length(ids) == 0) ids <- EFILE_RELEASES$id[!is.na(EFILE_RELEASES$count_file)]

for (id in ids) {
  rel <- efile_release(id)
  counts <- efile_nonempty(efile_counts(rel))
  cc <- efile_concordance(rel$concordance_ref)
  if (rel$concordance_ref == "v2.0.0-baseline") cc <- fill_titles(cc, efile_concordance("v2.0.0"))
  meta <- efile_table_meta(counts$table, cc, rel$form)
  meta$concordance_ref <- rel$concordance_ref
  out <- efile_table_meta_path(rel)
  utils::write.csv(meta, out, row.names = FALSE)
  message(id, ": ", nrow(meta), " tables, ", sum(!meta$in_concordance),
          " not in concordance990 ", rel$concordance_ref, " -> ", out)
}
