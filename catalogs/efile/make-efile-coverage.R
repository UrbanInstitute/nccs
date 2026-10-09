# Rebuild the efile coverage figure and table on the dataset page
# (_datasets/efile.md) from the row-count files of the current releases.
#
# Run from the catalogs/ directory after a new efile release:
#   Rscript efile/make-efile-coverage.R
# then paste the printed table into _datasets/efile.md.

source("R/efile_helpers.R")

rel <- efile_current("990")
rel_pf <- efile_current("990PF")
cov <- efile_coverage(efile_counts(rel), efile_counts(rel_pf))

ggplot2::ggsave(
  "../_datasets/img/efile_count.png",
  efile_coverage_plot(cov),
  width = 9, height = 4.5, dpi = 150, bg = "white"
)

cat(sprintf("**E-filed returns by tax year and return type (%s and %s, published %s)**\n\n",
            efile_label(rel), efile_label(rel_pf), rel$published))
print(efile_coverage_table(cov))
