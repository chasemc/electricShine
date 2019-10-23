
#' Install from isolated lib
#'
#' @return na
#' @export
#'

install_package <- function(){
  passthr <-  Sys.getenv(c("ESHINE_PASSTHRUPATH"))
  remotes_code <-  Sys.getenv(c("ESHINE_remotes_code"))
  
  if (!nchar(passthr) > 0 ) {
    stop("Empty path") 
  }  
  passthr <- normalizePath(passthr, 
                           winslash = "/")
  
  load(passthr)
  
  remotes_code <- getFromNamespace(remotes_code,
                                   ns = "remotes")

  
   do.call(remotes_code, passthr)
  

}
