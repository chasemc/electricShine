#' Install R from MRAN date into electricShine folder
#'
#' @param mran_date MRAN date from which to install R
#' @param app_root_path path to current electricShine app build
#' @param mac_url mac R installer url
#'
#' @return NA, installs/downloads R to a given path
#' @export
#'

install_r <- function(mran_date = as.character(Sys.Date() - 3),
                      app_root_path,
                      mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz"){
  
  app_root_path <- normalizePath(app_root_path, winslash = "/", mustWork = FALSE)
  
  os <- electricShine::get_os()
  
  if (identical(os, "mac")) {
    path <- .install_mac_r(app_root_path = app_root_path,
                           mac_url = mac_url)
  }
  
  if (identical(os, "win")) {
    
    win_url <- .find_win_exe_url(mran_date = mran_date)
    # download R.exe installer
    win_installer_path <- .download_r(d_url = win_url)
    # install R
    path <- .install_win_r(win_installer_path,
                           app_root_path)
    
    path <- base::file.path(path,
                            "bin",
                            fsep = "/")
    
    if (length(list.files(path, pattern = "Rscript.exe")) != 1L) {
      stop("Didn't find Rscript.exe after Windows R install.")
    }
    
    return(path)
  }
}



#' Find Windows R installer URL from MRAN snapshot
#'
#' @param mran_date MRAN date (yyyy-mm-dd) to download from
#'
#' @return url 
#'
.find_win_exe_url <- function(mran_date){
  
  baseUrl <- glue::glue("https://cran.microsoft.com/snapshot/{mran_date}/bin/windows/base")
  # Read snapshot html
  readCran <- base::readLines(baseUrl, warn = FALSE)
  # Find the name of the windows exe
  filename <- base::regexpr("R-[0-9.]+.+-win\\.exe", readCran)
  filename <- base::regmatches(readCran, filename)
  
  if (base::regexpr("R-[0-9.]+.+-win\\.exe", filename)[[1]] != 1L) {
    stop("Was unable to resolve url of R.exe installer for Windows.") 
  }
  
  # Construct the url of the download
  base::file.path(baseUrl, 
                  filename,
                  fsep = "/")
}





#' Download R installer given its url
#'
#' @param d_url download file from url
#'
#' @return Path to R.exe installer
.download_r <- function(d_url) {
  
  installer_filename <- basename(d_url)
  download_path <- base::file.path(tempdir(), 
                                   installer_filename,
                                   fsep = "/")
  utils::download.file(url = d_url, 
                       destfile = download_path, 
                       mode = "wb")
  return(download_path)
}




#' Install R for Windows at given path
#'
#' @param win_installer_path path of Windows R installer 
#' @param app_root_path top level of new electricShine app build
#'
#' @return NA, installs R to path

.install_win_r <- function(win_installer_path,
                           app_root_path){
  # path R installer will install to
  
  install_r_to_path <- base::file.path(app_root_path, 
                                       "app",
                                       "r_lang",
                                       fsep = "/")
  # create folder R will be installed to
  base::dir.create(install_r_to_path)
  # Quote path in case user's path has spaces, etc
  quoted_install_r_to_path <- base::shQuote(install_r_to_path)
  # install R
  base::system(glue::glue("{win_installer_path} /SILENT /DIR={quoted_install_r_to_path}"))
  return(install_r_to_path)
}



#' Download and untar mac R into app folder
#'
#' @param app_root_path top level of new electricShine app build
#' @param mac_url url for mac R language download
#'
#' @return NA
.install_mac_r <- function(app_root_path,
                           mac_url){
  os <- electricShine::get_os()
  
  installer_path <- .download_r(mac_url)
  # path R installer will install to
  install_r_to_path <- base::file.path(app_root_path, 
                                       "app",
                                       "r_lang",
                                       fsep = "/")
  
  # create folder R will be installed to
  base::dir.create(install_r_to_path)
  
  # untar files to the app folder
  utils::untar(tarfile = installer_path, exdir = install_r_to_path)
  
  
  if (identical(os, "mac")) {
    
    r_executable_path <- file.path(app_root_path, 
                              "app/r_lang/Library/Frameworks/R.framework/Versions")
    r_executable_path <- list.dirs( r_executable_path, 
                                recursive = FALSE)[[1]]
    r_executable_path <- file.path(r_executable_path,
                              "Resources/bin/R", 
                              fsep = "/")
    electricShine::modify_mac_r(r_executable_path)
  }    
  return(install_r_to_path)
  
}




