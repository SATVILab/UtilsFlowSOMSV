#' @title Get a FlowSet for demonstration purposes
#'
#' @description Loads two FCS files from the \code{flowWorkspaceData} package.
#'
#' @return A FlowSet of two samples.
.get_flowset_test <- function() {
  if (!requireNamespace("flowWorkspaceData", quietly = TRUE)) {
    BiocManager::install("flowWorkspaceData")
  }
  if (!requireNamespace("UtilsCytoRSV", quietly = TRUE)) {
    stop("UtilsCytoRSV package is required for testing. Install from GitHub: SATVILab/UtilsCytoRSV")
  }
  path_flow_workspace_data <- system.file(
    "extdata",
    package = "flowWorkspaceData"
  )

  fcs_vec <- list.files(
    path_flow_workspace_data,
    pattern = "^a2004",
    recursive = FALSE,
    full.names = TRUE
    )

  fs <- flowCore::read.flowSet(fcs_vec)

  asinh_trans <- flowCore::arcsinhTransform(b = 1 / 5, a = 0)
  trans_list <- flowCore::transformList(
    setdiff(UtilsCytoRSV::get_chnl(fs), "Time"),
    asinh_trans
  )
  fs <- flowCore::transform(fs, trans_list)

  fs
}