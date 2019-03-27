#' Create a directory for creating the new app and copy template of files
#'
#' @param name  name of app
#' @param description short description of app
#' @param productName product name
#' @param version version number: see https://semver.org/ for details on how to use version numbers
#' @param appPath path to new electron app top directory
#' @param ... pass optional arguments to electricShine::create_package_json()
#' @param functionName the function name in your package that starts the shiny app
#'
#' @return  nothing, creates a directory
#' @export
#'
create_build_directory <- function(name,
                            description,
                            productName,
                            version,
                            appPath,
                            functionName,
                            ...){

  electricShine::create_package_json(name = name,
                                     description = description,
                                     productName = productName,
                                     version = version,
                                     path = appPath,
                                     ...)

  electricShine::run_shiny(packageName = name,
                           path = appPath,
                           functionName = functionName)

  electricShine::create_background_js(path = appPath)

  electricShine::create_renderer_js(path = appPath)

}




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



