#' Install R from MRAN date into electricShine folder
#'
#' @param mran_date MRAN date from which to install R
#' @param app_build_path path to current electricShine app build
#'
#' @return NA, installs/downloads R to a given path
#' @export
#'

installR <- function(mran_date = as.character(Sys.Date() - 3),
                     app_build_path,
                     mac_url = "https://mac.r-project.org/el-capitan/R-3.6-branch/R-3.6-branch-el-capitan-sa-x86_64.tar.gz"){
  
  
  os <- electricShine::get_os()
  
  if(identical(os, "mac")) {
    .install_mac_r(app_build_path)
  }
  
  if(identical(os, "win")) {
    
    win_url <- .find_win_exe_url(mran_date)
    # download R.exe installer
    win_installer_path <- .download_r(win_url)
    # path R installer will install to
    install_r_to_path <- base::file.path(app_build_path, 
                                         "r_win",
                                         fsep = "/")
    # create folder R will be installed to
    base::dir.create(install_r_to_path)
    # Quote path in case user's path has spaces, etc
    install_r_to_path <- base::shQuote(install_r_to_path)
    # install R
    .install_win_r(win_installer_path,
                   install_r_to_path)
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





#' Download R installer for windows to tempdir()
#'
#' @param url url to download R from
#'
#' @return Path to R.exe installer
.download_r <- function(url) {
  
  installer_filename <- basename(url)
  download_path <- base::file.path(tempdir(), 
                                   installer_filename,
                                   fsep = "/")
  utils::download.file(url = url, 
                       destfile = download_path, 
                       mode = "wb")
  return(download_path)
}




#' Install R for Windows at given path
#'
#' @param win_installer_path path of Windows R installer 
#' @param install_r_to_path path to tell installer to install R to
#'
#' @return NA, installs R to path

.install_win_r <- function(win_installer_path,
                           install_r_to_path){
  # install R
  base::system(glue::glue("{win_installer} /SILENT /DIR={install_r_to_path}"))
}



#' Download and untar mac R into app folder
#'
#' @param app_build_path top level of new electricShine app build
#'
#' @return NA
.install_mac_r <- function(app_build_path){
  
  installer_path <- .download_r(mac_url)
  # path R installer will install to
  install_r_to_path <- base::file.path(app_build_path, 
                                       "r_lang",
                                       fsep = "/")
  
  # create folder R will be installed to
  base::dir.create(install_r_to_path)
  
  install_r_to_path <- shQuote(install_r_to_path)
  # untar files to the app folder
  untar(tarfile = installer_path, exdir = install_r_to_path)
  
}




