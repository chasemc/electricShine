



#' Prompt whether R can be installed or not
#'
#' @param app_root_path project path
#'
#' @return TRUE/FALSE
#' 
.prompt_install_r <- function(app_root_path) {
  
  app_root_path <- file.path(app_root_path, "app", "r_lang")
  app_root_path <- normalizePath(app_root_path, winslash = "/", mustWork = FALSE)
  
  if (!interactive()) {
    return(TRUE)
  } else {
    mess <- glue::glue("Install R into electricShine app folder: {app_root_path}? (y/n)..")
    answer <- readline(mess)
    if (tolower(substr(answer, 1, 1)) == "y") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}


#' Prompt whether nodejs can be installed or not
#'
#' @param nodejs_path nodejs install path
#'
#' @return TRUE/FALSE
#'
.prompt_install_nodejs <- function(nodejs_path) {
  
  if (!interactive()) {
    return(TRUE)
  } else {
    mess <- glue::glue("If not found, can electricShine try and install nodejs to: {nodejs_path}? (y/n)... ")
    answer <- readline(mess)
    if (tolower(substr(answer, 1, 1)) == "y") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}
