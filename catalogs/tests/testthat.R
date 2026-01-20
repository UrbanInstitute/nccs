# Test runner for catalog functions
# Run with: testthat::test_dir("tests")

library(testthat)
library(stringr)

# Source the functions being tested
source("../build-catalog-functions.R")

test_dir(".", reporter = "summary")
