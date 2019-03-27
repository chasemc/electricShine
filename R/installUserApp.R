#' Install your shiny app package and its dependencies to the R installation's library
#'
#' @param MRANdate MRAN date from which to download packages from
#' @param appPath path to the Electron app's build folder
#' @param githubRepo GitHub username/repo of your the shiny-app package  (e.g. 'chasemc/demoAPP')
#' @param localPath path to local shiny-app package
#'
#' @return nothing
#' @export
#'
install_user_app <- function(appPath = NULL,
                             MRANdate = NULL,
                             githubRepo = NULL,
                             localPath  = NULL){

  if(is.null(MRANdate)){
    base::stop("electricShine::install_user_app() requires an MRANdate value, in the format 'YYYY-MM-DD'")
  }

  # Not that great a check, but better than what was found on a quick stackoverflow search
  temp <- nchar(strsplit(MRANdate, "-")[[1]])
  if(!identical(temp, c(4,2,2))){
    base::stop("electricShine::install_user_app() requires an MRANdate value, in the format 'YYYY-MM-DD'")
  }


  repo <- glue::glue("https://cran.microsoft.com/snapshot/{MRANdate}/")

  library_path <- base::file.path(appPath,
                                  "app",
                                  "r_win",
                                  "library")

  withr::with_libpaths(library_path,
                       utils::install.packages("remotes",
                                               repos = repo,
                                               destdir = NULL))

  # If github repo was provided, install using remotes::
  if (!base::is.null(githubRepo)) {

    withr::with_libpaths(library_path,
                         remotes::install_github(githubRepo,
                                                 dependencies = NA,
                                                 repos = repo,
                                                 force = TRUE,
                                                 destdir = NULL,
                                                 lib = library_path,
                                                 type = "binary"))
  }
  # If local path was provided, install using install.packages::

  if (!base::is.null(localPath)) {

    if (base::dir.exists(localPath)) {
      tryCatch(
        utils::install.packages(localPath,
                                repos = NULL,
                                type = "source"),
        error = function(e) {
          base::stop("In electricShine::install_user_app(), localPath was provided but was unable to install.")
        }
      )

    } else {
      base::warning("In electricShine::install_user_app(), localPath was given, but path wasn't found.")
    }
  }

  if (base::is.null(localPath) && base::is.null(githubRepo)) {
    base::warning("In electricShine::install_user_app(), either a 'githubRepo' or 'localPath' must be provided")

  }

}




