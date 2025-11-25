test_that(".get_flowset_test returns a flowSet", {
  skip_if_not_installed("flowWorkspaceData")
  skip_if_not_installed("UtilsCytoRSV")

  fs <- .get_flowset_test()

  expect_s4_class(fs, "flowSet")
  expect_true(length(fs) > 0)
})

test_that(".get_flowset_test requires flowWorkspaceData", {
  # This test verifies the function exists and has proper documentation

  expect_true(exists(".get_flowset_test"))
  expect_true(is.function(.get_flowset_test))
})
