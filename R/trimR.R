#' Remove html and pdf files from R installation
#'
#' @param pathToR path to the copied R installation
#'
#' @return nothing
#' @export
#'
trim_r <- function(pathToR){

  html <- base::list.files(pathToR,
                           recursive = TRUE,
                           pattern = ".html",
                           full.names = TRUE)
  removed <- base::file.remove(html)

  message("Removed: \n", base::paste0(html[removed], collapse = "\n"))

  pdf <- base::list.files(pathToR,
                          recursive = TRUE,
                          pattern = ".pdf",
                          full.names = TRUE)
  removed <- base::file.remove(pdf)
  base::message("Removed: \n", base::paste0(pdf[removed], collapse = "\n"))

}
