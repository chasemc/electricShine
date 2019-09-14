#' Check if Node works
#'
#' @param node_top_dir directory containing nodejs app/exe
#' @param expected_version  expected version of node
#'
#' @return path of nodejs executable if found and functional, otherwise: FALSE
.check_node_works <- function(node_top_dir,
                              expected_version) {
  
  message("Checking if the provided nodejs path already contains nodejs...")
  
  if (!grepl("v", expected_version)) {
    expected_version <- paste0("v",
                               expected_version)
  }
  
  os <- electricShine::get_os()
  
  node_path <- normalizePath(node_top_dir,
                             "/")
  
  if (os == "win") {
    
    node_path <- file.path(node_path,
                           "node.exe")
    
  } else {
    
    node_path <- file.path(node_path,
                           "node")    
  }
  
  node_exists <- file.exists(node_path)
  
  if (!node_exists) {
    
    message("nodejs executable not found.")
    node_path <- FALSE
    return(node_path)
    
  } else {
    
    message("Found nodejs executable.")
    
    # Check that the node version is the same as what we expect and nodejs is functional
    command <- paste0(node_path, 
                      " -v")
    nodejs_response <- tryCatch(system(stringr::str_replace(command, "Max Feinberg", "\"Max Feinberg\""),
                                       intern = T),
                                error = function(e) FALSE, 
                                warning = function(e) FALSE)
    
    
    if (nodejs_response == FALSE) {
      
      message(glue::glue("nodejs at {node_path} seems not to be functional."))
      node_path <- FALSE
      return(node_path)
      
      
    # TODO: Use "base::as.numeric_version()" and "base::compareVersion()" 
    # so e.g. "10.6.0" == "10.6"  is TRUE 
      
    } else if (nodejs_response != expected_version) {
      
      message(glue::glue("Found nodejs {node_path} is version {nodejs_response}, expected {expected_version}."))
      node_path <- FALSE
      return(node_path)
    } else if (nodejs_response == expected_version) {
      
      message(glue::glue("Found nodejs {nodejs_response} at: {node_path}."))
      return(node_path)
      
    } 
  }
}







#' Check if npm works
#'
#' @param node_top_dir directory containing npmjs app/exe
#'
#' @return path of npm executable if found and functional, otherwise: FALSE
.check_npm_works <- function(node_top_dir) {
  
  message("Checking if given nodejs path already contains nodejs.")
  
  os <- electricShine::get_os()
  
  npm_path <- normalizePath(node_top_dir,
                            "/", 
                            mustWork = FALSE)
  
  npm_path <- file.path(npm_path,
                        "npm")  
  
  npm_exists <- file.exists(npm_path)
  
  if (!npm_exists) {
    
    message(glue::glue("npm seems not be installed."))
    npm_path <- FALSE
    return(npm_path)
    
  } else {
    
    # Check that the npm version is the same as what we expect
    command <- paste0(npm_path, 
                      " -v")
    
    result <- tryCatch(system(command,
                              intern = T),
                       error = function(e) FALSE, 
                       warning = function(e) FALSE)
    
    # TODO Write a etter check for npm response
    if(isFALSE(result)) { 
      
      message(glue::glue("npm executable was found but seems not to be functional."))
      npm_path <- FALSE
      return(npm_path)
      
    } else  {
      message(glue::glue("Found npm at: {npm_path}"))
      return(npm_path)
    } 
    
  }
}

