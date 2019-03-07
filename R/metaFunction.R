#' Meta-function
#'
#' @param path path to create installer
#' @param date date for MRAN
#' @param package github username/repo
#'
#' @return Nothing
#' @export
#'
buildPackage <- function(name = "My_Package",
                         description = "My Electron application",
                         productName = "productName",
                         version = NULL,
                         path = NULL,
                         date = "2019-01-01",
                         package = NULL){
  if (is.null(package)) {
    stop("electricShine() requires you to specify a 'package' argument.
(e.g. electricShine::electricShine(package = 'tidyverse/ggplot2') )")
  }
  if (is.null(path)) {
    stop("electricShine() requires you to specify a 'path' argument.
(e.g. electricShine::electricShine(path = 'C:/Users/me/Desktop/my_app') )")
  }
  if (is.null(version)) {
    stop("electricShine() requires you to specify a 'version' argument.
           (e.g. electricShine::electricShine(version = '1.0.0') )")
  }


  electricShine::getNodejs()


  appPath <- file.path(path, name)

  if (file.exists(appPath)) {
    stop(glue::glue("{appPath} already exists, choose a path that doesn't already contain a directory named '{name}'"))
  }

  dir.create(appPath)

  electricShine::setup_directory(name = name,
                                 description = description,
                                 productName = productName,
                                 version = version,
                                 appPath = appPath)

  electricShine::installR(date = date,
                          path = appPath)

  electricShine::trim_r(pathToR = file.path(appPath,
                                            "r_win"))

  try(
    electricShine::buildElectronDependencies(appPath = appPath)
  )

  electricShine::install_user_app(package = package,
                                  path = appPath,
                                  date = date)

}
