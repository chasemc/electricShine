#' Install your shiny app package and its dependencies to the R installation's library
#'
#' @param mran_date MRAN date from which to download packages from
#' @param library_path path to the Electron app's R's library folder
#' @param github_repo GitHub username/repo of your the shiny-app package  (e.g. 'chasemc/demoAPP')
#' @param local_package path to local shiny-app package
#'
#' @return nothing
#' @export
#'
install_user_app <- function(library_path = NULL,
                             mran_date = NULL,
                             github_repo = NULL,
                             local_package  = NULL){

  if(is.null(mran_date)){
    base::stop("electricShine::install_user_app() requires an mran_date value, in the format 'YYYY-MM-DD'")
  }

  # Not that great a check, but better than what was found on a quick stackoverflow search
  temp <- nchar(strsplit(mran_date, "-")[[1]])
  if(!identical(temp, c(4L,2L,2L))){
    base::stop("electricShine::install_user_app() requires an mran_date value, in the format 'YYYY-MM-DD'")
  }


  repo <- glue::glue("https://cran.microsoft.com/snapshot/{mran_date}/")

  

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

  if (!base::is.null(local_package)) {

    if (base::dir.exists(local_package)) {
      tryCatch(
        utils::install.packages(local_package,
                                repos = repo,
                                type = "binary"),
        error = function(e) {
          base::stop("In electricShine::install_user_app(), local_package was provided but was unable to install.")
        }
      )

    } else {
      base::warning("In electricShine::install_user_app(), local_package was given, but path wasn't found.")
    }
  }

  if (base::is.null(local_package) && base::is.null(github_repo)) {
    base::warning("In electricShine::install_user_app(), either a 'github_repo' or 'local_package' must be provided")

  }

}




