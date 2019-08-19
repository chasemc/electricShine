
#' Find nodejs and npm executables
#'
#' @param electricShine_nodejs electricShine pacakge location or location of nodejs directory
#'
#' @return list of two executable paths, one for nodejs and one for npm 
#' @export
#'
find_nodejs <- function(electricShine_nodejs = file.path(system.file(package = "electricShine"), "nodejs")) {
  
  os <- electricShine::get_os()
  
  
  if (!base::exists("node_path")) {
    node_path <- NULL
  }
  if (!base::exists("npm_path")) {
    npm_path <- NULL
  }
  
  
  if (is.null(node_path) || is.null(npm_path) || !file.exists(node_path) || !file.exists(npm_path)) {
    
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
  }
  
  if (length(node_path) != 1L) {
    node_path <- NULL
  }
  
  if (length(npm_path) != 1L) {
    npm_path <- NULL
  }
  
  if (identical(node_path, "")) {
    node_path <- NULL
  }
  
  if (identical(npm_path, "")) {
    npm_path <- NULL
  }
  
  return(list(node_path = node_path,
              npm_path = npm_path))
  
  
}
