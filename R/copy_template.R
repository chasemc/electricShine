
#' Copy Electron boilerplate into appPath
#'
#' @param appPath directory of new Electron app
#'
#' @return none
#' @export
#'
copy_template <- function(appPath){

  dirs <- file.path(system.file(package = "electricShine"), "template")
  dirs <- list.dirs(dirs)
  dirs <- dirs[-1]

file.copy(dirs,
          appPath, recursive = T)
}
