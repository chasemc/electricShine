

appInstallR <- function(repo){


  pathToInstall <- R.home()
  pathToInstall <- file.path(pathToInstall, "library")

  remotes::install_github(repo)


}
