#' Create an electron-builder release
#'
#' @param nodePath option to specifiy the path to the node.js directory if already installed
#' @param npmPath option to specifiy the path to the npm module directory if already installed
#' @param node folder where electricShine installs/looks for node an npm if not given in nodePath/npmPath
#' @param appPath path to new electron app top directory
#'
#' @return nothing, used for side-effects
#' @export
#'
runBuild <- function(nodePath = NULL,
                     npmPath = NULL,
                     appPath,
                     node = file.path(system.file(package = "electricShine"), "nodejs")){


  if (is.null(nodePath) || is.null(nodePath)) {

    nodePath <- list.files(node,
                           recursive = TRUE,
                           full.names = TRUE,
                           pattern = "node.exe")

    npmPath <- list.files(node,
                          recursive = TRUE,
                          full.names = TRUE,
                          pattern = "npm-cli.js")

    if (length(nodePath) == 0 || length(npmPath) == 0) {

      stop("Try running electricShine::getNodejs()
electricShine::getElectron() first")

    }

  }


  nodePath <- shQuote(nodePath)
  npmPath <- shQuote(npmPath)
  appPath <- shQuote(appPath)
  message("Creating app...")


  # electron-packager <sourcedir> <appname> --platform=<platform> --arch=<arch> [optional flags...]
  # npm start --prefix path/to/your/app

  message(system("cmd.exe",
                 glue::glue("cd {appPath} && {nodePath} {npmPath} run release --scripts-prepend-node-path"),
                 invisible = FALSE,
                 minimized = F,
                 wait = T,
                 intern=F,
                 ignore.stdout=F,
                 ignore.stderr=F))
}



