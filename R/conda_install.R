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
  if (!is.null(conda_env)) {
    conda_options <- c(conda_options, paste0("-n ", conda_env))
  }
  conda_options <- c(conda_options, conda_package, "-y")
  conda_options <- paste0(conda_options, collapse = " ")
  system2(conda_path,
          conda_options,
          stdout = "")
}


#' Install R from conda
#'
#' @inheritParams conda_params
#' @param r_version semantic version of R to install (e.g. "4.0")
#'
#' @return
#' @export
#'
conda_install_r <- function(conda_top_dir,
                            conda_env = "eshine",
                            conda_repo = "conda-forge",
                            r_version = NULL){
  if (is.null(r_version)) {
    # Use the version of R used to build the app
    r_version <- paste0(R.Version()$major, "." , R.Version()$minor)
  }
  message("Install R into conda environment:")
  conda_install(conda_top_dir = conda_top_dir,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_package = paste0("r-base=", r_version))
}


#' Instal python from conda
#'
#' @inheritParams conda_params
#' @param nodejs_version semantic version of nodejs to install (e.g. :15.13.0")
#'
#' @return
#' @export
#'
conda_install_nodejs <- function(conda_top_dir,
                                 conda_repo="conda-forge",
                                 conda_env="eshine-nodejs",
                                 nodejs_version = "15.13.0"){
  message("Install nodejs into conda environment:")
  conda_install(conda_top_dir = conda_top_dir,
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

  message("Install python into conda environment:")
  conda_install(conda_top_dir = conda_top_dir,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_package = paste0("python=", python_version))
}
