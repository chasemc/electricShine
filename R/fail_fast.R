#' Check that repo is set
#'
#'    Doesn't check whether it works, only that it is not-null
#'
#' @param arguments arguments to check 
#'
#' @return stops if neither cran-like url or mran date is set
.check_repo_set <- function(arguments){
  
  cran_like_url <- arguments$cran_like_url
  mran_date <- arguments$mran_date
  
  # Either 'cran_like_url' or 'mran_date' must be set
  if (is.null(c(cran_like_url, mran_date))) {
    base::stop("'cran_like_url' or 'mran_date' must be set. 'mran_date' is suggested and should be a date in the format 'yyyy-mm-dd' ") 
  }
  
  # Ensure that 'cran_like_url' and 'mran_date' aren't set at the same time.
  if (!is.null(cran_like_url) && !is.null(mran_date)) {
    stop("Values provided for both 'cran_like_url' and 'mran_date'.") 
  }
  
}



#' Check if compatible architecture
#'
#' @param arch only used for unit testing
#'
#' @return Stops if unsupported architecture
.check_arch <- function(arch = base::version$arch[[1]]){
 
   if (arch != "x86_64") {
    base::stop("Unfortunately 32 bit operating system builds are unsupported, if you would like to contribute to support this, that would be cool")
   }
  
}


#' Check whether build path exists
#'
#' @param arguments arguments to check 
#'
#' @return stops 
.check_build_path_exists <- function(arguments){
  
  build_path <- arguments$build_path
  
  if (is.null(build_path)) {
    base::stop("'build_path' not provided")
  }
  
  if (!is.character(build_path)) {
    base::stop("'build_path' should be character type.")
  }
 
  if (!dir.exists(build_path)) {
    base::stop("'build_path' provided, but path wasn't found.")
  }
}





#' Check package paths
#'
#'    Doesn't check whether it works, only for conflicts in arguments
#'
#' @param arguments arguments to check 
#'
#' @return stops 
.check_package_provided <- function(arguments){
  
  github_repo <- arguments$github_repo
  local_package <- arguments$local_package
  
  # Either 'github_repo' or 'local_package' must be set
  if (is.null(c(github_repo, local_package))) {
    base::stop("electricShine requires you to specify either a 'github_repo' or 'local_package' argument specifying
         the shiny app/package to be turned into an Electron app") 
  }
  
  # Ensure that 'github_repo' and 'local_package' aren't set at the same time.
  if (!is.null(github_repo) && !is.null(local_package)) {
    stop("Values provided for both 'github_repo' and 'local_package'; electricShine requires that only one of these is not NULL.") 
  }
  
}



