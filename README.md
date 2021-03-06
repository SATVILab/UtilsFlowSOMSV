
<!-- README.md is generated from README.Rmd. Please edit that file -->

# UtilsFlowSOMSV

<!-- badges: start -->
<!-- badges: end -->

The goal of UtilsFlowSOMSV is to provide support functions for assessing
and working with FlowSOM output

## Installation

You can install the development version of UtilsFlowSOMSV from
[GitHub](https://github.com/) with:

``` r
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("SATVILab/UtilsFlowSOMSV")
```

## Calculate cluster stability

Calculate cluster stability for each cluster in a FlowSOM clustering.

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
