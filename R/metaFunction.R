#' Meta-function
#'
#' @param installTo path to create installer, preferably points to an empty directory
#' @param appName electron app name
#' @param description electron app description
#' @param productName necessary?
#' @param version semantic version of your app, as character (not numeric!)
#' @param MRANdate MRAN snapshot date, formatted as 'YYYY-MM-DD'
#' @param githubRepo GitHub username/repo of your the shiny-app package (e.g. 'chasemc/demoAPP')
#' @param localPath path to local shiny-app package
#' @param functionName the function name in your package that starts the shiny app
#'
#' @return Nothing
#' @export
#'
buildPackage <- function(appName = "My_Package",
                         description = "My Electron application",
                         productName = "productName",
                         version = NULL,
                         installTo = NULL,
                         MRANdate = Sys.Date() - 3,
                         functionName = NULL,
                         githubRepo = NULL,
                         localPath  = NULL){

  if (is.null(githubRepo) && is.null(localPath)) {
    stop("electricShine::buildPackage() requires you to specify either a 'githubRepo' or 'localPath' argument specifying
         the shiny app/package to be turned into an Electron app")
  }
  if (is.null(installTo)) {
    stop("electricShine::buildPackage() requires you to specify a 'path' argument.
(e.g. electricShine::electricShine(path = 'C:/Users/me/Desktop/my_app') )")
  }
  if (is.null(version)) {
    stop("electricShine::buildPackage() requires you to specify a 'version' argument.
           (e.g. electricShine::electricShine(version = '1.0.0') )")
  }
  if (is.null(functionName)) {
    stop("electricShine::buildPackage() requires you to specify a 'functionName' argument.
         functionName should be the name of the function that starts your package's shiny app.
         e.g. is you have the function myPackage::start_shiny(), provide 'start_shiny'")
  }



  electricShine::get_nodejs()


  electricShine::create_folder(path = installTo,
                               name = appName)

  appPath <- file.path(installTo,
                       appName)

  appPath <-  normalizePath(appPath,
                            mustWork = FALSE)



# Create build directory structure ----------------------------------------

  electricShine::create_build_directory(name = appName,
                                        description = description,
                                        productName = productName,
                                        version = version,
                                        appPath = appPath,
                                        functionName = functionName)





# Download and Install R --------------------------------------------------

  electricShine::installR(date = MRANdate,
                          path = appPath)

# Trim R's size -----------------------------------------------------------

  electricShine::trim_r(pathToR = file.path(appPath,
                                            "r_win"))



# Install shiny app/package and dependencies ------------------------------


  electricShine::install_user_app(appPath = appPath,
                                  MRANdate = MRANdate,
                                  MRANdate = MRANdate)


# Download npm dependencies -----------------------------------------------

  try(
    electricShine::buildElectronDependencies(appPath = appPath)
  )


# Build the electron app --------------------------------------------------

  electricShine::runBuild(nodePath = NULL,
                          npmPath = NULL,
                          appPath = appPath,
                          node = file.path(system.file(package = "electricShine"), "nodejs"))

  message("You should now have both a transferable and distributable installer Electron app.")

}
