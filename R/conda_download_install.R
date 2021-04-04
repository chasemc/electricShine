
download_miniconda3 <- function(os, version, temp_dir) {
  os  <- switch(os,
                win = "Windows",
                mac = "MacOSX",
                lin = "Linux",
                stop('os must be "win", "mac", or "lin"'))

  version <- if (version == "latest") {
    version <- "latest"
  } else if (numeric_version(version)) {
    version <- version
  } else {
    stop('version must be "latest" or semantic version')
  }

  miniconda_url <- paste0("https://repo.anaconda.com/miniconda/Miniconda3-",
                          version,
                          "-",
                          os,
                          "-x86_64.sh")

  download.file(miniconda_url, file.path(temp_dir, "miniconda.sh"))

}

install_miniconda3 <- function(miniconda_install_script_path,
                               miniconda_installation_path){
  if (!file.exists(miniconda_install_script_path)){
    stop(paste0("Couldn't find: ", miniconda_install_script_path))
  }
  if (!dir.exists(miniconda_installation_path)){
    stop(paste0("Couldn't find: ", miniconda_installation_path))
  }

  installation_command <- paste0("sh ",
                                 file.path(miniconda_install_script_path,
                                           "miniconda.sh"),
                                 " -bup",
                                 miniconda_installation_path)
  system(installation_command)
}


conda_exec_path <- function(miniconda_installation_path){

  if (!dir.exists(miniconda_installation_path)){
    stop(paste0("Couldn't find: ", miniconda_installation_path))
  }
  conda_path <- normalizePath(miniconda_installation_path, winslash = "/")

  conda_path <- file.path(conda_path,
                          "bin",
                          "conda")

  return(conda_path)

}



conda_create_env <- function(conda_path){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  system2(conda_path,
          c("create","-n eshine -y"),
          stdout = "")
}



