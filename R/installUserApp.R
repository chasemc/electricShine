

#' Title
#'
#' @param package github username/repo    eg tidyverse/ggplot2
#' @param date MRAN date from which to download packages from
#' @param path path to electricShine folder
#'
#' @return nothing
#' @export
#'
install_user_app <- function(package,
                             path,
                             date){

  repo <- glue::glue("https://cran.microsoft.com/snapshot/{date}/")

  library_path <- base::file.path(path, "r_win", "library")



  withr::with_libpaths(library_path,
                       utils::install.packages("remotes", repos = repo, destdir = NULL)
  )

  withr::with_libpaths(library_path,
                       remotes::install_github(package,
                                               dependencies = NA,
                                               repos = repo,
                                               force = TRUE,
                                               destdir = NULL,
                                               lib = library_path)
  )
}
