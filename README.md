
<!-- README.md is generated from README.Rmd. Please edit that file -->

# UtilsFlowSOMSV

<!-- badges: start -->
[![R-CMD-check](https://github.com/SATVILab/UtilsFlowSOMSV/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/SATVILab/UtilsFlowSOMSV/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://codecov.io/gh/SATVILab/UtilsFlowSOMSV/graph/badge.svg)](https://codecov.io/gh/SATVILab/UtilsFlowSOMSV)
<!-- badges: end -->

UtilsFlowSOMSV provides utility functions for assessing and working with [FlowSOM](https://bioconductor.org/packages/release/bioc/html/FlowSOM.html) output. FlowSOM is a popular algorithm for clustering flow cytometry data using self-organizing maps.

The main functionality of this package is to calculate **cluster stability** for each cluster in a FlowSOM clustering, helping researchers assess the robustness and reliability of their clustering results.

## Functions

- `calc_cluster_stability()`: Calculate cluster stability for each cluster using bootstrap resampling and Jaccard similarity coefficients.

## Installation

You can install the development version of UtilsFlowSOMSV from
[GitHub](https://github.com/) with:

``` r
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("SATVILab/UtilsFlowSOMSV")
```

## Example: Calculate Cluster Stability

The `calc_cluster_stability()` function computes cluster stability for each cluster in a FlowSOM clustering using bootstrap resampling. The stability is measured using Jaccard similarity coefficients, which range from 0 (no overlap) to 1 (perfect overlap).

``` r
# load FlowSet
fs <- UtilsFlowSOMSV:::.get_flowset_test()

# apply FlowSOM
flowsom_orig <- FlowSOM::FlowSOM(
  input = fs,
  toTransform = NULL,
  transform = FALSE,
  scale = FALSE,
  colsToUse = c("Am Cyan-H", "Pacific Blue-A", "Pacific Blue-H"),
  nClus = 3
)

# get stability for each cluster
UtilsFlowSOMSV::calc_cluster_stability(
  fs = fs, flowsom_orig = flowsom_orig,
  scale = FALSE, seed = 2, boot = 2,
  chnl = c("Am Cyan-H", "Pacific Blue-A", "Pacific Blue-H"),
  n_cluster = 3
)
#> # A tibble: 3 x 3
#>   cluster stability_mean stability_sample
#>     <int>          <dbl> <list>          
#> 1       1          0.983 <dbl [2]>       
#> 2       2          0.982 <dbl [2]>       
#> 3       3          0.619 <dbl [2]>
```

The output is a tibble with:

- `cluster`: The cluster number
- `stability_mean`: The mean Jaccard similarity across bootstrap samples (higher values indicate more stable clusters)
- `stability_sample`: A list column containing individual stability values from each bootstrap iteration
