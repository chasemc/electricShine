#' Install an R package into the R installation library
#'
#' @param githubRepo Github username/repo of your the shiny-app package  (e.g. 'chasemc/demoAPP')
#' @param localPath path to local shiny-app package
#'
#' @return NA, installs R package into the R installation library
#' @export
#'
install_package <- function(githubRepo = NULL,
                            localPath = NULL){

  pathToInstall <- base::R.home()
  pathToInstall <- base::file.path(pathToInstall,
                                   "library")

  # If github repo was provided, install using remotes::
  if (!base::is.null(githubRepo)) {
    remotes::install_github(githubRepo,
                            lib = pathToInstall)
  }
  # If local path was provided, install using install.packages::

  if (!base::is.null(localPath)) {

    if (base::dir.exists(localPath)) {

      utils::install.packages(localPath,
                              repos = NULL,
                              type = "source")
    } else {
      base::warning("In electricShine::install_package(), localPath was given, but path wasn't found.")
    }
  }

  if (base::is.null(localPath) && base::is.null(githubRepo)) {
    base::warning("In electricShine::install_package(), either a 'githubRepo' or 'localPath' must be provided")

  }
}
