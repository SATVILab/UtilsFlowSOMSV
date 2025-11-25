#' @title Calculate cluster stability for each cluster
#'
#' @param fs flowSet.
#' Assumed appropriately transformed and compensated (but not necessary scaled).
#' @param flowsom_orig output from FlowSOM::FlowSOM, as applied to original data.
#' @param scale logical. If \code{TRUE}, the variables are centred and scaled.
#' @param boot integer. Number of bootstrap samples to take.
#' @param seed integer. If not \code{NULL}, then the seed is set to this.
#' @param chnl character vector. Channels to use for clustering.
#' Same as \code{colsToUse} for \code{FlowSOM::FlowSOM}.
#' @param n_cluster integer. Number of clusters.
#' Same meaning as \code{nClus} for \code{FlowSOM::FlowSOM}.
#' @return A \code{tibble::tibble} with the following three
#' 
#' @export
calc_cluster_stability <- function(fs,
                                   flowsom_orig,
                                   scale,
                                   seed = NULL,
                                   boot,
                                   chnl,
                                   n_cluster){

  # clusters for each original data point
  cluster_vec_orig <- as.numeric(
    flowsom_orig$metaclustering[flowsom_orig$map$mapping[, 1]]
   )

  # process data for FlowSOM
  # --------------------------
  flowsom_input_orig <- FlowSOM::ReadInput(
    input = fs,
    pattern = ".fcs",
    compensate = FALSE,
    spillover = NULL,
    transform = FALSE,
    toTransform = NULL,
    transformFunction = flowCore::logicleTransform(),
    scale = scale,
    silent = TRUE
  )



  stability_tbl_boot <- purrr::map_df(seq_len(boot), function(boot_ind) {

    if (!is.null(seed)) set.seed(seed)

    if (boot_ind %% 10 == 0) print(boot_ind)

    # get bootstrap sample
    flowsom_input_boot <- flowsom_input_orig
    ind_vec <- sample(seq_len(nrow(flowsom_input_orig$data)),
                      nrow(flowsom_input_orig$data),
                      replace = TRUE)

    flowsom_input_boot$data <- flowsom_input_orig$data[ind_vec, ]

    # build SOM
    flowsom_boot <- FlowSOM::BuildSOM(
      fsom = flowsom_input_boot,
      colsToUse = chnl,
      silent = TRUE,
      importance = NULL
    )

    # build mst
    flowsom_boot <- FlowSOM::BuildMST(
      flowsom_boot,
      silent = TRUE
    )

    # metaclustering
    cluster_lab_vec <- FlowSOM::metaClustering_consensus(
      data = flowsom_boot$map$codes,
      k = n_cluster,
      seed = if (!is.null(seed)) 2 * seed else NULL
    )
    # cluster for each cell
    cluster_vec_boot <- cluster_lab_vec[flowsom_boot$map$mapping[, 1]]

    # clusters for each observations
    cluster_vec_orig_in_boot <- cluster_vec_orig[ind_vec]
    results_mat <- matrix(rep(-1, n_cluster^2), nrow = n_cluster)
    for (i in seq_len(n_cluster)) {
      for (j in seq_len(n_cluster)) {
        ind_orig <- which(cluster_vec_orig_in_boot == i)
        ind_boot <- which(cluster_vec_boot == j)
        n_intersect <- length(intersect(ind_boot, ind_orig))
        n_union <- length(union(ind_boot, ind_orig))
        jacc_coef <- n_intersect / n_union
        results_mat[i, j] <- jacc_coef
      }
    }

    results_vec <- vapply(
      seq_len(n_cluster),
      function(i) {
        max(results_mat[i, , drop = TRUE])
      },
      numeric(1)
    )

    if (!is.null(seed)) seed <<- seed + 1

    out_tbl <- data.frame(t(as.matrix(results_vec)))
    colnames(out_tbl) <- paste0("cluster_", seq_len(n_cluster))
    out_tbl
  }) 

  stability_vec_summary <- vapply(seq_len(n_cluster), function(i) {
    mean(stability_tbl_boot[[i]])
  }, numeric(1))

  if (!requireNamespace("tibble", quietly = TRUE)) {
    install.packages("tibble")
  }

  tibble::tibble(
    cluster = seq_len(n_cluster),
    stability_mean = stability_vec_summary,
    stability_sample = lapply(seq_len(n_cluster), function(i) {
      stability_tbl_boot[[i]]
    })
  )

}