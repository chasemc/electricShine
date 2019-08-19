
#' Copy Electron boilerplate into app_root_path
#'
#' @param app_root_path directory of new Electron app
#'
#' @return none
#' @export
#'
copy_template <- function(app_root_path){

  dirs <- system.file("template",
                      package = "electricShine")
  dirs <- list.dirs(dirs)
  dirs <- dirs[-1]

file.copy(dirs,
          app_root_path, recursive = T)
}
