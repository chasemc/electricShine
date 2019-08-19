
#' Modify background.js to include the call to the shiny app
#'
#' @param background_js_path path to the final background.js, not the one in inst/...
#' @param package_name package name, will be used for namespacing- (e.g. 'dplyr' in 'dplyr::filter()')
#' @param function_name function that runs your shiny app - (e.g. 'filter' in 'dplyr::filter()')
#' @param r_path path from "r_lang" folder to the R/Rscript executable
#'
#' @return none, side effect
#' @export
#'
modify_background_js <- function(background_js_path,
                                 package_name,
                                 function_name,
                                 r_path){
  if (!file.exists(background_js_path)) {
    stop("addFunctionToBackgroundJs() failed because background_js_path didn't point to an existing file.")
  }
  
  b <- readLines(background_js_path)
  
  R_SHINY_FUNCTION <- paste0(package_name, 
                             "::",
                             function_name)
  
  
  b <- sapply(b, function(x) glue::glue(x, 
                                        .open = "<?<",
                                        .close = ">?>")
  )
  
  writeLines(b, background_js_path)
  
}