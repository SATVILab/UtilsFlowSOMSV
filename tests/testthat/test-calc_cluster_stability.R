test_that("calc_cluster_stability works", {

  fs <- .get_flowset_test()

  flowsom_orig <- FlowSOM::FlowSOM(
    input = fs,
    toTransform = NULL,
    transform = FALSE,
    scale = FALSE,
    colsToUse = c("Am Cyan-H", "Pacific Blue-A", "Pacific Blue-H"),
    nClus = 3
  )

  out_tbl <- calc_cluster_stability(
    fs = fs, flowsom_orig = flowsom_orig,
    scale = FALSE, seed = 2, boot = 2,
    chnl = c("Am Cyan-H", "Pacific Blue-A", "Pacific Blue-H"),
    n_cluster = 3
  )

  expect_identical(
    ncol(out_tbl),
    3L
  )
  expect_identical(
    out_tbl$cluster,
    c(1L, 2L, 3L)
  )
  expect_identical(
    class(out_tbl$stability_mean),
    "numeric"
  )
  expect_identical(
    class(out_tbl$stability_sample),
    "list"
  )
  expect_identical(
    class(out_tbl$stability_sample[[1]]),
    "numeric"
  )
})
