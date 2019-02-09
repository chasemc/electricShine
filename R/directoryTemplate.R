#' Create a directory for creating the new app and copy template of files
#'
#' @param path path to create the new app
#'
#' @return  nothing
#' @export
#'
create_directory_template <- function(path){

  existing_dirs <- base::list.dirs(path, recursive = FALSE)

  if (base::any(base::basename(existing_dirs) == "electricShine")) {
    stop(base::paste0("electricShine already exists in: ", path))
  }
  dir_path <- base::file.path(path, "electricShine")

  base::dir.create(dir_path,
                   showWarnings = FALSE)


  template_path <- system.file("template",package = "electricShine")
  template_files <- list.files(template_path,
                               recursive = TRUE,
                               full.names = TRUE)


  file.copy(from = template_files,
            to = dir_path)

}
