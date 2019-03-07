
#' Write to a file
#'
#' @param name name of file to be created, including extension
#' @param path path where file should be written to
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
