#' Install a conda package
#'
#' @param conda_path path
#' @param conda_env
#' @param conda_lib
#' @param conda_repo
#'
#' @return
#' @export
#'
#' @examples
conda_install <- function(conda_top_dir,
                          conda_env="eshine",
                          conda_lib,
                          conda_repo=NULL){

  if (!file.exists(conda_top_dir)){
    stop(paste0("Couldn't find: ", conda_top_dir))
  }

  conda_path <- find_conda_program(conda_top_dir)

  conda_options <- c("install")
  if (!is.null(conda_repo)) {
    conda_options <- c(conda_options, paste0("-c ", conda_repo))
  }
  if (!is.null(conda_env)) {
    conda_options <- c(conda_options, paste0("-n ", conda_env))
  }
  conda_options <- c(conda_options, conda_lib)
  conda_options <- paste0(conda_options, collapse = " ")

  system2(conda_path,
          conda_options,
          stdout = "")
}


conda_install_r <- function(conda_path,
                            conda_env="eshine",
                            conda_repo="conda-forge",
                            r_version="4.0.3"){

  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  conda_install(conda_path,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_lib = paste0("r-base=", r_version))
}


conda_install_python <- function(conda_path,
                                 conda_repo="conda-forge",
                                 conda_env="eshine",
                                 python_version = "3.7"){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  conda_install(conda_path,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_lib = paste0("python=", python_version))
}
