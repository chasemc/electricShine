#' Install shiny app package and dependencies
#'
#' @param library_path path to the new Electron app's R's library folder
#' @param site {remotes} package function, one of c("github", "gitlab", "bitbucket", "local")
#' @param repo e.g. if site is github: "chasemc/demoApp" ; if site is local: "C:/Users/chase/demoApp"
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
#' install_user_app(site = "github", 
#'                  repo = "chasemc/demoApp@@d81fff0")
#'                  
#' install_user_app(site = "github", 
#'                  repo = "chasemc/demoApp@@d81fff0",
#'                  auth_token = "my_secret_token")                  
#'                  
#' install_user_app(site = "bitbucket", 
#'                  repo = "chasemc/demoApp",
#'                  auth_user = bitbucket_user(), 
#'                  password = bitbucket_password())        
#'                  
#' install_user_app(site = "gitlab", 
#'                  repo = "chasemc/demoApp",
#'                  auth_token = "my_secret_token")   

#' install_user_app(site = "local", 
#'                  repo = "C:/Users/chase/demoApp",
#'                  build_vignettes = TRUE)                                      
#' }
#' 
install_user_app <- function(library_path = NULL,
                             site = "github",
                             repo = "chasemc/IDBacApp",
                             repos = cran_like_url,
                             package_install_opts = NULL){
  
  accepted_sites <- c("github", "gitlab", "bitbucket", "local")
  
  
  if(is.null(library_path)) {
    stop("install_user_app() requires library_path to be set.")
  }
  
  if(file.exists(library_path)) {
    stop("install_user_app() library_path wasn't found.")
  }
  
  if (length(site) != 1L) {
    stop(glue::glue("install_user_app(site) must be character vector of length 1"))
  }
  
  if (!site %in% accepted_sites) {
    stop(glue::glue("install_user_app(site) must be one of: {accepted_sites}"))
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
  
  
  if (length(package_install_opts) > 0) {
    
    provided_args_names <- names(package_install_opts)
    
    fun_args <- names(formals(eval(parse(text = glue::glue("remotes::install_{site}")))))
    
    package_install_opts <- package_install_opts[provided_args_names %in% fun_args]
    
    valid_args <- paste0(names(package_install_opts), 
                         sep = " = ")
    
    valid_args <- paste0(valid_args, 
                         package_install_opts,
                         collapse = ", \n ")
    
    remotes_code <- glue::glue("remotes::install_{site}('{repo}', {valid_args})")
    
    
    
    withr::with_libpaths(library_path,
                         eval(parse(text = remotes_code))
    )
    
  } else {
    
    remotes_code <- glue::glue("remotes::install_{site}('{repo}')")
    
    withr::with_libpaths(library_path,
    eval(parse(text = remotes_code))
    )
  }
  
  
  
}
