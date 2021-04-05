
#' Download miniconda install script
#'
#' @param os this development operating system ("win", "mac", or "lin")
#' @param minconda_version miniconda version
#' @param minconda_tempdir where should the install script be saved?
#'
#' @return
#' @export
#'
download_miniconda3 <- function(os, minconda_version ="latest", minconda_tempdir = NULL) {

  if (is.null(minconda_tempdir)) {
    minconda_tempdir <- tempdir()
  }

  os  <- switch(os,
                win = "Windows",
                mac = "MacOSX",
                lin = "Linux",
                stop('os must be "win", "mac", or "lin"'))

  if (minconda_version == "latest") {
    minconda_version <- "latest"
  } else if (numeric_version(minconda_version)) {
    minconda_version <- minconda_version
  } else {
    stop('minconda_version must be "latest" or semantic version')
  }

  miniconda_url <- paste0("https://repo.anaconda.com/miniconda/Miniconda3-",
                          minconda_version,
                          "-",
                          os,
                          "-x86_64.sh")

  outpath <- file.path(minconda_tempdir,
                       "miniconda.sh")
  download.file(miniconda_url,
                outpath)
  message(paste0("Saved to: ",
                 outpath))
  return(outpath)
}

#' Install miniconda3
#'
#' @param miniconda_install_script_path file path of the miniconda installer script
#' @param miniconda_installation_path directory path where conda will be installed
#'
#' @return
#' @export
#'
install_miniconda3 <- function(miniconda_install_script_path,
                               miniconda_installation_path = NULL){
#TODO, path-exist checks and message
  if (!file.exists(miniconda_install_script_path)){
    stop(paste0("Couldn't find: ", miniconda_install_script_path))
  }

  if (is.null(miniconda_installation_path)){
    temp <- tempdir()
    temp <- file.path(temp, "conda_top_dir")
    dir.create(temp)
    miniconda_installation_path <- temp
  }

  installation_command <- paste0("sh ",
                                 miniconda_install_script_path,
                                 " -bup",
                                 miniconda_installation_path)
  system(installation_command)

  miniconda_installation_path <- c("miniconda_top_directory" = miniconda_installation_path)
  return(miniconda_installation_path)
}



