getElectron <- function(nodePath = NULL,
                        npmPath = NULL,
                        path,
                        node = file.path(system.file(package = "electricShine"), "nodejs"),
                        force = FALSE){

  if (is.null(nodePath) || is.null(nodePath)) {

    nodePath <- list.files(node,
                           recursive = TRUE,
                           full.names = TRUE,
                           pattern = "node.exe")

    npmPath <- list.files(node,
                          recursive = TRUE,
                          full.names = TRUE,
                          pattern = "npm-cli.js")
    if (is.null(nodePath) || is.null(npmPath)) {

      stop("Try running electricShine::getNodejs(focre = TRUE)")

    }

  }


  nodePath <- shQuote(nodePath)
  npmPath <- shQuote(npmPath)
  path <- shQuote(path)
  message("Creating app...")
  # Use npm to get electron packager
  message(system(glue::glue("cd {path} {nodePath} {npmPath} run package-win"),
                 intern = FALSE,
                 invisible = FALSE))

}
