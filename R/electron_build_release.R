#' Create an electron-builder release
#'
#' @param node_path option to specifiy the path to the node.js directory if already installed
#' @param npm_path option to specifiy the path to the npm module directory if already installed
#' @param node folder where electricShine installs/looks for node an npm if not given in node_path/npm_path
#' @param app_path path to new electron app top directory
#'
#' @return nothing, used for side-effects
#' @export
#'
run_build <- function(node_path = NULL,
                      npm_path = NULL,
                      app_path,
                      node = file.path(system.file(package = "electricShine"), "nodejs")){
  
  
  os <- electricShine::get_os()
  
  temp <- electricShine::find_nodejs()
  
  node_path <- temp$node_path
  npm_path <- temp$npm_path
  
  
  if (length(node_path) == 0 || length(npm_path) == 0) {
    electricShine::get_nodejs()
    temp <- electricShine::find_nodejs()
    
    node_path <- temp$node_path
    npm_path <- temp$npm_path
    if (length(node_path) == 0 || length(npm_path) == 0) {
      stop("Try running electricShine::getNodejs()
           electricShine::getElectron() first")
    }
  }
  
  
  node_path <- shQuote(node_path)
  npm_path <- shQuote(npm_path)
  app_path <- shQuote(app_path)
  message("Creating app...")
  
  
  
  # electron-packager <sourcedir> <appname> --platform=<platform> --arch=<arch> [optional flags...]
  # npm start --prefix path/to/your/app
  message("Installing npm dependencies for the installation process. these are specfied in 'package.json'. Also this step can take a few minutes.")
  
  if (identical(os, "win")) {
    message(system("cmd.exe",
                   glue::glue("cd {app_path} && {node_path} {npm_path} install --scripts-prepend-node-path"),
                   invisible = FALSE,
                   minimized = F,
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    message("Building your Electron app.")
    message(system("cmd.exe",
                   glue::glue("cd {app_path} && {node_path} {npm_path} run release --scripts-prepend-node-path"),
                   invisible = FALSE,
                   minimized = F,
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    
  }
  
  
  if (identical(os, "mac")) {
    message(system(glue::glue("cd {app_path} && {node_path} {npm_path} install --scripts-prepend-node-path"),
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    message("Building your Electron app.")
    message(system(glue::glue("cd {app_path} && {node_path} {npm_path} run release --scripts-prepend-node-path"),
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    
  }
  
  
  
}

