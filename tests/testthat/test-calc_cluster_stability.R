test_that("calc_cluster_stability works", {
  dir_fcs <- system.file("extdata", package = "flowWorkspaceData")
  fcs_vec <- list.files(
      path = dir_fcs,
      pattern = "^a2004"
  )
  fs <- flowCore::read.flowSet(
      files = file.path(dir_fcs, fcs_vec)
  )
})
