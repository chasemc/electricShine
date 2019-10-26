
#' Construct MRAN url if snapshot date provided
#'
#' @param mran_date MRAN snapshot date (e.g. "2019-08-05")
#' @param cran_like_url url to CRAN-like repository
#'
#' @return CRAN-like url
#' @export
#'
#' @examples
#' 
#' construct_mran_url(mran_date = "2019-08-05")
#' 
#' construct_mran_url(cran_like_url = "https://cloud.r-project.org")
#' 
construct_mran_url <- function(mran_date = NULL,
                                    cran_like_url = NULL){
  
  .check_repo_set(cran_like_url = cran_like_url,
                  mran_date = mran_date) 
  
  if (!is.null(mran_date)) {
    cran_like_url <- glue::glue("https://cran.microsoft.com/snapshot/{mran_date}")
  }
  return(cran_like_url)
  
}