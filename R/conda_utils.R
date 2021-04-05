
#' Return filepath of conda, given miniconda directory path
#'
#' @inheritParams conda_params
#'
#' @return
#' @export
#'
find_conda_program <- function(conda_top_dir){

  conda_path <- file.path(conda_top_dir,
                          "bin",
                          "conda")
  if (!file.exists(conda_path)) {
    stop("Couldn't find conda")
  }

  check_conda(conda_path)
  return(conda_path)
}


#' Check that conda works
#'
#' @inheritParams conda_params
#'
#' @return
#'
check_conda <- function(conda_path){
  if (!file.exists(conda_path)) {
  }
  res <- system2(conda_path, "-V", stdout = T)

  if (grepl("conda", res)) {
    message(paste0("Using: ", res, "\n", conda_path))
  } else {
    stop("Something went wrong detecting conda")

  }
}



#' Create a new conda environment
#'
#' @inheritParams conda_params
#'
#' @return
#' @export
#'
#' @examples
conda_create_env <- function(conda_top_dir, conda_env){

  conda_path <- find_conda_program(conda_top_dir)

  system2(conda_path,
          c("create",
            paste0("-n ", conda_env),
            "-y"),
          stdout = "")
}


