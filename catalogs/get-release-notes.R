# =============================================================================
# Fetch data release notes from nccs-contracts/governance/release-notes/
# =============================================================================
# The governance directory is the ONLY authoring location for release notes
# (see nccs-contracts/governance/README.md); this script mirrors them into
# catalogs/release-notes-data/ so release-notes.qmd renders them. Re-run
# before each site render, alongside get-aws-files.R. No credentials needed
# (public repo, GitHub API).
#
# Usage: Rscript catalogs/get-release-notes.R
# =============================================================================

api <- "https://api.github.com/repos/UrbanInstitute/nccs-contracts/contents/governance/release-notes"
dir.create("catalogs/release-notes-data", showWarnings = FALSE)

listing <- jsonlite::fromJSON(api)
mds <- listing[grepl("\\.md$", listing$name), ]
message("Fetching ", nrow(mds), " release note(s)")
for (i in seq_len(nrow(mds))) {
  download.file(mds$download_url[i],
                file.path("catalogs/release-notes-data", mds$name[i]),
                quiet = TRUE)
}
message("Done: catalogs/release-notes-data/")
