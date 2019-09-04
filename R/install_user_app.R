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
  
  remotes_code <- getFromNamespace(remotes_code, ns = "remotes")
  
  repo <- as.list(repo)
  
  passthr <- c(repo, repos = repos ,package_install_opts)
  
  withr::with_libpaths(library_path,
                       do.call(remotes_code, passthr)
  )
  
}
