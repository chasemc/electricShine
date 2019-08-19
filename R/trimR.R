#' Remove html and pdf files from R installation
#'
#' @param app_root_path path to the copied R installation

#'
#' @return nothing
#' @export
#'
trim_r <- function(app_root_path
                   #only64
                   ){

  
  r_lang_path <- file.path(app_root_path,
                           "r_lang",
                           fsep = "/")
  
  a <- list.files(r_lang_path,
                  recursive = T,
                  full.names = T)
  pre <- sum(file.size(a))

  # Remove .html ------------------------------------------------------------
  temp <- base::list.files(r_lang_path,
                           recursive = TRUE,
                           pattern = ".html",
                           full.names = TRUE)
  removed <- base::file.remove(temp)

  message("Removed: \n", base::paste0(temp[removed], collapse = "\n"))

  # Remove .pdf ------------------------------------------------------------
  temp <- base::list.files(r_lang_path,
                           recursive = TRUE,
                           pattern = ".pdf",
                           full.names = TRUE)
  removed <- base::file.remove(temp)
  base::message("Removed: \n", base::paste0(temp[removed], collapse = "\n"))


  # Remove 32-bit dlls ------------------------------------------------------

  # if(only64) {
  # 
  #   temp <- list.dirs(r_lang_path, recursive = T, full.names = T)
  #   temp2 <- basename(temp)
  #   temp <- temp[temp2 == "i386"]
  #   temp <- base::list.files(temp,
  #                            recursive = TRUE,
  #                            full.names = TRUE)
  #   removed <- base::file.remove(temp)
  #   base::message("Removed: \n", base::paste0(temp, collapse = "\n"))
  # }

  a <- list.files(r_lang_path,
                  recursive = T,
                  full.names = T)

  post <- sum(file.size(a))
  base::message("Trimmed ", (pre-post) , "bytes")



}
