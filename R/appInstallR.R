#' TODO: Install user app on machine
#'
#' @param repo use repo or package with electron installer
#'
#' @return NA
#' @export
#'
appInstallR <- function(repo){


  pathToInstall <- R.home()
  pathToInstall <- file.path(pathToInstall, "library")

  remotes::install_github(repo)


}
