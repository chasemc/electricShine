
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


