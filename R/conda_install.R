#' Install a conda package
#'
#' @inheritParams conda_params
#'
#' @return
#' @export
#'
conda_install <- function(conda_top_dir, conda_env = "eshine", conda_package, conda_repo = NULL){

  if (!file.exists(conda_top_dir)){
    stop(paste0("Couldn't find: ", conda_top_dir))
  }

  conda_path <- find_conda_program(conda_top_dir)

  conda_options <- c("install")
  if (!is.null(conda_repo)) {
    conda_options <- c(conda_options, paste0("-c ", conda_repo))
  }
}


conda_install_r <- function(conda_path, conda_env="eshine",conda_repo="conda-forge", r_version="4.0.3"){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  conda_install(conda_path,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_package = paste0("r-base=", r_version))
}


conda_install_python <- function(conda_path, conda_repo="conda-forge", conda_env="eshine", python_version = "3.7"){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  conda_install(conda_path,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_package = paste0("nodejs=", nodejs_version))
}


#' Instal python from conda
#'
#' @inheritParams conda_params
#' @param python_version semantic version of python to install (e.g. "3.7")
#'
#' @return
#' @export
#'
conda_install_python <- function(conda_top_dir,
                                 conda_repo="conda-forge",
                                 conda_env="eshine",
                                 python_version = "3.7"){

  conda_install(conda_top_dir = conda_top_dir,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_package = paste0("python=", python_version))
}
