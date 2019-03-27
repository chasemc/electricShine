
#' Create app.R file that starts the shiny app
#'
#' @param path path of where to write app.R
#' @param packageName name of package
#' @param functionName function that starts the shiny app
#'
#' functionName should be the name of the function that startsthe package's shiny app.
#' e.g. is you have the function myPackage::start_shiny(), provide "start_shiny"
#'
#' @return nothing, writes app.R to path provided and provides feedback if succcessful or not
#' @export
#'
run_shiny <- function(packageName,
                      path,
                      functionName){

  packageName <- base::basename(packageName)

  file <- glue::glue("library(shiny)
                     {packageName}::{functionName}()
                     "
  )
  electricShine::write_text(text = file,
                            filename = "app.R",
                            path = path)


}
