test_that("calc_cluster_stability works", {
  skip_if_not_installed("flowWorkspaceData")
  skip_if_not_installed("UtilsCytoRSV")

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

test_that("calc_cluster_stability works with NULL seed", {
  skip_if_not_installed("flowWorkspaceData")
  skip_if_not_installed("UtilsCytoRSV")

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
    scale = FALSE, seed = NULL, boot = 2,
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
})

test_that("calc_cluster_stability returns valid stability values", {
  skip_if_not_installed("flowWorkspaceData")
  skip_if_not_installed("UtilsCytoRSV")

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
    scale = FALSE, seed = 42, boot = 3,
    chnl = c("Am Cyan-H", "Pacific Blue-A", "Pacific Blue-H"),
    n_cluster = 3
  )

  # Jaccard coefficients should be between 0 and 1
  expect_true(all(out_tbl$stability_mean >= 0))
  expect_true(all(out_tbl$stability_mean <= 1))

  # Each stability_sample should have boot number of samples
  expect_equal(length(out_tbl$stability_sample[[1]]), 3)
  expect_equal(length(out_tbl$stability_sample[[2]]), 3)
  expect_equal(length(out_tbl$stability_sample[[3]]), 3)
})

test_that("calc_cluster_stability works with scale = TRUE", {
  skip_if_not_installed("flowWorkspaceData")
  skip_if_not_installed("UtilsCytoRSV")

  fs <- .get_flowset_test()

  flowsom_orig <- FlowSOM::FlowSOM(
    input = fs,
    toTransform = NULL,
    transform = FALSE,
    scale = TRUE,
    colsToUse = c("Am Cyan-H", "Pacific Blue-A", "Pacific Blue-H"),
    nClus = 3
  )

  out_tbl <- calc_cluster_stability(
    fs = fs, flowsom_orig = flowsom_orig,
    scale = TRUE, seed = 2, boot = 2,
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
})

