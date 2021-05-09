#' Install R package within conda
#'
#' @inheritParams conda_params
#'
#' @param r_package_name name of package to install
#'
#' @return
#' @export
#'
install_r_packages <- function(r_package_name,
                               r_package_repo="https://cran.r-project.org",
                               conda_top_dir,
                               conda_env = "eshine"){

  script <- paste0("install.packages('",
                   r_package_name,
                   "',",
                   "repos='",
                   r_package_repo,
                   "')")


  script <-  paste0("Rscript -e ",
                    shQuote(script, type = "cmd"))

  script <- paste0("source ",
                   shQuote(
                     file.path(conda_top_dir,
                               "bin",
                               "activate")
                   ),
                   " ",
                   shQuote(
                     file.path(conda_top_dir,
                               "envs",
                               conda_env)
                   ),
                   " && ",
                   script,
                   " && ",
                   shQuote(
                     file.path(conda_top_dir,
                               "bin",
                               "deactivate")
                   )
  )
  cat(script)
  system(script)
}



#' Install {remotes} R package
#'
#' @inheritParams conda_params
#'
#' @return
#' @export
#'
install_r_remotes <- function(conda_top_dir,
                              r_package_repo="https://cran.r-project.org",
                              conda_env = "eshine"){

  install_r_packages(r_package_name = "remotes",
                     r_package_repo = r_package_repo,
                     conda_top_dir = conda_top_dir,
                     conda_env = conda_env)
}


