#' Remove html and pdf files from R installation
#'
#' @param pathToR path to the copied R installation
#' @param only64 if TRUE, remove 32-bit dlls; if FALSE do not remove 32-bit dlls
#'
#' @return nothing
#' @export
#'
trim_r <- function(pathToR,
                   only64){

  a <- list.files(pathToR,
                  recursive = T,
                  full.names = T)
  pre <- sum(file.size(a))

  # Remove .html ------------------------------------------------------------
  temp <- base::list.files(pathToR,
                           recursive = TRUE,
                           pattern = ".html",
                           full.names = TRUE)
  removed <- base::file.remove(temp)

  message("Removed: \n", base::paste0(temp[removed], collapse = "\n"))

  # Remove .pdf ------------------------------------------------------------
  temp <- base::list.files(pathToR,
                           recursive = TRUE,
                           pattern = ".pdf",
                           full.names = TRUE)
  removed <- base::file.remove(temp)
  base::message("Removed: \n", base::paste0(temp[removed], collapse = "\n"))


  # Remove 32-bit dlls ------------------------------------------------------

  if(only64) {

    temp <- list.dirs(pathToR, recursive = T, full.names = T)
    temp2 <- basename(temp)
    temp <- temp[temp2 == "i386"]
    temp <- base::list.files(temp,
                             recursive = TRUE,
                             full.names = TRUE)
    removed <- base::file.remove(temp)
    base::message("Removed: \n", base::paste0(temp, collapse = "\n"))
  }

  a <- list.files(pathToR,
                  recursive = T,
                  full.names = T)

  post <- sum(file.size(a))
  base::message("Trimmed ", (pre-post) , "bytes")



}
