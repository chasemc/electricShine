
#' Modify background.js to include the call to the shiny app
#'
#' @param backgroundjsPath path to the final background.js, not the one in inst/...
#' @param packageName package name, will be used for namespacing- (e.g. 'dplyr' in 'dplyr::filter()')
#' @param functionName function that runs your shiny app - (e.g. 'filter' in 'dplyr::filter()')
#'
#' @return none, side effect
#' @export
#'
addFunctionToBackgroundJs <- function(backgroundjsPath,
                                      packageName,
                                      functionName){
  if (!file.exists(backgroundjsPath)) {
    stop("addFunctionToBackgroundJs() failed because backgroundjsPath didn't point to an existing file.")
  }
  
  b <- readLines(backgroundjsPath)
  
  R_SHINY_FUNCTION <- paste0(packageName, "::", functionName)
  
  
  b <- sapply(b, function(x) glue::glue(x, 
                                        .open = "<?<",
                                        .close = ">?>")
              )
  
  writeLines(b, backgroundjsPath)
  
}