#' Meta-function
#'
#' @param build_path Path where the build files will be created, preferably points to an empty directory.
#'     Must not contain a folder with the name as what you put for electrify(app_name).
#' @param app_name This will be the name of the executable. It's a uniform type identifier (UTI)
#'    that contains only alphanumeric (A-Z,a-z,0-9), hyphen (-), and period (.) characters.
#'    see https://www.electron.build/configuration/configuration 
#'    and https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070
#' @param product_name String - allows you to specify a product name for your executable which
#'    contains spaces and other special characters not allowed in the name property.
#'    https://www.electron.build/configuration/configuration
#' @param semantic_version semantic version of your app, as character (not numeric!);
#'     See https://semver.org/ for more info on semantic versioning.
#' @param mran_date MRAN snapshot date, formatted as 'YYYY-MM-DD'
#' @param git_host one of c("github", "gitlab", "bitbucket")
#' @param git_repo GitHub/Bitbucket/GitLab username/repo of your the shiny-app package (e.g. 'chasemc/demoAPP'). 
#'     Can also use notation for commits/branch (i.e. "chasemc/demoapp@@d81fff0).
#' @param local_package_path path to local shiny-app package, if 'git_package' isn't used 
#' @param package_install_opts optional arguments passed to remotes::install_github, install_gitlab, install_bitbucket, or install_local
#' @param function_name the function name in your package that starts the shiny app
#' @param run_build logical, whether to start the build process, helpful if you want to modify anthying before building
#' @param short_description short app description
#' @param cran_like_url url to cran-like repository 
#' @param nodejs_path path to nodejs
#' @param nodejs_version nodejs version to install
#' @param permission automatically grant permission to install nodejs and R 
#' @param mac_url url to mac OS tar.gz 
#'
#' @export
#'
electrify <- function(app_name = NULL,
                      product_name = "product_name",
                      short_description = NULL,
                      semantic_version = NULL,
                      build_path = NULL,
                      mran_date = NULL,
                      cran_like_url = NULL,
                      function_name = NULL,
                      git_host = NULL,
                      git_repo = NULL,
                      local_package_path = NULL,
                      package_install_opts = NULL,
                      run_build = TRUE,
                      nodejs_path = file.path(system.file(package = "electricShine"), "nodejs"),
                      nodejs_version = "v12.16.2",
                      permission = FALSE,
                      mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz"){
  
  
  
  # Check and fail early ---------------------------------------------------
  
  
  .check_arch()  
  .check_repo_set(cran_like_url = cran_like_url,
                  mran_date = mran_date)  
  
  .check_build_path_exists(build_path = build_path)
  
  
  .check_package_provided(git_host = git_host,
                          git_repo = git_repo,
                          local_package_path = local_package_path)
  
  if (is.null(app_name)) {
    stop("electricShine::electrify() requires you to provide an 'app_name' argument specifying
         the shiny app/package name.")
  }
  
  if (is.null(semantic_version)) {
    stop("electricShine::electrify() requires you to specify a 'semantic_version' argument.
           (e.g. electricShine::electricShine(semantic_version = '1.0.0') )")
  }
  
  if (is.null(function_name)) {
    stop("electricShine::electrify() requires you to specify a 'function_name' argument.
         function_name should be the name of the function that starts your package's shiny app.
         e.g. is you have the function myPackage::start_shiny(), provide 'start_shiny'")
  }
  
  
  if (is.null(nodejs_path)) {
    file.path(system.file(package = "electricShine"), "nodejs")
  }
  
  if (!is.null(package_install_opts)) { 
    if (!is.list(package_install_opts)) {
      stop("package_install_opts in electrify() must be a list of arguments.")
    }
  }
  
  app_root_path <- file.path(build_path,
                             app_name)
  
  if (!isTRUE(permission)) {
    
    permission_to_install_r <- .prompt_install_r(app_root_path)
    permission_to_install_nodejs <- .prompt_install_nodejs(nodejs_path)
    
  } else {
    permission_to_install_r <- TRUE
    permission_to_install_nodejs <- TRUE
    
  }
  # Determine Operating System ----------------------------------------------
  
  os <- electricShine::get_os()  
  
  # Set cran_like_url -------------------------------------------------------
  
  # If MRAN date provided, construct MRAN url. Else, pass through cran_like_url.
  cran_like_url <- construct_mran_url(mran_date = mran_date,
                                      cran_like_url = cran_like_url)
  
  
  
  # Create top-level build folder for app  ----------------------------------
  
  
  electricShine::create_folder(app_root_path)
  
  # Copy Electron template into app_root_path -------------------------------------
  electricShine::copy_template(app_root_path)
  
  # Download and Install R --------------------------------------------------
  electricShine::install_r(cran_like_url = cran_like_url,
                           app_root_path = app_root_path,
                           mac_url = mac_url,
                           permission_to_install = permission_to_install_r)
  
  # Trim R's size -----------------------------------------------------------
  electricShine::trim_r(app_root_path = app_root_path)
  
  
  
  # Find Electron app's R's library folder ----------------------------------
  
  if (identical(os, "win")) {
    
    library_path <- base::file.path(app_root_path,
                                    "app",
                                    "r_lang",
                                    "library",
                                    fsep = "/")
  }
  
  if (identical(os, "mac")) {
    
    library_path <- file.path(app_root_path, 
                              "app/r_lang/Library/Frameworks/R.framework/Versions")
    
    library_path <-  list.dirs(library_path, 
                               recursive = FALSE)
    
    library_path <- library_path[grep("\\d+\\.(?:\\d+|x)(?:\\.\\d+|x){0,1}",
                                      library_path)][[1]]
    
    library_path <- file.path(library_path,
                              "Resources/library", 
                              fsep = "/")
  }  
  
  # Install shiny app/package and dependencies ------------------------------
  
  
  if (!base::is.null(git_host)) {
    
    my_package_name <-  electricShine::install_user_app(library_path = library_path,
                                                        repo_location = git_host,
                                                        repo = git_repo,
                                                        repos = cran_like_url,
                                                        package_install_opts = package_install_opts)
  }
  
  
  if (!is.null(local_package_path)) {
    
    my_package_name <- electricShine::install_user_app(library_path = library_path ,
                                                       repo_location = "local",
                                                       repo = local_package_path,
                                                       repos = cran_like_url,
                                                       package_install_opts = package_install_opts)
  }
  
  
  
  # Transfer icons if present -----------------------------------------------
  
  
  electron_build_resources <- system.file("extdata", 
                                          "icon",
                                          package = my_package_name,
                                          lib.loc = library_path)
  
  if (nchar(electron_build_resources) == 0) {
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
                                      my_package_name = my_package_name,
                                      function_name = function_name,
                                      r_path = base::dirname(library_path))
  
  
  # Download and unzip nodejs -----------------------------------------------
  
  nodejs_path <- electricShine::install_nodejs(node_url = "https://nodejs.org/dist",
                                               nodejs_path = nodejs_path,
                                               force_install = FALSE,
                                               nodejs_version = nodejs_version,
                                               permission_to_install = permission_to_install_nodejs)
  
  
  # Build the electron app --------------------------------------------------
  if (run_build == TRUE) {
    
    electricShine::run_build_release(nodejs_path = nodejs_path,
                                     app_path = app_root_path,
                                     nodejs_version = nodejs_version)
    
    message("You should now have both a transferable and distributable installer Electron app.")
    
  } else {
    
    message("Build step was skipped. When you are ready to build the distributable run 'electricShine::runBuild(...)'")
    
  }
  
}
