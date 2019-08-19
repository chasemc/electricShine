#' Install your shiny app package and its dependencies to the R installation's library
#'
#' @param mran_date MRAN date from which to download packages from
#' @param app_root_path path to the Electron app's build folder
#' @param github_repo GitHub username/repo of your the shiny-app package  (e.g. 'chasemc/demoAPP')
#' @param local_path path to local shiny-app package
#'
#' @return nothing
#' @export
#'
install_user_app <- function(app_root_path = NULL,
                             mran_date = NULL,
                             github_repo = NULL,
                             local_path  = NULL){

  if(is.null(mran_date)){
    base::stop("electricShine::install_user_app() requires an mran_date value, in the format 'YYYY-MM-DD'")
  }

  # Not that great a check, but better than what was found on a quick stackoverflow search
  temp <- nchar(strsplit(mran_date, "-")[[1]])
  if(!identical(temp, c(4L,2L,2L))){
    base::stop("electricShine::install_user_app() requires an mran_date value, in the format 'YYYY-MM-DD'")
  }


  repo <- glue::glue("https://cran.microsoft.com/snapshot/{mran_date}/")

  library_path <- base::file.path(app_root_path,
                                  "app",
                                  "r_win",
                                  "library")

  withr::with_libpaths(library_path,
                       utils::install.packages("remotes",
                                               repos = repo,
                                               destdir = NULL,
                                               type="binary"))

  # If github repo was provided, install using remotes::
  if (!base::is.null(github_repo)) {

    withr::with_libpaths(library_path,
                         remotes::install_github(github_repo,
                                                 dependencies = NA,
                                                 force = TRUE,
                                                 destdir = NULL,
                                                 repos = repo,
                                                 type = "binary"))
  }
  # If local path was provided, install using install.packages::

  if (!base::is.null(local_path)) {

    if (base::dir.exists(local_path)) {
      tryCatch(
        utils::install.packages(local_path,
                                repos = repo,
                                type = "binary"),
        error = function(e) {
          base::stop("In electricShine::install_user_app(), local_path was provided but was unable to install.")
        }
      )

    } else {
      base::warning("In electricShine::install_user_app(), local_path was given, but path wasn't found.")
    }
  }

  if (base::is.null(local_path) && base::is.null(github_repo)) {
    base::warning("In electricShine::install_user_app(), either a 'github_repo' or 'local_path' must be provided")

  }

}




