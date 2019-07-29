
#' Install electron-packager and electron via npm
#'
#' @param nodePath path to node.exe
#' @param npmPath path to npm-cli.js
#' @param installTo path of nodejs folder
#' @param appPath path of new electron app
#'
#' @return nothing
#' @export
#'
buildElectronDependencies <- function(appPath,
                                      nodePath = NULL,
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

      stop("Try running electricShine::get_nodejs(force = TRUE)")

    }

  }

  appPath <- (normalizePath(appPath))
  nodePath <- shQuote(nodePath)
  npmPath <- shQuote(npmPath)
  message("Downloading Electron packager...")
  # Use npm to get electron packager
  message(system("cmd.exe",
                 input = glue::glue("cd {appPath} && {nodePath} {npmPath} install --scripts-prepend-node-path"),
                 invisible = FALSE,
                 minimized = F,
                 wait = T))

}
