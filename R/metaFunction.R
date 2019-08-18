#' Meta-function
#'
#' @param buildPath path to create installer, preferably points to an empty directory
#' @param appName electron app name
#' @param productName necessary?
#' @param semanticVersion semantic version of your app, as character (not numeric!)
#' @param MRANdate MRAN snapshot date, formatted as 'YYYY-MM-DD'
#' @param githubRepo GitHub username/repo of your the shiny-app package (e.g. 'chasemc/demoAPP')
#' @param localPath path to local shiny-app package
#' @param functionName the function name in your package that starts the shiny app
#' @param only64 if TRUE, remove 32-bit dlls; if FALSE do not remove 32-bit dlls
#' @param packageName can be empty if Github repo/base path is same as your shiny package name
#' @param build logical, whether to start the build process, helpful if want to mod before building
#' @param description short app description
#'
#' @return Nothing
#' @export
#'
buildElectricApp <- function(appName = "My_Package",
                             productName = "productName",
                             description = "description",
                             semanticVersion = "0.0.0",
                             buildPath = NULL,
                             MRANdate = Sys.Date() - 3,
                             functionName = NULL,
                             githubRepo = NULL,
                             localPath  = NULL,
                             only64 = FALSE,
                             packageName = NULL,
                             build = TRUE){

  if (is.null(githubRepo) && is.null(localPath)) {
    stop("electricShine::buildElectricApp() requires you to specify either a 'githubRepo' or 'localPath' argument specifying
         the shiny app/package to be turned into an Electron app")
  }
  if (is.null(buildPath)) {
    stop("electricShine::buildElectricApp() requires you to specify a 'path' argument.
(e.g. electricShine::electricShine(path = 'C:/Users/me/Desktop/my_app') )")
  }
  if (is.null(version)) {
    stop("electricShine::buildElectricApp() requires you to specify a 'version' argument.
           (e.g. electricShine::electricShine(version = '1.0.0') )")
  }
  if (is.null(functionName)) {
    stop("electricShine::buildElectricApp() requires you to specify a 'functionName' argument.
         functionName should be the name of the function that starts your package's shiny app.
         e.g. is you have the function myPackage::start_shiny(), provide 'start_shiny'")
  }


  electricShine::get_nodejs()


  
  appPath <- file.path(buildPath,
                       appName)
  electricShine::create_folder(appPath)

  



  # Copy Electron template into appPath -------------------------------------

  electricShine::copy_template(appPath)


  # Create app.r ------------------------------------------------------------
  # app.r gets put into the app folder
  temp <- file.path(appPath,
                    "app")

  if (!is.null(packageName)) {
    if (!is.null(githubRepo)) {
      packageName <- basename(githubRepo)
    }
    if (!is.null(localPath)) {
      packageName <- basename(localPath)
    }
  }
  electricShine::run_shiny(packageName = packageName,
                           path = temp,
                           functionName = functionName)

  # Download and Install R --------------------------------------------------

  # R gets put into the app folder
  temp <- file.path(appPath,
                    "app")

  electricShine::installR(date = MRANdate,
                          path = temp)

  # Trim R's size -----------------------------------------------------------
  temp <- file.path(appPath,
                    "app",
                    "r_win")

  electricShine::trim_r(pathToR = temp,
                        only64 = only64)

  # Install shiny app/package and dependencies ------------------------------

  electricShine::install_user_app(appPath = appPath,
                                  MRANdate = MRANdate,
                                  githubRepo = githubRepo,
                                  localPath = localPath)

  # transfer icons if present
  buildResources <- system.file("extdata", 
                                "icon",
                                package = packageName,
                                lib.loc = base::file.path(appPath,
                                                          "app",
                                                          "r_win",
                                                          "library"))

  if (nchar(buildResources) == 0) {
  } else {
    buildResources <- base::list.files(buildResources, full.names = TRUE)
    resources <- base::file.path(appPath, "resources")
    base::dir.create(resources)
    file.copy(buildResources, resources)
  }


  # Create package.json -----------------------------------------------------
  electricShine::create_package_json(appName = appName,
                                     semanticVersion = semanticVersion,
                                     path = appPath,
                                     description = "description")

  

# Add function that runs the shiny app to description.js ------------------

  electricShine::addFunctionToBackgroundJs(backgroundjsPath = file.path(appPath,
                                                                        "src", 
                                                                        "background.js"),
                                           packageName = packageName,
                                           functionName = functionName)
  
  # Download npm dependencies -----------------------------------------------


    electricShine::buildElectronDependencies(appPath = appPath)


  # Build the electron app --------------------------------------------------
if (build == TRUE) {
  electricShine::runBuild(nodePath = NULL,
                          npmPath = NULL,
                          appPath = appPath,
                          node = file.path(system.file(package = "electricShine"), "nodejs"))

  message("You should now have both a transferable and distributable installer Electron app.")
} else {
  message("Build step was skipped. When you are ready to build the distributable run 'electricShine::runBuild(...)'")
}
  
  
  
  
  
}
