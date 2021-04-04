
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
#' @param conda_path path to conda executable
#'
#' @return
#' @export
#'
check_conda <- function(conda_path){
  if (!file.exists(conda_path)) {
    stop(paste0("Couldn't find: ", conda_path))
  }
  res <- system2(conda_path, "-V", stdout = T)

  if (grepl("conda", res)) {
    message(paste0("Using: ", res, "\n", conda_path))
  } else {
    stop("Something went wrong detecting conda")

  }
}
