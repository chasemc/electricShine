
#' Install electron-packager and electron via npm
#'
#' @param node_path path to node.exe
#' @param npm_path path to npm-cli.js
#' @param buildPath path of nodejs folder
#' @param app_root_path path of new electron app
#'
#' @return nothing
#' @export
#'
buildElectronDependencies <- function(app_root_path,
                                      node_path = NULL,
                                      npm_path = NULL,
                                      electricShine_nodejs = file.path(system.file(package = "electricShine"), "nodejs")
){

  os <- electricShine::get_os()
  
  if (is.null(node_path) || is.null(node_path)) {

    if (identical(os, "win")) {
    node_path <- list.files(electricShine_nodejs,
                           recursive = TRUE,
                           full.names = TRUE,
                           pattern = "node.exe")
    }
    if (identical(os, "mac")) {
      node_path <- list.files(electricShine_nodejs,
                              recursive = TRUE,
                              full.names = TRUE)
      node_path <- node_path[grep("node$", node_path)]
    }


    npm_path <- list.files(electricShine_nodejs,
                          recursive = TRUE,
                          full.names = TRUE,
                          pattern = "npm-cli.js")
    
    
    if (length(node_path) != 1L) {
      node_path <- NULL
    }
    
    if (length(npm_path) != 1L) {
      npm_path <- NULL
    }
    
    
    if (is.null(node_path) || is.null(npm_path)) {

      stop("Make sure you ran, 'electricShine::get_nodejs()'. If you did, try running electricShine::get_nodejs(force = TRUE)")

    }

  }

  app_root_path <- (normalizePath(app_root_path))
  node_path <- shQuote(node_path)
  npm_path <- shQuote(npm_path)
  message("Downloading build tools from npm...")
  # Use npm to get electron packager
  message(system("cmd.exe",
                 input = glue::glue("cd {app_root_path} && {node_path} {npm_path} install --scripts-prepend-node-path"),
                 invisible = FALSE,
                 minimized = F,
                 wait = T))

}
