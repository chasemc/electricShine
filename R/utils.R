
#' Write to a file
#'
#' @param path path where file should be written to
#' @param text text to write
#' @param filename name of file to write to
#'
#' @return message saying whether file was created or not
#' @export
#'
write_text <- function(text,
                       filename,
                       path){
  
  path <- base::file.path(path,
                          filename)
  
  path <- normalizePath(path, 
                        winslash = "/", 
                        mustWork = FALSE)
  
  base::writeLines(text,
                   path)
  
  if (file.exists(path)) {
    base::message(glue::glue("Successfully created {path}"))
  } else {
    base::warning(glue::glue("Did not create {path}"))
  }
  
}


#' Create an output folder
#'
#' @param app_root_path path where output folder gonna be
#'
#' @return if folder name already exists, show error and do nothing;
#' @export
#'
create_folder <- function(app_root_path){
  
  name <- base::basename(app_root_path)
  
  if (file.exists(app_root_path)) {
    stop(glue::glue("electricShine::create_folder(app_root_path, name) already exists, choose a path that doesn't already contain a directory named '{name}'"))
  } else {
    dir.create(app_root_path)
  }
  
}





#' Check if Node works
#'
#' @param node_top_dir directory containing nodejs app/exe
#' @param expected_version  expected version of node
#'
#' @return TRUE/FALSE whether node exists and is functional
.check_node_works <- function(node_top_dir,
                              expected_version) {
  
  if (!grepl("v", expected_version)) {
    expected_version <- paste0("v",
                               expected_version)
  }
  
  os <- electricShine::get_os()
  
  command <- normalizePath(node_top_dir,
                           "/")
  
  if (os == "win") {
    
    command <- file.path(command,
                         "node.exe")
    
  } else {
    
    command <- file.path(command,
                         "node")    
  }
  
  
  
  node_exists <- file.exists(command)
  
  if (node_exists) {
    # Check that the node version is the same as what we expect
    command <- paste0(command, 
                      " -v")
    
    result <- tryCatch(system(command,
                              intern = T),
                       error = function(e) "not_found", 
                       warning = function(e) "not_found")
    
    if (expected_version != result) {
      
      stop(glue::glue("Node executable in {node_top_dir} was found to be version {result}, but {expected_version} was specified in electricShine."))
      
    }
    node_exists <- TRUE 
  }
  
  return(node_exists)
}














#' Check if npm works
#'
#' @param node_top_dir directory containing npmjs app/exe
#' @param expected_version  expected version of npm
#'
#' @return TRUE/FALSE whether npm exists and is functional
.check_npm_works <- function(node_top_dir) {
  
  os <- electricShine::get_os()
  
  command <- normalizePath(node_top_dir,
                           "/", 
                           mustWork = FALSE)
  
  
  
  command <- file.path(command,
                       "npm")  
  
  npm_exists <- file.exists(command)
  
  if (npm_exists) {
    # Check that the npm version is the same as what we expect
    command <- paste0(command, 
                      " -v")
    
    result <- tryCatch(system(command,
                              intern = T),
                       error = function(e) FALSE, 
                       warning = function(e) FALSE)
    
    if(!isFALSE(result)) { 
      
      npm_exists <- TRUE 
    }
  }
  
  return(npm_exists)
}

