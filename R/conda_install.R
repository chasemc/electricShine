conda_install <- function(conda_path, conda_env="eshine", conda_lib, conda_repo=FALSE){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  if (conda_repo) {
    system2(conda_path,
            c("install",
              paste0("-n ", conda_env),
              paste0("-c ", conda_repo),
              conda_lib,
              "-y"),
            stdout = "")
  } else {
    system2(conda_path,
            c("install",
              paste0("-n ", conda_env),
              conda_lib,
              "-y"),
            stdout = "")
  }
}


conda_install_r <- function(conda_path, conda_env="eshine",conda_repo="conda-forge", r_version="4.0.3"){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  conda_install(conda_path,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_lib = paste0("r-base=", r_version))
}


conda_install_python <- function(conda_path, conda_repo="conda-forge", conda_env="eshine", python_version = "3.7"){
  if (!file.exists(conda_path)){
    stop(paste0("Couldn't find: ", conda_path))
  }
  conda_install(conda_path,
                conda_env = conda_env,
                conda_repo = conda_repo,
                conda_lib = paste0("python=", python_version))
}
