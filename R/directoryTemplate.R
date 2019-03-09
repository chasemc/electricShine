#' Create a directory for creating the new app and copy template of files
#'
#' @param path path to create the new app
#' @param name  name of app
#' @param description short description of app
#' @param productName product name
#' @param version version number: see https://semver.org/ for details on how to use version numbers
#'
#' @return  nothing, creates a directory
#' @export
#'
setup_directory <- function(name,
                            description,
                            productName,
                            version,
                            appPath){

  electricShine::create_package_json(name = name,
                                     description = description,
                                     productName = productName,
                                     version = version,
                                     path = appPath)

  electricShine::create_app_R(packageName = name,
                              path = appPath)

  electricShine::create_main_js(path = appPath)

  electricShine::create_renderer_js(path = appPath)

}




#' Create app.R file
#'
#' @param path path of where to write app.R
#' @param packageName name of package
#'
#' @return nothing, writes app.R to path provided and provides feedback if succcessful or not
#' @export
#'
create_app_R <- function(packageName,
                         path){

  packageName <- base::basename(packageName)

  file <- glue::glue("library(shiny)

shinyApp(ui = {packageName}::app_ui(),
server = {packageName}::app_server
)
"
  )

electricShine::write_text(text = file,
                          name = "app.R",
                          path = path)


}








#
#
#
# create_random_port <- function(){
# file <-
#  'export const randomPort = () => {
#     // Those forbidden ports are in line with shiny
#     // https://github.com/rstudio/shiny/blob/288039162086e183a89523ac0aacab824ef7f016/R/server.R#L734
#     const forbiddenPorts = [3659, 4045, 6000, 6665, 6666, 6667, 6668, 6669, 6697];
#     while (true) {
#       let port = randomInt(3000, 8000)
#       if (forbiddenPorts.includes(port))
#         continue
#       return port
#     }'
#
#
#   }



