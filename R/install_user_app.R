#' Install shiny app package and dependencies
#'
#' @param library_path path to the new Electron app's R's library folder
#' @param repo_location {remotes} package function, one of c("github", "gitlab", "bitbucket", "local")
#' @param repo e.g. if repo_location is github: "chasemc/demoApp" ; if repo_location is local: "C:/Users/chase/demoApp"
#' @param repos cran like repository package dependencies will be retrieved from  
#' @param package_install_opts further arguments to remotes::install_github, install_gitlab, install_bitbucket, or install_local
#'
#' @return App name

#' @export
#'
#' @examples
#' 
#'\dontrun{
#'
#' install_user_app(repo_location = "github", 
#'                  repo = "chasemc/demoApp@@d81fff0")
#'                  
#' install_user_app(repo_location = "github", 
#'                  repo = "chasemc/demoApp@@d81fff0",
#'                  auth_token = "my_secret_token")                  
#'                  
#' install_user_app(repo_location = "bitbucket", 
#'                  repo = "chasemc/demoApp",
#'                  auth_user = bitbucket_user(), 
#'                  password = bitbucket_password())        
#'                  
#' install_user_app(repo_location = "gitlab", 
#'                  repo = "chasemc/demoApp",
#'                  auth_token = "my_secret_token")   

#' install_user_app(repo_location = "local", 
#'                  repo = "C:/Users/chase/demoApp",
#'                  build_vignettes = TRUE)                                      
#' }
#' 
install_user_app <- function(library_path = NULL,
                             repo_location = "github",
                             repo = "chasemc/IDBacApp",
                             repos = cran_like_url,
                             package_install_opts = NULL){
  
  accepted_sites <- c("github", "gitlab", "bitbucket", "local")
  
  
  if (is.null(library_path)) {
    stop("install_user_app() requires library_path to be set.")
  }
  
  if (!dir.exists(library_path)) {
    stop("install_user_app() library_path wasn't found.")
  }
  
  if (length(repo_location) != 1L) {
    stop(glue::glue("install_user_app(repo_location) must be character vector of length 1"))
  }
  
  if (!repo_location %in% accepted_sites) {
    stop(glue::glue("install_user_app(repo_location) must be one of: {accepted_sites}"))
  }
  
  if (!nchar(repo) > 0) {
    # TODO: Maybe make this a regex?
    stop("install_user_app(repo) must be character with > 0 characters")
  }
  
  if (!is.null(package_install_opts)) { 
    if (!is.list(package_install_opts)) {
      stop("package_install_opts  must be a list of arguments.")
    }
  }
  
  remotes_code <- as.character(glue::glue("install_{repo_location}"))
  
  
  
  repo <- as.list(repo)
  
  passthr <- c(repo, repos = repos,
               c(package_install_opts, 
                 list(force = TRUE,
                      lib = library_path)
               )
  )
  
  os <- electricShine::get_os()  
  
  if (identical(os, "win")) {
    rscript_path <- file.path(dirname(library_path),
                              "bin",
                              "Rscript.exe")
  }
  
  if (identical(os, "mac")) {
    rscript_path <- file.path(dirname(library_path),
                              "bin",
                              "R")
  }
  
  if (identical(os, "unix")) {
    stop("electricShine is still under development for linux systems")
    
  }
  
  
  tmp_file <- tempfile()
  save(list = c("remotes_code",
                "passthr"),
       file = tmp_file)
  
  
  
  remotes_library <- copy_remotes_package()
  
  copy_electricshine_package()
  
  
  old_libs <- Sys.getenv("R_LIBS")
  old_libs_user <- Sys.getenv("R_LIBS_USER")
  Sys.setenv(R_LIBS=library_path)
  Sys.setenv(R_LIBS_USER=remotes_library)
  Sys.setenv(R_LIBS_SITE=remotes_library)
  message("Installing your Shiny package into electricShine framework.")
  
  
  Sys.setenv(ESHINE_PASSTHRUPATH=tmp_file)
  
  Sys.setenv(ESHINE_remotes_code=remotes_code)
  
 z <- system2(rscript_path,
              paste0(" -e " ,"'","electricShine::install_package()","'"),
          wait = TRUE,
          stdout = FALSE)

  
  Sys.setenv(R_LIBS=old_libs)
  Sys.setenv(R_LIBS_USER=old_libs_user)
  
  
  message("Finshed: Installing your Shiny package into electricShine framework")
  return(z)
}




#' Copy {remotes} package to an isolated folder.
#'    This is necessary to avoid dependency-install issues
#'
#' @return path of new {remotes}-only library
copy_remotes_package <- function(){
  remotes_path <- system.file(package = "remotes")
  
  new_path <- file.path(tempdir(), 
                        "electricShine")
  dir.create(new_path)
  
  new_path <- file.path(tempdir(), 
                        "electricShine",
                        "templib")
  dir.create(new_path)
  
  file.copy(remotes_path,
            new_path, 
            recursive = TRUE,
            copy.mode = F)
  
  test <- file.path(new_path, 
                    "remotes")
  if (!file.exists(test)) {
    stop("Wasn't able to copy remotes package.")
  }
  normalizePath(new_path,
                winslash = "/")
}



#' Copy {electricShine} package to an isolated folder.
#'    This is necessary to avoid dependency-install issues
#'
#' @return path of new {electricShine}-only library
copy_electricshine_package <- function(){
  remotes_path <- system.file(package = "electricShine")
  
  new_path <- file.path(tempdir(), 
                        "electricShine")
  dir.create(new_path)
  
  new_path <- file.path(tempdir(), 
                        "electricShine",
                        "templib")
  dir.create(new_path)
  
  file.copy(remotes_path,
            new_path, 
            recursive = TRUE,
            copy.mode = F)
  
  test <- file.path(new_path, 
                    "electricShine")
  if (!file.exists(test)) {
    stop("Wasn't able to copy electricShine package.")
  }
  invisible(normalizePath(new_path,
                          winslash = "/"))
}

