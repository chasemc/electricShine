#' Create the app.R file that will launch the app
#'
#' @param packageName name of the shiny app package
#' @param path path of the electricShine folder
#'
#' @return nothing
#' @export
#'
create_app_file <- function(packageName,
                            path){

  packageName <- base::basename(packageName)

  gluey <- glue::glue("library(shiny)

shinyApp(ui = {packageName}::app_ui(),
server = {packageName}::app_server
)
"
  )

base::writeLines(gluey,
                 file.path(path, "app.R"))


}
