
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

  path <- base::file.path(path, filename)

  base::writeLines(text,
                   path)

  if (file.exists(path)) {
    base::message(glue::glue("Successfully created {path}"))
  } else {
    base::warning(glue::glue("Did not create {path}"))

  }
}


#' Title  Create an output folder
#'
#' @param path path where output folder gonna be
#' @param name name of the output folder about to be created
#'
#' @return if folder name already exists, show error and do nothing;
#'         if folder name doesn't exist, create a new file
#' @export
#'
#' @examples
#'
create_folder <- function(path, name){
  appPath <- file.path(path, name)

  if (file.exists(appPath)) {
    #print("stop")
    stop(glue::glue("{appPath} already exists, choose a path that doesn't already contain a directory named '{name}'"))
  } else {
    #print("create")
    dir.create(appPath)
  }
}


