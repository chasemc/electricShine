#' Create an electron-builder release
#'
#' @param nodejs_path parent folder of node.exe (~nodejs_path/node.exe)
#' @param app_path path to new electron app top directory
#' @param nodejs_version for checking if nodejs is functional 
#'
#' @return nothing, used for side-effects
#' @export
#'
run_build_release <- function(nodejs_path = file.path(system.file(package = "electricShine"), "nodejs"),
                              app_path,
                              nodejs_version){
  
  
  os <- electricShine::get_os()
  
  node_path <- .check_node_works(node_top_dir = nodejs_path,
                                 expected_version = nodejs_version)
  
  npm_path <- .check_npm_works(node_top_dir = nodejs_path)
  
  if (base::isFALSE(node_path) || base::isFALSE(npm_path)) {
    
    stop("First run install_nodejs() or point nodejs_path to a functional version of nodejs.")
    
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
                   glue::glue("cd {app_path} && {npm_path} install --scripts-prepend-node-path"),
                   invisible = FALSE,
                   minimized = F,
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    message("Building your Electron app.")
    message(system("cmd.exe",
                   glue::glue("cd {app_path} && {npm_path} run release --scripts-prepend-node-path"),
                   invisible = FALSE,
                   minimized = F,
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    
  }
  
  if (identical(os, "mac")) {
    message(system(glue::glue("cd {app_path} && {npm_path} install --scripts-prepend-node-path"),
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    message("Building your Electron app.")
    message(system(glue::glue("cd {app_path} && {npm_path} run release --scripts-prepend-node-path"),
                   wait = T,
                   intern=F,
                   ignore.stdout=F,
                   ignore.stderr=F))
    
  }
  
  
  
}

