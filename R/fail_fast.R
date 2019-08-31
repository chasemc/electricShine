

#' Functions to fail script at beginning
#'
#'
#' @param arguments 
#'
#' @return stops scripting function ASAP
.fail_fast <- function(arguments){
  
  os <- electricShine::get_os()
  # These checks can be found in this document, below this wrapper function.
  .check_arch()  
  .check_repo_set(...)  
  .check_build_path_exists(...)
}



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
  # Ensure that 'cran_like_url' and 'mran_date' can't be set at the same time.
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
#' @return
.check_build_path_exists <- function(arguments){
  
  
  build_path <- arguments$build_path
  
  if (is.null(build_path)) {
    base::stop("'build_path' not provided")
  }
  
  if (!is.character(build_path)) {
    base::stop("'build_path' should be character type.")
  }
  
   
  if (!is.character(build_path)) {
    base::stop("'build_path' should be character type.")
  }
  
  if (!dir.exists(build_path)) {
    base::stop("'build_path' provided, but path wasn't found.")
  }
}



