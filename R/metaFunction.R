#' Meta-function
#'
#' @param build_path path to create installer, preferably points to an empty directory
#' @param app_name electron app name
#' @param product_name necessary?
#' @param semantic_version semantic version of your app, as character (not numeric!)
#' @param mran_date MRAN snapshot date, formatted as 'YYYY-MM-DD'
#' @param github_repo GitHub username/repo of your the shiny-app package (e.g. 'chasemc/demoAPP')
#' @param local_path path to local shiny-app package
#' @param function_name the function name in your package that starts the shiny app
#' @param package_name name of your R package, because a git repo doesn't have to be the same as the package name
#' @param build logical, whether to start the build process, helpful if you want to modify anthying before building
#' @param description short app description
#'
#' @return Nothing
#' @export
#'
buildElectricApp <- function(app_name = "My_Package",
                             product_name = "product_name",
                             description = "description",
                             semantic_version = "0.0.0",
                             build_path = NULL,
                             mran_date = Sys.Date() - 3,
                             function_name = NULL,
                             github_repo = NULL,
                             local_path  = NULL,
                             #  only64 = FALSE, taken out for now, some pkgs need the 32 bit dlls
                             package_name = NULL,
                             build = TRUE){
  
  if (is.null(github_repo) && is.null(local_path)) {
    stop("electricShine::buildElectricApp() requires you to specify either a 'github_repo' or 'local_path' argument specifying
         the shiny app/package to be turned into an Electron app")
  }
  if (is.null(build_path)) {
    stop("electricShine::buildElectricApp() requires you to specify a 'path' argument.
(e.g. electricShine::electricShine(path = 'C:/Users/me/Desktop/my_app') )")
  }
  if (is.null(version)) {
    stop("electricShine::buildElectricApp() requires you to specify a 'version' argument.
           (e.g. electricShine::electricShine(version = '1.0.0') )")
  }
  if (is.null(function_name)) {
    stop("electricShine::buildElectricApp() requires you to specify a 'function_name' argument.
         function_name should be the name of the function that starts your package's shiny app.
         e.g. is you have the function myPackage::start_shiny(), provide 'start_shiny'")
  }
  if (is.null(package_name)) {
    stop("electricShine::buildElectricApp() requires you to specify a 'package_name' argument.
           (e.g. electricShine::electricShine(package_name = 'myPackage') )")
  }
  
  os <- electricShine::get_os()
  
  
  electricShine::get_nodejs()
  
  
  # create top-level build folder for app 
  app_root_path <- file.path(build_path,
                             app_name)
  electricShine::create_folder(app_root_path)
  
  
  # Copy Electron template into app_root_path -------------------------------------
  
  electricShine::copy_template(app_root_path)
  
  # Download and Install R --------------------------------------------------
  
  electricShine::install_r(mran_date = mran_date,
                           app_root_path = app_root_path,
                           mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz")
  
  # Trim R's size -----------------------------------------------------------
  
  
  electricShine::trim_r(app_root_path = app_root_path
                        #only64 = only64
  )
  
  # Install shiny app/package and dependencies ------------------------------
  
  electricShine::install_user_app(app_root_path = app_root_path,
                                  mran_date = mran_date,
                                  github_repo = github_repo,
                                  local_path = local_path)
  
  
  if (identical(os, "win")) {
    
    # transfer icons if present
    library_path <- base::file.path(app_root_path,
                                    "app",
                                    "r_win",
                                    "library",
                                    fsep = "/")
  }
  
  if (identical(os, "mac")) {
    
    library_path <- file.path(app_root_path, "r_lang/Library/Frameworks/R.framework/Versions")
    library_path <-  list.dirs( library_path, recursive = FALSE)[[1]]
    library_path <- file.path(library_path, "Resources/library", fsep = "/")
    
  }  
  
  electron_build_resources <- system.file("extdata", 
                                          "icon",
                                          package = package_name,
                                          lib.loc = library_path)
  
  if (nchar(electron_build_resources) == 0) {
  } else {
    electron_build_resources <- base::list.files(electron_build_resources, 
                                                 full.names = TRUE)
    resources <- base::file.path(app_root_path, 
                                 "resources")
    base::dir.create(resources)
    base::file.copy(from = electron_build_resources,
                    to = resources)
  }
  
  
  # Create package.json -----------------------------------------------------
  electricShine::create_package_json(app_name = app_name,
                                     semantic_version = semantic_version,
                                     app_root_path = app_root_path,
                                     description = "description")
  
  
  
  # Add function that runs the shiny app to description.js ------------------
  
  electricShine::modify_background_js(background_js_path = file.path(app_root_path,
                                                                    "src", 
                                                                    "background.js"),
                                     package_name = package_name,
                                     function_name = function_name)
  
  # Download npm dependencies -----------------------------------------------
  
  
  electricShine::buildElectronDependencies(app_root_path = app_root_path)
  
  
  # Build the electron app --------------------------------------------------
  if (build == TRUE) {
    electricShine::run_build(node_path = NULL,
                            npm_path = NULL,
                            app_path = app_root_path,
                            node = file.path(system.file(package = "electricShine"), "nodejs"))
    
    message("You should now have both a transferable and distributable installer Electron app.")
  } else {
    message("Build step was skipped. When you are ready to build the distributable run 'electricShine::runBuild(...)'")
  }
  
  
  
  
  
}
