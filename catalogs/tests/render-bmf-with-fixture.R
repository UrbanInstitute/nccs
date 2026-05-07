# End-to-end render check.
# Copies catalog-bmf.qmd + R/ helpers into a tempdir, writes a synthetic
# AWS-BMF.csv there, runs `quarto render`, and asserts on the rendered HTML.
# Renders in a tempdir so the real catalogs/ directory is never touched.

suppressPackageStartupMessages(library(stringr))

resolve_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  hits <- args[grepl("^--file=", args)]
  if (length(hits)) return(dirname(normalizePath(sub("^--file=", "", hits[1]))))
  frame_file <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  if (!is.null(frame_file) && nzchar(frame_file)) return(dirname(normalizePath(frame_file)))
  getwd()
}

script_dir   <- resolve_script_dir()
catalogs_dir <- normalizePath(file.path(script_dir, ".."))

work <- tempfile("bmf-render-")
dir.create(work)
on.exit(unlink(work, recursive = TRUE), add = TRUE)

# Stage the qmd, the helpers it sources, and the shared Quarto config/styles
file.copy(file.path(catalogs_dir, "catalog-bmf.qmd"), work)
file.copy(file.path(catalogs_dir, "_quarto.yml"),     work)
dir.create(file.path(work, "R"))
file.copy(file.path(catalogs_dir, "R", "bmf_helpers.R"), file.path(work, "R"))
dir.create(file.path(work, "styles"))
file.copy(file.path(catalogs_dir, "styles", "catalog.css"), file.path(work, "styles"))

# Synthetic manifest
fixture <- data.frame(
  source = c("master","master","master","master",
             "processed","processed","processed",
             "legacy","legacy"),
  Prefix = c(rep("master/bmf/", 4),
             rep("processed/bmf/", 3),
             rep("processed/bmf-legacy/", 2)),
  Key = c(
    "master/bmf/BMF_MASTER_CA.csv",
    "master/bmf/BMF_MASTER_NY.csv",
    "master/bmf/BMF_MASTER_TX.csv",
    "master/bmf/BMF_MASTER.csv",
    "processed/bmf/2026_01/BMF.csv",
    "processed/bmf/2025_12/BMF.csv",
    "processed/bmf/2025_06/BMF.csv",
    "processed/bmf-legacy/2024_03/BMF.csv",
    "processed/bmf-legacy/2023_11/BMF.csv"
  ),
  Size = c(50e6, 60e6, 55e6, 1300e6, 200e6, 198e6, 195e6, 180e6, 175e6),
  stringsAsFactors = FALSE
)
fixture$URL <- paste0("https://nccsdata.s3.us-east-1.amazonaws.com/", fixture$Key)
write.csv(fixture, file.path(work, "AWS-BMF.csv"), row.names = FALSE)

cat("Rendering catalog-bmf.qmd in", work, "\n")
prev_wd <- getwd()
setwd(work)
on.exit(setwd(prev_wd), add = TRUE)
status <- system2(
  "quarto",
  args = c("render", "catalog-bmf.qmd"),
  stdout = TRUE, stderr = TRUE
)
attr_status <- attr(status, "status")
if (!is.null(attr_status) && attr_status != 0) {
  cat(paste(status, collapse = "\n"), "\n")
  stop("quarto render failed")
}

html_path <- file.path(work, "catalog-bmf.html")
stopifnot(file.exists(html_path))
html <- paste(readLines(html_path, warn = FALSE), collapse = "\n")

check <- function(condition, msg) {
  if (!isTRUE(condition)) stop("ASSERTION FAILED: ", msg)
  cat("  ok: ", msg, "\n", sep = "")
}

check(grepl("Master BMF by State/Territory", html, fixed = TRUE),
      "Master BMF section heading present")
check(grepl("Processed BMF (Monthly)", html, fixed = TRUE),
      "Processed BMF section heading present")
check(grepl("Legacy BMF (Monthly)", html, fixed = TRUE),
      "Legacy BMF section heading present")

check(grepl("BMF_MASTER_CA\\.csv", html), "California master URL rendered")
check(grepl("BMF_MASTER_NY\\.csv", html), "New York master URL rendered")
check(grepl("BMF_MASTER_TX\\.csv", html), "Texas master URL rendered")

check(grepl(">Wyoming<", html),
      "Wyoming row present even when no file exists (left-join filler)")

check(grepl("bmf_2026_01_quality_report\\.html", html),
      "2026-01 quality report URL present")
check(grepl("bmf_2025_12_quality_report\\.html", html),
      "2025-12 quality report URL present")
check(grepl("bmf_2024_03_quality_report\\.html", html),
      "2024-03 (legacy) quality report URL present")

pos_2026 <- regexpr("2026_01/BMF\\.csv", html)
pos_2025 <- regexpr("2025_12/BMF\\.csv", html)
check(pos_2026 > 0 && pos_2025 > 0 && pos_2026 < pos_2025,
      "Processed table sorted descending (2026-01 before 2025-12)")

check(!grepl("processed/bmf/README\\.txt", html),
      "Junk paths excluded from monthly tables")

# The unsuffixed master/bmf/BMF_MASTER.csv must not be linked anywhere on the
# rendered page (the qmd has no headline link to it). Quarto emits href="..."
# with double quotes, so match the URL boundary on either quote style.
positions <- gregexpr("/BMF_MASTER\\.csv[\"']", html)[[1]]
master_csv_count <- if (length(positions) == 1 && positions[1] == -1L) 0L else length(positions)
check(master_csv_count == 0,
      "Unsuffixed master file did not leak into the state-by-state table")

cat("\nAll render assertions passed.\n")
