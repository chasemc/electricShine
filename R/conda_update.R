#' Update conda version
#'
#' @inheritParams conda_params
#'
#' @return
#' @export
#'
conda_update <- function(conda_top_dir){

  conda_path <- find_conda_program(conda_top_dir)

  system2(conda_path,
          c("update -n base -c defaults conda -y"),
          stdout = "")
}
