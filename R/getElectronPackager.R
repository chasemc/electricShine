
#' Install electron-packager
#'
#' @param nodePath path to node.exe
#' @param npmPath path to npm-cli.js
#' @param installTo path of nodejs folder
#'
#' @return nothing
#' @export
#'
getElectronPackager <- function(nodePath = NULL,
                                npmPath = NULL,
                                installTo = file.path(system.file(package = "electricShine"), "nodejs")
){

  if (is.null(nodePath) || is.null(nodePath)) {

    nodePath <- list.files(installTo,
                           recursive = TRUE,
                           full.names = TRUE,
                           pattern = "node.exe")

    npmPath <- list.files(installTo,
                          recursive = TRUE,
                          full.names = TRUE,
                          pattern = "npm-cli.js")
    if (is.null(nodePath) || is.null(npmPath)) {

      stop("Try running electricShine::getNodejs(force = TRUE)")

    }

  }


  nodePath <- shQuote(nodePath)
  npmPath <- shQuote(npmPath)
  message("Downloading Electron packager...")
  # Use npm to get electron packager
  message(system(glue::glue("{nodePath} {npmPath} install electron-packager -g"),
                 intern = FALSE,
                 invisible = FALSE))

}
